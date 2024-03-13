import 'package:flutter/cupertino.dart';

///左边是提示文字右边是Switch按钮的控件
///Create by cd on 2021/8/23
class SwitchButton extends StatefulWidget {
  final Function? onChange;
  final String? hint;
  final bool isChecked;
  final bool isCloseChange;

  const SwitchButton({
    Key? key,
    this.hint,
    this.isChecked = false,
    this.onChange,
    this.isCloseChange = false,
  }) : super(key: key);

  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  ///单条按钮布局
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 21.0),
      child: Container(
        height: 54.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Text(
              "${widget.hint}",
              style: TextStyle(fontSize: 16.0, color: Color(0xFF31343D)),
            )),
            _buildSwitch(),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch() {
    return CupertinoSwitch(
      value: _isChecked,
      onChanged: (bool value) {
        if (widget.isCloseChange ?? true) {
          _isChecked = !_isChecked;
          setState(() {});
        }
        if (widget.onChange != null) widget.onChange!(_isChecked);
      },
      activeColor: Color(0xff639EF4),
    );
  }
}
