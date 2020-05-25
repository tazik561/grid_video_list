import 'dart:convert';

import 'package:grid_app/model/category_item_model.dart';
import 'package:grid_app/model/category_model.dart';
import 'package:http/http.dart' as http;

class HomeTabProvider {
  static final HomeTabProvider _instance = HomeTabProvider._internal();
  HomeTabProvider._internal();
  factory HomeTabProvider() => _instance;

  Future<CategoryModel> getCategories() async {
    try {
      var response = await http.get("http://test.sibuy.ca/api/V1/categories");
      if (response.statusCode == 200) {
        var model = CategoryModel.fromJson(json.decode(response.body));
        return model;
      }
    } on Exception catch (e) {
      print(e);
      throw e;
    }
    return null;
  }

    Future<CategoryItemModel> getCategoryItems(int id) async {
    try {
      var response = await http.get("http://test.sibuy.ca/api/V1/categories/$id");
      if (response.statusCode == 200) {
        var model = CategoryItemModel.fromJson(json.decode(response.body));
        return model;
      }
    } on Exception catch (e) {
      print(e);
      throw e;
    }
    return null;
  }
}
