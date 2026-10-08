import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_cached_image.dart';
import '../../../core/widgets/app_shimmer.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/meal_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../filtered_meals/pages/filtered_meals_page.dart';
import '../../meal_details/pages/meal_details_page.dart';
import '../bloc/home_bloc.dart';

/// Modern 2026 Home Screen consuming real TheMealDB API endpoints.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.onNavigateToSearch,
    required this.onNavigateToCategories,
    required this.onNavigateToAreas,
    required this.onNavigateToIngredients,
  });

  final VoidCallback onNavigateToSearch;
  final VoidCallback onNavigateToCategories;
  final VoidCallback onNavigateToAreas;
  final VoidCallback onNavigateToIngredients;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return _buildSkeleton();
            } else if (state is HomeFailure) {
              return ErrorStateWidget(
                message: state.message,
                onRetry: () => context
                    .read<HomeBloc>()
                    .add(const HomeFetchDataEvent(isRefresh: false)),
              );
            } else if (state is HomeSuccess) {
              final featured = state.featuredMeal;
              final categories = state.categories;
              final popularMeals = state.popularMeals;
              final areas = state.areas;

              return RefreshIndicator(
                color: AppColors.primaryLight,
                backgroundColor: AppColors.surface,
                onRefresh: () async {
                  context
                      .read<HomeBloc>()
                      .add(const HomeFetchDataEvent(isRefresh: true));
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    // Header with Branding & Search Trigger
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Pulse Recipes',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.6,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'What would you like to cook today?',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.egg_alt_outlined,
                                    color: AppColors.primaryLight,
                                  ),
                                  tooltip: 'Browse Ingredients',
                                  onPressed: onNavigateToIngredients,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Search Trigger Bar
                            GestureDetector(
                              onTap: onNavigateToSearch,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.search_rounded,
                                      size: 20,
                                      color: AppColors.textSecondary,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Search recipes by name or letter...',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Featured / Random Meal Card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => MealDetailsPage(
                                  mealId: featured.idMeal,
                                  initialMealName: featured.strMeal,
                                  initialMealThumb: featured.strMealThumb,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.18),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (featured.strMealThumb != null)
                                  AppCachedImage(
                                    imageUrl: featured.strMealThumb!,
                                    fit: BoxFit.cover,
                                  ),
                                // Dark cinematic gradient overlay
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.2),
                                        Colors.black.withValues(alpha: 0.85),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 14,
                                  left: 14,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'FEATURED DISH',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        featured.strMeal,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.white,
                                          height: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          if (featured.strCategory != null) ...[
                                            const Icon(
                                              Icons.restaurant_rounded,
                                              size: 13,
                                              color: AppColors.primaryLight,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              featured.strCategory!,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primaryLight,
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                          ],
                                          if (featured.strArea != null) ...[
                                            const Icon(
                                              Icons.public_rounded,
                                              size: 13,
                                              color: AppColors.textSecondary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              featured.strArea!,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Categories Carousel
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Categories',
                        actionText: 'See All',
                        onAction: onNavigateToCategories,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 110,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => FilteredMealsPage(
                                      category: cat.strCategory,
                                      title: cat.strCategory,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 90,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.border),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: AppCachedImage(
                                        imageUrl: cat.strCategoryThumb,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      cat.strCategory,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Popular Recipes Section
                    SliverToBoxAdapter(
                      child: const SizedBox(height: 12),
                    ),
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Popular Recipes',
                        subtitle: 'Delicacies from TheMealDB',
                        actionText: 'Browse',
                        onAction: onNavigateToSearch,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 220,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: popularMeals.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final meal = popularMeals[index];
                            return MealCard(
                              id: meal.idMeal,
                              title: meal.strMeal,
                              imageUrl: meal.strMealThumb,
                              area: meal.strArea,
                              width: 170,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => MealDetailsPage(
                                      mealId: meal.idMeal,
                                      initialMealName: meal.strMeal,
                                      initialMealThumb: meal.strMealThumb,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),

                    // Browse by World Cuisines
                    SliverToBoxAdapter(
                      child: const SizedBox(height: 12),
                    ),
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'World Cuisines',
                        subtitle: 'Recipes from across the globe',
                        actionText: 'View All',
                        onAction: onNavigateToAreas,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 48,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: areas.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final area = areas[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => FilteredMealsPage(
                                      area: area.strArea,
                                      title: '${area.strArea} Cuisine',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.public_rounded,
                                      size: 16,
                                      color: AppColors.primaryLight,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      area.strArea,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: 40),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(width: 180, height: 28),
            const SizedBox(height: 8),
            const ShimmerBox(width: 240, height: 16),
            const SizedBox(height: 24),
            const ShimmerBox(width: double.infinity, height: 50, borderRadius: 14),
            const SizedBox(height: 24),
            const ShimmerBox(width: double.infinity, height: 200, borderRadius: 20),
            const SizedBox(height: 28),
            const ShimmerBox(width: 140, height: 20),
            const SizedBox(height: 16),
            Row(
              children: const [
                ShimmerBox(width: 85, height: 95, borderRadius: 16),
                SizedBox(width: 12),
                ShimmerBox(width: 85, height: 95, borderRadius: 16),
                SizedBox(width: 12),
                ShimmerBox(width: 85, height: 95, borderRadius: 16),
                SizedBox(width: 12),
                ShimmerBox(width: 85, height: 95, borderRadius: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
