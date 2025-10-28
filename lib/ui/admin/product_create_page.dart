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
  final _stock = TextEditingController();
  final _tags = TextEditingController();
  final _imageUrl = TextEditingController();
  final _description = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _artist.dispose();
    _price.dispose();
    _stock.dispose();
    _tags.dispose();
    _imageUrl.dispose();
    _description.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      artist: _artist.text.trim(),
      price: int.parse(_price.text.trim()),
      imageUrl: _imageUrl.text.trim(),
      stock: int.tryParse(_stock.text.trim()) ?? 0,
      tags: _tags.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList(),
      description: _description.text.trim(),
    );

    widget.onCreate(product);
    Navigator.pop(context); // 등록 완료 후 뒤로가기
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('상품 등록'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 미리보기
              if (_imageUrl.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _imageUrl.text,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Center(child: Text('이미지 로드 실패')),
                    ),
                  ),
                ),
              TextFormField(
                controller: _imageUrl,
                decoration: const InputDecoration(
                  labelText: '이미지 URL',
                  hintText: '예: https://picsum.photos/seed/album/600/400',
                ),
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  if (v == null || v.isEmpty) return '이미지 주소를 입력하세요';
                  final uri = Uri.tryParse(v);
                  if (uri == null || !uri.isAbsolute) return '유효한 URL을 입력하세요';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: '상품명'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? '상품명을 입력하세요' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _artist,
                decoration: const InputDecoration(labelText: '아티스트'),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '가격'),
                validator: (v) {
                  if (v == null || v.isEmpty) return '가격을 입력하세요';
                  if (int.tryParse(v) == null) return '숫자만 입력하세요';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _stock,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '재고 수량'),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _tags,
                decoration: const InputDecoration(
                  labelText: '태그 (쉼표로 구분)',
                  hintText: '예: jazz, vinyl, classic',
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: '설명'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // 등록 버튼
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check),
                  label: const Text('등록하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
