// // ignore_for_file: prefer_final_fields

// import 'dart:async';

// import 'package:Bubble/util/image_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// import '../../home/provider/home_provider.dart';
// import '../../widgets/load_image.dart';

// class Background extends StatefulWidget {
//   const Background({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   final BackgroundController controller;

//   @override
//   State<Background> createState() => _BackgroundState();
// }

// class _BackgroundState extends State<Background> {
//   final ScreenUtil _screenUtil = ScreenUtil();
//   final AvatarController _avatarController = AvatarController();
//   final ScrollController _scrollController = ScrollController();
//   bool _isScroll = true;
//   double _distance = 0.0;

//   // String stillImage = provider.character.imageUrl;
//   //             String motionImage = provider.character.imageUrl;

//   // void scroll() {
//   //   if (!_isScroll) {
//   //     return;
//   //   }
//   //   double offset = _screenUtil.screenWidth;
//   //   if (_distance > 0) {
//   //     if (widget.controller.slideDirection == 'right') {
//   //       offset -= _distance;
//   //     }
//   //     if (widget.controller.slideDirection == 'left') {
//   //       offset += _distance;
//   //     }
//   //   }
//   //   _scrollController.jumpTo(offset);
//   //   _isScroll = false;
//   // }

//   @override
//   void initState() {
//     super.initState();
//     // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//     //   WidgetsBinding.instance.addPersistentFrameCallback((_) {
//     //     Future.delayed(Duration.zero, scroll);
//     //   });
//     // });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   // String imgType(String imgStr) {
//   //   if (imgStr == "peppa_pig" ||
//   //       imgStr == "gg_bond" ||
//   //       imgStr == "mickey" ||
//   //       imgStr == "eggy" ||
//   //       imgStr == "ultraman") {
//   //     return "1";
//   //   }

//   //   return "2";
//   // }

//   @override
//   Widget build(BuildContext context) {
//     Widget content(HomeProvider provider) {
//       double width = 150;
//       double height = 150;
//       return Row(
//         children: <Widget>[
//           // LoadImage(
//           //   widget.controller.leftImageUrl ?? "",
//           //   width: width,
//           //   height: height,
//           // ),
//           StreamBuilder(
//             stream: _avatarController.getStream(),
//             builder: (_, snapshot) {
//               String stillImage = provider.character.stillImage;
//               String motionImage = provider.character.motionImage;
//               // if (provider.character.stillImage != '') {
//               //   stillImage = provider.character.stillImage;
//               // }
//               // if (provider.character.motionImage != '') {
//               //   motionImage = provider.character.motionImage;
//               // }

//               // if (provider.character.characterId == "dora") {
//               //   stillImage = "dora_still_image";
//               //   motionImage = "dora_motion_image";
//               // } else if (provider.character.characterId == "peppa_pig") {
//               //   stillImage = "peppa_pig";
//               //   motionImage = "peppa_pig";
//               // } else if (provider.character.characterId == "sophia") {
//               //   stillImage = "sophia_still_image";
//               //   motionImage = "sophia_motion_image";
//               // } else if (provider.character.characterId == "gg_bond") {
//               //   stillImage = "gg_bond";
//               //   motionImage = "gg_bond";
//               // } else if (provider.character.characterId == "mickey") {
//               //   stillImage = "mickey";
//               //   motionImage = "mickey";
//               // } else if (provider.character.characterId == "eggy") {
//               //   stillImage = "eggy";
//               //   motionImage = "eggy";
//               // } else if (provider.character.characterId == "ultraman") {
//               //   stillImage = "ultraman";
//               //   motionImage = "ultraman";
//               // } else {
//               //   stillImage = "harry_potter_still_image";
//               //   motionImage = "harry_potter_motion_image";
//               // }

//               dynamic data = snapshot.data;
//               return Stack(
//                 children: [
//                   Container(
//                     width: width,
//                     height: height,
//                     alignment: Alignment.center,
//                     child:
//                         // LoadAssetImage(
//                         //   motionImage,
//                         //   format: imgType(motionImage) == "1"
//                         //       ? ImageFormat.jpg
//                         //       : ImageFormat.gif,
//                         //   width: width,
//                         //   height: height,
//                         //   fit: BoxFit.fitHeight,
//                         // )
//                         LoadImage(
//                       motionImage,
//                       height: height,
//                       fit: BoxFit.fitHeight,
//                     ),
//                   ),
//                   Container(
//                     width: data != null && data == true ? 0 : width,
//                     height: height,
//                     alignment: Alignment.center,
//                     color: Colors.white,
//                     child:
//                         // LoadAssetImage(
//                         //   stillImage,
//                         //   format: imgType(stillImage) == "1"
//                         //       ? ImageFormat.jpg
//                         //       : ImageFormat.gif,
//                         //   width: width,
//                         //   height: height,
//                         //   fit: BoxFit.fitHeight,
//                         // ),
//                         LoadImage(
//                       stillImage,
//                       height: height,
//                       fit: BoxFit.fitHeight,
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//           // LoadImage(
//           //   widget.controller.rightImageUrl ?? "",
//           //   width: width,
//           //   height: height,
//           // ),
//         ],
//       );
//     }

