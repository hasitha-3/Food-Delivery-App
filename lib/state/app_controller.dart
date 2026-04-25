import 'package:flutter/foundation.dart';

import '../data/sample_data.dart';
import '../models/app_models.dart';

enum AddToCartResult { added, restaurantConflict }

class AppController extends ChangeNotifier {
  AppController();

  final List<Restaurant> restaurants = kRestaurants;
  final List<FoodCategory> categories = kCategories;

  final Map<String, CartLine> _cart = <String, CartLine>{};
  final List<OrderRecord> _orders = <OrderRecord>[];

  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  String? _activeRestaurantId;

  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;

  List<CartLine> get cartLines => _cart.values.toList(growable: false);
  List<OrderRecord> get orders => List<OrderRecord>.unmodifiable(_orders);

  int get cartItemCount =>
      _cart.values.fold<int>(0, (int acc, CartLine line) => acc + line.quantity);

  bool get hasItemsInCart => _cart.isNotEmpty;

  Restaurant? get activeRestaurant {
    if (_activeRestaurantId == null) {
      return null;
    }
    for (final Restaurant restaurant in restaurants) {
      if (restaurant.id == _activeRestaurantId) {
        return restaurant;
      }
    }
    return null;
  }

  List<Restaurant> get filteredRestaurants {
    final String query = _searchQuery.trim().toLowerCase();

    return restaurants.where((Restaurant restaurant) {
      final bool categoryMatches = _selectedCategoryId == 'all' ||
          restaurant.cuisine.toLowerCase().contains(_selectedCategoryId);
      final bool queryMatches = query.isEmpty ||
          restaurant.name.toLowerCase().contains(query) ||
          restaurant.cuisine.toLowerCase().contains(query) ||
          restaurant.menu.any(
            (MenuItem item) => item.name.toLowerCase().contains(query),
          );
      return categoryMatches && queryMatches;
    }).toList(growable: false);
  }

  int quantityFor(String menuItemId) {
    return _cart[menuItemId]?.quantity ?? 0;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  AddToCartResult addToCart({
    required Restaurant restaurant,
    required MenuItem item,
  }) {
    if (_activeRestaurantId != null && _activeRestaurantId != restaurant.id) {
      return AddToCartResult.restaurantConflict;
    }

    _activeRestaurantId = restaurant.id;

    final CartLine? existing = _cart[item.id];
    if (existing == null) {
      _cart[item.id] = CartLine(
        restaurantId: restaurant.id,
        restaurantName: restaurant.name,
        item: item,
        quantity: 1,
      );
    } else {
      _cart[item.id] = existing.copyWith(quantity: existing.quantity + 1);
    }

    notifyListeners();
    return AddToCartResult.added;
  }

  void forceSwitchRestaurantAndAdd({
    required Restaurant restaurant,
    required MenuItem item,
  }) {
    _cart.clear();
    _activeRestaurantId = null;
    addToCart(restaurant: restaurant, item: item);
  }

  void increaseQuantity(String menuItemId) {
    final CartLine? line = _cart[menuItemId];
    if (line == null) {
      return;
    }
    _cart[menuItemId] = line.copyWith(quantity: line.quantity + 1);
    notifyListeners();
  }

  void decreaseQuantity(String menuItemId) {
    final CartLine? line = _cart[menuItemId];
    if (line == null) {
      return;
    }

    if (line.quantity <= 1) {
      _cart.remove(menuItemId);
      if (_cart.isEmpty) {
        _activeRestaurantId = null;
      }
    } else {
      _cart[menuItemId] = line.copyWith(quantity: line.quantity - 1);
    }
    notifyListeners();
  }

  void removeLine(String menuItemId) {
    _cart.remove(menuItemId);
    if (_cart.isEmpty) {
      _activeRestaurantId = null;
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _activeRestaurantId = null;
    notifyListeners();
  }

  double get subtotal {
    return _cart.values.fold<double>(
      0,
      (double acc, CartLine line) => acc + line.item.price * line.quantity,
    );
  }

  double get deliveryFee {
    if (_cart.isEmpty) {
      return 0;
    }
    return activeRestaurant?.deliveryFee ?? 0;
  }

  double get taxes => subtotal * 0.05;

  double get platformFee => _cart.isEmpty ? 0 : 7;

  double get grandTotal => subtotal + deliveryFee + taxes + platformFee;

  bool placeOrder() {
    if (_cart.isEmpty) {
      return false;
    }

    final DateTime now = DateTime.now();
    final String orderId = 'FD${now.millisecondsSinceEpoch.toString().substring(7)}';

    _orders.insert(
      0,
      OrderRecord(
        id: orderId,
        restaurantName: activeRestaurant?.name ?? 'FoodieGo',
        createdAt: now,
        total: grandTotal,
        items: cartLines,
      ),
    );

    clearCart();
    return true;
  }
}
