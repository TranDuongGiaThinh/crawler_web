class PackageUserModel {
  int id;
  int userTypeId;
  int userId;
  int packageTypeId;
  int totalPrice;
  int configCount;
  DateTime createAt;
  bool isActive;

  PackageUserModel({
    required this.id,
    required this.userTypeId,
    required this.userId,
    required this.packageTypeId,
    required this.totalPrice,
    required this.configCount,
    required this.createAt,
    required this.isActive,
  });

  factory PackageUserModel.fromJson(Map<String, dynamic> json) {
    return PackageUserModel(
      id: json['id'],
      userTypeId: json['user_type_id'],
      userId: json['user_id'],
      packageTypeId: json['package_type_id'],
      totalPrice: json['total_price'],
      configCount: json['config_count'],
      createAt: DateTime.parse(json['create_at']),
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_type_id': userTypeId,
      'user_id': userId,
      'package_type_id': packageTypeId,
      'total_price': totalPrice,
      'config_count': configCount,
      'create_at': createAt.toIso8601String(),
      'is_active': isActive,
    };
  }
}
