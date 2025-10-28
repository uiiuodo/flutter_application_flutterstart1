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

  // 폼 컨트롤러
  final _title = TextEditingController();
  final _artist = TextEditingController();
  final _price = TextEditingController();
  final _stock = TextEditingController(text: '1');
  final _tags = TextEditingController();
  final _description = TextEditingController();

  // 이미지 URL은 텍스트필드를 숨기고, '이미지 박스'를 통해 팝업에서만 입력
  final _imageUrl = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _artist.dispose();
    _price.dispose();
    _stock.dispose();
    _tags.dispose();
    _description.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  Future<void> _editImageUrl() async {
    final url = await showDialog<String>(
      context: context,
      builder: (_) => _ImageUrlDialog(initial: _imageUrl.text),
    );
    if (url != null) {
      setState(() => _imageUrl.text = url.trim());
    }
  }

  void _submit() {
    // 이미지 필수
    if (_imageUrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('이미지 URL을 입력하세요')));
      return;
    }
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
    Navigator.pop(context); // 저장 후 목록으로
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
              // 1) 이미지 큰 박스 (탭하면 URL 팝업)
              GestureDetector(
                onTap: _editImageUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _imageUrl.text.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            color: cs.surfaceContainerHighest,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.image_outlined, size: 40),
                                SizedBox(height: 8),
                                Text('이미지 등록 (탭)'),
                              ],
                            ),
                          )
                        : Image.network(
                            _imageUrl.text,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              alignment: Alignment.center,
                              color: cs.surfaceContainerHighest,
                              child: const Text('이미지를 불러올 수 없습니다'),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2) 기본 정보
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: '음반명'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? '음반명을 입력하세요' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _artist,
                decoration: const InputDecoration(labelText: '아티스트'),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: '상세 설명'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // 3) 수량/금액
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stock,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: '보유/등록 수량'),
                      validator: (v) {
                        if (v == null || v.isEmpty) return '수량을 입력하세요';
                        if (int.tryParse(v) == null) return '숫자만 입력하세요';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _price,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: '금액'),
                      validator: (v) {
                        if (v == null || v.isEmpty) return '금액을 입력하세요';
                        if (int.tryParse(v) == null) return '숫자만 입력하세요';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _tags,
                decoration: const InputDecoration(
                  labelText: '태그 (쉼표로 구분)',
                  hintText: '예: jazz, vinyl, classic',
                ),
              ),
              const SizedBox(height: 24),

              // 4) 하단 버튼 (취소 / 등록하기)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.check),
                      label: const Text('등록하기'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 이미지 URL 입력용 다이얼로그
class _ImageUrlDialog extends StatefulWidget {
  const _ImageUrlDialog({required this.initial});
  final String initial;

  @override
  State<_ImageUrlDialog> createState() => _ImageUrlDialogState();
}

class _ImageUrlDialogState extends State<_ImageUrlDialog> {
  late final TextEditingController _ctrl;
  String? _error;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final v = _ctrl.text.trim();
    final uri = Uri.tryParse(v);
    if (v.isEmpty || uri == null || !uri.isAbsolute) {
      setState(() => _error = '유효한 이미지 URL을 입력하세요');
      return;
    }
    Navigator.pop(context, v);
  }

  @override
  Widget build(BuildContext context) {
    final previewUrl = _ctrl.text.trim();

    return AlertDialog(
      title: const Text('이미지 URL 입력'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _ctrl,
            decoration: InputDecoration(
              hintText: 'https:// ...',
              errorText: _error,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _ctrl.clear();
                  setState(() => _error = null);
                },
              ),
            ),
            onChanged: (_) => setState(() => _error = null),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          if (previewUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  previewUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    alignment: Alignment.center,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Text('미리보기 실패'),
                  ),
                ),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(onPressed: _submit, child: const Text('확인')),
      ],
    );
  }
}
