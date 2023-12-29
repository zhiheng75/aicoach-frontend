// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/load_data.dart';
import '../../widgets/load_fail.dart';
import '../../widgets/load_image.dart';
import '../entity/analysis_entity.dart';

class Analysis extends StatefulWidget {
  const Analysis({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {

  // 状态 loading-加载中 fail-失败 success-成功
  final ScreenUtil _screenUtil = ScreenUtil();
  String _state = 'loading';
  List<AnalysisEntity> _analysisList = [];

  void init() {
    _state = 'loading';
    setState(() {});
    getAnalysisList();
  }

  void getAnalysisList() {
    Future.delayed(const Duration(seconds: 1), () {
      AnalysisEntity analysis = AnalysisEntity();
      analysis.userText = 'Really? Awesome， Awesome，Behind me are the Alps，Now I\'m going skiing，shall we go？';

      GrammarEntity grammar1 = GrammarEntity();
      grammar1.en = 'turn yellow';
      grammar1.zh = '变为黄色';
      GrammarEntity grammar2 = GrammarEntity();
      grammar2.en = 'turn';
      grammar2.zh = '表示变化';

      PronounceEntity pronounce1 = PronounceEntity();
      pronounce1.text = 'leaves 发音不清晰，应该这样读';
      PronounceEntity pronounce2 = PronounceEntity();
      pronounce2.text = 'leaves 发音不清晰，应该这样读';

      analysis.grammar = [grammar1, grammar2];
      analysis.pronounce = [pronounce1, pronounce2];
      _state = 'success';
      _analysisList = [analysis];
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_state != 'success') {
      return Padding(
        padding: EdgeInsets.only(
          bottom: _screenUtil.bottomBarHeight,
        ),
        child: _state == 'fail' ? LoadFail(
          reload: init,
        ) : const LoadData(),
      );
    }

    Widget analysisItem(AnalysisEntity analysis) {

      Widget session(String label, {required Widget child}) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: label.length * 16.0,
                  height: 12.0,
                  color: const Color(0xFFFFDD9C),
                ),
                Positioned(
                  left: 0,
                  child: Center(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            child,
          ],
        );
      }

      Widget content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _screenUtil.screenWidth - 32.0,
            child: Text(
              analysis.userText,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 16.0 / 14.0,
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          session(
            '语法与句子解析',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: analysis.grammar.map((item) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(
                    bottom: 16.0,
                  ),
                  child: Text(
                    '${item.en} : ${item.zh}',
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 20.0 / 15.0,
                      letterSpacing: 0.05,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          session(
            '发音建议',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: analysis.pronounce.map((item) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(
                    bottom: 16.0,
                  ),
                  child: Row(
                    children: [
                      const LoadAssetImage(
                        'laba_lan',
                        width: 17.6,
                        height: 16.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Text(
                          item.text,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            height: 20.0 / 15.0,
                            letterSpacing: 0.05,
                          ),
                        ),
                      ),
                      const LoadAssetImage(
                        'laba_lan',
                        width: 17.6,
                        height: 16.0,
                      ),
                    ],
                  )
                );
              }).toList(),
            ),
          ),
        ],
      );

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color(0xFFF8F8F8),
        ),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(
          bottom: 16.0,
        ),
        child: content,
      );
    }

    return Column(
      children: _analysisList.map((analysis) => analysisItem(analysis)).toList(),
    );
  }
}