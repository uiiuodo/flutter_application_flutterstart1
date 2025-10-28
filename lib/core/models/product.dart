
class Product {
  final String id;
  final String title;
  final String artist;
  final int price;
  final String imageUrl;
  final int stock;
  final List<String> tags;

  const Product({
    required this.id,
    required this.title,
    required this.artist,
    required this.price,
    required this.imageUrl,
    required this.stock,
    this.tags = const [],
  });
}
