import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Map<String, dynamic> websocketManagement = {};

class WebsocketUtils {
  static void createWebsocket(String name, Uri url, {
    Function()? onSuccess,
    Function()? onError,
    Function()? onDone
  }) {
    WebsocketManage manage = WebsocketManage(name: name, url: url, onError: onError, onDone: onDone);
    if (manage.state == 'connected') {
      websocketManagement[name] = manage;
      if (onSuccess != null) {
        onSuccess();
      }
    }
  }

  static WebsocketManage? getWebsocket(String name) {
    return websocketManagement[name];
  }

  static void closeWebsocket(String name) {
    WebsocketManage? manage = getWebsocket(name);
    if (manage != null) {
      manage.close();
      websocketManagement.remove(name);
    }
  }
}

class WebsocketManage {
  WebsocketManage({
    required this.name,
    required Uri url,
    Function()? onError,
    Function()? onDone,
  }) {
    state = 'connecting';
    try {
      channel = WebSocketChannel.connect(url);
      channel!.stream.listen(
        (event) {
          if (_onMessage == null) {
            needDealDataList.add(event);
            return;
          }
          // 待处理数据未处理完先缓存
          if (needDealDataList.isNotEmpty) {
            needDealDataList.add(event);
            return;
          }
          _onMessage!(event);
        },
        onDone: () {
          if (kDebugMode) {
            print('websocket-$name is onDone');
          }
          if (state == 'connecting' && onDone != null) {
            onDone();
          }
          state = 'close';
          channel = null;
        },
        cancelOnError: true,
      );
      state = 'connected';
    } catch (error) {
      if (kDebugMode) {
        print('websocket-$name is onError;error is $error');
      }
      if (state == 'connecting' && onError != null) {
        onError();
      }
      state = 'close';
      channel = null;
    }
  }

  // 用于关联到指定websocket
  String name;
  // close-关闭 connecting-连接中 connected-已连接
  String state = 'close';
  WebSocketChannel? channel;
  // 未设置onMessage前缓存所有接收的数据
  List<dynamic> needDealDataList = [];
  bool isDealing = false;
  Function(dynamic)? _onMessage;

  void send(dynamic data) {
    if (state == 'connected') {
      channel!.sink.add(data);
    }
  }

  void setOnMessage(Function(dynamic) onMessage) {
    if (isDealing) {
      isDealing = false;
    }
    _onMessage = onMessage;
    dealData();
  }

  void dealData() {
    isDealing = true;
    while(isDealing && needDealDataList.isNotEmpty) {
      dynamic data = needDealDataList.removeAt(0);
      _onMessage!(data);
    }
  }

  void close() {
    if (state != 'close') {
      channel!.sink.close(WebSocketStatus.normalClosure, 'close');
    }
  }

  void dispose() {
    websocketManagement.remove(name);
  }
}