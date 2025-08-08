import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onbook_app/general/themes/app_colors.dart';
// import 'app_colors.dart';

class AppTheme {
  // Centralized text styles
  static TextStyle get title => AppColors.poppinsBold(fontSize: 20, color: AppColors.primaryColor);
  static TextStyle get subtitle => AppColors.poppinsMedium(fontSize: 16, color: AppColors.grey);
  static TextStyle get body => AppColors.poppinsRegular(fontSize: 14, color: AppColors.black);

  // Centralized input decoration for different field types
  static InputDecoration textFieldDecoration({
    required String label,
    IconData? icon,
    Widget? suffixIcon,
    bool readOnly = false,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.primaryColor) : null,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: readOnly ? AppColors.lightGrey : AppColors.bggrey,
      enabled: !readOnly,
      labelStyle: AppColors.poppinsRegular(
        color: readOnly ? AppColors.grey : AppColors.black,
      ),
    );
  }

  // Email field
  static Widget emailField({
    required TextEditingController controller,
    String label = 'Email',
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      readOnly: readOnly,
      validator: validator,
      decoration: textFieldDecoration(
        label: label,
        icon: Icons.email_outlined,
        readOnly: readOnly,
      ),
    );
  }

  // Phone field
  static Widget phoneField({
    required TextEditingController controller,
    String label = 'Phone Number',
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      readOnly: readOnly,
      validator: validator,
      decoration: textFieldDecoration(
        label: label,
        icon: Icons.phone,
        readOnly: readOnly,
      ),
    );
  }

  // Password field
  static Widget passwordField({
    required TextEditingController controller,
    String label = 'Password',
    bool readOnly = false,
    String? Function(String?)? validator,
    bool isVisible = false,
    void Function()? onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      readOnly: readOnly,
      validator: validator,
      decoration: textFieldDecoration(
        label: label,
        icon: Icons.lock_outline,
        readOnly: readOnly,
        suffixIcon: onToggleVisibility != null
            ? IconButton(
                icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: onToggleVisibility,
              )
            : null,
      ),
    );

  }

  // ...existing code...

  /// Generic reusable text field for custom usage
  static Widget customField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    Widget? suffixIcon,
    bool readOnly = false,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    int? maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: textFieldDecoration(
        label: label,
        icon: icon,
        suffixIcon: suffixIcon,
        readOnly: readOnly,
      ),
    );
  }

//shop action button
// Inside AppTheme class
static Widget shopActionButton({
  required IconData icon,
  String? label, // optional
  required VoidCallback onPressed,
}) {
  final buttonStyle = OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    side: BorderSide(
      color: AppColors.primaryColor,
    ),
  );

  // If label is given, use OutlinedButton.icon, else use OutlinedButton
  return label != null && label.isNotEmpty
      ? OutlinedButton.icon(
          style: buttonStyle,
          onPressed: onPressed,
          icon: Icon(icon, size: 18, color: AppColors.primaryColor),
          label: Text(
            label,
            style: AppColors.poppinsMedium(
              fontSize: 14,
              color: AppColors.primaryColor,
            ),
          ),
        )
      : OutlinedButton(
          style: buttonStyle,
          onPressed: onPressed,
          child: Icon(icon, size: 18, color: AppColors.primaryColor),
        );
}


}