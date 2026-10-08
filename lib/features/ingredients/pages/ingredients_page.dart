import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_cached_image.dart';
import '../../../core/widgets/app_shimmer.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../injection/dependency_injection.dart';
import '../../filtered_meals/pages/filtered_meals_page.dart';
import '../bloc/ingredients_bloc.dart';

/// Ingredients browsing screen consuming TheMealDB ingredients list API.
class IngredientsPage extends StatelessWidget {
  const IngredientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IngredientsBloc>(
      create: (context) => IngredientsBloc(DependencyInjection.mealRepository)
        ..add(const IngredientsFetchEvent()),
      child: const _IngredientsView(),
    );
  }
}

class _IngredientsView extends StatefulWidget {
  const _IngredientsView();

  @override
  State<_IngredientsView> createState() => _IngredientsViewState();
}

class _IngredientsViewState extends State<_IngredientsView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Browse Ingredients',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                context
                    .read<IngredientsBloc>()
                    .add(IngredientsFilterQueryEvent(val));
              },
              cursorColor: AppColors.primary,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Filter ingredients by name...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear_rounded,
                          color: AppColors.textMuted,
                          size: 18,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          context
                              .read<IngredientsBloc>()
                              .add(const IngredientsFilterQueryEvent(''));
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Content
          Expanded(
            child: BlocBuilder<IngredientsBloc, IngredientsState>(
              builder: (context, state) {
                if (state is IngredientsLoading || state is IngredientsInitial) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: 15,
                    itemBuilder: (context, index) => AppShimmer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  );
                } else if (state is IngredientsFailure) {
                  return ErrorStateWidget(
                    message: state.message,
                    onRetry: () => context
                        .read<IngredientsBloc>()
                        .add(const IngredientsFetchEvent()),
                  );
                } else if (state is IngredientsSuccess) {
                  final ingredients = state.filteredIngredients;
                  if (ingredients.isEmpty) {
                    return EmptyStateWidget(
                      title: 'No ingredients found',
                      message: 'No ingredient matches "${state.searchQuery}".',
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                      final item = ingredients[index];
                      final imageUrl =
                          ApiConstants.ingredientImageUrl(item.strIngredient);

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => FilteredMealsPage(
                                ingredient: item.strIngredient,
                                title: item.strIngredient,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: AppCachedImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.contain,
                                  errorIcon: Icons.fastfood_outlined,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.strIngredient,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
