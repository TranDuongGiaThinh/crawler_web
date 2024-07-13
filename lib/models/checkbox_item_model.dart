class CheckBoxItem {
  final int? id;
  final String name;

  CheckBoxItem({
    required this.id,
    required this.name,
  });

  factory CheckBoxItem.fromJson(Map<String, dynamic> json) {
    return CheckBoxItem(
      id: json['id'],
      name: json['name'],
    );
  }
}