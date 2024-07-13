import 'package:crawler/models/item_detail_model.dart';

class ItemModel {
  final int id;
  final int configId;
  final int itemTypeId;
  final String itemTypeName;
  final String websiteName;
  final String websiteUrl;
  final List<ItemDetailModel> itemDetails;

  ItemModel({
    required this.id,
    required this.configId, 
    required this.itemTypeId,
    required this.itemTypeName,
    required this.websiteName,
    required this.websiteUrl,
    required this.itemDetails,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    List<ItemDetailModel> details = (json['item_details'] as List)
        .map((detail) => ItemDetailModel.fromJson(detail))
        .toList();

    return ItemModel(
      id: json['id'],
      configId: json['crawl_config_id'],
      itemTypeId: json['item_type_id'],
      itemTypeName: json['item_type_name'],
      websiteName: json['website_name'],
      websiteUrl: json['website_url'],
      itemDetails: details,
    );
  }
}