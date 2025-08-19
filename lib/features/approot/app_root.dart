import 'package:flutter/material.dart';
import 'package:onbook_app/features/bookings/bookings_preview_page.dart';
import 'package:onbook_app/features/chats/chat_shoplist_page.dart';
import 'package:onbook_app/features/home/home_screen.dart';
import 'package:onbook_app/features/notifications/notifications_page.dart';
import 'package:onbook_app/features/offers/offers_page.dart';
import 'package:onbook_app/features/profile/profiles_page.dart';
// import 'package:onbook_app/features/settings/settings_page.dart';
import 'package:onbook_app/features/vehicles/vehicles_page.dart';
import 'package:onbook_app/general/providers/vehicles_provider.dart';
import 'package:onbook_app/general/widgets/onbook_bottom_navbar.dart';
import 'package:provider/provider.dart';

class AppRoot extends StatefulWidget {
  final int initialTabIndex;
  final String? shopName;
  final String? shopCity;

  const AppRoot({
    super.key,
    this.initialTabIndex = 0,
    this.shopName,
    this.shopCity,
  }); // default to Home

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late int currentIndex;
  late List<Widget> _pages;

  PreferredSizeWidget? _buildAppBarForIndex(int index) {
  // If the page manages its own app bar, return null
  if (index == 3) return null; // Chat tab (index 3) — no default app bar

  return AppBar(
    title: Text(_titles[index]),
  );
}


  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialTabIndex;

    _pages = [
      const HomeScreen(),
      const BookingsPreviewScreen(),
      ChangeNotifierProvider(
        create: (_) => VehicleProvider(),
        child: const VehiclesScreen(),
      ),
      ChatShopListScreen(
        // shopName: widget.shopName ?? 'Chat',
        // shopCity: widget.shopCity ?? '',
      ),
      const OffersScreen(),
      const NotificationsScreen(),
      const ProfileScreen(),
    ];
  }

  final List<String> _titles = [
    'Dashboard',
    'My Bookings',
    'My Vehicles',
    'Chats',
    'Offers',
    'Notifications',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: _buildAppBarForIndex(currentIndex),
      body: _pages[currentIndex],
      bottomNavigationBar: OnBookBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}