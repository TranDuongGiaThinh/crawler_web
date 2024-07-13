import 'dart:convert';
import 'package:crawler/config/config.dart';
import 'package:http/http.dart' as http;

import 'package:crawler/models/package_type_model.dart';

class PackageTypePresenter {
  static List<PackageTypeModel> packageTypes = [];

  PackageTypePresenter();

  Future<void> fetchPackageTypes() async {
    String message = "";
    try {
      final response = await http.get(Uri.parse(getAllPackageTypeAPI));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['package_types'];
        packageTypes =
            data.map((json) => PackageTypeModel.fromJson(json)).toList();
        message = 'Dữ liệu đã được tải thành công';
      } else {
        message = 'Không thể tải dữ liệu';
        print(message);
      }
    } catch (e) {
      message = 'Đã xảy ra lỗi: $e';
      print(message);
    }
  }

  static Future<PackageTypeModel?> getPackageType(int packageTypeId) async {
    try {
      final response =
          await http.get(Uri.parse("$getPackageTypeAPI$packageTypeId"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return PackageTypeModel.fromJson(body['package_type']);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static String? getPackageTypeName(int packageTypeId) {
    try {
      final packageType = packageTypes.firstWhere((type) => type.id == packageTypeId);
      return packageType.type;
    } catch (error) {
      return null;
    }
  }
}
