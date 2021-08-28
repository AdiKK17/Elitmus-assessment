class Comment {
  String _id = "";
  String _userId = "";
  String _comment = "";
  String _advertisementId = "";


  Comment({
    String id = "",
    String userId = "",
    String comment = "",
    String advertisementId = ""
  }) {
    this._id = id;
    this._userId = userId;
    this._comment = comment;
    this._advertisementId = advertisementId;
  }

  String get id => _id;
  String get userId => _userId;
  String get comment => _comment;
  String get advertisementId => _advertisementId;

  set id(String id) {
    this._id = id;
  }

  Comment.fromJson(Map<String, dynamic> json) {
    _id = json["id"].toString();
    _userId = json["user_id"].toString();
    _comment = json["comment"];
    _advertisementId = json["advertisement_id"].toString();
  }
}