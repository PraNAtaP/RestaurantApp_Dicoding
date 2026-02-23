import 'package:flutter/material.dart';
import '../data/db/database_helper.dart';
import '../data/models/restaurant_model.dart';

class FavoriteProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper;

  FavoriteProvider({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper();

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  final Set<String> _favoriteIds = {};

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  String _message = '';
  String get message => _message;

  bool isFavoriteById(String id) => _favoriteIds.contains(id);

  Future<void> loadFavorites() async {
    try {
      _favorites = await _databaseHelper.getFavorites();
      _favoriteIds.clear();
      for (final r in _favorites) {
        _favoriteIds.add(r.id);
      }
      if (_favorites.isEmpty) {
        _message = 'No favorites yet';
      } else {
        _message = '';
      }
    } catch (e) {
      _message = 'Failed to load favorites';
    }
    notifyListeners();
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    try {
      await _databaseHelper.insertFavorite(restaurant);
      _isFavorite = true;
      _favoriteIds.add(restaurant.id);
      await loadFavorites();
    } catch (e) {
      _message = 'Failed to add favorite';
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await _databaseHelper.removeFavorite(id);
      _isFavorite = false;
      _favoriteIds.remove(id);
      await loadFavorites();
    } catch (e) {
      _message = 'Failed to remove favorite';
      notifyListeners();
    }
  }

  Future<void> checkFavorite(String id) async {
    _isFavorite = await _databaseHelper.isFavorite(id);
    notifyListeners();
  }

  Future<void> toggleFavoriteFromCard(Restaurant restaurant) async {
    if (_favoriteIds.contains(restaurant.id)) {
      await removeFavorite(restaurant.id);
    } else {
      await addFavorite(restaurant);
    }
  }
}
