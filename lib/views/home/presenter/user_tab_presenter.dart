import 'dart:convert';
import 'package:crawler/config/config.dart';
import 'package:crawler/models/package_type_model.dart';
import 'package:crawler/models/package_user_model.dart';
import 'package:crawler/models/user_model.dart';
import 'package:crawler/models/user_type_model.dart';
import 'package:crawler/views/home/presenter/package_type_presenter.dart';
import 'package:http/http.dart' as http;

class UserTabPresenter {
  UserModel user;
  PackageUserModel? packageUserActive;
  UserTypeModel? userType;
  List<PackageUserModel> packageUsers = [];
  DateTime? outDate;
  final Function reload;

  UserTabPresenter({required this.user, required this.reload});

  Future<void> loadPackageUserOfUser() async {
    try {
      final response =
          await http.get(Uri.parse("$getAllUserPackageUserOfUser${user.id}"));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['package_users'];
        packageUsers =
            data.map((json) => PackageUserModel.fromJson(json)).toList();
        packageUsers.sort((a, b) => b.createAt.compareTo(a.createAt));
        reload();

        if (packageUsers.isNotEmpty) {
          packageUserActive = getPackageUserActive();
          await getOutdate();
          await getUsertype();
        } else {
          final response = await http.get(Uri.parse(getUserTypeDefaultAPI));

          if (response.statusCode == 200) {
            final Map<String, dynamic> data =
                json.decode(response.body)['user_type'];
            UserTypeModel userType = UserTypeModel.fromJson(data);

            this.userType = userType;
          }
        }
      } else {
        print('Lỗi tải dữ liệu: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
    }
  }

  PackageUserModel? getPackageUserActive() {
    try {
      return packageUsers.firstWhere((user) => user.isActive);
    } catch (error) {
      return null;
    }
  }

  getOutdate() async {
    try {
      PackageTypeModel packageType = (await PackageTypePresenter.getPackageType(
          packageUserActive!.packageTypeId))!;
      int days = packageType.days;
      DateTime startDate = packageUserActive!.createAt;
      DateTime outdate = startDate.add(Duration(days: days));
      outDate = outdate;
    } catch (e) {
      print(e);
      outDate = null;
    }
  }

  getUsertype() async {
    try {
      final response = await http
          .get(Uri.parse("$getUserTypeAPI${packageUserActive!.userTypeId}"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(response.body)['user_type'];
        UserTypeModel userType = UserTypeModel.fromJson(data);

        this.userType = userType;
      } else {
        print('Lỗi tải dữ liệu');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkOutdate() async {
    try {
      DateTime? outdate = await getOutdate();

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
}
