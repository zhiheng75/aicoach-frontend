import 'package:flutter/material.dart';

class MyExaminationDetailPage extends StatefulWidget {
  final String idStr;
  const MyExaminationDetailPage({super.key, required this.idStr});

  @override
  State<MyExaminationDetailPage> createState() =>
      _MyExaminationDetailPageState();
}

class _MyExaminationDetailPageState extends State<MyExaminationDetailPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (BuildContext c, int i) {
        return Container(
          alignment: Alignment.center,
          height: 60.0,
          child: Text(
            '${widget.idStr}: ListView$i',
          ),
        );
      },
    );
  }
}
