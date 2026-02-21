class DocumentModel {
  String? id;
  String? name;
  String? type;
  bool? active;
  bool? isTwoSide;

  DocumentModel({
    this.id,
    this.name,
    this.type,
    this.active,
    this.isTwoSide,
  });

  DocumentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['title'];
    type = json['type'];
    active = json['active'];
    isTwoSide = json['isTwoSide'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = name;
    data['type'] = type;
    data['active'] = active;
    data['isTwoSide'] = isTwoSide;
    return data;
  }
}

