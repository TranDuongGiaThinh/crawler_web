import 'dart:convert';

import 'package:crawler/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:crawler/models/user_model.dart';
import 'package:flutter/material.dart';

class LoginPresenter {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = '';
  final Function reload;

  LoginPresenter({required this.reload});

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }

  Future<UserModel?> login() async {
    checkInput();

    if (message.isEmpty) {
      // Thực hiện đăng nhập khi đầu vào hợp lệ
      UserModel? user = await checkLogin();

      return user;
    } else {
      return null;
    }
  }

  void checkInput() {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty) {
      message = 'Vui lòng nhập tên đăng nhập!';
    } else if (password.isEmpty) {
      message = 'Vui lòng nhập mật khẩu!';
    } else {
      message = '';
    }
    reload();
  }

  Future<UserModel?> checkLogin() async {
    try {
      String username = usernameController.text;
      String password = passwordController.text;

      final url = Uri.parse(checkLoginAPI);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserModel.fromJson(data['user']);
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        message = body['error'] ?? 'Lỗi không xác định';
        reload();
        return null;
      }
    } catch (error) {
      print("Lỗi khi đăng nhập: $error");
      return null;
    }
  }
}
