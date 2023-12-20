// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

final InAppPurchase inAppPurchase = InAppPurchase.instance;
StreamSubscription<List<PurchaseDetails>>? _subscription;
Function()? _onSuccess;
Function()? _onFail;
Function()? _onCancel;

// 获取队列中的交易列表
Future<List<SKPaymentTransactionWrapper>> getTransactionList({
  required String userId,
  String? productId,
}) async {
  List<SKPaymentTransactionWrapper> list = [];

  // 获取该用户未处理完成的订单
  Map<String, dynamic> cachedOrder = await getCachedApplePayOredrByUserId(userId);
  List<String> productIds = cachedOrder.keys.toList();
  // 特定的product
  if (productId != null) {
    productIds = productIds.isNotEmpty ? productIds.where((item) => item == productId).toList() : [productId];
  }

  List<SKPaymentTransactionWrapper> transactionList = await SKPaymentQueueWrapper().transactions();
  if (transactionList.isNotEmpty) {
    list = transactionList.where((item) => productIds.contains(item.payment.productIdentifier)).toList();
  }

  return list;
}

// 二次校验
Future<void> verifyPurchase(String receipt, Function() callback) async {
  await DioUtils.instance.requestNetwork(
    Method.post,
    HttpApi.applePayValidate,
    params: {
      'receipt': receipt
    },
    onSuccess: (_) {
      Log.d('validate success:$_', tag: 'verifyPurchase');
      callback();
    },
    onError: (code, msg) {
      Log.d('validate fail:code=$code msg=$msg', tag: 'verifyPurchase');
      throw Exception(msg);
    },
  );
}

void onDone() {
  _subscription!.cancel();
  _subscription = null;
}

void onError(dynamic error) {
  Log.d('支付异常:error:$error', tag: 'onError');
}

// 丢单、漏单处理（利用keychain存储订单数据，每种类型的商品在某个时间段只会存在一个订单，key格式为"userId"）
Future<Map<String, dynamic>> getCachedApplePayOredrByUserId(String userId) async {
  String? value = await FlutterKeychain.get(key: userId);
  if (value == null) {
    return {};
  }
  return jsonDecode(value) as Map<String, dynamic>;
}
Future<void> addPurchasedOrder(String userId, Map<String, dynamic> order) async {
  Map<String, dynamic> cachedOrder = await getCachedApplePayOredrByUserId(userId);
  cachedOrder[order['productId']] = order;
  await FlutterKeychain.put(key: userId, value: jsonEncode(cachedOrder));
}
Future<void> removePurchaseOrder(String userId, String productId) async {
  Map<String, dynamic> cachedOrder = await getCachedApplePayOredrByUserId(userId);
  if (cachedOrder.containsKey(productId)) {
    cachedOrder.remove(productId);
  }
  await FlutterKeychain.put(key: userId, value: jsonEncode(cachedOrder));
}

class ApplePayUtils {

  static InAppPurchase instance() => inAppPurchase;

  // 获取商品列表
  static Future<List<ProductDetails>> getProductList(List<String> ids) async {
    ProductDetailsResponse response = await inAppPurchase.queryProductDetails(ids.toSet());
    if (response.error != null) {
      return [];
    }
    return response.productDetails;
  }

  // 支付
  static void pay({
    required ProductDetails product,
    required String userId,
    Function()? onSuccess,
    Function()? onFail,
    Function()? onCancel,
  }) async {
    // 校验是否支持苹果支付
    bool available = await inAppPurchase.isAvailable();
    if (!available) {
      Toast.show(
        "苹果支付不可用",
        duration: 1000,
      );
      return;
    }

    // 设置回调
    _onSuccess = onSuccess;
    _onFail = onFail;
    _onCancel = onCancel;

    // 设置监听
    _subscription ??= inAppPurchase.purchaseStream.listen(
      (List<PurchaseDetails> purchaseList) async {
        for (PurchaseDetails purchase in purchaseList) {
          PurchaseStatus status = purchase.status;

          if (status == PurchaseStatus.error) {
            Log.d('error', tag: 'onData');
            await inAppPurchase.completePurchase(purchase);
            await removePurchaseOrder(userId, purchase.productID);
            if (_onFail != null) {
              _onFail!();
            }
          }

          if (status == PurchaseStatus.canceled) {
            Log.d('canceled', tag: 'onData');
            await inAppPurchase.completePurchase(purchase);
            await removePurchaseOrder(userId, purchase.productID);
            if (_onCancel != null) {
              _onCancel!();
            }
          }

          if (status == PurchaseStatus.purchased) {
            Log.d('purchased', tag: 'onData');
            Map<String, dynamic> order = {
              'id': purchase.purchaseID,
              'productId': purchase.productID,
              'state': purchase.status.name,
            };
            await addPurchasedOrder(userId, order);
            try {
              await verifyPurchase(purchase.purchaseID!, () async {
                // 结束交易
                await removePurchaseOrder(userId, purchase.productID);
                await inAppPurchase.completePurchase(purchase);
                if (_onSuccess != null) {
                  _onSuccess!();
                }
              });
            } catch (e) {
              if (_onFail != null) {
                _onFail!();
              }
            }
          }

          if (status == PurchaseStatus.restored) {
          }

          if (status == PurchaseStatus.pending) {
            Log.d('pending', tag: 'onData');
            Map<String, dynamic> order = {
              'id': purchase.purchaseID,
              'productId': purchase.productID,
              'state': purchase.status.name,
            };
            await addPurchasedOrder(userId, order);
          }
        }
      },
      onDone: onDone,
      onError: onError,
    );

    // 处理未完成交易的同类型商品
    List<SKPaymentTransactionWrapper> transactionList = await getTransactionList(userId: userId, productId: product.id);
    if (transactionList.isNotEmpty) {
      Log.d('存在同类型的未处理完成的交易', tag: 'dealSameType');
      return;
    }

    // 购买
    // 基于SHA1，将"用户ID&商品ID"的字符串加密成uuid
    String uuid = sha1.convert(utf8.encode('$userId&${product.id}')).toString();
    PurchaseParam param = PurchaseParam(
      productDetails: product,
      applicationUserName: uuid,
    );
    await inAppPurchase.buyConsumable(purchaseParam: param);
  }

  // 处理未完成的交易
  static Future<void> dealtUnCompletedPurchase(String userId) async {
    SKPaymentQueueWrapper payment = SKPaymentQueueWrapper();

    // List<SKPaymentTransactionWrapper> transactionList = await payment.transactions();
    // for (SKPaymentTransactionWrapper transaction in transactionList) {
    //   await payment.finishTransaction(transaction);
    // }

    List<SKPaymentTransactionWrapper> transactionList = await getTransactionList(userId: userId);
    for (SKPaymentTransactionWrapper transaction in transactionList) {
      SKPaymentTransactionStateWrapper state = transaction.transactionState;

      if (SKPaymentTransactionStateWrapper.failed == state) {
        await payment.finishTransaction(transaction);
        await removePurchaseOrder(userId, transaction.payment.productIdentifier);
      }

      if (SKPaymentTransactionStateWrapper.purchased == state) {
        try {
          await verifyPurchase(transaction.transactionIdentifier!, () async {
            await payment.finishTransaction(transaction);
            await removePurchaseOrder(userId, transaction.payment.productIdentifier);
          });
        } catch (e) {
          Log.d('二次校验失败:${e.toString()}', tag: 'dealtUnCompletedPurchase');
        }
      }
    }
  }

}