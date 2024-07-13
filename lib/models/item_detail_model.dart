class ItemDetailModel {
  final String name;
  final String value;

  ItemDetailModel({
    required this.name,
    required this.value,
  });

  factory ItemDetailModel.fromJson(Map<String, dynamic> json) {
    return ItemDetailModel(
      name: json['name'],
      value: json['value'],
    );
  }
}