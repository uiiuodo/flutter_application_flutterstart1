//장바구니 관련 UI
//사용자가 담은 상품 목록 표시

import 'package:flutter/material.dart';
import '../../core/models/product.dart';
import '../../core/models/cart_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({
    super.key,
    required this.items,
    required this.findProduct,
    required this.onRemove,
    required this.onChangeQty,
    required this.onPurchase,
  });

  final List<CartItem> items;
  final Product Function(String id) findProduct;
  final void Function(String productId) onRemove;
  final void Function(String productId, int qty) onChangeQty;
  final VoidCallback onPurchase;

  int _total() {
    int sum = 0;
    for (final it in items) {
      final p = findProduct(it.productId);
      sum += p.price * it.quantity;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final total = _total();

    return Scaffold(
      appBar: AppBar(title: const Text('장바구니')),
      body: items.isEmpty
          ? const Center(child: Text('장바구니가 비었습니다.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    padding: const EdgeInsets.all(16),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final it = items[i];
                      final p = findProduct(it.productId);
                      return Dismissible(
                        key: ValueKey(it.productId),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => onRemove(it.productId),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          color: Theme.of(context).colorScheme.error,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          elevation: 0,
                          child: ListTile(
                            leading: SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.network(
                                p.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              p.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text('₩${p.price}'),
                            trailing: _QtyControl(
                              qty: it.quantity,
                              onDec: () =>
                                  onChangeQty(it.productId, it.quantity - 1),
                              onInc: () =>
                                  onChangeQty(it.productId, it.quantity + 1),
                              onRemove: () => onRemove(it.productId),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '합계',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '₩$total',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: items.isEmpty ? null : onPurchase,
                        child: const Text('구매하기'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  const _QtyControl({
    required this.qty,
    required this.onDec,
    required this.onInc,
    required this.onRemove,
  });

  final int qty;
  final VoidCallback onDec;
  final VoidCallback onInc;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: qty > 1 ? onDec : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text('$qty'),
        IconButton(
          onPressed: onInc,
          icon: const Icon(Icons.add_circle_outline),
        ),
        IconButton(onPressed: onRemove, icon: const Icon(Icons.delete_outline)),
      ],
    );
  }
}
