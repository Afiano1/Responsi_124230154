import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/restaurant.dart';
import '../providers/favorites_provider.dart';
import '../services/api_service.dart';
import '../widgets/restaurant_card.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Restaurant>> _futureRestaurants;

  // Kategori yang tersedia
  final List<String> _categories = [
    "Semua",
    "Italia",
    "Modern",
    "Sunda",
    "Jawa",
    "Bali",
  ];

  // Kategori yang sedang dipilih
  String _selectedCategory = "Semua";

  @override
  void initState() {
    super.initState();
    _futureRestaurants = _loadRestaurantsWithDetail();
  }

  Future<List<Restaurant>> _loadRestaurantsWithDetail() async {
    // 1. Ambil /list
    final list = await _apiService.fetchRestaurantList();
    final detailedList = await Future.wait(
      list.map((r) async {
        try {
          final detail = await _apiService.fetchRestaurantDetail(r.id);
          return detail;
        } catch (_) {
          return r;
        }
      }),
    );

    return detailedList;
  }

  Future<void> _refresh() async {
    final newFuture = _loadRestaurantsWithDetail();
    setState(() {
      _futureRestaurants = newFuture;
    });
    await newFuture;
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);

    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.restaurant, color: Colors.deepOrange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Jelajahi restoran favoritmu 🍽️',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // BAR KATEGORI
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final selected = _selectedCategory == category;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? Colors.orange : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? Colors.orange : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (selected)
                        const Icon(Icons.check, size: 14, color: Colors.white),
                      if (selected) const SizedBox(width: 4),
                      Text(
                        category,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemCount: _categories.length,
          ),
        ),

        const SizedBox(height: 8),

        // LIST RESTORAN + FILTER
        Expanded(
          child: FutureBuilder<List<Restaurant>>(
            future: _futureRestaurants,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Terjadi kesalahan:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              List<Restaurant> data = snapshot.data ?? [];
              if (data.isEmpty) {
                return const Center(child: Text('Tidak ada data restoran'));
              }

              if (_selectedCategory != "Semua") {
                data = data.where((r) {
                  return r.categories.any(
                    (c) =>
                        c.name.toLowerCase() == _selectedCategory.toLowerCase(),
                  );
                }).toList();
              }

              if (data.isEmpty) {
                return const Center(
                  child: Text('Tidak ada restoran untuk kategori ini'),
                );
              }

              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final restaurant = data[index];
                    final isFav = favProvider.isFavorite(restaurant.id);

                    return RestaurantCard(
                      restaurant: restaurant,
                      isFavorite: isFav,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetailPage(restaurantId: restaurant.id),
                          ),
                        );
                      },
                      onFavoriteTap: () {
                        favProvider.toggleFavorite(restaurant);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
