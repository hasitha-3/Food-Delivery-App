import 'package:flutter/material.dart';

import 'models/app_models.dart';
import 'screens/cart_screen.dart';
import 'screens/home_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/restaurant_screen.dart';
import 'state/app_controller.dart';

void main() {
  runApp(const FoodieGoApp());
}

class FoodieGoApp extends StatelessWidget {
  const FoodieGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodieGo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6B35)),
        scaffoldBackgroundColor: const Color(0xFFF8F9FB),
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final AppController _controller = AppController();
  int _tabIndex = 0;

  late final HomeScreen _homeScreen;
  late final OrdersScreen _ordersScreen;
  late final CartScreen _cartScreen;
  late final ProfileScreen _profileScreen;

  @override
  void initState() {
    super.initState();
    _homeScreen = HomeScreen(
      controller: _controller,
      onRestaurantTap: _openRestaurant,
    );
    _ordersScreen = OrdersScreen(controller: _controller);
    _cartScreen = CartScreen(
      controller: _controller,
      onBrowseTap: () => setState(() => _tabIndex = 0),
      onOrderPlaced: () => setState(() => _tabIndex = 1),
    );
    _profileScreen = const ProfileScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openRestaurant(Restaurant restaurant) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => RestaurantScreen(
          restaurant: restaurant,
          controller: _controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        final List<Widget> tabs = <Widget>[
          _homeScreen,
          _ordersScreen,
          _cartScreen,
          _profileScreen,
        ];

        return Scaffold(
          appBar: _tabIndex == 0
              ? null
              : AppBar(
                  title: Text(
                    switch (_tabIndex) {
                      1 => 'Orders',
                      2 => 'Cart',
                      3 => 'Profile',
                      _ => 'FoodieGo',
                    },
                  ),
                ),
          body: IndexedStack(index: _tabIndex, children: tabs),
          bottomNavigationBar: NavigationBar(
            height: 72,
            selectedIndex: _tabIndex,
            onDestinationSelected: (int value) {
              setState(() => _tabIndex = value);
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long_rounded),
                label: 'Orders',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_bag_outlined),
                selectedIcon: Icon(Icons.shopping_bag),
                label: 'Cart',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _controller.hasItemsInCart && _tabIndex != 2
              ? FloatingActionButton.extended(
                  backgroundColor: const Color(0xFFFF6B35),
                  onPressed: () => setState(() => _tabIndex = 2),
                  label: Text(
                    'View Cart (${_controller.cartItemCount})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                  ),
                )
              : null,
        );
      },
    );
  }
}
