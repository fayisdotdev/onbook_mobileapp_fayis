// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:languagetool_textfield/languagetool_textfield.dart';

// class CustomLanguageTool extends StatelessWidget {
//   final LanguageToolController controller;
//   final String? hintText;
//   final FormFieldValidator<String>? validator;
//   final Widget? suffixIcon;
//   final Widget? prefix;
//   final TextInputType keyboardType;
//   final int? maxLength;
//   final int? maxLines;
//   final int? minLines;
//   final double? height;
//   final double? width;
//   final bool readOnly;
//   final void Function()? onTap;
//   final void Function(String)? onSubmitted;
//   final TextStyle? hintStyle;
//   final ValueChanged<String>? onChanged;
//   final TextCapitalization textCapitalization;
//   final BorderSide borderSide;
//   final Color? fillColor;
//   final List<BoxShadow>? boxShadow;
//   final List<TextInputFormatter>? inputFormatters;
//   final double? contentPadding;
//   final String? labelText;
//   final TextStyle? labelStyle;
//   final bool? autofocus;
//   final double? borderRadius;
//   final AutovalidateMode? autovalidateMode;
//   final bool? isDense;
//   final bool? expands;
//   final BoxConstraints? constraints;
//   final TextStyle? style;
//   final TextAlign? textAlign;
//   final Widget? suffix;
//   final Widget? prefix2;
//   final FocusNode? focusNode;
//   final TextAlignVertical? textAlignVertical;

//   const CustomLanguageTool({
//     super.key,
//     required this.controller,
//     this.hintText,
//     this.validator,
//     this.suffixIcon,
//     this.keyboardType = TextInputType.text,
//     this.maxLength,
//     this.maxLines,
//     this.minLines,
//     this.height,
//     this.width,
//     this.readOnly = false,
//     this.textCapitalization = TextCapitalization.none,
//     this.onTap,
//     this.hintStyle = const TextStyle(
//       color: Colors.grey,
//       fontSize: 14,
//       fontWeight: FontWeight.w400,
//     ),
//     this.onChanged,
//     this.borderSide = BorderSide.none,
//     this.fillColor,
//     this.inputFormatters,
//     this.boxShadow,
//     this.contentPadding,
//     this.labelText,
//     this.labelStyle,
//     this.autofocus,
//     this.borderRadius,
//     this.autovalidateMode,
//     this.prefix,
//     this.isDense,
//     this.expands,
//     this.onSubmitted,
//     this.constraints,
//     this.style,
//     this.textAlign,
//     this.suffix,
//     this.prefix2,
//     this.focusNode,
//     this.textAlignVertical,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: Container(
//         // width: width ?? 450,
//         height: height,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: boxShadow,
//         ),
//         child: LanguageToolTextField(
//           alignCenter: true,
//           language: 'en-US',
//           textAlignVertical: textAlignVertical,
//           focusNode: focusNode,
//           textAlign: textAlign ?? TextAlign.start,
//           expands: expands ?? false,
//           autoFocus: autofocus ?? false,
//           onTap: onTap,
//           autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
//           textCapitalization: textCapitalization,
//           inputFormatters: inputFormatters,
//           decoration: InputDecoration(
//               constraints: constraints,
//               isDense: isDense ?? false,
//               labelText: labelText,
//               labelStyle: labelStyle,
//               contentPadding: EdgeInsets.all(contentPadding ?? 10),
//               counterStyle: const TextStyle(
//                 height: double.minPositive,
//               ),
//               counterText: "",
//               filled: true,
//               fillColor: fillColor ?? Colors.transparent,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(borderRadius ?? 6),
//                 borderSide: borderSide,
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(borderRadius ?? 6),
//                 borderSide: borderSide,
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(borderRadius ?? 6),
//                 borderSide: borderSide,
//               ),
//               suffixIcon: suffixIcon,
//               prefixIcon: prefix,
//               hintText: hintText,
//               hintStyle: hintStyle,
//               suffix: suffix,
//               prefix: prefix2,
//               errorStyle: const TextStyle(fontSize: 10)),
//           style: style ??
//               const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//               ),
//           controller: controller,
//           keyboardType: keyboardType,
//           maxLength: maxLength,
//           maxLines: maxLines,
//           minLines: minLines,
//           readOnly: readOnly,
//           validator: validator,
//           onTextChange: onChanged,
//           onTextSubmitted: onSubmitted,
//         ),
//       ),
//     );
//   }
// }
