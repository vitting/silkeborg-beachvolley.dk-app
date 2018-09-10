class InfoUser {
  String name;
  String id;
  String photoUrl;

  InfoUser({this.id, this.name, this.photoUrl});

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "photoUrl": photoUrl};
  }

  static InfoUser fromMap(Map<String, dynamic> item) {
    return InfoUser(
        id: item["id"] == null ? "" : item["id"],
        name: item["name"] == null ? "" : item["name"],
        photoUrl: item["photoUrl"] == null ? "" : item["photoUrl"]);
  }
}
