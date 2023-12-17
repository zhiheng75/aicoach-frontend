import 'package:flutter/cupertino.dart';

import 'mvps.dart';

///生命周期绑定
class BasePresenter<V extends IMvpView> extends IPresenter {

  late V view;

  @override
  void deactivate() {}

  @override
  void didChangeDependencies() {}

  @override
  void didUpdateWidgets<W>(W oldWidget) {}

  @override
  void dispose() {}

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      afterInit();
    });
  }

  @override
  void afterInit() {

  }

}
