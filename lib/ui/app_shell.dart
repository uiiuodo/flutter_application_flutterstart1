// lib/ui/app_shell.dart
import 'package:flutter/material.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final _pages = const [
    Center(child: Text('상품 목록 페이지(임시)')),
    Center(child: Text('장바구니 페이지(임시)')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shop App')),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar( // 👈 const 제거!
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: '장바구니'),
        ],
      ),
    );
  }
}
