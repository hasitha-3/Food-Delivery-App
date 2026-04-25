import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../state/app_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.controller,
    required this.onRestaurantTap,
  });

  final AppController controller;
  final ValueChanged<Restaurant> onRestaurantTap;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.controller.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (BuildContext context, _) {
        final List<Restaurant> restaurants = widget.controller.filteredRestaurants;
        final List<Restaurant> featured = widget.controller.restaurants.take(3).toList();

        return SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.delivery_dining_rounded,
                              color: Color(0xFFFF6B35),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Delivering to',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Hanamkonda, Warangal',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications_none_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x12000000),
                              blurRadius: 14,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: widget.controller.setSearchQuery,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.search_rounded),
                            hintText: 'Search restaurants, dishes...',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: <Color>[Color(0xFFFF6B35), Color(0xFFFF8C42)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Pro Pass Offer',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Up to 60% OFF + free delivery',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Categories',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 42,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.controller.categories.length,
                          separatorBuilder:
                              (BuildContext context, int index) =>
                                  const SizedBox(width: 8),
                          itemBuilder: (BuildContext context, int index) {
                            final FoodCategory category =
                                widget.controller.categories[index];
                            final bool selected =
                                widget.controller.selectedCategoryId == category.id;

                            return InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () =>
                                  widget.controller.setSelectedCategory(category.id),
                              child: Ink(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFFFF6B35)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      category.icon,
                                      size: 16,
                                      color: selected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      category.label,
                                      style: TextStyle(
                                        color: selected
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Featured',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 170,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: featured.length,
                          separatorBuilder:
                              (BuildContext context, int index) =>
                                  const SizedBox(width: 12),
                          itemBuilder: (BuildContext context, int index) {
                            final Restaurant restaurant = featured[index];
                            return GestureDetector(
                              onTap: () => widget.onRestaurantTap(restaurant),
                              child: Container(
                                width: 255,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: restaurant.color,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            restaurant.promo,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                              color: Color(0xFFFF6B35),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.favorite_border_rounded),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      restaurant.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${restaurant.cuisine}  •  ${restaurant.deliveryTime}',
                                      style: const TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Top picks for you',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              if (restaurants.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('No restaurants found. Try another search.'),
                  ),
                )
              else
                SliverList.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Restaurant restaurant = restaurants[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => widget.onRestaurantTap(restaurant),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: restaurant.color,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.restaurant_rounded,
                                    color: Color(0xFFFF6B35),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        restaurant.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        restaurant.cuisine,
                                        style: const TextStyle(color: Colors.black54),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${restaurant.deliveryTime} • ${restaurant.distanceKm.toStringAsFixed(1)} km • Rs. ${restaurant.deliveryFee.toStringAsFixed(0)} fee',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2E7D32),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${restaurant.rating.toStringAsFixed(1)}★',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
    );
  }
}
