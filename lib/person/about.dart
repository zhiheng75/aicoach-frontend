import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/entity/version_bean.dart';
import 'package:Bubble/person/widget/illustration.dart';
import 'package:Bubble/setting/entity/updata_info_entity.dart';
import 'package:Bubble/util/channel.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/other_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../res/colors.dart';
import '../widgets/navbar.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScreenUtil _screenUtil = ScreenUtil();
  String version = 'V1.0.0';

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    Future.delayed(const Duration(milliseconds: 300), () {
      getStandardAnswer();
    });
  }

  void getStandardAnswer() {
    String platformStr = "android";

    if (Device.isAndroid) {
      platformStr = Channel.channelmeizu;
    } else {
      platformStr = Channel.channelios;
    }
    DioUtils.instance.requestNetwork<ResultData>(
      Method.get,
      HttpApi.version,
      queryParameters: {
        'platform': platformStr,
      },
      onSuccess: (result) {
        Map<String, dynamic> versionBeanMap = json.decode(result.toString());
        VersionBean versionBean = VersionBean.fromJson(versionBeanMap);
        // Log.e("====================${_packageInfo.buildNumber}");
        if (versionBean.data.versionCode >
            int.parse(_packageInfo.buildNumber)) {
          showDialog(
            context: context,
            barrierColor: Colors.transparent,
            barrierDismissible: false,
            useSafeArea: false,
            builder: (_) => UpDataView(
              versionBean: versionBean,
              onSuccess: () {
                // String url = "https://www.baidu.com";
                // Utils.launchWebURL(url);

                Utils.launchWebURL(versionBean.data.package);
                // openUrl(versionBean.data.package);
              },
            ),
          );
        }
      },
      onError: (code, msg) {},
    );
  }

  void openUrl(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Future<void> _launchInBrowser(Uri url) async {
  //   if (!await launchUrl(
  //     url,
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
    version = "V${_packageInfo.version}";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget aboutUs = Container(
      width: _screenUtil.screenWidth - 32.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 32.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '口语嘟嘟',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              Text(
                version,
                style: const TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w400,
                  color: Colours.color_999999,
                  height: 14.0 / 11.0,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          const Text(
            '口语嘟嘟是一款基于生成式人工智能的英语口语训练平台。通过与自主研发的AI智能体英语老师实景对话模式，让同学们在有趣且高效的氛围中获得口语能力快速提升。\n 口语嘟嘟用科技与创新探索语言学习提高的无尽可能。结合多年教育科技行业研发经验，创造性地将广受欢迎的海量IP形象、英语语法与句型教学体系、英语升级阅读引擎、大语言模型与自适应学习系统等多个领域的成功实践，整合为一套启发式兴趣对话的英语“口语学习黑科技”。提供家长式陪伴，为学英语的孩子营造出一个沉浸式的语言学习环境。进入口语嘟嘟的英语对话世界，孩子们一开口说英语，就“完全停不下来”。\nAI时代浪潮下，我们希望与您一路同行。欢迎加入口语嘟嘟金种子用户社群，与我们一起见证AI时代的未来教育！',
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
              height: 18.0 / 13.0,
              letterSpacing: 0.05,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          const Text(
            "联系客服举报\n客服邮箱:help@shenmo-ai.com",
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
              height: 18.0 / 13.0,
              letterSpacing: 0.05,
            ),
          ),
        ],
      ),
    );

    Widget customerService = Container(
      width: _screenUtil.screenWidth - 32.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(24.0),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '加入口语嘟嘟金种子用户社群',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
              height: 24.0 / 15.0,
            ),
          ),
          SizedBox(
            height: 6.0,
          ),
          LoadImage(
            "http://statics.shenmo-ai.com/qywxkf.jpg",
            width: 200,
            height: 200,
          ),
          SizedBox(
            height: 6.0,
          ),
          Text(
            '欢迎添加客服微信',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
              height: 24.0 / 15.0,
            ),
          ),
          SizedBox(
            height: 6.0,
          ),
          Text(
            '客服微信：bubbleapp',
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
              height: 18.0 / 13.0,
            ),
          ),
        ],
      ),
    );

    Widget footer = const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '客服邮箱：help@shenmo-ai.com',
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
            color: Colours.color_999999,
            height: 13.0 / 11.0,
            letterSpacing: 0.05,
          ),
        ),
        Text(
          'ICP备案号：京ICP备2023024660号-1',
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
            color: Colours.color_999999,
            height: 13.0 / 11.0,
            letterSpacing: 0.05,
          ),
        ),
        Text(
          '深模科技 版权所有',
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
            color: Colours.color_999999,
            height: 13.0 / 11.0,
            letterSpacing: 0.05,
          ),
        ),
      ],
    );

    return Scaffold(
      body: Container(
        width: _screenUtil.screenWidth,
        height: _screenUtil.screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/person_bg.png',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          children: [
            // const Text("data"),
            // const Text("data"),
            // const Text("data"),
            // const Text("data"),
            const XTCupertinoNavigationBar(
              backgroundColor: Color(0xFFFFFFFF),
              border: null,
              padding: EdgeInsetsDirectional.zero,
              leading: NavigationBackWidget(),
              middle: Text(
                "关于我们",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: _screenUtil.screenHeight - 120,
              child: MyScrollView(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // const SizedBox(
                  //   height: 60.0,
                  // ),
                  // const Navbar(
                  //   title: '关于我们',
                  // ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // GestureDetector(
                      //     onTap: () {
                      //       Log.e("msg");
                      //       showDialog(
                      //         context: context,
                      //         barrierColor: Colors.transparent,
                      //         barrierDismissible: false,
                      //         useSafeArea: false,
                      //         builder: (_) => const UpDataView(),
                      //       );
                      //     },
                      //     child: const Text("点这里")),
                      aboutUs,
                      const SizedBox(
                        height: 16.0,
                      ),
                      customerService,
                      const SizedBox(
                        height: 16.0,
                      ),
                      footer,
                      const SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
