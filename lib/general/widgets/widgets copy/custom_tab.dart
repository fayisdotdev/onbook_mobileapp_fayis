// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:on_book_shop_crm/general/utils/app_colors.dart';

// class CustomTab extends StatelessWidget {
//   final String text;
//   final bool isSelected;
//   const CustomTab({super.key, required this.text, required this.isSelected});

//   @override
//   Widget build(BuildContext context) {
//     return Tab(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Gap(10),
//           Text(
//             text,
//             style: TextStyle(
//                 color: AppColors.primaryColor, fontWeight: FontWeight.w500),
//           ),
//           isSelected
//               ? Container(
//                   width: 150,
//                   height: 10,
//                   color: AppColors.primaryColor,
//                 )
//               : const Gap(10),
//         ],
//       ),
//     );
//   }
// }
