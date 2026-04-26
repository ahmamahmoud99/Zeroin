import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class ZorinCard extends StatelessWidget {
  final Widget child;
  final Color? color;

  const ZorinCard({super.key, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? ZorinColors.cardBackground,
        // عمل انحناء ناعم للزوايا زي التصميم
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}