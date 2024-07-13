import 'dart:convert';
import 'package:crawler/config/config.dart';
import 'package:crawler/global/global_data.dart';
import 'package:crawler/models/checkbox_item_model.dart';
import 'package:crawler/models/item_model.dart';
import 'package:http/http.dart' as http;

class ListItemTabPresenter {
  static List<ItemModel>? items;
  List<CheckBoxItem> configs = [CheckBoxItem(id: null, name: "Chọn cấu hình")];
  List<CheckBoxItem> itemTypes = [CheckBoxItem(id: null, name: "Chọn chủ đề")];
  List<CheckBoxItem> websites = [CheckBoxItem(id: null, name: "Chọn website")];

  bool isLoading = false;

  CheckBoxItem? selectedConfig;
  CheckBoxItem? selectedItemType;
  CheckBoxItem? selectedWebsite;

  final Function(bool) reload;

  ListItemTabPresenter({required this.reload});

  load() {
    fetchAllItemOfUser().then((value) {
      fetchCheckBoxData().then((value) {
        reload(false);
      });
    });
  }

  fetchAllItemOfUser() async {
    try {
      final response =
          await http.get(Uri.parse("$getAllItemOfUserAPI${userLogin!.id}"));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['items'];
        items = data.map((json) => ItemModel.fromJson(json)).toList();
      } else {
        items = [];
        print('Lỗi tải dữ liệu: ${response.statusCode}');
      }
    } catch (error) {
      items = [];
      print(error);
    }
  }

  fetchCheckBoxData() async {
    try {
      await fetchCheckBoxDataFromAPI(
          "$getAllConfigOfUserAPI${userLogin!.id}", 'crawl_configs', (data) {
        configs.addAll(data.map((json) => CheckBoxItem.fromJson(json)));
      });

      await fetchCheckBoxDataFromAPI(
          "$getAllItemTypeOfUserAPI${userLogin!.id}", 'item_types', (data) {
        itemTypes.addAll(data.map((json) => CheckBoxItem.fromJson(json)));
      });

      await fetchCheckBoxDataFromAPI(
          "$getAllWebsiteOfUserAPI${userLogin!.id}", 'websites', (data) {
        websites.addAll(data.map((json) => CheckBoxItem.fromJson(json)));
      });
    } catch (error) {
      configs = [];
      itemTypes = [];
      websites = [];
      print(error);
    }
  }

  fetchCheckBoxDataFromAPI(
      String strAPI, String key, void Function(List<dynamic>) onData) async {
    final response = await http.get(Uri.parse(strAPI));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)[key];
      onData(data);
    } else {
      print('Lỗi tải dữ liệu $key: ${response.statusCode}');
    }
  }

  void setSelectedConfig(CheckBoxItem? config) {
    if (isLoading) return;
    selectedConfig = config;
    filterItems();
  }

  void setSelectedItemType(CheckBoxItem? itemType) {
    if (isLoading) return;
    selectedItemType = itemType;
    filterItems();
  }

  void setSelectedWebsite(CheckBoxItem? website) {
    if (isLoading) return;
    selectedWebsite = website;
    filterItems();
  }

  filterItems() async {
    reload(true);
    try {
      final queryParams = {
        "user_id": userLogin!.id.toString(),
        "type_id": selectedItemType?.id.toString() ?? "null",
        "website_id": selectedWebsite?.id.toString() ?? "null",
        "config_id": selectedConfig?.id.toString() ?? "null",
      };

      final uri =
          Uri.parse(filterItemApi).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['items'];
        items = data.map((json) => ItemModel.fromJson(json)).toList();
        reload(false);
      } else {
        print('Lỗi tải dữ liệu: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
    }
  }

  String getExportFileJsonAPI() {
    try {
      final queryParams = {
        "user_id": userLogin!.id.toString(),
        "type_id": selectedItemType?.id.toString() ?? "null",
        "website_id": selectedWebsite?.id.toString() ?? "null",
        "config_id": selectedConfig?.id.toString() ?? "null",
      };

      final uri =
          Uri.parse(exportFileJsonAPI).replace(queryParameters: queryParams);
      return uri.toString();
    } catch (error) {
      print(error);
      return "";
    }
  }
}
