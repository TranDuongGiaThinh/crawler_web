class UserTypeModel {
  final int id;
  final String type;
  final String description;
  final int price;
  final int maxConfigs;

  UserTypeModel({
    required this.id,
    required this.type,
    required this.description,
    required this.price,
    required this.maxConfigs
  });

  factory UserTypeModel.fromJson(Map<String, dynamic> json) {
    return UserTypeModel(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      price: json['price'],
      maxConfigs: json['max_configs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'price': price,
      'max_configs': maxConfigs,
    };
  }
}
