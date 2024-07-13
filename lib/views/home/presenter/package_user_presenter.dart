import 'dart:convert';
import 'package:crawler/config/config.dart';
import 'package:crawler/global/global_data.dart';
import 'package:crawler/models/package_type_model.dart';
import 'package:crawler/models/package_user_model.dart';
import 'package:crawler/views/home/presenter/package_type_presenter.dart';
import 'package:http/http.dart' as http;

class PackageUserPresenter {
  static PackageUserModel? packageUserActive;
  static List<PackageUserModel> packageUsers = [];
  final Function reload;

  PackageUserPresenter({required this.reload});

  static Future<void> fetchPackageUserOfUser(int userId) async {
    try {
      final response = await http.get(Uri.parse("$getAllUserPackageUserOfUser$userId"));

      if (response.statusCode == 200) {
        final List<dynamic> data =
            json.decode(response.body)['package_users'];
        packageUsers =
            data.map((json) => PackageUserModel.fromJson(json)).toList();

        if (packageUsers.isNotEmpty) {
          packageUserActive = getPackageUserActive();
        }
      } else {
        print('Lỗi tải dữ liệu: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
    }
  }

  static PackageUserModel? getPackageUserActive() {
    try {
      return packageUsers.firstWhere((user) => user.isActive);
    } catch (error) {
      return null;
    }
  }

  static Future<DateTime?> getOutdate(PackageUserModel packageUser) async {
    try {
      PackageTypeModel packageType = (await PackageTypePresenter.getPackageType(
          packageUser.packageTypeId))!;
      int days = packageType.days;
      DateTime startDate = packageUser.createAt;
      DateTime outdate = startDate.add(Duration(days: days));
      return outdate;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> checkOutdate(PackageUserModel packageUser) async {
    try {
      DateTime? outdate = await getOutdate(packageUser);

      if (outdate == null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<PackageUserModel?> createPackageUser(int packageTypeId, int userTypeId, int totalPrice) async {
    try {

      final url = Uri.parse(creatPackageUserAPI);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "user_id": userLogin!.id,
          "package_type_id": packageTypeId,
          "user_type_id": userTypeId,
          "total_price": totalPrice,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> body = json.decode(response.body);
        return PackageUserModel.fromJson(body['package_user']);
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        print(body['error']);
        return null;
      }
    } catch (error) {
      print("Lỗi khi đăng ký gói tài khoản: $error");
      return null;
    }
  }
}
