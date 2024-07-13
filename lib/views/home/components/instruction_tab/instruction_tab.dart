import 'package:crawler/config/config.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

class InstructionTab extends StatefulWidget {
  const InstructionTab({super.key});

  @override
  State<InstructionTab> createState() => _InstructionTabState();
}

class _InstructionTabState extends State<InstructionTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        width: 500,
        height: 600,
        child: Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Tải xuống file hướng dẫn',
                  ),
                ),
                const Icon(
                  Icons.install_desktop_rounded,
                  size: 100,
                  color: Colors.deepPurpleAccent,
                ),
                ElevatedButton(
                  onPressed: () {
                    js.context.callMethod('open', [downloadInstructionAPI]);
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.deepPurpleAccent),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Tải xuống',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
