import 'package:flutter/material.dart';
import 'package:onbook_app/general/providers/booking_provider.dart';
import 'package:onbook_app/general/providers/message_provider.dart';
import 'package:onbook_app/general/providers/shop_provider.dart';
import 'package:onbook_app/general/providers/vehicles_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'general/providers/auth_provider.dart';
import 'features/splash_screen/splash_screen.dart';
import 'general/themes/app_colors.dart';

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ShopPublicProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OnBook App',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.scaffoldBg,
          primaryColor: AppColors.primaryColor,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.red,
            accentColor: AppColors.lightGrey,
            backgroundColor: AppColors.scaffoldBg,
          ).copyWith(secondary: AppColors.lightGrey),
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.white,
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.lightGrey,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            labelStyle: GoogleFonts.poppins(),
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
