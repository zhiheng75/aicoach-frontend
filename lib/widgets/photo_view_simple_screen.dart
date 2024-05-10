import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// class PhotoViewSimpleScreen extends StatefulWidget {
//   const PhotoViewSimpleScreen({super.key});

//   @override
//   State<PhotoViewSimpleScreen> createState() => _PhotoViewSimpleScreenState();
// }

// class _PhotoViewSimpleScreenState extends State<PhotoViewSimpleScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class PhotoViewSimpleScreen extends StatelessWidget {
  final ImageProvider imageProvider;
  // final dynamic minScale;
  // final dynamic maxScale;
  // final String heroTag;
  const PhotoViewSimpleScreen({
    super.key,
    required this.imageProvider, //图片
    // required this.minScale, //最大缩放倍数
    // required this.maxScale, //最小缩放倍数
    //  this.heroTag = "heroTag", ////hero动画tagid
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: PhotoView(
                imageProvider: imageProvider,
                // minScale: minScale,
                // maxScale: maxScale,
                // heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
                enableRotation: true,
              ),
            ),
            Positioned(
              //右上角关闭按钮
              right: 10,
              top: 60,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
