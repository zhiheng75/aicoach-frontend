import 'package:Bubble/course/entity/step_detail_bean.dart';
import 'package:Bubble/course/presenter/curriculum_evaluation_page_presenter.dart';
import 'package:Bubble/course/view/curriculum_evaluation_page_view.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/dimens.dart';
import 'package:Bubble/res/resources.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurriculumEvaluationPage extends StatefulWidget {
  final StepDetailBean stepDetailBean;
  const CurriculumEvaluationPage({super.key, required this.stepDetailBean});

  @override
  State<CurriculumEvaluationPage> createState() =>
      _CurriculumEvaluationPageState();
}

class _CurriculumEvaluationPageState extends State<CurriculumEvaluationPage>
    with
        BasePageMixin<CurriculumEvaluationPage,
            CurriculumEvaluationPagePresenter>,
        RouteAware,
        AutomaticKeepAliveClientMixin<CurriculumEvaluationPage>
    implements
        CurriculumEvaluationPageView {
  // double star = 4;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  List<TextInputFormatter>? _inputFormatters;
  bool _isSelect = false;
  final ScreenUtil _screenUtil = ScreenUtil();

  double starNum = 5;
  late CurriculumEvaluationPagePresenter _curriculumEvaluationPagePresenter;

  @override
  void initState() {
    super.initState();
    _controller.text = '';

    _inputFormatters = null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "课程评价",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
              child: GestureDetector(
        onTap: () {
          _nodeText1.unfocus();
        },
        child: MyScrollView(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Text(
              widget.stepDetailBean.data.unitName,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            )),
            Text(
              widget.stepDetailBean.data.lessonName,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Container(
                width: _screenUtil.screenWidth - 20,
                height: 100,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colours.color_F8F8F8,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 15.0,
                ),
                child: Column(
                  children: [
                    const Text(
                      "你对本节课是否满意（必填）",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Gaps.vGap8,
                    // RatingBar.builder(
                    //   initialRating: 3,
                    //   minRating: 1,
                    //   direction: Axis.horizontal,
                    //   allowHalfRating: true,
                    //   itemCount: 5,
                    //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    //   itemBuilder: (context, _) => Icon(
                    //     Icons.star,
                    //     color: Colors.amber,
                    //   ),
                    //   onRatingUpdate: (rating) {
                    //     print(rating);
                    //   },
                    // ),
                    RatingBar(
                      initialRating: starNum,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      ratingWidget: RatingWidget(
                        full: const LoadAssetImage('full_star_img'),
                        half: const LoadAssetImage('full_star_img'),
                        empty: const LoadAssetImage('empty_star_img'),
                      ),
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      onRatingUpdate: (rating) {
                        setState(() {
                          starNum = rating;
                        });
                      },
                    ),
                  ],
                )),
            Row(
              children: [
                Gaps.hGap10,
                const Text(
                  "还有哪些建议？",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  color: Colours.color_F8F8F8),
              child: Semantics(
                multiline: true,
                maxValueLength: 200,
                child: TextField(
                  cursorColor: Colours.color_333333,
                  style: const TextStyle(
                      color: Colours.color_546092, fontSize: 13),
                  // maxLength: _maxLength,
                  maxLines: 5,
                  autofocus: false,
                  focusNode: _nodeText1,
                  controller: _controller,
                  inputFormatters: _inputFormatters,
                  decoration: const InputDecoration(
                    hintText: "说出你的课程建议把",
                    hintStyle: TextStyle(color: Colours.color_999999),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _isSelect = !_isSelect;
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    child: LoadAssetImage(
                      _isSelect ? "select_img2" : "unselect_img2",
                      width: 15.0,
                      height: 15.0,
                    ),
                  ),
                  // Gaps.hGap10,
                  Text(
                    "匿名评价",
                    style: TextStyle(
                        fontSize: Dimens.font_sp12, color: Colours.black),
                  ),
                  Gaps.hGap26,
                ],
              ),
            ),
            Gaps.vGap26,
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (_controller.text.isNotEmpty) {
                  _curriculumEvaluationPagePresenter.postLessonFeedback(
                      widget.stepDetailBean.data.lessonId.toString(),
                      _isSelect ? "1" : "0",
                      starNum.toInt().toString(),
                      _controller.text);
                } else {
                  Toast.show("请输入建议");
                }
              },
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
                  '提交',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_001652,
                  ),
                ),
              ),
            ),
          ],
        ),
      ))),
    );
  }

  @override
  CurriculumEvaluationPagePresenter createPresenter() {
    // TODO: implement createPresenter
    _curriculumEvaluationPagePresenter = CurriculumEvaluationPagePresenter();
    return _curriculumEvaluationPagePresenter;
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(String msg) {
    // TODO: implement sendSuccess
    Toast.show(msg);
    NavigatorUtils.goBack(context);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
