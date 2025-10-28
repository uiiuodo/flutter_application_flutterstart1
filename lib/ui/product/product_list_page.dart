//상품 목록 페이지

import 'package:flutter/material.dart';
import '../../core/models/product.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({
    super.key,
    required this.products,
    required this.onTapDetail,
    required this.onAddToCart,
    required this.cartCount,
  });

  final List<Product> products;
  final void Function(Product) onTapDetail;
  final void Function(Product) onAddToCart;
  final int cartCount;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.products.where((p) {
      final q = _query.toLowerCase();
      return q.isEmpty ||
          p.title.toLowerCase().contains(q) ||
          p.artist.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('상품 목록'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: '제목/아티스트 검색',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final p = filtered[i];
                return Card(
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => widget.onTapDetail(p),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          height: 80,
                          child: Image.network(p.imageUrl, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.title, style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 4),
                              Text(p.artist, style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 6),
                              Text('₩${p.price}', style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilledButton(
                            onPressed: () => widget.onAddToCart(p),
                            child: const Text('담기'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
