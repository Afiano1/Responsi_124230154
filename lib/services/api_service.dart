// services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/restaurant.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<List<Restaurant>> fetchRestaurantList() async {
    final uri = Uri.parse('$_baseUrl/list');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);

      final List<dynamic> restaurantsJson =
          decoded['restaurants'] as List<dynamic>;

      return restaurantsJson
          .map((json) => Restaurant.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Gagal mengambil daftar restoran '
        '(${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<Restaurant> fetchRestaurantDetail(String id) async {
    final uri = Uri.parse('$_baseUrl/detail/$id');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);

      final Map<String, dynamic> restaurantJson =
          decoded['restaurant'] as Map<String, dynamic>;

      return Restaurant.fromJson(restaurantJson);
    } else {
      throw Exception(
        'Gagal mengambil detail restoran '
        '(${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<List<Restaurant>> searchRestaurant(String query) async {
    final uri = Uri.parse('$_baseUrl/search?q=$query');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);

      final List<dynamic> restaurantsJson =
          decoded['restaurants'] as List<dynamic>;

      return restaurantsJson
          .map((json) => Restaurant.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Gagal mencari restoran '
        '(${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<bool> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final uri = Uri.parse('$_baseUrl/review');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'name': name, 'review': review}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
        'Gagal menambahkan review '
        '(${response.statusCode}): ${response.body}',
      );
    }
  }
}
