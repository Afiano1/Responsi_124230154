// models/restaurant.dart

/// Model utama untuk menampung data restoran dari API Dicoding
class Restaurant {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;

  /// Optional: detail tambahan yang hanya ada di endpoint /detail/{id}
  final List<Category> categories;
  final Menus? menus;
  final List<CustomerReview> customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    this.categories = const [],
    this.menus,
    this.customerReviews = const [],
  });

  /// Factory untuk buat Restaurant dari JSON (bisa dipakai untuk /list dan /detail)
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    // Handle list categories (bisa null di /list atau /detail)
    final List<Category> categories =
        (json['categories'] as List?)
            ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    // Handle menus (ada di /detail)
    final Menus? menus = json['menus'] != null
        ? Menus.fromJson(json['menus'] as Map<String, dynamic>)
        : null;

    // Handle customerReviews (ada di /detail)
    final List<CustomerReview> reviews =
        (json['customerReviews'] as List?)
            ?.map((e) => CustomerReview.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      pictureId: json['pictureId'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      categories: categories,
      menus: menus,
      customerReviews: reviews,
    );
  }

  /// 🔥 Helper: cek apakah restoran punya kategori tertentu
  bool hasCategory(String categoryName) {
    final target = categoryName.toLowerCase();
    return categories.any((c) => c.name.toLowerCase() == target);
  }
}

/// Kategori restoran (misal: Italia, Modern, dll)
class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name'] ?? '');
  }
}

/// Menus berisi list makanan & minuman
class Menus {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) {
    final List<MenuItem> foods =
        (json['foods'] as List?)
            ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final List<MenuItem> drinks =
        (json['drinks'] as List?)
            ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return Menus(foods: foods, drinks: drinks);
  }
}

/// Item menu (makanan / minuman)
class MenuItem {
  final String name;

  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(name: json['name'] ?? '');
  }
}

/// Review dari customer
class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'] ?? '',
      review: json['review'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
