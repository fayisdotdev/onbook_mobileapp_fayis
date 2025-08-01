import 'package:flutter/material.dart';
import 'package:onbook_app/features/bookings/bookings_page.dart';
// import 'package:onbook_app/features/chats/chats_page.dart';
import 'package:onbook_app/features/home/home_screen.dart';
import 'package:onbook_app/features/notifications/notifications_page.dart';
import 'package:onbook_app/features/offers/offers_page.dart';
import 'package:onbook_app/features/profile/profiles_page.dart';
// import 'package:onbook_app/features/settings/settings_page.dart';
import 'package:onbook_app/features/vehicles/vehicles_page.dart';
import 'package:onbook_app/general/widgets/onbook_bottom_navbar.dart';

class AppRoot extends StatefulWidget {
  final int initialTabIndex;

  const AppRoot({super.key, this.initialTabIndex = 0}); // default to Home

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialTabIndex;
  }

  final List<Widget> _pages = const [
    HomeScreen(),
    BookingsScreen(),
    // ChatScreen(),
    // SettingsScreen(),
    VehiclesScreen(),

    // ChatScreen(),
    OffersScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'My Bookings',
    'My Vehicles',
    // 'Chats',
    'Offers',
    'Notifications',
    'Profile',
  ];

  // List<Widget>? _getAppBarActions(int index, BuildContext context) {
  //   switch (index) {
  //     case 0:
  //       return HomeScreen.appBarActions(context);
  //     // Add more cases for other pages if needed
  //     default:
  //       return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[currentIndex]),
        // actions: _getAppBarActions(currentIndex, context),
      ),
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
