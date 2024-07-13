import 'package:crawler/global/global_data.dart';
import 'package:crawler/views/login/presenter/register_presenter.dart';
import 'package:flutter/material.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  RegistrationFormState createState() => RegistrationFormState();
}

class RegistrationFormState extends State<RegistrationForm> {
  late RegistrationPresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = RegistrationPresenter(reload: () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            controller: presenter.fullnameController,
            decoration: const InputDecoration(labelText: 'Họ và tên'),
          ),
          TextField(
            controller: presenter.usernameController,
            decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
          ),
          TextField(
            controller: presenter.passwordController,
            decoration: const InputDecoration(labelText: 'Mật khẩu'),
            obscureText: true,
          ),
          TextField(
            controller: presenter.emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: presenter.phoneController,
            decoration: const InputDecoration(labelText: 'Số điện thoại'),
          ),
          if (presenter.message.isNotEmpty)
            Text(
              presenter.message,
              style: const TextStyle(color: Colors.red),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await presenter.register();
              if (userLogin != null) {
                // Điều hướng đến màn hình chính
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
            child: const Text('Đăng ký'),
          ),
        ],
      ),
    );
  }
}
