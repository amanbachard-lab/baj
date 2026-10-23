class ServiceProvider {
  final String id;
  final String name;
  final String? profession;
  final String? description;
  final String? phone;
  final String? whatsapp;
  final String? address;
  final double? latitude;
  final double? longitude;
  final double? rating;
  final int? reviewCount;
  final String? imageUrl;
  final String? categoryName;

  const ServiceProvider({
    required this.id, required this.name, this.profession, this.description,
    this.phone, this.whatsapp, this.address, this.latitude, this.longitude,
    this.rating, this.reviewCount, this.imageUrl, this.categoryName,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> j) => ServiceProvider(
    id: (j['id'] ?? '').toString(),
    name: (j['name'] ?? j['fullName'] ?? '').toString(),
    profession: j['profession']?.toString() ?? j['title']?.toString(),
    description: j['description']?.toString(),
    phone: j['phone']?.toString(),
    whatsapp: j['whatsapp']?.toString(),
    address: j['address']?.toString(),
    latitude: _double(j['latitude']),
    longitude: _double(j['longitude']),
    rating: _double(j['rating'] ?? j['averageRating']),
    reviewCount: int.tryParse((j['reviewCount'] ?? j['reviewsCount'] ?? '').toString()),
    imageUrl: j['imageUrl']?.toString() ?? j['photoUrl']?.toString(),
    categoryName: j['category'] is Map ? (j['category']['name'] ?? '').toString() : j['categoryName']?.toString(),
  );

  static double? _double(dynamic value) => value == null ? null : double.tryParse(value.toString());
}
