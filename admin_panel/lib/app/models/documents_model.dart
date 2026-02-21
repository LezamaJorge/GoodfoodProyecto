import 'dart:convert';

class DocumentsModel {
  final String id;
  bool ? active;
  final bool isTwoSide;
  final String title;
  final String type;

  DocumentsModel({
    required this.id,
    required this.active,
    required this.isTwoSide,
    required this.title,
    required this.type,
  });

  factory DocumentsModel.fromRawJson(String str) => DocumentsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocumentsModel.fromJson(Map<String, dynamic> json) => DocumentsModel(
    id: json["id"],
    active: json["active"],
    isTwoSide: json["isTwoSide"],
    title: json["title"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "active": active??false,
    "isTwoSide": isTwoSide,
    "title": title,
    "type": type,
  };
}
