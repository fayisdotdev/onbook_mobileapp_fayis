// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:on_book_shop_crm/general/utils/app_colors.dart';

// Column buildDropDown(
//     {required double? fieldWidth,
//     required String heading,
//     required bool isRequired,
//     double? gap,
//     bool isHeadingVisible = true,
//     required void Function(String?)? onChanged,
//     String? Function(String?)? validator,
//     required String? value,
//     required List<DropdownMenuItem<String>>? items}) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       if (isHeadingVisible == true)
//         RichText(
//             text: TextSpan(children: [
//           TextSpan(
//               text: heading,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//               )),
//           TextSpan(
//               text: isRequired ? '*' : '*',
//               style: TextStyle(
//                 color: isRequired ? Colors.red : Colors.transparent,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w400,
//               ))
//         ])),
//       Gap(gap ?? 5),
//       SizedBox(
//           width: fieldWidth,
//           // height: 40,
//           child: DropdownButtonFormField(
//             value: value,
//             items: items,
//             onChanged: onChanged,
//             validator: validator,
//             dropdownColor: AppColors.white,
//             style: const TextStyle(fontSize: 14),
//             decoration: InputDecoration(
//               isDense: true,
//               contentPadding: const EdgeInsets.all(13),
//               filled: true,
//               fillColor: AppColors.offWhite.withOpacity(0.8),
//               border: OutlineInputBorder(
//                   borderSide:
//                       BorderSide(color: AppColors.grey.withOpacity(0.4)),
//                   borderRadius: BorderRadius.circular(6)),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: AppColors.grey.withOpacity(0.4)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: AppColors.grey.withOpacity(0.4)),
//               ),
//             ),
//           )),
//     ],
//   );
// }
