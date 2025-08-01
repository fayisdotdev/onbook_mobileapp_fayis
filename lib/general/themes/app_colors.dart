import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static Color primaryColor = const Color(0xFFAB0000);
  static Color appbarbg = const Color(0xff610000);

  static Color sideMenu = const Color(0xFF191F2F);
  static Color textfeildgrey = const Color(0xFFE7E7E7);
  static Color bggrey = const Color(0xFFF2F2F2);
  static const Color secondary = Color(0xFFBB0000); // Online, Credit & Wallet
  static const Color bttnRed = Color(0xFFAB0000); // Online, Credit & Wallet
  static Color scaffoldBg = Colors.white;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color greyColor = Colors.grey;
  static Color lightGreyColor = const Color(0xFFEBEBEE);
  static Color orang = const Color(0xFFFF8E29);
  static Color buttonGreen = const Color(0xFF17E3D2);
  static Color lightBlue = const Color(0xFFEEF4FF);

  static Color greenColor = Colors.green;
  static Color lightgreenColor = const Color(0xff99C3BF);
  static Color lightGrey = const Color(0xFFF5F5F5);
  static Color grey = const Color.fromARGB(255, 63, 63, 63);

  static Color buttonRed = const Color(0xffFF5454);
  static Color buttonOrange = const Color(0xffFFA500);
  static Color amountFrameBlue = const Color(0xff84BCFF);
  static Color amountFramePurple = const Color(0xffD0BCFF);
  static Color amountFrameCream = const Color(0xffFFBCBC);
  static Color amountFrameLightBlue = const Color(0xffBCCFFF);
  static Color lightpinknew = const Color(0xffFAE9EA);

  static const Color yellow = Color(0xFFFFD700); // Online & Credit
  static const Color orange = Color(0xFFFFA500); // COD & Credit
  static const Color red = Color(0xFFFF4500); // Credit only
  static const Color blue = Color(0xFF1183ED); // COD only
  static const Color purple = Color(0xFF800080); // Online, Credit & Wallet
  static const Color brown = Color(0xFF8B4513); // COD, Credit & Wallet
  static const Color pink = Color(0xFFFFC0CB); // Wallet & Credit
  static const Color cyan = Color(0xFF00FFFF); // Online & Wallet
  static const Color teal = Color(0xFF008080); // COD & Wallet
  static const Color magenta = Color(0xFFFF00FF);
  static const Color lightGreen = Color(0xFFAFFF89);
  static const Color lightpink = Color(0xFFE9D8E3);

  // Poppins font styles
  static TextStyle poppinsBold({double fontSize = 18, Color? color}) =>
      GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        color: color,
      );

  static TextStyle poppinsMedium({double fontSize = 16, Color? color}) =>
      GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: fontSize,
        color: color,
      );

  static TextStyle poppinsRegular({double fontSize = 14, Color? color}) =>
      GoogleFonts.poppins(
        fontWeight: FontWeight.normal,
        fontSize: fontSize,
        color: color,
      );
}
