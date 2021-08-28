import 'comment_model.dart';

class Advertisement {
  String _id = "";
  String _userId = "";
  String _title = "";
  String _description = "";
  bool _publish = false;
  List<Comment> _comments = [];

  Advertisement({
    String userId = "",
    String title = "",
    String description = "",
    bool publish = false,
    required List<Comment> comments,
  }) {
    this._id = id;
    this._userId = userId;
    this._title = title;
    this._description = description;
    this._comments = comments;
    this._publish = publish;
  }

  String get id => _id;
  String get userId => _userId;
  String get title => _title;
  String get description => _description;
  bool get publish => _publish;
  List<Comment> get comments => _comments;


  set id(String id) {
    this._id = id;
  }

  set publish(bool value) {
    this._publish = value;
  }

  set title(String value) {
    this._title = value;
  }

  set description(String value) {
    this._description = value;
  }

  Advertisement.fromJson(Map<String, dynamic> json) {
    print(json);
    _id = json["id"].toString();
    _userId = json["user_id"].toString();
    _title = json["title"];
    _description = json["description"];
    _publish = json["publish"];
    _comments = [];
  }
}