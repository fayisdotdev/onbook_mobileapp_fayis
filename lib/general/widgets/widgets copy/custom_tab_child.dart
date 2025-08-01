// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:on_book_shop_crm/general/utils/app_colors.dart';
// import 'package:on_book_shop_crm/general/utils/app_fonts.dart';

// class CustomRedTabChild extends StatelessWidget {
//   final String text;
//   final bool isSelected;
//   const CustomRedTabChild(
//       {super.key, required this.text, required this.isSelected});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Gap(10),
//         Text(
//           text,
//           style: TextStyle(
//               color: isSelected ? AppColors.primaryColor : AppColors.black,
//               fontWeight: FontWeight.w500),
//         ),
//         Container(
//           decoration: BoxDecoration(
//               color: isSelected ? AppColors.primaryColor : Colors.transparent,
//               borderRadius: const BorderRadius.all(Radius.circular(15))),
//           width: text.length.toDouble() * 10,
//           height: 8,
//         )
//       ],
//     );
//   }
// }

// class CustomBlueTabChild extends StatelessWidget {
//   final String text;
//   final int? count;
//   final bool isSelected;
//   final bool? isCurveOnTop;
//   const CustomBlueTabChild(
//       {super.key,
//       required this.text,
//       required this.isSelected,
//       this.count,
//       this.isCurveOnTop});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Gap(12),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               text,
//               style: TextStyle(
//                   fontFamily: AppFonts.istokWeb,
//                   fontSize: 16,
//                   color: isSelected
//                       ? AppColors.buttonBlue
//                       : AppColors.black.withOpacity(0.7),
//                   fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400),
//             ),
//             count != null && count != 0
//                 ? Padding(
//                     padding: const EdgeInsets.only(left: 4.0),
//                     child: Container(
//                       height: 22,
//                       width: 22,
//                       decoration: BoxDecoration(
//                           color: isSelected
//                               ? AppColors.buttonBlue
//                               : AppColors.black.withOpacity(0.3),
//                           shape: BoxShape.circle),
//                       child: Center(
//                         child: Text(
//                           count!.toString(),
//                           style: TextStyle(
//                             fontFamily: AppFonts.istokWeb,
//                             fontSize: 12,
//                             color: AppColors.white,
//                             fontWeight:
//                                 isSelected ? FontWeight.w700 : FontWeight.w400,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 : const SizedBox.shrink(),
//           ],
//         ),
//         const Gap(2),
//         Container(
//           decoration: BoxDecoration(
//             color: isSelected ? AppColors.buttonBlue : Colors.transparent,
//             borderRadius: isCurveOnTop == true
//                 ? const BorderRadius.vertical(
//                     top: Radius.circular(25),
//                   )
//                 : const BorderRadius.vertical(
//                     bottom: Radius.circular(25),
//                   ),
//           ),
//           width: count != null && count != 0
//               ? text.length.toDouble() * 10 + 24
//               : text.length.toDouble() * 10,
//           height: 3,
//         )
//       ],
//     );
//   }
// }

// class CustomColorTabChild extends StatelessWidget {
//   final String text;
//   final int? count;
//   final bool isSelected;
//   final Color color;
//   final Color bgcolor;
//   const CustomColorTabChild(
//       {super.key,
//       required this.text,
//       required this.isSelected,
//       this.count,
//       required this.color,
//       required this.bgcolor});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 8,
//       ),
//       decoration: BoxDecoration(
//         color: isSelected ? bgcolor : Colors.transparent,
//         borderRadius: BorderRadius.circular(
//           6,
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             text,
//             style: TextStyle(
//                 fontFamily: AppFonts.istokWeb,
//                 fontSize: 16,
//                 color: AppColors.black,
//                 fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400),
//           ),
//           count != null
//               ? Padding(
//                   padding: const EdgeInsets.only(left: 4.0),
//                   child: Container(
//                     height: 22,
//                     width: 22,
//                     decoration: BoxDecoration(
//                         color: isSelected
//                             ? color
//                             : AppColors.black.withOpacity(0.3),
//                         shape: BoxShape.circle),
//                     child: Center(
//                       child: Text(
//                         count!.toString(),
//                         style: TextStyle(
//                           fontFamily: AppFonts.istokWeb,
//                           fontSize: 12,
//                           color: AppColors.black,
//                           fontWeight:
//                               isSelected ? FontWeight.w700 : FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ],
//       ),
//     );
//   }
// }
