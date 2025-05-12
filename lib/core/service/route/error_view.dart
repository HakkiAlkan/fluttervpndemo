import 'package:flutter/material.dart';
import 'package:fluttervpndemo/ui/helper/ui_helpers.dart';
import 'package:go_router/go_router.dart';

class ErrorView extends StatelessWidget {
  const ErrorView(this.state, {super.key});

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Bulunamadı!'),
      ),
      body: Center(
        child: Text(
          state.error?.message ?? 'Hata',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: FontSizeValue.large),
        ),
      ),
    );
  }
}
