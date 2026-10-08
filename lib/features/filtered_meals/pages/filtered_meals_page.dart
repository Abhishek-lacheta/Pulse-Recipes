import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/meal_card.dart';
import '../../../injection/dependency_injection.dart';
import '../../meal_details/pages/meal_details_page.dart';
import '../bloc/filtered_meals_bloc.dart';

/// Shows a grid of meals filtered by Category, Area/Cuisine, or Ingredient.
class FilteredMealsPage extends StatelessWidget {
  const FilteredMealsPage({
    super.key,
    this.category,
    this.area,
    this.ingredient,
    required this.title,
  });

  final String? category;
  final String? area;
  final String? ingredient;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FilteredMealsBloc>(
      create: (context) => FilteredMealsBloc(DependencyInjection.mealRepository)
        ..add(
          FilteredMealsFetchEvent(
            category: category,
            area: area,
            ingredient: ingredient,
          ),
        ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          elevation: 0,
          backgroundColor: AppColors.background,
        ),
        body: BlocBuilder<FilteredMealsBloc, FilteredMealsState>(
          builder: (context, state) {
            if (state is FilteredMealsLoading || state is FilteredMealsInitial) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
                itemCount: 8,
                itemBuilder: (context, index) => const MealCardSkeleton(),
              );
            } else if (state is FilteredMealsFailure) {
              return ErrorStateWidget(
                message: state.message,
                onRetry: () => context.read<FilteredMealsBloc>().add(
                      FilteredMealsFetchEvent(
                        category: category,
                        area: area,
                        ingredient: ingredient,
                      ),
                    ),
              );
            } else if (state is FilteredMealsEmpty) {
              return EmptyStateWidget(
                title: 'No meals found',
                message: 'No recipes found for "$title".',
              );
            } else if (state is FilteredMealsSuccess) {
              final meals = state.meals;
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return MealCard(
                    id: meal.idMeal,
                    title: meal.strMeal,
                    imageUrl: meal.strMealThumb,
                    area: meal.strArea,
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
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
