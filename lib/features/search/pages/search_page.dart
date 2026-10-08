import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/meal_card.dart';
import '../../../injection/dependency_injection.dart';
import '../../meal_details/pages/meal_details_page.dart';
import '../bloc/search_bloc.dart';

/// Dedicated search screen supporting query-by-name with debounce and search-by-first-letter.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(DependencyInjection.mealRepository),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();
  String? _selectedLetter;

  static const _alphabet = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onLetterSelected(String letter) {
    setState(() {
      _selectedLetter = letter;
      _controller.text = '';
    });
    FocusScope.of(context).unfocus();
    context.read<SearchBloc>().add(SearchByFirstLetterEvent(letter.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Search Recipes',
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
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _controller,
              onChanged: (query) {
                setState(() => _selectedLetter = null);
                context.read<SearchBloc>().add(SearchQueryChangedEvent(query));
              },
              cursorColor: AppColors.primary,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Search by meal name (e.g. Pasta, Pie)...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear_rounded,
                          color: AppColors.textMuted,
                          size: 18,
                        ),
                        onPressed: () {
                          _controller.clear();
                          context.read<SearchBloc>().add(const SearchClearEvent());
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
          ),

          // A-Z Alphabet Filter Row
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _alphabet.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final letter = _alphabet[index];
                final isSelected = _selectedLetter == letter;

                return GestureDetector(
                  onTap: () => _onLetterSelected(letter),
                  child: Container(
                    width: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Search Results View
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => const MealCardSkeleton(),
                  );
                } else if (state is SearchFailure) {
                  return ErrorStateWidget(
                    message: state.message,
                    onRetry: () {
                      if (_selectedLetter != null) {
                        _onLetterSelected(_selectedLetter!);
                      } else {
                        context
                            .read<SearchBloc>()
                            .add(SearchQueryChangedEvent(_controller.text));
                      }
                    },
                  );
                } else if (state is SearchEmpty) {
                  return EmptyStateWidget(
                    title: 'No recipes found',
                    message: 'No matches found for "${state.query}". Try another keyword or browse by letter.',
                  );
                } else if (state is SearchSuccess) {
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
                        imageUrl: meal.strMealThumb ?? '',
                        category: meal.strCategory,
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

                // Initial State
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(
                            Icons.restaurant_rounded,
                            size: 44,
                            color: AppColors.primaryLight,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Find Any Recipe',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Type a dish name above or pick a letter to browse thousands of recipes from TheMealDB.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
