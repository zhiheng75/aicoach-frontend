import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';

///并排头像显示组件
class GroupAvatarWidget extends StatefulWidget {
  final List<String?>? data;
  final bool isShowNum; //是否显示共几人提示
  final double size;
  const GroupAvatarWidget(
      {super.key, this.data, this.isShowNum = false, this.size = 20});

  @override
  // ignore: library_private_types_in_public_api
  _GroupAvatarWidgetState createState() => _GroupAvatarWidgetState();
}

class _GroupAvatarWidgetState extends State<GroupAvatarWidget> {
  List<Widget> avatarWidgets = [];
  List<String?>? avatarList;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    avatarList = widget.data;
    avatarWidgets.clear();
    for (int i = 0; avatarList != null && i < avatarList!.length; i++) {
      avatarWidgets.add(_avatar(avatarList![i]!, i));
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[_sectionAvatar(), _sectionHint()],
    );
  }

  Widget _sectionHint() {
    return widget.isShowNum == true
        ? Container(
            padding: EdgeInsets.only(left: 5),
            //共*人
            child: Text("共${avatarWidgets.length}人",
                style: const TextStyle(color: Color(0xFF9B9B9B), fontSize: 12)),
          )
        : Container();
  }

  Widget _sectionAvatar() {
    return Stack(
      children: avatarWidgets,
    );
  }

  Widget _avatar(String url, int position) {
    return Container(
      padding: EdgeInsets.only(left: (16 * position).toDouble()),
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: ClipOval(
          child: LoadImage(
            url,
            holderImg: "teacher",
            height: 20,
            width: 20,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
