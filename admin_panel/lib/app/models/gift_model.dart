class GiftModel {
  String? id;
  int? points;
  String? giftImages;
  bool? isEnable;

  GiftModel({this.id, this.points,  this.giftImages, this.isEnable, });

  GiftModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    points = json['points']??0;
    giftImages = json['giftImages'];
    isEnable = json['isEnable'] ?? true;
  }

  @override
  String toString() {
    return 'GiftModel{id: $id, points: $points,  giftImages: $giftImages, isEnable: $isEnable}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['points'] = points??0;
    data['giftImages'] = giftImages;
    data['isEnable'] = isEnable ?? true;
    return data;
  }
}
