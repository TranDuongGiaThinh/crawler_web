import 'package:crawler/views/admin/presnter/admin_presenter.dart';
import 'package:flutter/material.dart';

class DownloadInstructionAdminTab extends StatefulWidget {
  const DownloadInstructionAdminTab({super.key, required this.presenter});
  final AdminPresenter presenter;

  @override
  State<DownloadInstructionAdminTab> createState() => _DownloadInstructionAdminTabState();
}

class _DownloadInstructionAdminTabState extends State<DownloadInstructionAdminTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget.presenter.isHandling
            ? const CircularProgressIndicator()
            : Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.presenter.instructionFilePathController,
                  decoration: const InputDecoration(
                    hintText: 'Đường dẫn chứa file hướng dẫn',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  widget.presenter.updateInstructionFilePath();
                },
                style: ButtonStyle(
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                  'Thay đổi',
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
        const SizedBox(height: 8),
        Text(
          widget.presenter.message,
          style: TextStyle(color: widget.presenter.messageColor),
        ),
      ],
    );
  }
}