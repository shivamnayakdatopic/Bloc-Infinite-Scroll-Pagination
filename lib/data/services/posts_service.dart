import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

class PostsService {
  static const FETCH_LIMIT = 10;
  final baseUrl = "https://jsonplaceholder.typicode.com/posts";

  Future<List<dynamic>> fetchPosts(int page) async {
    try {
      final response =
          await get(Uri.parse(baseUrl + "?_limit=$FETCH_LIMIT&_page=$page"));
      return jsonDecode(response.body) as List<dynamic>;
    } catch (err) {
      return [];
    }
  }
}
