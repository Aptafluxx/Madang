import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/features/onboarding/controller/onboarding_binding.dart';
import 'package:madang/features/onboarding/presentation/onboarding_screen.dart';
import 'package:madang/features/splash/controller/splash_binding.dart';
import 'package:madang/features/splash/presentation/splash_screen.dart';

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
  ];
}
