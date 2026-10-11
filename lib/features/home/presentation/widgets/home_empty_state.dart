import 'package:flutter/material.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Нет активного челленджа',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
