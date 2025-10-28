//상품 한 개의 상세 화면

import 'package:flutter/material.dart';
import '../../core/models/product.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.product,
    required this.onAddToCart,
    this.related = const [],
  });

  final Product product;
  final void Function(int qty) onAddToCart;
  final List<Product> related;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final total = p.price * qty;

    return Scaffold(
      appBar: AppBar(title: Text(p.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 1.6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(p.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16),
          Text(p.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(p.artist, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('₩${p.price}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('수량'),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$qty'),
              IconButton(
                onPressed: () => setState(() => qty++),
                icon: const Icon(Icons.add_circle_outline),
              ),
              const Spacer(),
              Text(
                '합계 ₩$total',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              widget.onAddToCart(qty);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to Cart'),
          ),
          if (widget.related.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('관련 상품', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.related.length,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final r = widget.related[i];
                  return Container(
                    width: 160,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    child: Text(
                      r.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
