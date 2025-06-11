import 'dart:convert';

class Farmer {
  final String id;
  final String name;
  final String phoneNumber;
  final String location;
  final String category;
  final String description;
  final List<String> products;
  final String avatar;
  final bool isOnline;
  final double rating;
  final DateTime joinedDate;

  Farmer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.location,
    required this.category,
    required this.description,
    required this.products,
    this.avatar = '',
    required this.isOnline,
    required this.rating,
    required this.joinedDate,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      location: json['location'],
      category: json['category'],
      description: json['description'],
      products: List<String>.from(json['products']),
      avatar: json['avatar'] ?? '',
      isOnline: json['isOnline'],
      rating: (json['rating'] as num).toDouble(),
      joinedDate: DateTime.parse(json['joinedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'location': location,
      'category': category,
      'description': description,
      'products': products,
      'avatar': avatar,
      'isOnline': isOnline,
      'rating': rating,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }
}