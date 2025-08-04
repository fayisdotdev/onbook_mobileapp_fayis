import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:onbook_app/features/approot/app_root.dart';
import 'package:onbook_app/features/chatbot/chatbot.dart';
import 'package:onbook_app/features/coming_soon/coming_soon.dart';
import 'package:onbook_app/general/themes/app_colors.dart';
import 'package:onbook_app/general/themes/app_icons.dart';
import 'package:onbook_app/features/profile/presentation/view/widget/profile_info_frame.dart';
import 'package:onbook_app/features/profile/presentation/view/widget/profile_invoice_frame.dart';
import 'package:provider/provider.dart';
import 'package:onbook_app/general/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Offset buttonPosition = const Offset(300, 600); // Initial button position
  


  void _navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context).userData;
    final name = userData?['name'] ?? 'Unknown User';
    final phone = userData?['phone'] ?? 'No Number';

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.scaffoldBg,
                title: const Center(
                  child: Text(
                    'Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  AppIcons.profileIcon,
                                  scale: 8,
                                ),
                              ),
                              const Gap(20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    phone,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(20),
                      const ProfileInvoiceFrame(
                        title: 'Invoice',
                        subtitle: '( 2 Unpaid Invoices )',
                        showSubtitle: true,
                      ),
                      const Gap(20),
                      _buildInfoSection(context),
                      const Gap(20),
                      _buildOtherInfoSection(context),
                      const Gap(20),
                      _buildSettingsSection(context),
                      const Gap(20),
                      _buildLogoutButton(context),
                      const Gap(100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Draggable Chat Bubble
          Positioned(
            left: buttonPosition.dx,
            top: buttonPosition.dy,
            child: Draggable(
              feedback: _buildChatButton(),
              childWhenDragging: Container(),
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  buttonPosition = offset;
                });
              },
              child: _buildChatButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatButton() {
    return GestureDetector(
      // onTap: () {
      //   // TODO: implement chat logic
      //   print("Chat button tapped");
      // },
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const ChatPopupDialog(),
        );
        print("Chat button tapped");
      },

      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: Image.asset(AppIcons.bubbleicon, scale: 4.5)),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.bggrey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 18.0, top: 18),
            child: Text(
              ' YOUR INFORMATION',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          ProfileInfoFrame(
            onTap: () => _navigate(
              context,
              const ComingSoonPage(title: 'Profile', message: 'Coming Soon!.'),
            ),
            iconPath: AppIcons.profileuser,
            title: 'Profile',
            showSubtitle: false,
          ),
          ProfileInfoFrame(
            onTap: () => _navigate(
              context,
              const ComingSoonPage(
                title: 'Add New Vehicle',
                message: 'This would navigate to the Vehicles tab.',
              ),
            ),
            iconPath: AppIcons.newVehicle,
            title: 'Add New Vehicle',
            showSubtitle: false,
          ),
        ],
      ),
    );
  }

  Widget _buildOtherInfoSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.bggrey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 18.0, top: 18),
            child: Text(
              ' OTHER INFORMATION',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          ProfileInfoFrame(
            onTap: () => _navigate(
              context,
              const ComingSoonPage(
                title: 'Customer Support',
                message: 'Coming Soon!.',
              ),
            ),
            iconPath: AppIcons.customerService,
            title: 'Customer Support',
            showSubtitle: false,
          ),
          ProfileInfoFrame(
            onTap: () {
              // TODO: Add share logic
            },
            iconPath: AppIcons.shareIcon,
            title: 'Share App',
            showSubtitle: false,
          ),
          ProfileInfoFrame(
            onTap: () {
              // TODO: Add rating logic
            },
            iconPath: AppIcons.rateappIcon,
            title: 'Rate This App',
            showSubtitle: false,
          ),
          ProfileInfoFrame(
            onTap: () => _navigate(
              context,
              const ComingSoonPage(title: 'F A Q', message: 'Coming Soon!.'),
            ),
            iconPath: AppIcons.faqIcon,
            title: 'FAQ',
            showSubtitle: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.bggrey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 18.0, top: 18),
            child: Text(
              ' APP SETTINGS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          ProfileInfoFrame(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const AppRoot(initialTabIndex: 0),
                ),
                (route) => false,
              );
            },
            iconPath: AppIcons.settingsFilled,
            title: 'Settings',
            showSubtitle: false,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        final confirm = await showModalBottomSheet<bool>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          isScrollControlled: true,
          builder: (ctx) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Wrap(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Image.asset(AppIcons.logoutIcon, scale: 4),
                    const SizedBox(width: 12),
                    Text(
                      'Logout',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to logout?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurface,
                        ),
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Logout'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );

        if (confirm == true) {
          final authProvider = Provider.of<AuthProvider>(
            context,
            listen: false,
          );
          await authProvider.signOut();
        }
      },

      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: .8, color: AppColors.secondary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppIcons.logoutIcon, scale: 4),
            const Gap(10),
            Text(
              'Log Out',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
