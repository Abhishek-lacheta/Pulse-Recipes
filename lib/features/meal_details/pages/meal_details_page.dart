import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_cached_image.dart';
import '../../../core/widgets/app_shimmer.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../injection/dependency_injection.dart';
import '../bloc/meal_details_bloc.dart';

/// Rich recipe detail screen consuming TheMealDB lookup API.
class MealDetailsPage extends StatelessWidget {
  const MealDetailsPage({
    super.key,
    required this.mealId,
    this.initialMealName,
    this.initialMealThumb,
  });

  final String mealId;
  final String? initialMealName;
  final String? initialMealThumb;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MealDetailsBloc>(
      create: (context) => MealDetailsBloc(DependencyInjection.mealRepository)
        ..add(MealDetailsFetchEvent(mealId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<MealDetailsBloc, MealDetailsState>(
          builder: (context, state) {
            if (state is MealDetailsLoading || state is MealDetailsInitial) {
              return _buildSkeleton(context);
            } else if (state is MealDetailsFailure) {
              return Scaffold(
                appBar: AppBar(),
                body: ErrorStateWidget(
                  message: state.message,
                  onRetry: () => context
                      .read<MealDetailsBloc>()
                      .add(MealDetailsFetchEvent(mealId)),
                ),
              );
            } else if (state is MealDetailsSuccess) {
              final meal = state.meal;
              final ingredients = meal.ingredients;
              final tags = meal.strTags
                  ?.split(',')
                  .map((t) => t.trim())
                  .where((t) => t.isNotEmpty)
                  .toList();

              return CustomScrollView(
                slivers: [
                  // Sliver App Bar with Recipe Image
                  SliverAppBar(
                    expandedHeight: 340,
                    pinned: true,
                    stretch: true,
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.textPrimary,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                      ],
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (meal.strMealThumb != null)
                            AppCachedImage(
                              imageUrl: meal.strMealThumb!,
                              fit: BoxFit.cover,
                            ),
                          // Subtle dark overlay gradient
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.5),
                                  Colors.transparent,
                                  AppColors.background.withValues(alpha: 0.9),
                                  AppColors.background,
                                ],
                                stops: const [0.0, 0.4, 0.85, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Recipe Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            meal.strMeal,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Badges (Category & Area)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (meal.strCategory != null && meal.strCategory!.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.primaryLight.withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.restaurant_menu_rounded,
                                        size: 14,
                                        color: AppColors.primaryLight,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        meal.strCategory!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (meal.strArea != null && meal.strArea!.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceLight,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.public_rounded,
                                        size: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        meal.strArea!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),

                          // Tags
                          if (tags != null && tags.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: tags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],

                          const SizedBox(height: 28),

                          // Ingredients Section
                          if (ingredients.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Ingredients',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Text(
                                    '${ingredients.length} items',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Ingredient Cards List
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: ingredients.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final ing = ingredients[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    children: [
                                      // Ingredient image
                                      AppCachedImage(
                                        imageUrl: ApiConstants.ingredientSmallImageUrl(ing.name),
                                        width: 36,
                                        height: 36,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          ing.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      if (ing.measure.isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.surfaceLight,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            ing.measure,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primaryLight,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 28),
                          ],

                          // Instructions Section
                          if (meal.strInstructions != null &&
                              meal.strInstructions!.trim().isNotEmpty) ...[
                            const Text(
                              'Instructions',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                meal.strInstructions!.trim(),
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  height: 1.65,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                          ],

                          // External Links (YouTube, Source)
                          if ((meal.strYoutube != null && meal.strYoutube!.isNotEmpty) ||
                              (meal.strSource != null && meal.strSource!.isNotEmpty)) ...[
                            const Text(
                              'Explore More',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                if (meal.strYoutube != null && meal.strYoutube!.isNotEmpty)
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _openUrl(meal.strYoutube!),
                                      icon: const Icon(
                                        Icons.play_circle_fill_rounded,
                                        color: Color(0xFFFF0000),
                                        size: 20,
                                      ),
                                      label: const Text('Watch on YouTube'),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: AppColors.surface,
                                        foregroundColor: AppColors.textPrimary,
                                        side: const BorderSide(color: AppColors.border),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                    ),
                                  ),
                                if (meal.strYoutube != null &&
                                    meal.strYoutube!.isNotEmpty &&
                                    meal.strSource != null &&
                                    meal.strSource!.isNotEmpty)
                                  const SizedBox(width: 12),
                                if (meal.strSource != null && meal.strSource!.isNotEmpty)
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _openUrl(meal.strSource!),
                                      icon: const Icon(
                                        Icons.open_in_new_rounded,
                                        color: AppColors.primaryLight,
                                        size: 18,
                                      ),
                                      label: const Text('Recipe Source'),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: AppColors.surface,
                                        foregroundColor: AppColors.textPrimary,
                                        side: const BorderSide(color: AppColors.border),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 32),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _openUrl(String urlString) async {
    final uri = Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildSkeleton(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: AppColors.surface,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(color: AppColors.surface),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: AppShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(width: 240, height: 26),
                  const SizedBox(height: 14),
                  Row(
                    children: const [
                      ShimmerBox(width: 80, height: 28, borderRadius: 14),
                      SizedBox(width: 8),
                      ShimmerBox(width: 90, height: 28, borderRadius: 14),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const ShimmerBox(width: 130, height: 20),
                  const SizedBox(height: 16),
                  const ShimmerBox(width: double.infinity, height: 48, borderRadius: 12),
                  const SizedBox(height: 8),
                  const ShimmerBox(width: double.infinity, height: 48, borderRadius: 12),
                  const SizedBox(height: 8),
                  const ShimmerBox(width: double.infinity, height: 48, borderRadius: 12),
                  const SizedBox(height: 32),
                  const ShimmerBox(width: 140, height: 20),
                  const SizedBox(height: 16),
                  const ShimmerBox(width: double.infinity, height: 160, borderRadius: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
