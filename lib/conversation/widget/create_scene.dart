import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/colors.dart';
import '../../routers/fluro_navigator.dart';
import '../../widgets/load_image.dart';

class CreateScene extends StatefulWidget {
  const CreateScene({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  final Function() onComplete;

  @override
  State<CreateScene> createState() => _CreateScenState();
}

class _CreateScenState extends State<CreateScene> {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<int> canCreate = ValueNotifier(0);

  void createScene() {
    // if (controller.text == '') {
    //   return;
    // }
    onComplete();
  }

  void createRandomScene() {
    onComplete();
  }

  void onComplete() {
    NavigatorUtils.goBack(context);
    Future.delayed(const Duration(milliseconds: 300), () {
      widget.onComplete();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    input() {
      return TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: '请输入自定义场景，开启个性化对话，限8字内',
          border: InputBorder.none,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(8),
        ],
      );
    }

    bottomButton({
      required String text,
      Widget? icon,
      required ImageProvider bgImage,
      required Function() onPress
    }) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPress,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            image: DecorationImage(
              image: bgImage,
              fit: BoxFit.fill,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null)
                ...[
                  icon,
                  const SizedBox(
                    width: 4.0,
                  ),
                ],
              Text(
                text,
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 16.0 / 13.0,
                  height: 18.0 / 13.0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colours.hex2color('#111B44').withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/xinjianchangjing_bg.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              padding: const EdgeInsets.only(
                top: 19.0,
                bottom: 22.0,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 19.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            NavigatorUtils.goBack(context);
                          },
                          child: const LoadAssetImage(
                            'guanbi_bai',
                            width: 10.0,
                            height: 10.0,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  Container(
                    width: size.width - 54.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13.0),
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13.0,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 27.0,
                    ),
                    child: input(),
                  ),
                  Container(
                    height: 26.0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 27.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        bottomButton(
                          text: '试试随机话题',
                          icon: const LoadAssetImage(
                            'suijihuati',
                            width: 17.0,
                            height: 14.0,
                            fit: BoxFit.fill,
                          ),
                          bgImage: const AssetImage('assets/images/suijihuati_bt.png'),
                          onPress: createRandomScene,
                        ),
                        ValueListenableBuilder(
                          valueListenable: canCreate,
                          builder: (_, canCreate, __) {
                            return bottomButton(
                              text: '确定',
                              bgImage: const AssetImage('assets/images/queding_bt.png'),
                              onPress: createScene,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
    );
  }
}