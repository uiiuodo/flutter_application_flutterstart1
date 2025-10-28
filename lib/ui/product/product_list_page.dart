//상품 목록 페이지

import 'package:flutter/material.dart';
import '../../core/models/product.dart';
import '../admin/product_create_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({
    super.key,
    required this.products,
    required this.onTapDetail,
    required this.onAddToCart,
    required this.cartCount,
    required this.onCreateProduct,
    this.showAppBar = true, // ⬅️ 추가
  });

  final List<Product> products;
  final void Function(Product) onTapDetail;
  final void Function(Product) onAddToCart;
  final int cartCount;
  final void Function(Product) onCreateProduct;
  final bool showAppBar;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final filtered = widget.products.where((p) {
      if (q.isEmpty) return true;
      return p.title.toLowerCase().contains(q) ||
             p.artist.toLowerCase().contains(q) ||
             p.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();

    final content = Column(
      children: [
        // 리스트 상단 검색창은 "임시용" — AppShell 검색 아이콘을 쓸 땐 감춰도 됨.
        if (widget.showAppBar) // ⬅️ 아이콘 UX로 가면 이 블록을 숨김
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: '제목/아티스트/태그 검색',
                border: const OutlineInputBorder(),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),

        if (filtered.isEmpty)
          Expanded(
            child: Center(
              child: Text(
                '해당하는 음반이 없습니다.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        else
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
                              Text(p.title,
                                  style: Theme.of(context).textTheme.titleMedium,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(p.artist,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                runSpacing: -6,
                                children: [
                                  Text('₩${p.price}'),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(999),
                                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                                    ),
                                    child: Text('재고 ${p.stock}', style: const TextStyle(fontSize: 11)),
                                  ),
                                  ...p.tags.take(2).map((t) => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(999),
                                          color: Theme.of(context).colorScheme.surfaceContainerHigh,
                                        ),
                                        child: Text('#$t', style: const TextStyle(fontSize: 11)),
                                      )),
                                ],
                              ),
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
    );

    if (widget.showAppBar) {
      return Scaffold(
        appBar: AppBar(title: const Text('목록페이지'), centerTitle: true),
        body: content,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductCreatePage(onCreate: widget.onCreateProduct),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      );
    } else {
      // 상위(AppShell)가 AppBar를 제공하는 경우: 본문만 반환
      return content;
    }
  }
}
