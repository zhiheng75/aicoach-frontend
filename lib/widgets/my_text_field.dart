import 'dart:async';

import 'package:Bubble/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_button.dart';

/// 登录模块的输入框封装
class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    required this.controller,
    this.maxLength = 16,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.hintText = '',
    this.focusNode,
    this.isInputPwd = false,
    this.getVCode,
    this.keyName,
    this.underLineColor = Colours.color_001652,
    this.txtStyle = const TextStyle(color: Colors.white, fontSize: 20),
    this.hintStyle = const TextStyle(color: Colors.white, fontSize: 20),
    this.closeColor = Colours.color_001652,
    this.countDownColor = Colours.color_001652,
  });

  final TextEditingController controller;
  final int maxLength;
  final bool autoFocus;
  final TextInputType keyboardType;
  final String hintText;
  final FocusNode? focusNode;
  final bool isInputPwd;
  final Future<bool> Function()? getVCode;

  /// 用于集成测试寻找widget
  final String? keyName;
  final Color underLineColor;
  final TextStyle txtStyle;
  final TextStyle hintStyle;
  final Color countDownColor;
  final Color closeColor;

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isShowPwd = false;
  bool _isShowDelete = false;
  bool _clickable = true;

  /// 倒计时秒数
  final int _second = 30;

  /// 当前秒数
  late int _currentSecond;
  StreamSubscription<dynamic>? _subscription;

  @override
  void initState() {
    /// 获取初始化值
    _isShowDelete = widget.controller.text.isNotEmpty;

    /// 监听输入改变
    widget.controller.addListener(isEmpty);
    super.initState();
  }

  void isEmpty() {
    final bool isNotEmpty = widget.controller.text.isNotEmpty;

    /// 状态不一样在刷新，避免重复不必要的setState
    if (isNotEmpty != _isShowDelete) {
      setState(() {
        _isShowDelete = isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    widget.controller.removeListener(isEmpty);
    super.dispose();
  }

  Future<dynamic> _getVCode() async {
    final bool isSuccess = await widget.getVCode!();
    if (isSuccess) {
      setState(() {
        _currentSecond = _second;
        _clickable = false;
      });
      _subscription = Stream.periodic(const Duration(seconds: 1), (int i) => i)
          .take(_second)
          .listen((int i) {
        setState(() {
          _currentSecond = _second - i - 1;
          _clickable = _currentSecond < 1;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isDark = themeData.brightness == Brightness.dark;

    Widget textField = TextField(
      style: widget.txtStyle,
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      obscureText: widget.isInputPwd && !_isShowPwd,
      autofocus: widget.autoFocus,
      controller: widget.controller,
      textInputAction: TextInputAction.done,
      keyboardType: widget.keyboardType,
      onTapOutside: (e) => {
        widget.focusNode?.unfocus(),
      },
      onEditingComplete: () => {
        FocusScope.of(context).requestFocus(widget.focusNode),
      },
      // 数字、手机号限制格式为0到9， 密码限制不包含汉字
      inputFormatters: (widget.keyboardType == TextInputType.number ||
              widget.keyboardType == TextInputType.phone)
          ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
          : [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        counterText: '',
        border: InputBorder.none, //去掉输入框下方的下划线
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.underLineColor,
            width: 10.8,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.underLineColor,
            width: 0.8,
          ),
        ),
      ),
    );

    /// 个别Android机型（华为、vivo）的密码安全键盘不弹出问题（已知小米正常），
    /// 怀疑是安全键盘与三方输入法之间的切换冲突问题。
    if (Device.isAndroid) {
      textField = Listener(
        onPointerDown: (e) =>
            FocusScope.of(context).requestFocus(widget.focusNode),
        child: textField,
      );
    }

    Widget? clearButton;

    if (_isShowDelete) {
      clearButton = Semantics(
        label: '清空',
        hint: '清空输入框',
        child: GestureDetector(
          child: LoadAssetImage(
            'delete_img',
            color: widget.closeColor,
            key: Key('${widget.keyName}_delete'),
            width: 13.0,
            height: 13.0,
          ),
          onTap: () => widget.controller.text = '',
        ),
      );
    }

    late Widget pwdVisible;
    if (widget.isInputPwd) {
      pwdVisible = Semantics(
        label: '密码可见开关',
        hint: '密码是否可见',
        child: GestureDetector(
          child: LoadAssetImage(
            _isShowPwd ? 'open_eye_img' : 'close_eye_img',
            key: Key('${widget.keyName}_showPwd'),
            width: 18.0,
            height: 40.0,
          ),
          onTap: () {
            setState(() {
              _isShowPwd = !_isShowPwd;
            });
          },
        ),
      );
    }

    late Widget getVCodeButton;
    if (widget.getVCode != null) {
      getVCodeButton = MyButton(
        key: const Key('getVerificationCode'),
        onPressed: _clickable ? _getVCode : null,
        fontSize: Dimens.font_sp12,
        text: _clickable ? "获取验证码" : '$_currentSecond s',
        textColor: widget.countDownColor,
        disabledTextColor: widget.countDownColor,
        backgroundColor: Colors.transparent,
        // disabledBackgroundColor: isDark ? Colours.dark_text_gray : Colours.text_gray_c,
        disabledBackgroundColor: Colors.transparent,
        radius: 100.0,
        minHeight: 26.0,
        minWidth: 76.0,
        padding:
            const EdgeInsets.only(left: 19, top: 10, right: 19, bottom: 10),
        side: BorderSide(
          // color: _clickable ? Colors.white : Colors.transparent,
          color: widget.countDownColor,
          width: 0.8,
        ),
      );
    }

    return Row(
      // alignment: Alignment.centerRight,
      children: <Widget>[
        Expanded(
            child: Column(
          children: [
            textField,
            // const Divider(
            //   color: Colors.white,
            //   thickness: 0.4,
            // ),
          ],
        )),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /// _isShowDelete参数动态变化，为了不破坏树结构使用Visibility，false时放一个空Widget。
            /// 对于其他参数，为初始配置参数，基本可以确定树结构，就不做空Widget处理。
            Visibility(
              visible: _isShowDelete,
              child: clearButton ?? Gaps.empty,
            ),
            if (widget.isInputPwd) Gaps.hGap15,
            if (widget.isInputPwd) pwdVisible,
            if (widget.getVCode != null) Gaps.hGap15,
            if (widget.getVCode != null)
              Container(
                child: getVCodeButton,
              ),
          ],
        )
      ],
    );
  }
}
