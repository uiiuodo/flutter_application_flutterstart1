//첫 화면
// lib/ui/start/start_page.dart
import 'package:flutter/material.dart';
import '../app_shell.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  void _go(BuildContext context) {
    // 시작화면으로 돌아오지 않게 교체 내비게이션
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AppShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      // 심플 배경 (원하면 이미지/그래디언트로 교체 가능)
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [cs.surface, cs.surfaceContainerHighest],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 가운데 로고/앱명
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 앱 로고 자리
                    Container(
                      width: 120, height: 120,
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.album, size: 64, color: cs.onPrimaryContainer),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Shop App',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '음반 쇼핑을 더 쉽게',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              // 하단 "들어가기" 텍스트
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: InkWell(
                      onTap: () => _go(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          '들어가기',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: cs.primary,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
