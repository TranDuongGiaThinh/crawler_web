import 'package:flutter/material.dart';

class IntroductionTab extends StatefulWidget {
  const IntroductionTab({super.key});

  @override
  State<IntroductionTab> createState() => _IntroductionTabState();
}

class _IntroductionTabState extends State<IntroductionTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 50,
            color: Colors.deepPurpleAccent,
          ),
          SizedBox(height: 20),
          Text(
            'Trang này đang được cập nhật...',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
