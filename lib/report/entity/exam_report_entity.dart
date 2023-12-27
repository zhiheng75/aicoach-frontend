class ExamReportEntity {

  int id = 0;
  String name = '';
  int duration = 0;
  int score = 0;
  String examinerAvatar = '';
  String examinerName = '';
  String createTime = '';

  ExamReportEntity();

  factory ExamReportEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    ExamReportEntity entity = ExamReportEntity ();
    if (json['id'] != null) {
      entity.id = json['id'];
    }
    if (json['name'] != null) {
      entity.name = json['name'];
    }
    if (json['duration'] != null) {
      entity.duration = json['duration'];
    }
    if (json['score'] != null) {
      entity.score = json['score'];
    }
    if (json['examiner_avatar'] != null) {
      entity.examinerAvatar = json['examiner_avatar'];
    }
    if (json['examiner_name'] != null) {
      entity.examinerName = json['examiner_name'];
    }

    if (json['create_time'] != null) {
      entity.createTime = json['create_time'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'score': score,
      'examiner_avatar': examinerAvatar,
      'examiner_name': examinerName,
      'create_time': createTime,
    };
  }

}