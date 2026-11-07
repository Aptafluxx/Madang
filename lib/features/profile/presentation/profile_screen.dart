import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/core/widgets/custom_button.dart';
import 'package:madang/core/widgets/custom_top_navigation.dart';
import 'package:madang/features/profile/presentation/widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopNavigation(
        title: "Profile",
        showBackButton: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primary,
                            radius: 40,
                            child: Icon(Icons.person, color: AppColors.white),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Michael Antonio',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'mich@gmail.com',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 16,
                                color: Colors.black54,
                              ),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      const _SectionTitle('Account'),
                      const SizedBox(height: 16),
                      const ProfileMenuItem(
                        icon: Icons.credit_card,
                        label: 'Payment Method',
                      ),
                      ProfileMenuItem(
                        icon: Icons.shopping_cart_outlined,
                        label: 'My Cart',
                        onTap: () {
                          Get.offNamed(AppRoutes.cart);
                        },
                      ),
                      const ProfileMenuItem(
                        icon: Icons.help_outline,
                        label: 'Help & Report',
                      ),
                      const ProfileMenuItem(
                        icon: Icons.translate,
                        label: 'Language',
                      ),
                      const ProfileMenuItem(
                        icon: Icons.notifications_none,
                        label: 'Notification',
                      ),
                      const SizedBox(height: 24),
                      const _SectionTitle('More Info'),
                      const SizedBox(height: 16),
                      const ProfileMenuItem(
                        icon: Icons.shield_outlined,
                        label: 'Privacy Policy',
                      ),
                      const ProfileMenuItem(
                        icon: Icons.newspaper_outlined,
                        label: 'News & Services',
                      ),
                      const ProfileMenuItem(
                        icon: Icons.star_outline,
                        label: 'Give Rating',
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        label: "Logout",
                        onPressed: () {},
                        variant: .outlined,
                        foregroundColor: AppColors.error,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  );
}
