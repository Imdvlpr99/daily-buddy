import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../model/category_model.dart';
import '../widget/custom_toast.dart';

class ApiService {
  static Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  static Future<void> createCategory(String categoryName, {Function()? onCategoryCreated}) async {
    final Uri uri = Uri.parse('https://imdvlpr.my.id/dailybuddy/api/create-category');
    final Map<String, dynamic> body = {
      'category_name': categoryName,
    };
    final encodedBody = body.keys.map((key) => '$key=${Uri.encodeQueryComponent(body[key]!.toString())}').join('&');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: encodedBody,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String message = responseData['message'];
        CustomToast.show(
          message: message,
          gravity: ToastGravity.BOTTOM,
          length: Toast.LENGTH_LONG,
          textColor: Colors.white,
        );

        if (onCategoryCreated != null) {
          onCategoryCreated();
        }

      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String message = responseData['message'];
        CustomToast.show(
          message: message,
          gravity: ToastGravity.BOTTOM,
          length: Toast.LENGTH_LONG,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      logger.e('Exception: $e');
      rethrow;
    }
  }

  static Future<List<CategoryModel>> getCategoryList({Function()? onDataChanged}) async {
    final Uri uri = Uri.parse('https://imdvlpr.my.id/dailybuddy/api/get-category-list');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> data = json['data'] as List<dynamic>;

      List<CategoryModel> categoryModels = data.map((item) => CategoryModel.fromJson(item)).toList();

      onDataChanged?.call();
      return categoryModels;
    } else {
      throw Exception('Failed to load category list');
    }
  }

  static Future<void> createActivity(
      String title,
      String desc,
      String date,
      String time,
      String categoryId,
      {Function()? onActivityCreated}) async {
    final Uri uri = Uri.parse('https://imdvlpr.my.id/dailybuddy/api/create-activity');
    final Map<String, dynamic> body = {
      'title': title,
      'desc': desc,
      'date': date,
      'time': time,
      'category_id': categoryId,
      'is_complete': 'false'
    };
    final encodedBody = body.keys.map((key) => '$key=${Uri.encodeQueryComponent(body[key]!.toString())}').join('&');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: encodedBody,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String message = responseData['message'];
        CustomToast.show(
          message: message,
          gravity: ToastGravity.BOTTOM,
          length: Toast.LENGTH_LONG,
          textColor: Colors.white,
        );

        if (onActivityCreated != null) {
          onActivityCreated();
        }

      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String message = responseData['message'];
        CustomToast.show(
          message: message,
          gravity: ToastGravity.BOTTOM,
          length: Toast.LENGTH_LONG,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      logger.e('Exception: $e');
      rethrow;
    }
  }

  static Future<void> deleteCategory(String categoryId, {Function()? onDeleteCategorySuccess}) async {
    final Uri uri = Uri.parse('https://imdvlpr.my.id/dailybuddy/api/delete-category');
    final Map<String, dynamic> body = {
      'id': categoryId,
    };
    final encodedBody = body.keys.map((key) => '$key=${Uri.encodeQueryComponent(body[key]!.toString())}').join('&');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: encodedBody,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String message = responseData['message'];
        CustomToast.show(
          message: message,
          gravity: ToastGravity.BOTTOM,
          length: Toast.LENGTH_LONG,
          textColor: Colors.white,
        );

        if (onDeleteCategorySuccess != null) {
          onDeleteCategorySuccess();
        }

      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String message = responseData['message'];
        CustomToast.show(
          message: message,
          gravity: ToastGravity.BOTTOM,
          length: Toast.LENGTH_LONG,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      logger.e('Exception: $e');
      rethrow;
    }
  }

  static Future<void> editCategory(String categoryId, String categoryName, {Function()? onSuccessEditCategory}) async {
    final Uri uri = Uri.parse('https://imdvlpr.my.id/dailybuddy/api/edit-category');
    final Map<String, dynamic> body = {
      'category_id': categoryId,
      'category_name': categoryName
    };
    final encodedBody = body.keys.map((key) => '$key=${Uri.encodeQueryComponent(body[key]!.toString())}').join('&');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: encodedBody,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String message = responseData['message'];
        CustomToast.show(
          message: message,
          gravity: ToastGravity.BOTTOM,
          length: Toast.LENGTH_LONG,
          textColor: Colors.white,
        );

        if (onSuccessEditCategory != null) {
          onSuccessEditCategory();
        }

      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String message = responseData['message'];
        CustomToast.show(
          message: message,
          gravity: ToastGravity.BOTTOM,
          length: Toast.LENGTH_LONG,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      logger.e('Exception: $e');
      rethrow;
    }
  }
}