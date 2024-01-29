import 'package:flutter/services.dart';

class MockMessageEntity {
  String sessionId = '';
  String messageId = '';
  String text = '';
  String speechfile = '';
  String type = '3';
  List<Uint8List> audio = [];
}

class MockMessageUPEntity {
  // String id = '';
  // String answer = '';
  List<Map<String, dynamic>> answer = [];
}
