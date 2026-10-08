import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_shimmer.dart';

/// Production cached network image with shimmer loading and error fallback.
class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0.0,
    this.errorIcon = Icons.broken_image_rounded,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final IconData errorIcon;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    final isInvalid = url == null || url.isEmpty || !url.startsWith('http');

    if (isInvalid) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Icon(errorIcon, color: AppColors.textMuted, size: 28),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, _) => AppShimmer(
          child: Container(
            width: width,
            height: height,
            color: AppColors.surface,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: AppColors.surface,
          child: Icon(errorIcon, color: AppColors.textMuted, size: 28),
        ),
      ),
    );
  }
}
