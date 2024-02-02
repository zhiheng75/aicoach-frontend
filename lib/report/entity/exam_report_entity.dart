class ExamReportEntity {

  int id = 0;
  String name = '';
  int duration = 0;
  int score = 0;
  String examinerAvatar = '';
  String createTime = '';

  ExamReportEntity();

  factory ExamReportEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    ExamReportEntity entity = ExamReportEntity ();
    if (json['id'] != null) {
      entity.id = json['id'];
    }
    if (json['title'] != null) {
      entity.name = json['title'];
    }
    if (json['duration'] != null) {
      entity.duration = json['duration'];
    }
    if (json['score'] != null) {
      entity.score = json['score'];
    }
    if (json['character_avatar'] != null) {
      entity.examinerAvatar = json['character_avatar'];
    }
    if (json['created_at'] != null) {
      entity.createTime = json['created_at'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'duration': duration,
      'score': score,
      'character_avatar': examinerAvatar,
      'created_at': createTime,
    };
  }

}