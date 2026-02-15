
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant_model.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));

    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantSearchResponse> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));

    if (response.statusCode == 200) {
      return RestaurantSearchResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to search restaurant');
    }
  }

  Future<CustomerReview> postReview(String id, String name, String review) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/review"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id, 'name': name, 'review': review}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
       // Return a dummy object for now as we just need to know it succeeded, or parse if Model allows. 
       // Keeping it simple as per original code's intent but fixing the potential missing return if I were strict.
       // Actually, let's just return the input data to satisfy the Future<CustomerReview> signature
       // without parsing the complex response which might include the whole list.
       return CustomerReview(name: name, review: review, date: DateTime.now().toString()); 
    } else {
      throw Exception('Failed to post review');
    }
  }
}
