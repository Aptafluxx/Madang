import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/features/auth/presentation/controller/login_binding.dart';
import 'package:madang/features/auth/presentation/controller/signup_binding.dart';
import 'package:madang/features/auth/presentation/login_screen.dart';
import 'package:madang/features/auth/presentation/signup_screen.dart';
import 'package:madang/features/home/data/controller/home_binding.dart';
import 'package:madang/features/home/presentation/home_screen.dart';
import 'package:madang/features/onboarding/controller/onboarding_binding.dart';
import 'package:madang/features/onboarding/presentation/onboarding_screen.dart';
import 'package:madang/features/splash/controller/splash_binding.dart';
import 'package:madang/features/splash/presentation/splash_screen.dart';
import 'package:madang/features/recent/presentation/recent_screen.dart';
import 'package:madang/features/table/data/bindings/table_binding.dart';
import 'package:madang/features/table/presentation/table_screen.dart';
import 'package:madang/presentation/screens/profile/profile_screen.dart';
import 'package:madang/presentation/screens/search/search_screen.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: .fadeIn,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
      transition: .leftToRight,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: SignupBinding(),
      transition: .rightToLeft,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: .rightToLeft,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: .noTransition,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => SearchScreen(onNavigationTap: _onBottomNavigationTap),
      transition: .noTransition,
    ),
    GetPage(
      name: AppRoutes.recent,
      page: () => RecentScreen(onNavigationTap: _onBottomNavigationTap),
      transition: .noTransition,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(onNavigationTap: _onBottomNavigationTap),
      transition: .noTransition,
    ),
    GetPage(
      name: AppRoutes.table,
      page: () => const TableScreen(),
      binding: TableBinding(),
      transition: .rightToLeft,
    ),
  ];
}

void _onBottomNavigationTap(int index) {
  switch (index) {
    case 0:
      Get.offAllNamed(AppRoutes.home);
      break;
    case 1:
      Get.offAllNamed(AppRoutes.search);
      break;
    case 2:
      Get.offAllNamed(AppRoutes.recent);
      break;
    case 3:
      Get.offAllNamed(AppRoutes.profile);
      break;
  }
}
