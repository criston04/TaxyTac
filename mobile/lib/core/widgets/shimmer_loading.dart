import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusSm),
        ),
      ),
    );
  }
}

class ShimmerDriverCard extends StatelessWidget {
  const ShimmerDriverCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Row(
          children: [
            ShimmerLoading(width: 60, height: 60, borderRadius: BorderRadius.circular(30)),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoading(width: double.infinity, height: 16),
                  const SizedBox(height: AppTheme.spacingSm),
                  ShimmerLoading(width: 120, height: 14),
                  const SizedBox(height: AppTheme.spacingSm),
                  ShimmerLoading(width: 80, height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerTripCard extends StatelessWidget {
  const ShimmerTripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(AppTheme.spacingMd),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoading(width: 150, height: 20),
            const SizedBox(height: AppTheme.spacingMd),
            ShimmerLoading(width: double.infinity, height: 16),
            const SizedBox(height: AppTheme.spacingSm),
            ShimmerLoading(width: double.infinity, height: 16),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerLoading(width: 100, height: 24),
                ShimmerLoading(width: 80, height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
