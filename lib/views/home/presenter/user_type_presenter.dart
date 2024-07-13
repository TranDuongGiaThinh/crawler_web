import 'dart:convert';
import 'package:crawler/config/config.dart';
import 'package:crawler/global/global_data.dart';
import 'package:crawler/models/package_type_model.dart';
import 'package:crawler/models/package_user_model.dart';
import 'package:crawler/models/user_type_model.dart';
import 'package:crawler/views/home/components/user_type_tab/package_type_dialog.dart';
import 'package:crawler/views/home/presenter/package_type_presenter.dart';
import 'package:crawler/views/home/presenter/package_user_presenter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserTypePresenter {
  static List<UserTypeModel> userTypes = [];
  String message = '';
  final Function reload;

  UserTypePresenter({required this.reload});

  fetchUserTypes() async {
    try {
      final response = await http.get(Uri.parse(getAllUserTypeAPI));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['user_types'];
        userTypes = data.map((json) => UserTypeModel.fromJson(json)).toList();
        message = 'Dữ liệu đã được tải thành công';
      } else {
        message = 'Lỗi tải dữ liệu: ${response.statusCode}';
      }
    } catch (error) {
      message = 'Lỗi tải dữ liệu: $error';
    }

    reload();
  }

  static Future<UserTypeModel?> getPackageType(int userTypeId) async {
    try {
      final response = await http.get(Uri.parse("$getUserTypeAPI$userTypeId"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return UserTypeModel.fromJson(body['user_type']);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  void onClickItem(
    BuildContext context,
    UserTypeModel userType,
    PackageTypePresenter packageTypePresenter,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PackageTypeDialog(
          userType: userType,
          packageTypePresenter: packageTypePresenter,
          onConfirm: (PackageTypeModel packageType, int userTypeId,
              double totalPrice) async {
            PackageUserModel? packageUser =
                await PackageUserPresenter.createPackageUser(
                    packageType.id, userTypeId, totalPrice.ceil());
            if (packageUser != null) {
              await PackageUserPresenter.fetchPackageUserOfUser(userLogin!.id);
              reload();
              return true;
            }
            return false;
          },
        );
      },
    );
  }

  static UserTypeModel? getUserType(int userTypeId) {
    try {
      final userType = userTypes.firstWhere((type) => type.id == userTypeId);
      return userType;
    } catch (error) {
      return null;
    }
  }
}
