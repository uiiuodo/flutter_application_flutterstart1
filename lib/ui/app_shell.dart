import 'package:flutter/material.dart';
import '../core/models/product.dart';
import '../core/models/cart_item.dart';
import '../core/data/products_mock.dart';
import 'product/product_list_page.dart';
import 'product/product_detail_page.dart';
import 'cart/cart_page.dart';
import 'admin/product_create_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  // App-wide state (simple setState version)
  final List<Product> _products = List<Product>.from(mockProducts);
  final List<CartItem> _cart = [];

  int get cartCount => _cart.fold<int>(0, (sum, it) => sum + it.quantity);

  void _addToCart(Product p, {int qty = 1}) {
    setState(() {
      final i = _cart.indexWhere((e) => e.productId == p.id);
      if (i >= 0) {
        _cart[i].quantity += qty;
      } else {
        _cart.add(CartItem(productId: p.id, quantity: qty));
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('장바구니에 담았어요! (${p.title}) x$qty')));
    });
  }

  void _updateQuantity(String productId, int qty) {
    setState(() {
      final i = _cart.indexWhere((e) => e.productId == productId);
      if (i >= 0) {
        _cart[i].quantity = qty.clamp(1, 999);
      }
    });
  }

  void _removeFromCart(String productId) {
    setState(() {
      _cart.removeWhere((e) => e.productId == productId);
    });
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('구매 완료! 장바구니를 비웠어요.')));
    });
  }

  void _createProduct(Product p) {
    setState(() {
      _products.insert(0, p);
      _index = 0; // 목록으로 이동
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('상품 등록됨: ${p.title}')));
  }

  Product _findProduct(String id) => _products.firstWhere((e) => e.id == id);

  @override
  Widget build(BuildContext context) {
    final pages = [
      ProductListPage(
        products: _products,
        onTapDetail: (p) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(
                product: p,
                onAddToCart: (qty) => _addToCart(p, qty: qty),
                related: _products
                    .where(
                      (e) =>
                          e.id != p.id && e.tags.any((t) => p.tags.contains(t)),
                    )
                    .take(6)
                    .toList(),
              ),
            ),
          );
        },
        onAddToCart: (p) => _addToCart(p),
        cartCount: cartCount,
      ),
      CartPage(
        items: _cart,
        findProduct: _findProduct,
        onRemove: _removeFromCart,
        onChangeQty: _updateQuantity,
        onPurchase: _clearCart,
      ),
      ProductCreatePage(onCreate: _createProduct),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: '목록',
          ),
          NavigationDestination(
            icon: _CartIcon(count: cartCount),
            selectedIcon: _CartIcon(count: cartCount, selected: true),
            label: '장바구니',
          ),
          const NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(Icons.add_box),
            label: '등록',
          ),
        ],
      ),
    );
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon({required this.count, this.selected = false});
  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      selected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
    );
    if (count <= 0) return icon;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        Positioned(
          right: -6,
          top: -6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              count > 99 ? '99+' : '$count',
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
