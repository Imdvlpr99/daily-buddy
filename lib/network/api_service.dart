import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../widget/custom_toast.dart';

class ApiService {

  static Future<void> createCategory(String categoryName, BuildContext context) async {
    final Uri uri = Uri.parse('https://imdvlpr.my.id/dailybuddy/api/create-category');
    final Map<String, dynamic> body = {
      'category_name': categoryName,
    };
    final encodedBody = body.keys.map((key) => '$key=${Uri.encodeQueryComponent(body[key]!.toString())}').join('&');
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
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
      Navigator.of(context).pop();
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      String message = responseData['message'];
      CustomToast.show(
        message: message,
        gravity: ToastGravity.BOTTOM,
        length: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    }
  }

  static Future<List> getCategoryList({Function()? onDataChanged}) async {
    final Uri uri = Uri.parse('https://imdvlpr.my.id/dailybuddy/api/get-category-list');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['data'] as List;

      if (onDataChanged != null) {
        onDataChanged();
      }

      return result;
    } else {
      throw Exception('Failed to load category list');
    }
  }
}