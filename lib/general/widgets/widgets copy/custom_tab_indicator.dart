// import 'package:flutter/material.dart';
// import 'package:on_book_shop_crm/general/utils/app_colors.dart';

// class CustomTabIndicator extends StatelessWidget {
//   final int fieldWidth;
//   final List<String> totalTabs;
//   final int currentTab;
//   final Function(int) onTap;

//   const CustomTabIndicator(
//       {super.key,
//       required this.totalTabs,
//       required this.currentTab,
//       required this.fieldWidth,
//       required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         ...List.generate(
//             totalTabs.length,
//             (index) => CustomTabIndicatorItem(
//                 currentTab: currentTab,
//                 fieldWidth: fieldWidth,
//                 index: index,
//                 totalTabs: totalTabs,
//                 onTap: onTap)),
//       ],
//     );
//   }
// }

// class CustomTabIndicatorItem extends StatelessWidget {
//   final int index;
//   final int currentTab;
//   final List<String> totalTabs;
//   final int fieldWidth;
//   final Function(int) onTap;
//   const CustomTabIndicatorItem(
//       {super.key,
//       required this.index,
//       required this.currentTab,
//       required this.totalTabs,
//       required this.fieldWidth,
//       required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => onTap(index),
//       child: Column(
//         children: [
//           AnimatedDefaultTextStyle(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//             style: TextStyle(
//               fontSize: 14,
//               color:
//                   index == currentTab ? AppColors.buttonBlue : AppColors.grey,
//               fontWeight:
//                   index == currentTab ? FontWeight.w700 : FontWeight.w400,
//             ),
//             child: Text(totalTabs[index]),
//           ),
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//             width: fieldWidth / totalTabs.length,
//             height: 2,
//             color: index == currentTab ? AppColors.buttonBlue : AppColors.grey,
//             margin: const EdgeInsets.symmetric(horizontal: 2),
//           ),
//         ],
//       ),
//     );
//   }
// }
