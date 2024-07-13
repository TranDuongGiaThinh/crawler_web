import 'dart:convert';
import 'package:crawler/global/global_data.dart';
import 'package:http/http.dart' as http;
import 'package:crawler/config/config.dart';

import 'package:crawler/models/user_model.dart';
import 'package:flutter/material.dart';

class RegistrationPresenter {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  String message = '';
  final Function reload;

  RegistrationPresenter({required this.reload});

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    fullnameController.dispose();
  }

  checkInput() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String fullname = fullnameController.text.trim();

    if (username.isNotEmpty) {
      await checkUsernameExists();

      if (message.isNotEmpty) {
        reload();
        return;
      }
    }

    // Kiểm tra các trường hợp nhập liệu
    if (fullname.isEmpty) {
      message = 'Vui lòng nhập họ và tên!';
    } else if (username.isEmpty) {
      message = 'Vui lòng nhập tên đăng nhập!';
    } else if (username.length < 6) {
      message = 'Tên đăng nhập chứa ít nhất 6 ký tự!';
    } else if (password.isEmpty) {
      message = 'Vui lòng nhập mật khẩu!';
    } else if (email.isEmpty) {
      message = 'Vui lòng nhập email!';
    } else if (email.length < 5) {
      message = 'Email không hợp lệ!';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      message = 'Email chưa đúng định dạng!';
    } else if (phone.isEmpty) {
      message = 'Vui lòng nhập số điện thoại!';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      message = 'Số điện thoại chưa đúng định dạng!';
    } else if (phone.length < 10) {
      message = 'Số điện thoại chứa ít nhất 10 ký tự!';
    } else {
      message = '';
    }

    reload();
  }

  register() async {
    await checkInput();
    if (message.isNotEmpty) return null;

    await checkUsernameExists();
    if (message.isNotEmpty) return null;

    UserModel? user = await createUser();

    userLogin = user;
  }

  checkUsernameExists() async {
    try {
      String username = usernameController.text.trim();

      final url = Uri.parse('$checkUsernameExistsAPI$username');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        if (body['exists']) {
          message = 'Tên đăng nhập đã tồn tại!';
          reload();
        } else {
          message = '';
        }
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        message = body['error'] ?? 'Lỗi không xác định';
        reload();
      }
    } catch (error) {
      print("Lỗi khi kiểm tra tên đăng nhập: $error");
    }
  }

  Future<UserModel?> createUser() async {
    try {
      String username = usernameController.text.trim();
      String password = passwordController.text.trim();
      String email = emailController.text.trim();
      String phone = phoneController.text.trim();
      String fullname = fullnameController.text.trim();

      final url = Uri.parse(createUserAPI);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user': {
            'username': username,
            'password': password,
            'email': email,
            'phone': phone,
            'fullname': fullname,
          }
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> body = json.decode(response.body);
        return UserModel.fromJson(body['user']);
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        message = body['error'] ?? 'Lỗi không xác định';
        reload();
        return null;
      }
    } catch (error) {
      print("Lỗi khi đăng ký tài khoản: $error");
      return null;
    }
  }
}
