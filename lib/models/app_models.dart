import 'package:flutter/material.dart';

class FoodCategory {
  const FoodCategory({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.prepTime,
    required this.isVeg,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int prepTime;
  final bool isVeg;
}

class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.distanceKm,
    required this.promo,
    required this.color,
    required this.menu,
  });

  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final String deliveryTime;
  final double deliveryFee;
  final double distanceKm;
  final String promo;
  final Color color;
  final List<MenuItem> menu;
}

class CartLine {
  const CartLine({
    required this.restaurantId,
    required this.restaurantName,
    required this.item,
    required this.quantity,
  });

  final String restaurantId;
  final String restaurantName;
  final MenuItem item;
  final int quantity;

  CartLine copyWith({int? quantity}) {
    return CartLine(
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      item: item,
      quantity: quantity ?? this.quantity,
    );
  }
}

class OrderRecord {
  const OrderRecord({
    required this.id,
    required this.restaurantName,
    required this.createdAt,
    required this.total,
    required this.items,
  });

  final String id;
  final String restaurantName;
  final DateTime createdAt;
  final double total;
  final List<CartLine> items;
}
