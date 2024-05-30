class Purpose {
  //prop
  int? id = -1;
  String? name;
  int iconId;
  //constructor
  Purpose({this.id, this.name, this.iconId = 0});
  //to map
  Map<String, Object?> toMap(){
    return {
      "id": id,
      "name": name,
      "iconId": iconId
    };
  }
  @override
  String toString() {
    // TODO: implement toString
    return "{$id, $name, $iconId}";
  }
}