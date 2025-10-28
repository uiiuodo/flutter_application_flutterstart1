import 'package:flutter/material.dart';
import '../core/models/product.dart';
import '../core/models/cart_item.dart';
import '../core/data/products_mock.dart';
import 'product/product_list_page.dart';
import 'product/product_detail_page.dart';
import 'product/product_search_delegate.dart'; // ⬅️ 추가
import 'cart/cart_page.dart';
import 'admin/product_create_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // 앱 전역(간단형) 상태
  final List<Product> _products = List<Product>.from(mockProducts);
  final List<CartItem> _cart = [];

  int get cartCount => _cart.fold<int>(0, (s, it) => s + it.quantity);

  void _addToCart(Product p, {int qty = 1}) {
    setState(() {
      final i = _cart.indexWhere((e) => e.productId == p.id);
      if (i >= 0) {
        _cart[i].quantity += qty;
      } else {
        _cart.add(CartItem(productId: p.id, quantity: qty));
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('장바구니에 담았어요! (${p.title}) x$qty')));
  }

  void _updateQuantity(String productId, int qty) {
    setState(() {
      final i = _cart.indexWhere((e) => e.productId == productId);
      if (i >= 0) _cart[i].quantity = qty.clamp(1, 999);
    });
  }

  void _removeFromCart(String productId) {
    setState(() => _cart.removeWhere((e) => e.productId == productId));
  }

  void _clearCart() {
    setState(() => _cart.clear());
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('구매 완료! 장바구니를 비웠어요.')));
  }

  void _createProduct(Product p) {
    setState(() {
      _products.insert(0, p);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('상품 등록됨: ${p.title}')));
  }

  Product _findProduct(String id) => _products.firstWhere((e) => e.id == id);

  void _openDetail(Product p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(
          product: p,
          onAddToCart: (qty) => _addToCart(p, qty: qty),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('타이틀명'), // 원하면 "타이틀"로 교체
        centerTitle: true,
        actions: [
          // 검색
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: ProductSearchDelegate(
                  products: _products,
                  onSelect: _openDetail,
                ),
              );
            },
          ),
          // 장바구니
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartPage(
                        items: _cart,
                        findProduct: _findProduct,
                        onRemove: _removeFromCart,
                        onChangeQty: _updateQuantity,
                        onPurchase: _clearCart,
                      ),
                    ),
                  );
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      cartCount > 99 ? '99+' : '$cartCount',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      // 본문: 목록 페이지 (AppBar/FAB 없는 "내용만" 렌더)
      body: SafeArea(
        child: ProductListPage(
          products: _products,
          onTapDetail: _openDetail,
          onAddToCart: (p) => _addToCart(p),
          cartCount: cartCount,
          onCreateProduct: (p) => _createProduct(p),
          showAppBar: false, // ⬅️ 상단바는 AppShell이 담당
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductCreatePage(onCreate: _createProduct),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
