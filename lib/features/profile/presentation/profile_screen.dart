import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/app_snackbar.dart';
import 'package:madang/core/widgets/custom_button.dart';
import 'package:madang/core/widgets/custom_top_navigation.dart';
import 'package:madang/features/profile/data/controllers/profile_controller.dart';
import 'package:madang/features/profile/presentation/widgets/profile_edit_sheet.dart';
import 'package:madang/features/profile/presentation/widgets/profile_menu_item.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  void _comingSoon(BuildContext context, String label) {
    AppSnackBar.show(context, message: '$label is coming soon');
  }

  Future<void> _editProfile(BuildContext context) async {
    final saved = await ProfileEditSheet.show(context, controller: controller);
    if (saved == true && context.mounted) {
      AppSnackBar.success(context, 'Profile updated');
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) await controller.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopNavigation(
        title: 'Profile',
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
                      _buildHeader(context),
                      const SizedBox(height: 40),
                      const _SectionTitle('Account'),
                      const SizedBox(height: 16),
                      ProfileMenuItem(
                        icon: Icons.credit_card,
                        label: 'Payment Method',
                        onTap: () => _comingSoon(context, 'Payment Method'),
                      ),
                      ProfileMenuItem(
                        icon: Icons.shopping_cart_outlined,
                        label: 'My Cart',
                        onTap: () => Get.toNamed(AppRoutes.cart),
                      ),
                      ProfileMenuItem(
                        icon: Icons.help_outline,
                        label: 'Help & Report',
                        onTap: () => _comingSoon(context, 'Help & Report'),
                      ),
                      ProfileMenuItem(
                        icon: Icons.translate,
                        label: 'Language',
                        onTap: () => _comingSoon(context, 'Language'),
                      ),
                      ProfileMenuItem(
                        icon: Icons.notifications_none,
                        label: 'Notification',
                        onTap: () => _comingSoon(context, 'Notification'),
                      ),
                      const SizedBox(height: 24),
                      const _SectionTitle('More Info'),
                      const SizedBox(height: 16),
                      ProfileMenuItem(
                        icon: Icons.shield_outlined,
                        label: 'Privacy Policy',
                        onTap: () => _comingSoon(context, 'Privacy Policy'),
                      ),
                      ProfileMenuItem(
                        icon: Icons.newspaper_outlined,
                        label: 'News & Services',
                        onTap: () => _comingSoon(context, 'News & Services'),
                      ),
                      ProfileMenuItem(
                        icon: Icons.star_outline,
                        label: 'Give Rating',
                        onTap: () => _comingSoon(context, 'Give Rating'),
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        label: 'Logout',
                        onPressed: () => _confirmLogout(context),
                        variant: CustomButtonVariant.outlined,
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

  /// Avatar, name, email and the Edit button.
  Widget _buildHeader(BuildContext context) {
    return Obx(() {
      final name = controller.displayName;
      final email = controller.email;
      final photo = controller.photoUrl;
      final initial = controller.initial;

      return Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 40,
            foregroundImage: photo.isEmpty
                ? null
                : CachedNetworkImageProvider(photo),
            child: initial.isEmpty
                ? const Icon(Icons.person, color: AppColors.white)
                : Text(
                    initial,
                    style: AppTextStyles.title1.copyWith(
                      fontSize: 28,
                      color: AppColors.white,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'Your name' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subtitle1,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _editProfile(context),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 16, color: Colors.black54),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Text(title, style: AppTextStyles.body2);
}
