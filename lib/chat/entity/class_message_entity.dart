import 'package:flutter/services.dart';

class ErrorClassMessageEntity {
  String sessionId = '';

  String tesuggestionSentencext = '';
  String suggestionAudio = '';

  String speechfile = '';
  String text = '';

  List<Uint8List> audio = [];
}

class MockMessageUPEntity {
  // String id = '';
  // String answer = '';
  List<Map<String, dynamic>> answer = [];
}
