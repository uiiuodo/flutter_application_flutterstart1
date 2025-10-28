import 'package:flutter/material.dart';
import '../../core/models/product.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  final Product product;
  final void Function(int quantity) onAddToCart;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _itemCount = 1;

  @override
  Widget build(BuildContext context) {
    final lp = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(lp.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 대표 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  lp.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Text('이미지를 불러올 수 없습니다')),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 제목, 아티스트, 가격
            Text(
              lp.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              lp.artist,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              '₩${lp.price}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // 설명
            if (lp.description != null && lp.description!.isNotEmpty)
              Text(
                lp.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

            const SizedBox(height: 24),

            // 수량 선택
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      if (_itemCount > 1) _itemCount--;
                    });
                  },
                ),
                Text(
                  '$_itemCount',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() => _itemCount++);
                  },
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () {
                    widget.onAddToCart(_itemCount);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('장바구니에 추가됨 (${lp.title} x$_itemCount)'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('담기'),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
