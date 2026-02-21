class ChatThemeModel {
  String? id;
  String? name;
  String? color;
  String? lightThemeImage;
  String? darkThemeImage;
  bool? isEnable;

  ChatThemeModel({this.id, this.name, this.color, this.lightThemeImage, this.isEnable, this.darkThemeImage});

  ChatThemeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    lightThemeImage = json['lightThemeImage'];
    darkThemeImage = json['darkThemeImage'];
    isEnable = json['isEnable'] ?? true;
  }

  @override
  String toString() {
    return 'ChatThemeModel{id: $id, name: $name, color: $color, lightThemeImage: $lightThemeImage, isEnable: $isEnable , darkThemeImage: $darkThemeImage}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['color'] = color;
    data['lightThemeImage'] = lightThemeImage;
    data['darkThemeImage'] = darkThemeImage;
    data['isEnable'] = isEnable ?? true;
    return data;
  }
}
