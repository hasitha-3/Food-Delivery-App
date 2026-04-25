import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../state/app_controller.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({
    super.key,
    required this.restaurant,
    required this.controller,
  });

  final Restaurant restaurant;
  final AppController controller;

  Future<void> _handleAddTap(
    BuildContext context,
    MenuItem item,
  ) async {
    final AddToCartResult result =
        controller.addToCart(restaurant: restaurant, item: item);

    if (result == AddToCartResult.added) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 900),
          content: Text('${item.name} added to cart'),
        ),
      );
      return;
    }

    final bool? shouldSwitch = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Replace cart items?'),
          content: const Text(
            'Your cart has items from another restaurant.\nClear cart and add this item?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Replace'),
            ),
          ],
        );
      },
    );

    if (shouldSwitch == true && context.mounted) {
      controller.forceSwitchRestaurantAndAdd(restaurant: restaurant, item: item);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 900),
          content: Text('${item.name} added to cart'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(restaurant.name),
          ),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: restaurant.color,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 21,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      restaurant.cuisine,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${restaurant.rating.toStringAsFixed(1)}★  •  ${restaurant.deliveryTime}  •  Rs. ${restaurant.deliveryFee.toStringAsFixed(0)} delivery',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      restaurant.promo,
                      style: const TextStyle(
                        color: Color(0xFFFF6B35),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Recommended dishes',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 12),
              ...restaurant.menu.map((MenuItem item) {
                final int quantity = controller.quantityFor(item.id);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            item.isVeg
                                ? Icons.verified_rounded
                                : Icons.warning_amber_rounded,
                            color: item.isVeg
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFF8B0000),
                            size: 19,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(item.description),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Rs. ${item.price.toStringAsFixed(0)}  •  ${item.rating.toStringAsFixed(1)}★  •  ${item.prepTime} min',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          if (quantity == 0)
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B35),
                              ),
                              onPressed: () => _handleAddTap(context, item),
                              child: const Text('Add'),
                            )
                          else
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFFF6B35)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () => controller.decreaseQuantity(item.id),
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => controller.increaseQuantity(item.id),
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }
}
