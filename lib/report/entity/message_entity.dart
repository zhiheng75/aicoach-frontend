class MessageEntity {
  late String sessionId;
  late String messageId;
  late String clientMessageUnicode;
  late String serverMessageUnicode;

  MessageEntity();

  MessageEntity.fromJson(Map<String, dynamic> json) {
    sessionId = json['session_id'];
    messageId = json['message_id'];
    clientMessageUnicode = json['client_message_unicode'];
    serverMessageUnicode = json['server_message_unicode'];
  }
}