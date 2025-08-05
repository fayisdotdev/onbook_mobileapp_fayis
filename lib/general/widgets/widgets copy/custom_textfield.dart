import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final Widget? prefix;
  final TextInputType keyboardType;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final double? height;
  final bool readOnly;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final TextStyle? hintStyle;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;
  final BorderSide borderSide;
  final Color? fillColor;
  final List<BoxShadow>? boxShadow;
  final List<TextInputFormatter>? inputFormatters;
  final double? contentPadding;
  final String? labelText;
  final TextStyle? labelStyle;
  final bool? autofocus;
  final double? borderRadius;
  final AutovalidateMode? autovalidateMode;
  final bool? isDense;
  final bool? expands;
  final BoxConstraints? constraints;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Widget? suffix;
  final Widget? prefix2;
  final FocusNode? focusNode;
  final TextAlignVertical? textAlignVertical;
  final Color? hoverColor;
  final bool obscureText;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.validator,
    this.suffixIcon,
    this.prefix,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.height,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.hintStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    this.onChanged,
    this.borderSide = BorderSide.none,
    this.fillColor,
    this.inputFormatters,
    this.boxShadow,
    this.contentPadding,
    this.labelText,
    this.labelStyle,
    this.autofocus,
    this.borderRadius,
    this.autovalidateMode,
    this.isDense,
    this.expands,
    this.onSubmitted,
    this.constraints,
    this.style,
    this.textAlign,
    this.suffix,
    this.prefix2,
    this.focusNode,
    this.textAlignVertical,
    this.hoverColor,
    this.obscureText = false,
    
  });

  @override
  Widget build(BuildContext context) {
    if (obscureText) {
      return _PasswordField(
        controller: controller,
        hintText: hintText,
        validator: validator,
        borderSide: borderSide,
        fillColor: fillColor,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: labelStyle,
        textAlign: textAlign,
        contentPadding: contentPadding,
        style: style,
      );
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: boxShadow,
      ),
      child: TextFormField(
        textAlignVertical: textAlignVertical,
        focusNode: focusNode,
        textAlign: textAlign ?? TextAlign.start,
        expands: expands ?? false,
        autofocus: autofocus ?? false,
        onTap: onTap,
        autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hoverColor: hoverColor,
          constraints: constraints,
          isDense: isDense ?? false,
          labelText: labelText,
          labelStyle: labelStyle,
          contentPadding: EdgeInsets.all(contentPadding ?? 10),
          counterStyle: const TextStyle(height: double.minPositive),
          counterText: "",
          filled: true,
          fillColor: fillColor ?? Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
            borderSide: borderSide,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
            borderSide: borderSide,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
            borderSide: borderSide,
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefix,
          hintText: hintText,
          hintStyle: hintStyle,
          suffix: suffix,
          prefix: prefix2,
          errorStyle: const TextStyle(fontSize: 10),
        ),
        style: style ??
            const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        maxLines: maxLines,
        minLines: minLines,
        readOnly: readOnly,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final BorderSide borderSide;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double? contentPadding;

  const _PasswordField({
    this.controller,
    this.hintText,
    this.validator,
    this.borderSide = BorderSide.none,
    this.fillColor,
    this.hintStyle,
    this.labelText,
    this.labelStyle,
    this.style,
    this.textAlign,
    this.contentPadding,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      validator: widget.validator,
      textAlign: widget.textAlign ?? TextAlign.start,
      decoration: InputDecoration(
        isDense: true,
        labelText: widget.labelText,
        labelStyle: widget.labelStyle,
        contentPadding: EdgeInsets.all(widget.contentPadding ?? 10),
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        filled: true,
        fillColor: widget.fillColor ?? Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: widget.borderSide,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: widget.borderSide,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: widget.borderSide,
        ),
        errorStyle: const TextStyle(fontSize: 10),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      style: widget.style ??
          const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
    );
  }
}
