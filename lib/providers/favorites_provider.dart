// providers/favorites_provider.dart

import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Restaurant> _favorites = [];

  List<Restaurant> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String id) {
    return _favorites.any((r) => r.id == id);
  }

  void toggleFavorite(Restaurant restaurant) {
    final index = _favorites.indexWhere((r) => r.id == restaurant.id);

    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(restaurant);
    }

    notifyListeners();
  }

  void removeFavoriteById(String id) {
    _favorites.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
