import 'package:flutter/material.dart';
import 'package:madang/presentation/screens/home/widgets/navigation/bottom_navigation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.onNavigationTap});

  final ValueChanged<int> onNavigationTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 411,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            'Profile',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              ClipOval(
                                child: Image.network(
                                  'https://www.figma.com/api/mcp/asset/e13a86ed-fbd7-4f66-8704-e5d8a5a4ef1b/82dc0.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    width: 80,
                                    height: 80,
                                    color: const Color(0xFFDDECF1),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.person,
                                      size: 42,
                                      color: Color(0xFF6BA6B8),
                                    ),
                                  ),
                                ),
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
                          const ProfileMenuItem(
                            icon: Icons.shopping_cart_outlined,
                            label: 'My Cart',
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
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFE53935),
                                side: const BorderSide(
                                  color: Color(0xFFE53935),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                BottomNavigation(selectedIndex: 3, onTap: onNavigationTap),
              ],
            ),
          ),
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

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: Row(
            children: [
              Icon(icon, size: 24, color: const Color(0xFF6D6D6D)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, size: 20, color: Colors.black54),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          indent: 40,
          color: Color(0xFFE6E6E6),
        ),
      ],
    );
  }
}
