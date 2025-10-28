//관리자용(상품 등록 등) UI

import 'package:flutter/material.dart';
import '../../core/models/product.dart';

class ProductCreatePage extends StatefulWidget {
  const ProductCreatePage({super.key, required this.onCreate});
  final void Function(Product) onCreate;

  @override
  State<ProductCreatePage> createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _artist = TextEditingController();
  final _price = TextEditingController();
  final _imageUrl = TextEditingController(
    text: 'https://picsum.photos/seed/new/600/400',
  );
  final _tags = TextEditingController(text: 'new');

  @override
  void dispose() {
    _title.dispose();
    _artist.dispose();
    _price.dispose();
    _imageUrl.dispose();
    _tags.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final p = Product(
      id: 'lp-${DateTime.now().millisecondsSinceEpoch}',
      title: _title.text.trim(),
      artist: _artist.text.trim(),
      price: int.parse(_price.text.trim()),
      imageUrl: _imageUrl.text.trim(),
      stock: 50,
      tags: _tags.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
    );
    widget.onCreate(p);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('상품이 등록되었습니다.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상품 등록')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: '제목'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '제목을 입력하세요' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _artist,
              decoration: const InputDecoration(labelText: '아티스트'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '아티스트를 입력하세요' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _price,
              decoration: const InputDecoration(labelText: '가격'),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '가격을 입력하세요';
                final n = int.tryParse(v.trim());
                if (n == null || n <= 0) return '유효한 숫자를 입력하세요';
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _imageUrl,
              decoration: const InputDecoration(labelText: '이미지 URL'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _tags,
              decoration: const InputDecoration(labelText: '태그 (쉼표로 구분)'),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _submit, child: const Text('저장')),
          ],
        ),
      ),
    );
  }
}
