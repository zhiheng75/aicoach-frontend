import 'package:dio/dio.dart';

import '../net/dio_utils.dart';
import '../net/error_handle.dart';
import 'base_presenter.dart';
import 'mvps.dart';

class BasePagePresenter<V extends IMvpView> extends BasePresenter<V> {

  BasePagePresenter() {
    _cancelToken = CancelToken();
  }

  late CancelToken _cancelToken;

  @override
  void dispose() {
    /// 销毁时，将请求取消
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }


  Future<dynamic> requestNetwork<T>(Method method, {
    required String url,
    bool isShow = true,
    bool isClose = true,
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    dynamic params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    if (isShow) {
      view.showProgress();
    }
    return DioUtils.instance.requestNetwork<T>(method, url,
      params: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken?? _cancelToken,
      onSuccess: (data) {
        if (isClose) {
          view.closeProgress();
        }
        onSuccess?.call(data);
      },
      onError: (code, msg) {
        _onError(code, msg, onError);
      },
    );
  }

  void asyncRequestNetwork<T>(Method method, {
    required String url,
    bool isShow = true,
    bool isClose = true,
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    dynamic params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    if (isShow) {
      view.showProgress();
    }
    DioUtils.instance.asyncRequestNetwork<T>(method, url,
      params: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken?? _cancelToken,
      onSuccess: (data) {
        if (isClose) {
          view.closeProgress();
        }
        onSuccess?.call(data);
      },
      onError: (code, msg) {
        _onError(code, msg, onError);
      },
    );
  }

  /// 上传图片实现
  // Future<String> uploadImg(File image) async {
  //   String imgPath = '';
  //   try{
  //     final String path = image.path;
  //     final String name = path.substring(path.lastIndexOf('/') + 1);
  //     final FormData formData = FormData.fromMap(<String, dynamic>{
  //       'file': await MultipartFile.fromFile(path, filename: name)
  //     });
  //     await requestNetwork<String>(Method.post,
  //         url: HttpApi.upload,
  //         params: formData,
  //         onSuccess: (data) {
  //           imgPath = data ?? '';
  //           Toast.show("上传成功");
  //         }
  //     );
  //   } catch(e) {
  //     view.showToast('图片上传失败！');
  //   }
  //   return imgPath;
  // }

  void _onError(int code, String msg, NetErrorCallback? onError) {
    /// 异常时直接关闭加载圈，不受isClose影响
    view.closeProgress();
    if (code != ExceptionHandle.cancel_error) {
      view.showToast(msg);
    }
    /// 页面如果dispose，则不回调onError
    if (onError != null) {
      onError(code, msg);
    }
  }

  V getView() {
    return view;
  }
}
