import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../home/provider/home_provider.dart';
import '../mvp/base_page.dart';
import '../res/colors.dart';
import 'exam_purchase.dart';
import 'presenter/exam_page_presenter.dart';
import 'view/exam_view.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({Key? key}) : super(key: key);

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with BasePageMixin<ExamPage, ExamPagePresenter>, AutomaticKeepAliveClientMixin<ExamPage> implements ExamView {

  late ExamPagePresenter _examPagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  late HomeProvider _homeProvider;
  String _type = 'ket';
  List<String> ketDescList = [
    '1V1真实还原考试全流程',
    '详细讲解考试流程和注意事项',
    '全方位展示和练习真实考试的各种情况',
    '严格按照评分标准和评分体系进行评分',
  ];
  List<String> petDescList = [
    '1V1真实还原考试全流程',
    '详细讲解考试流程和注意事项',
    '全方位展示和练习真实考试的各种情况',
    '严格按照评分标准和评分体系进行评分',
  ];

  void startExam() {
    if (_homeProvider.usageCount == 0) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        builder: (_) => ExamPurchasePage(
          onPurchased: () {},
        ),
      );
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget barItem(String label, String type) {
      bool isSelected = _type == type;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isSelected) {
            return;
          }
          _type = type;
          setState(() {});
        },
        child: Container(
          width: 88.0,
          height: 34.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFF3F5F7),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected ? Colors.white : Colours.color_999999,
              height: 20.0 / 15.0,
            ),
          ),
        ),
      );
    }

    Widget tabbar = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          barItem('KET', 'ket'),
          const SizedBox(
            width: 10.0,
          ),
          barItem('PET', 'pet'),
        ],
      ),
    );

    Widget descItem(String desc) {
      return Row(
        children: <Widget>[
          Container(
            width: 4.0,
            height: 4.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: Colours.color_999999,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Text(
              desc,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 20.0 / 15.0,
                letterSpacing: 0.05,
              ),
            ),
          ),
        ],
      );
    }

    List<Widget> descChildren = [];
    List<String> descList = _type == 'ket' ? ketDescList : petDescList;
    for (int i = 0; i < descList.length; i++) {
      descChildren.add(descItem(descList.elementAt(i)));
      if (i < descList.length - 1) {
        descChildren.add(const SizedBox(
          height: 20.0,
        ));
      }
    }

    Widget desc = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: Container(
        width: _screenUtil.screenWidth - 32.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/exam_bg.png',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 24.0,
        ),
        child: Column(
          children: <Widget>[
            const Text(
              '模拟考试介绍',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 28.0,
            ),
            SizedBox(
              width: 280.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: descChildren,
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  const LoadAssetImage(
                    'exam_desc_icon',
                    width: 32.0,
                    height: 32.0,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    '适合人群：备课${_type == 'ket' ? 'KET' : 'PET'}的学生\n考试时长：25分钟 可免费体验1次',
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 20.0 / 15.0,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      color: Colours.color_001652.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 102.0,
              ),
              tabbar,
              const SizedBox(
                height: 12.0,
              ),
              desc,
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: startExam,
                child: Container(
                  width: 231.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(
                      width: 1.0,
                      style: BorderStyle.solid,
                      color: Colours.color_001652,
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colours.color_9AC3FF,
                        Colours.color_FF71E0,
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '开始考试',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_001652,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: _screenUtil.bottomBarHeight + 24.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  ExamPagePresenter createPresenter() {
    _examPagePresenter = ExamPagePresenter();
    return _examPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;
}