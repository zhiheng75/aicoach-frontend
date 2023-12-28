class StudyEntity {

  int count = 0;
  int duration = 0;
  String rank = '0%';
  String activeRank = '0%';


  StudyEntity();

  factory StudyEntity.fromJson(dynamic json) {
    json = json as Map<String, dynamic>;
    StudyEntity entity = StudyEntity();
    if (json['session_count'] != null) {
      entity.count = json['session_count'];
    }
    if (json['duration'] != null) {
      entity.duration = json['duration'];
    }
    if (json['rank'] != null) {
      entity.rank = json['rank'];
    }
    if (json['active_rank'] != null) {
      entity.activeRank = json['active_rank'];
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'session_count': count,
      'duration': duration,
      'rank': rank,
      'active_rank': activeRank,
    };
  }

}