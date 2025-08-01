// import 'package:buttons_tabbar/buttons_tabbar.dart';
// import 'package:flutter/material.dart';
// import 'package:on_book_shop_crm/general/utils/app_colors.dart';

// class CustomButtonTabBar extends StatelessWidget {
//   const CustomButtonTabBar({
//     super.key,
//     required this.tabs,
//     this.onTap,
//     this.height,
//     this.bgcolor,
//     this.unselectedBackgroundColor,
//     this.contentPadding,
//     this.buttonMargin,
//     this.labelTextStyle,
//     this.controller,
//   });
//   final List<Widget> tabs;
//   final void Function(int)? onTap;
//   final double? height;
//   final Color? bgcolor;
//   final Color? unselectedBackgroundColor;
//   final EdgeInsets? contentPadding;
//   final EdgeInsets? buttonMargin;
//   final TextStyle? labelTextStyle;
//   final TabController? controller;

//   @override
//   Widget build(BuildContext context) {
//     return ButtonsTabBar(
//       controller: controller,
//       // physics: const NeverScrollableScrollPhysics(),
//       unselectedLabelStyle: TextStyle(
//           color: AppColors.black,
//           // fontFamily: AppFonts.inter,
//           fontWeight: FontWeight.w400),
//       labelStyle: labelTextStyle ??
//           TextStyle(
//             color: AppColors.primaryColor,
//             // fontFamily: AppFonts.inter,
//             fontWeight: FontWeight.w500,
//           ),
//       backgroundColor: bgcolor ?? AppColors.buttonTabbarPinkColor,
//       splashColor: AppColors.grey.withValues(alpha: 0.1),
//       unselectedBackgroundColor:
//           unselectedBackgroundColor ?? Colors.transparent,
//       unselectedBorderColor: Colors.transparent,
//       borderColor: Colors.transparent,
//       contentCenter: true,
//       borderWidth: 1,
//       contentPadding: contentPadding ?? EdgeInsets.zero,
//       radius: 6,
//       duration: 50,
//       height: height ?? 50,
//       // width: 200,
//       buttonMargin: buttonMargin ?? const EdgeInsets.symmetric(horizontal: 8),
//       onTap: onTap,
//       tabs: tabs,
//     );
//   }
// }
