import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../state/app_controller.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({
    super.key,
    required this.controller,
  });

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, _) {
        final List<OrderRecord> orders = controller.orders;

        if (orders.isEmpty) {
          return const Center(
            child: Text('No orders yet. Place your first order.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (BuildContext context, int index) {
            final OrderRecord order = orders[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        order.restaurantName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        order.id,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year} • ${order.items.length} items',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: order.items
                        .map(
                          (line) => Chip(
                            label: Text('${line.item.name} x${line.quantity}'),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Paid: Rs. ${order.total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
