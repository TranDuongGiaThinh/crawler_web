class SettingModel {
  final String appFilePath;
  final String instructionFilePath;

  SettingModel({
    required this.appFilePath,
    required this.instructionFilePath,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      appFilePath: json['app_file_path'],
      instructionFilePath: json['instruction_file_path'],
    );
  }
}