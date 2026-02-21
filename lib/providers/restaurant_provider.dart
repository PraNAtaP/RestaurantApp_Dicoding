import 'dart:async';
import 'package:flutter/material.dart';
import '../data/api/api_service.dart';
import '../data/models/restaurant_model.dart';
import '../data/models/result_state.dart';
import '../utils/date_helper.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantListProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  ResultState<RestaurantListResponse> _state = Initial();
  ResultState<RestaurantListResponse> get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> _fetchAllRestaurant() async {
    try {
      _state = Loading();
      notifyListeners();
      final restaurant = await apiService.getRestaurantList();
      if (restaurant.restaurants.isEmpty) {
        _state = NoData('No Data');
        notifyListeners();
        _message = 'Empty Data';
      } else {
        _state = HasData(restaurant);
        notifyListeners();
        _message = 'Data Loaded';
      }
    } catch (e) {
      _state = ErrorState(
        'No Internet Connection. Please check your connection.',
      );
      notifyListeners();
      _message = 'Error --> $e';
    }
  }

  void refresh() {
    _fetchAllRestaurant();
  }
}

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantDetailProvider({required this.apiService});

  ResultState<RestaurantDetailResponse> _state = Initial();
  ResultState<RestaurantDetailResponse> get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> fetchDetail(String id) async {
    try {
      _state = Loading();
      notifyListeners();
      final restaurant = await apiService.getRestaurantDetail(id);
      if (restaurant.error) {
        _state = ErrorState("Gagal memuat detail restoran.");
      } else {
        restaurant.restaurant.customerReviews.sort((a, b) {
          final dateA = DateHelper.parseIndonesianDate(a.date);
          final dateB = DateHelper.parseIndonesianDate(b.date);
          return dateB.compareTo(dateA);
        });
        _state = HasData(restaurant);
      }
      notifyListeners();
    } catch (e) {
      _state = ErrorState(
        "Yah, koneksinya terputus. Coba cek internetmu dan refresh lagi ya!",
      );
      notifyListeners();
    }
  }

  Future<void> postReview(String id, String name, String review) async {
    try {
      await apiService.postReview(id, name, review);
      fetchDetail(id);
    } catch (e) {
      _message = "Gagal mengirim ulasan. Silakan coba lagi.";
      notifyListeners();
      throw Exception(_message);
    }
  }
}

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantSearchProvider({required this.apiService});

  ResultState<RestaurantSearchResponse> _state = Initial();
  ResultState<RestaurantSearchResponse> get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> searchRestaurant(String query) async {
    if (query.isEmpty) {
      _state = Initial();
      notifyListeners();
      return;
    }

    try {
      _state = Loading();
      notifyListeners();
      final result = await apiService.searchRestaurant(query);
      if (result.restaurants.isEmpty) {
        _state = NoData('No Restaurant Found');
        notifyListeners();
        _message = 'No Data';
      } else {
        _state = HasData(result);
        notifyListeners();
        _message = 'Data Loaded';
      }
    } catch (e) {
      _state = ErrorState(
        'No Internet Connection. Please check your connection.',
      );
      notifyListeners();
      _message = 'Error --> $e';
    }
  }
}
