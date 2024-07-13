class UserModel {
  int id;
  int accountTypeId;
  String username;
  String fullname;
  String email;
  String phone;
  bool isAdmin;
  bool locked;

  UserModel({
    required this.id,
    required this.accountTypeId,
    required this.username,
    required this.fullname,
    required this.email,
    required this.phone,
    required this.isAdmin,
    required this.locked,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      accountTypeId: json['account_type_id'],
      username: json['username'],
      fullname: json['fullname'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      isAdmin: json['is_admin'] == 1,
      locked: json['locked'],
    );
  }
}
