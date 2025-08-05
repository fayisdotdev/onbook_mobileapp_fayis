import 'package:flutter/material.dart';
import 'package:onbook_app/general/themes/app_colors.dart';
import 'package:onbook_app/general/themes/app_icons.dart';

class OnBookBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const OnBookBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.scaffoldBg,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          tooltip: "Home",
          activeIcon: ImageIcon(
            AssetImage(AppIcons.homeFilled),
            color: AppColors.primaryColor,
            size: 26,
          ),
          icon: ImageIcon(
            AssetImage(AppIcons.home),
            color: AppColors.grey,
            size: 24,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          tooltip: "Bookings",
          activeIcon: ImageIcon(
            AssetImage(AppIcons.bookingsFilled),
            color: AppColors.primaryColor,
            size: 26,
          ),
          icon: ImageIcon(
            AssetImage(AppIcons.bookings),
            color: AppColors.grey,
            size: 24,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          tooltip: "Vehicles",
          activeIcon: ImageIcon(
            AssetImage(AppIcons.vehiclesFilled),
            color: AppColors.primaryColor,
            size: 26,
          ),
          icon: ImageIcon(
            AssetImage(AppIcons.vehicles),
            color: AppColors.grey,
            size: 24,
          ),
          label: '',
        ),
        //chats
        // BottomNavigationBarItem(
        //   tooltip: "Chat",
        //   activeIcon: ImageIcon(
        //     AssetImage(AppIcons.chatIcon),
        //     color: AppColors.primaryColor,
        //     size: 26,
        //   ),
        //   icon: ImageIcon(
        //     AssetImage(AppIcons.chatIcon),
        //     color: AppColors.grey,
        //     size: 24,
        //   ),
        //   label: '',
        // ),
        //offers
        BottomNavigationBarItem(
          tooltip: "Offers",
          activeIcon: ImageIcon(
            AssetImage(AppIcons.offersFilled),
            color: AppColors.primaryColor,
            size: 26,
          ),
          icon: ImageIcon(
            AssetImage(AppIcons.offers),
            color: AppColors.grey,
            size: 24,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          tooltip: "Notifications",
          activeIcon: ImageIcon(
            AssetImage(AppIcons.notificationFilled),
            color: AppColors.primaryColor,
            size: 26,
          ),
          icon: ImageIcon(
            AssetImage(AppIcons.notification),
            color: AppColors.grey,
            size: 24,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          tooltip: "Profile",
          activeIcon: ImageIcon(
            AssetImage(AppIcons.profileFilled),
            color: AppColors.primaryColor,
            size: 26,
          ),
          icon: ImageIcon(
            AssetImage(AppIcons.profile),
            color: AppColors.grey,
            size: 24,
          ),
          label: '',
        ),
      ],
    );
  }
}