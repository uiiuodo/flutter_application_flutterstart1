import 'package:flutter/material.dart';
import '../../core/models/product.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  ProductSearchDelegate({required this.products, required this.onSelect});

  final List<Product> products;
  final void Function(Product) onSelect;

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  Iterable<Product> _results() => products.where((p) {
    final q = query.toLowerCase();
    return p.title.toLowerCase().contains(q) ||
        p.artist.toLowerCase().contains(q) ||
        p.tags.any((t) => t.toLowerCase().contains(q));
  });

  @override
  Widget buildResults(BuildContext context) {
    final res = _results().toList();
    if (res.isEmpty) {
      return const Center(child: Text('검색 결과가 없습니다.'));
    }
    return ListView.separated(
      itemCount: res.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final p = res[i];
        return ListTile(
          leading: SizedBox(
            width: 56,
            height: 56,
            child: Image.network(p.imageUrl, fit: BoxFit.cover),
          ),
          title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            p.artist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text('₩${p.price}'),
          onTap: () {
            onSelect(p);
            close(context, null);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
