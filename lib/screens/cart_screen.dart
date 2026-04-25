import 'package:flutter/material.dart';

import '../state/app_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    super.key,
    required this.controller,
    required this.onBrowseTap,
    required this.onOrderPlaced,
  });

  final AppController controller;
  final VoidCallback onBrowseTap;
  final VoidCallback onOrderPlaced;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, _) {
        if (!controller.hasItemsInCart) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 56,
                    color: Color(0xFFFF6B35),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add tasty dishes from your favorite restaurants.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: onBrowseTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                    ),
                    child: const Text('Browse Restaurants'),
                  ),
                ],
              ),
            ),
          );
        }

        return SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  children: <Widget>[
                    Text(
                      controller.activeRestaurant?.name ?? 'Your Cart',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('Review items before checkout'),
                    const SizedBox(height: 14),
                    ...controller.cartLines.map((line) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    line.item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Rs. ${line.item.price.toStringAsFixed(0)}'),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  onPressed: () =>
                                      controller.decreaseQuantity(line.item.id),
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text(
                                  '${line.quantity}',
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      controller.increaseQuantity(line.item.id),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: <Widget>[
                    _priceRow('Subtotal', controller.subtotal),
                    const SizedBox(height: 5),
                    _priceRow('Delivery fee', controller.deliveryFee),
                    const SizedBox(height: 5),
                    _priceRow('Taxes', controller.taxes),
                    const SizedBox(height: 5),
                    _priceRow('Platform fee', controller.platformFee),
                    const Divider(height: 18),
                    _priceRow('Total', controller.grandTotal, isBold: true),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          final bool placed = controller.placeOrder();
                          if (!placed) {
                            return;
                          }
                          onOrderPlaced();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order placed successfully.'),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Place Order'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _priceRow(String label, double value, {bool isBold = false}) {
    final TextStyle style = TextStyle(
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
      fontSize: isBold ? 17 : 14,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: style),
        Text('Rs. ${value.toStringAsFixed(0)}', style: style),
      ],
    );
  }
}
