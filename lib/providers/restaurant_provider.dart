import 'package:flutter/material.dart';
import '../data/api/api_service.dart';
import '../data/models/restaurant_model.dart';
import '../data/models/result_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantListProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  ResultState<RestaurantListResponse> _state = Initial();
  ResultState<RestaurantListResponse> get state => _state;

  String _message = '';
  String get message => _message;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = Loading();
      notifyListeners();
      final restaurant = await apiService.getRestaurantList();
      if (restaurant.restaurants.isEmpty) {
        _state = ErrorState('No Data');
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = HasData(restaurant);
        notifyListeners();
        return _message = 'Data Loaded';
      }
    } catch (e) {
      _state = ErrorState('Error --> $e');
      notifyListeners();
      return _message = 'Error --> $e';
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

  Future<dynamic> fetchDetail(String id) async {
    try {
      _state = Loading();
      notifyListeners();
      final restaurant = await apiService.getRestaurantDetail(id);
      if (restaurant.error) {
         _state = ErrorState(restaurant.message);
         notifyListeners();
         return _message = restaurant.message;
      } else {
        _state = HasData(restaurant);
        notifyListeners();
        return _message = 'Data Loaded';
      }
    } catch (e) {
      _state = ErrorState('Error --> $e');
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
  
  Future<void> postReview(String id, String name, String review) async {
      try {
          await apiService.postReview(id, name, review);
          fetchDetail(id);
      } catch (e) {
             print("Error posting review: $e");
             // Consider handling error state here if UI needs it
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

  Future<dynamic> searchRestaurant(String query) async {
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
        _state = ErrorState('No Restaurant Found');
        notifyListeners();
        return _message = 'No Data';
      } else {
        _state = HasData(result);
        notifyListeners();
        return _message = 'Data Loaded';
      }
    } catch (e) {
      _state = ErrorState('Error --> $e');
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
