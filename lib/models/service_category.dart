class ServiceCategory {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final String? imageUrl;
  const ServiceCategory({required this.id, required this.name, this.description, this.icon, this.imageUrl});

  factory ServiceCategory.fromJson(Map<String, dynamic> json) => ServiceCategory(
    id: (json['id'] ?? '').toString(),
    name: (json['name'] ?? json['label'] ?? '').toString(),
    description: json['description']?.toString(),
    icon: json['icon']?.toString(),
    imageUrl: json['imageUrl']?.toString() ?? json['image_url']?.toString(),
  );
}
