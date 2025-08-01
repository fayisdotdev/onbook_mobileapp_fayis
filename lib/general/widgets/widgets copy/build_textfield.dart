// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gap/gap.dart';
// import 'package:languagetool_textfield/languagetool_textfield.dart';
// import 'package:on_book_shop_crm/general/utils/app_colors.dart';
// import 'package:on_book_shop_crm/general/widgets/custom_language_tool.dart';
// import 'package:on_book_shop_crm/general/widgets/custom_textfield.dart';

// Column buildTextField(
//     {required double? fieldWidth,
//     bool? isHeadingRequired = true,
//     bool isHeadingVisible = true,
//     int? maxLines,
//     double? height,
//     double? gap,
//     required String heading,
//     required bool isRequired,
//     TextInputType? textInputType,
//     List<TextInputFormatter>? inputFormatters,
//     String? Function(String?)? validator,
//     void Function(String)? onChanged,
//     void Function(String)? onSubmitted,
//     FocusNode? focusNode,
//     Widget? suffix,
//     Widget? prefix,
//     bool? readOnly,
//     AutovalidateMode? autoValidateMode,
//     void Function()? onTap,
//     bool? expands,
//     double? contentPadding,
//     required TextEditingController controller,
//     String? hintText,
//     TextStyle? hintStyle}) {
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
//               text: isRequired ? ' *' : '*',
//               style: TextStyle(
//                 color: isRequired ? Colors.red : Colors.transparent,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w400,
//               ))
//         ])),
//       if (isHeadingRequired == true) Gap(gap ?? 5) else Gap(gap ?? 5),
//       SizedBox(
//         width: fieldWidth,
//         height: height,
//         child: CustomTextField(
//           onSubmitted: onSubmitted,
//           focusNode: focusNode,
//           autovalidateMode: autoValidateMode ?? AutovalidateMode.disabled,
//           inputFormatters: inputFormatters,
//           contentPadding: 14,
//           isDense: true,
//           hintText: hintText,
//           hintStyle: hintStyle,
//           maxLines: maxLines,
//           keyboardType: textInputType ?? TextInputType.text,
//           controller: controller,
//           fillColor: AppColors.offWhite.withOpacity(0.8),
//           borderSide: BorderSide(color: AppColors.grey.withOpacity(0.4)),
//           validator: validator,
//           onChanged: onChanged,
//           // suffixIcon: suffix,
//           suffix: suffix,
//           prefix2: prefix,
//           readOnly: readOnly ?? false,
//           onTap: onTap,
//           expands: expands ?? false,
//         ),
//       ),
//     ],
//   );
// }

// Column buildLanguageTool(
//     {required double? fieldWidth,
//     bool? isHeadingRequired = true,
//     bool isHeadingVisible = true,
//     int? maxLines,
//     required String heading,
//     required bool isRequired,
//     TextInputType? textInputType,
//     List<TextInputFormatter>? inputFormatters,
//     String? Function(String?)? validator,
//     void Function(String)? onChanged,
//     void Function(String)? onSubmitted,
//     FocusNode? focusNode,
//     Widget? suffix,
//     Widget? prefix,
//     bool? readOnly,
//     double? contentPadding,
//     AutovalidateMode? autoValidateMode,
//     void Function()? onTap,
//     bool? expands,
//     required LanguageToolController controller}) {
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
//               text: isRequired ? ' *' : '*',
//               style: TextStyle(
//                 color: isRequired ? Colors.red : Colors.transparent,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w400,
//               ))
//         ])),
//       if (isHeadingRequired == true) const Gap(5) else const Gap(5),
//       SizedBox(
//         width: fieldWidth,
//         // height: 40,
//         child: CustomLanguageTool(
//           onSubmitted: onSubmitted,
//           focusNode: focusNode,
//           autovalidateMode: autoValidateMode ?? AutovalidateMode.disabled,
//           inputFormatters: inputFormatters,
//           contentPadding: contentPadding ?? 14,
//           isDense: true,
//           maxLines: maxLines,
//           keyboardType: textInputType ?? TextInputType.text,
//           controller: controller,
//           fillColor: AppColors.offWhite.withOpacity(0.8),
//           borderSide: BorderSide(color: AppColors.grey.withOpacity(0.4)),
//           validator: validator,
//           onChanged: onChanged,
//           // suffixIcon: suffix,
//           suffix: suffix,
//           prefix2: prefix,
//           readOnly: readOnly ?? false,
//           onTap: onTap,
//           expands: expands ?? false,
//         ),
//       ),
//     ],
//   );
// }
