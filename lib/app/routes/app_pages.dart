import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/features/auth/presentation/controller/login_binding.dart';
import 'package:madang/features/auth/presentation/controller/signup_binding.dart';
import 'package:madang/features/auth/presentation/login_screen.dart';
import 'package:madang/features/auth/presentation/signup_screen.dart';
import 'package:madang/features/cart/data/bindings/cart_binding.dart';
import 'package:madang/features/cart/presentation/cart_screen.dart';
import 'package:madang/features/food/data/bindings/food_binding.dart';
import 'package:madang/features/food/presentation/food_screen.dart';
import 'package:madang/features/main/data/bindings/main_binding.dart';
import 'package:madang/features/main/presentation/main_shell_screen.dart';
import 'package:madang/features/onboarding/controller/onboarding_binding.dart';
import 'package:madang/features/onboarding/presentation/onboarding_screen.dart';
import 'package:madang/features/splash/controller/splash_binding.dart';
import 'package:madang/features/splash/presentation/splash_screen.dart';
import 'package:madang/features/table/data/bindings/table_binding.dart';
import 'package:madang/features/table/presentation/table_screen.dart';

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
      page: () => const MainShellScreen(),
      binding: MainBinding(),
      transition: .noTransition,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const MainShellScreen(),
      binding: MainBinding(),
      transition: .noTransition,
    ),
    GetPage(
      name: AppRoutes.recent,
      page: () => const MainShellScreen(),
      binding: MainBinding(),
      transition: .noTransition,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const MainShellScreen(),
      binding: MainBinding(),
      transition: .noTransition,
    ),
    GetPage(
      name: AppRoutes.table,
      page: () => const TableScreen(),
      binding: TableBinding(),
      transition: .rightToLeft,
    ),
    GetPage(
      name: AppRoutes.food,
      page: () => const FoodScreen(),
      binding: FoodBinding(),
      transition: .rightToLeft,
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartScreen(),
      binding: CartBinding(),
      transition: .rightToLeft,
    ),
  ];
}
