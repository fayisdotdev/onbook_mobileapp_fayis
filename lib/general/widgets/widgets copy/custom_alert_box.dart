// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:on_book_shop_crm/general/utils/app_colors.dart';
// import 'package:on_book_shop_crm/general/widgets/custom_button.dart';
// import 'package:on_book_shop_crm/general/widgets/custom_textfield.dart';

// class CAlertBox {
//   static Future<void> showCommonDialog({
//     required BuildContext context,
//     required void Function() confirmButton,
//     void Function()? cancelButton,
//     required String content,
//     required String title,
//     String? confirmButtonText,
//     String? cancelButtonText,
//   }) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           alignment: Alignment.topCenter,
//           backgroundColor: AppColors.scaffoldBg,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//           title: Text(
//             title,
//             style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//           ),
//           content: Text(content,
//               overflow: TextOverflow.visible,
//               style:
//                   const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
//           actions: [
//             CustomButton(
//               onPressed: cancelButton != null
//                   ? () {
//                       cancelButton.call();
//                     }
//                   : () {
//                       Navigator.pop(context);
//                     },
//               buttonColor: AppColors.offWhite,
//               buttonWidget: Text(
//                 cancelButtonText ?? 'Cancel',
//                 style: TextStyle(
//                   color: AppColors.black,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             CustomButton(
//               onPressed: () {
//                 confirmButton.call();
//               },
//               buttonColor: AppColors.buttonBlue,
//               buttonWidget: Text(
//                 confirmButtonText ?? 'Confirm',
//                 style: TextStyle(
//                   color: AppColors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   static Future<void> showDeleteDialog({
//     required BuildContext context,
//     required void Function() confirmButton,
//     void Function()? cancelButton,
//     required String content,
//     required String title,
//     String? confirmButtonText,
//     String? cancelButtonText,
//     required TextEditingController reasonController,
//   }) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: AppColors.scaffoldBg,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 title,
//                 style:
//                     const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//               ),
//             ],
//           ),
//           content: SizedBox(
//             width: 350,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(content,
//                     overflow: TextOverflow.visible,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.w500, fontSize: 14)),
//                 const Gap(10),
//                 SizedBox(
//                   height: 40,
//                   child: CustomTextField(
//                     textAlign: TextAlign.center,
//                     hintText: 'Add a reason (optional)',
//                     controller: reasonController,
//                     borderSide:
//                         BorderSide(color: AppColors.grey.withOpacity(0.4)),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           actions: [
//             CustomButton(
//               onPressed: cancelButton != null
//                   ? () {
//                       cancelButton.call();
//                     }
//                   : () {
//                       Navigator.pop(context);
//                     },
//               buttonColor: AppColors.offWhite,
//               buttonWidget: Text(
//                 cancelButtonText ?? 'Cancel',
//                 style: TextStyle(
//                   color: AppColors.black,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             CustomButton(
//               onPressed: () {
//                 GoRouter.of(context).pop();
//                 confirmButton.call();
//               },
//               buttonColor: AppColors.buttonBlue,
//               buttonWidget: Text(
//                 confirmButtonText ?? 'Confirm',
//                 style: TextStyle(
//                   color: AppColors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
