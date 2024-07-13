import 'dart:convert';

import 'package:crawler/config/config.dart';
import 'package:crawler/models/package_type_model.dart';
import 'package:crawler/models/setting_model.dart';
import 'package:crawler/models/user_model.dart';
import 'package:crawler/models/user_type_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminPresenter {
  final Function reload;
  List<UserTypeModel> userTypes = [];
  List<PackageTypeModel> packageTypes = [];
  List<UserModel> users = [];
  SettingModel? setting;

  late TabController tabController;
  final TextEditingController appFilePathController = TextEditingController();
  final TextEditingController instructionFilePathController =
      TextEditingController();

  String message = '';
  Color messageColor = Colors.red;

  bool isHandling = false;

  AdminPresenter({required this.reload});

  loadSetting() async {
    isHandling = true;
    try {
      final response = await http.get(Uri.parse(getSettingAPI));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        setting = SettingModel.fromJson(body['setting']);
        reload();
      } else {
        print("Lấy dữ liệu thất bại");
      }
    } catch (error) {
      print("lỗi khi lấy thông tin cài đặt");
    }
    isHandling = false;
  }

  updateAppFilePath() async {
    if (isHandling == true) {
      return;
    }

    isHandling = true;

    final String appFilePath = appFilePathController.text;

    if (appFilePath.isEmpty) {
      message = "Đường dẫn không được để trống";
      messageColor = Colors.red;
      isHandling = false;
      appFilePathController.text = "";
      reload();
      return;
    }

    try {
      final response = await http.put(
        Uri.parse(updateAppFilePathAPI),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'path': appFilePath,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        setting = SettingModel.fromJson(body['setting']);
        message = "Thay đổi thành công";
        messageColor = Colors.blue;
      } else {
        message = "Thay đổi thất bại";
        messageColor = Colors.red;
      }
    } catch (error) {
      print("Lỗi khi cập nhật thông tin cài đặt: $error");
      message = "Có lỗi khi thực hiện thay đổi, thay đổi thất bại";
      messageColor = Colors.red;
    }

    isHandling = false;
    appFilePathController.text = "";
    reload();
  }

  updateInstructionFilePath() async {
    if (isHandling == true) {
      return;
    }

    isHandling = true;

    final String instructionFilePath = instructionFilePathController.text;

    if (instructionFilePath.isEmpty) {
      message = "Đường dẫn không được để trống";
      messageColor = Colors.red;
      isHandling = false;
      instructionFilePathController.text = "";
      reload();
      return;
    }

    try {
      final response = await http.put(
        Uri.parse(updateInstructionFilePathAPI),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'path': instructionFilePath,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        setting = SettingModel.fromJson(body['setting']);
        message = "Thay đổi thành công";
        messageColor = Colors.blue;
      } else {
        message = "Thay đổi thất bại";
        messageColor = Colors.red;
      }
    } catch (error) {
      print("Lỗi khi cập nhật thông tin file hướng dẫn: $error");
      message = "Có lỗi khi thực hiện thay đổi, thay đổi thất bại";
      messageColor = Colors.red;
    }

    isHandling = false;
    instructionFilePathController.text = "";
    reload();
  }

  // Users
  loadUsers() async {
    isHandling = true;
    try {
      final response = await http.get(Uri.parse(getAllUserAPI));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['users'];
        users = data.map((json) => UserModel.fromJson(json)).toList();
        message = 'Dữ liệu đã được tải thành công';
      } else {
        message = 'Lỗi tải dữ liệu: ${response.statusCode}';
      }
    } catch (error) {
      message = 'Lỗi tải dữ liệu: $error';
    }

    isHandling = false;
    reload();
  }

  Future<bool> lockUser(int id) async {
    isHandling = true;
    try {
      final response = await http.get(Uri.parse('$lockUserAPI$id'));

      if (response.statusCode == 200) {
        isHandling = false;
        return true;
      } else {
        print('Lỗi khi khóa người dùng: ${response.statusCode}');

        isHandling = false;
        return false;
      }
    } catch (error) {
      isHandling = false;
      return false;
    }
  }

  Future<bool> unlockUser(int id) async {
    isHandling = true;
    try {
      final response = await http.get(Uri.parse('$unlockUserAPI$id'));

      if (response.statusCode == 200) {
        isHandling = false;
        return true;
      } else {
        print('Lỗi khi khóa người dùng: ${response.statusCode}');

        isHandling = false;
        return false;
      }
    } catch (error) {
      isHandling = false;
      return false;
    }
  }

  // Loại gói thành viên
  loadUserTypes() async {
    isHandling = true;
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

    isHandling = false;
    reload();
  }

  createUserType(UserTypeModel userType) async {
    if (isHandling) return;
    isHandling = true;

    try {
      final response = await http.post(
        Uri.parse(createUserTypeAPI),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"user_type": userType.toJson()}),
      );

      if (response.statusCode == 201) {
        await loadUserTypes();
      } else {
        print("Lỗi khi tạo user type: ${response.body}");
      }
    } catch (error) {
      print("Lỗi khi tạo user type: $error");
    }
    isHandling = false;
    reload();
  }

  Future<void> updateUserType(UserTypeModel userType) async {
    if (isHandling) return;
    isHandling = true;

    try {
      final response = await http.put(
        Uri.parse(updateUserTypeAPI),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"user_type": userType.toJson()}),
      );

      if (response.statusCode == 200) {
        await loadUserTypes();
      } else {
        print("Lỗi khi cập nhật user type: ${response.body}");
      }
    } catch (error) {
      print("Lỗi khi cập nhật user type: $error");
    }

    isHandling = false;
    reload();
  }

  Future<void> deleteUserType(int id) async {
    if (isHandling) return;
    isHandling = true;

    try {
      final response = await http.delete(
        Uri.parse('$deleteUserTypeAPI$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        await loadUserTypes();
      } else {
        print("Lỗi xóa user type: ${response.body}");
      }
    } catch (error) {
      print("Lỗi xóa user type: $error");
    }

    isHandling = false;
    reload();
  }

  // Loại gói thời hạn
  loadPackageTypes() async {
    isHandling = true;
    try {
      final response = await http.get(Uri.parse(getAllPackageTypeAPI));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['package_types'];
        packageTypes =
            data.map((json) => PackageTypeModel.fromJson(json)).toList();
        message = 'Dữ liệu đã được tải thành công';
      } else {
        message = 'Lỗi tải dữ liệu: ${response.statusCode}';
      }
    } catch (error) {
      message = 'Lỗi tải dữ liệu: $error';
    }

    isHandling = false;
    reload();
  }

  createPackageType(PackageTypeModel packageType) async {
    if (isHandling) return;
    isHandling = true;

    try {
      final response = await http.post(
        Uri.parse(createPackageTypeAPI),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"package_type": packageType.toJson()}),
      );

      if (response.statusCode == 201) {
        await loadPackageTypes();
      } else {
        print("Lỗi khi tạo package type: ${response.body}");
      }
    } catch (error) {
      print("Lỗi khi tạo package type: $error");
    }
    isHandling = false;
    reload();
  }

  updatePackageType(PackageTypeModel packageType) async {
    if (isHandling) return;
    isHandling = true;

    try {
      final response = await http.put(
        Uri.parse(updatePackageTypeAPI),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"package_type": packageType.toJson()}),
      );

      if (response.statusCode == 200) {
        await loadPackageTypes();
      } else {
        print("Lỗi khi cập nhật package type: ${response.body}");
      }
    } catch (error) {
      print("Lỗi khi cập nhật package type: $error");
    }

    isHandling = false;
    reload();
  }

  deletePackageType(int id) async {
    if (isHandling) return;
    isHandling = true;

    try {
      final response = await http.delete(
        Uri.parse('$deletePackageTypeAPI$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        await loadPackageTypes();
      } else {
        print("Lỗi xóa package type: ${response.body}");
      }
    } catch (error) {
      print("Lỗi xóa package type: $error");
    }

    isHandling = false;
    reload();
  }

  UserTypeModel? getUserType(int userTypeId) {
    try {
      final userType = userTypes.firstWhere((type) => type.id == userTypeId);
      return userType;
    } catch (error) {
      return null;
    }
  }

  String? getPackageTypeName(int packageTypeId) {
    try {
      final packageType =
          packageTypes.firstWhere((type) => type.id == packageTypeId);
      return packageType.type;
    } catch (error) {
      return null;
    }
  }
}
