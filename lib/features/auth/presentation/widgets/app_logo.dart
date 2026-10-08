import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Modern, premium app logo widget with subtle gradient and depth.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 72.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(size * 0.28);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF818CF8),
            Color(0xFF4F46E5),
            Color(0xFF3730A3),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: size * 0.35,
            offset: Offset(0, size * 0.15),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.bolt_rounded,
          size: size * 0.58,
          color: AppColors.white,
        ),
      ),
    );
  }
}
