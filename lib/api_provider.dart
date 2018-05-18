import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const baseUrl = "http://yarche.mobile.dev.magonline.ru/";
const headers = {"Accept-version": "8"};

class CategoryService {
  Future<List<Category>> fetchCategories() async {
    final client = http.Client();
    return client
        .get("$baseUrl/api/category/index", headers: headers)
        .then((response) => utf8.decoder.convert(response.bodyBytes))
        .then((response) => json.decode(response))
        .then((json) => json["data"]["result"][0]["children"])
        .then((list) {
      final categories = <Category>[];
      for (var item in list) {
        final category = new Category.fromJson(item);
        categories.add(category);
      }

      return categories;
    });
  }
}

class Category {
  final String id;
  final String name;
  final String thumbnailUrl;
  List<Category> subcategories = [];

  Category.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        name = data["name"],
        thumbnailUrl = data["thumbnail"] {
    subcategories = (data["children"] as List<dynamic>).map((string) {
      return new Category.fromJson(string);
    }).toList();
  }
}
