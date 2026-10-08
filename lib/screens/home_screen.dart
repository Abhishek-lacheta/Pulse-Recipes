import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants/app_colors.dart';
import '../features/areas/pages/areas_page.dart';
import '../features/auth/cubit/auth_cubit.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/categories/pages/categories_page.dart';
import '../features/home/bloc/home_bloc.dart';
import '../features/home/pages/home_page.dart';
import '../features/ingredients/pages/ingredients_page.dart';
import '../features/search/pages/search_page.dart';
import '../injection/dependency_injection.dart';

/// Main Application Shell integrating TheMealDB recipe features and Firebase Auth.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  void _showProfileModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final user = state is AuthAuthenticated
                ? state.user
                : (state is AuthSuccess ? state.user : null);

            final name = user?.displayName ?? 'Chef';
            final email = user?.email ?? 'No email associated';
            final uid = user?.id ?? 'N/A';

            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.surfaceLight,
                        backgroundImage: user?.photoUrl != null
                            ? NetworkImage(user!.photoUrl!)
                            : null,
                        child: user?.photoUrl == null
                            ? const Icon(
                                Icons.person_rounded,
                                size: 30,
                                color: AppColors.primaryLight,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_user_rounded,
                          size: 16,
                          color: AppColors.primaryLight,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'UID: $uid',
                            style: const TextStyle(
                              fontSize: 11,
                              fontFamily: 'monospace',
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(modalContext).pop();
                      context.read<AuthCubit>().signOut();
                    },
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceLight,
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: BlocProvider<HomeBloc>(
        create: (context) => HomeBloc(DependencyInjection.mealRepository)
          ..add(const HomeFetchDataEvent()),
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: AppColors.primaryLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Pulse Recipes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Account Profile',
                icon: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
                onPressed: () => _showProfileModal(context),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              HomePage(
                onNavigateToSearch: () => _onTabSelected(1),
                onNavigateToCategories: () => _onTabSelected(2),
                onNavigateToAreas: () => _onTabSelected(3),
                onNavigateToIngredients: () => _onTabSelected(4),
              ),
              const SearchPage(),
              const CategoriesPage(),
              const AreasPage(),
              const IngredientsPage(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border, width: 1)),
            ),
            child: NavigationBar(
              backgroundColor: AppColors.surface,
              selectedIndex: _currentIndex,
              onDestinationSelected: _onTabSelected,
              indicatorColor: AppColors.primary.withValues(alpha: 0.25),
              elevation: 0,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, color: AppColors.textSecondary),
                  selectedIcon: Icon(Icons.home_rounded, color: AppColors.primaryLight),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search_outlined, color: AppColors.textSecondary),
                  selectedIcon: Icon(Icons.search_rounded, color: AppColors.primaryLight),
                  label: 'Search',
                ),
                NavigationDestination(
                  icon: Icon(Icons.category_outlined, color: AppColors.textSecondary),
                  selectedIcon: Icon(Icons.category_rounded, color: AppColors.primaryLight),
                  label: 'Categories',
                ),
                NavigationDestination(
                  icon: Icon(Icons.public_outlined, color: AppColors.textSecondary),
                  selectedIcon: Icon(Icons.public_rounded, color: AppColors.primaryLight),
                  label: 'Cuisines',
                ),
                NavigationDestination(
                  icon: Icon(Icons.egg_alt_outlined, color: AppColors.textSecondary),
                  selectedIcon: Icon(Icons.egg_alt_rounded, color: AppColors.primaryLight),
                  label: 'Ingredients',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