//     return Consumer<HomeProvider>(
//       builder: (_, provider, __) {
//         if (provider.chatBackground == null) {
//           return const SizedBox();
//         }
//         return SizedBox(
//           width: _screenUtil.screenWidth,
//           child: ValueListenableBuilder(
//             valueListenable: widget.controller.distance,
//             builder: (_, distance, child) {
//               _isScroll = true;
//               _distance = distance;
//               return child!;
//             },
//             child: SingleChildScrollView(
//               controller: _scrollController,
//               scrollDirection: Axis.horizontal,
//               physics: const NeverScrollableScrollPhysics(),
//               child: content(provider),
//             ),
//           ),
//         );

//         // return SizedBox(
//         //   width: _screenUtil.screenWidth,
//         //   child: ValueListenableBuilder(
//         //     valueListenable: widget.controller.distance,
//         //     builder: (_, distance, child) {
//         //       return Row(
//         //         children: <Widget>[
//         //           if (distance > 0 && widget.controller.slideDirection == 'right')
//         //             LoadImage(
//         //               widget.controller.leftImageUrl!,
//         //               width: distance,
//         //               height: _screenUtil.screenHeight,
//         //             ),
//         //           StreamBuilder(
//         //             stream: _avatarController.getStream(),
//         //             builder: (_, snapshot) {
//         //               double width = _screenUtil.screenWidth - distance;
//         //               double height = _screenUtil.screenHeight;
//         //               dynamic data = snapshot.data;
//         //               if (data == true) {
//         //                 return SizedBox(
//         //                   width: width,
//         //                   height: height,
//         //                   child: Speaker(
//         //                     url: "https://test-1308793220.cos.ap-guangzhou.myqcloud.com/speaking.mp4",
//         //                     aspectRatio: width / height,
//         //                   ),
//         //                 );
//         //               }
//         //               return LoadImage(
//         //                 provider.chatBackground!,
//         //                 width: width,
//         //                 height: height,
//         //               );
//         //             },
//         //           ),
//         //           if (distance > 0 && widget.controller.slideDirection == 'left')
//         //             LoadImage(
//         //               widget.controller.rightImageUrl!,
//         //               width: distance,
//         //               height: _screenUtil.screenHeight,
//         //             ),
//         //         ],
//         //       );
//         //     },
//         //   ),
//         // );
//       },
//     );
//   }
// }

// class BackgroundController {
//   BackgroundController();

//   Offset? initialPosition;
//   // left-左滑 right-右滑
//   String slideDirection = '';
//   ValueNotifier<double> distance = ValueNotifier(0);
//   String? leftImageUrl;
//   String? rightImageUrl;

//   void setSideImage(String leftImage, String rightImage) {
//     leftImageUrl = leftImage;
//     rightImageUrl = rightImage;
//   }

//   void slideStart({
//     required Offset position,
//     // required String leftImage,
//     // required String rightImage,
//   }) {
//     initialPosition = position;
//     // leftImageUrl= leftImage;
//     // rightImageUrl = rightImage;
//   }

//   void slideMove(Offset position) {
//     if (initialPosition == null) {
//       return;
//     }
//     double initialX = initialPosition!.dx;
//     double x = position.dx;
//     slideDirection = x == initialX
//         ? ''
//         : x > initialX
//             ? 'right'
//             : 'left';
//     double xDistance = (x - initialX).abs();
//     distance.value = xDistance;
//   }

//   void slideEnd(onSlideEnd) {
//     if (distance.value > 50) {
//       onSlideEnd(slideDirection);
//     }
//     distance.value = 0;
//     slideDirection = '';
//     initialPosition = null;
//     // leftImageUrl = null;
//     // rightImageUrl = null;
//   }
// }

// class AvatarController {
//   factory AvatarController() {
//     return _avatarController;
//   }
//   AvatarController._internal();

//   static final AvatarController _avatarController =
//       AvatarController._internal();

//   final StreamController _streamController = StreamController.broadcast();

//   Stream getStream() {
//     return _streamController.stream;
//   }

//   void startSpeak() {
//     _streamController.sink.add(true);
//   }

//   void stopSpeak() {
//     _streamController.sink.add(false);
//   }
// }
