// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.buttonHeight,
    this.buttonWidth,
    required this.buttonColor,
    required this.buttonWidget,
    this.borderRadius,
    this.borderRadiusGeometry,
    this.elevation,
    this.onPressed,
    this.focusedColor,
    this.hoverColor,
    this.pressedColor,
  });

  final double? buttonHeight;
  final double? buttonWidth;
  final Color buttonColor;
  final Color? focusedColor; // When focused
  final Color? hoverColor; // When hovered
  final Color? pressedColor; // When clicked
  final Widget buttonWidget;
  final double? borderRadius;
  final BorderRadiusGeometry? borderRadiusGeometry;
  final double? elevation;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight ?? 40,
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(elevation ?? 0),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return pressedColor ??
                    buttonColor.withOpacity(0.5); // ✅ Color when clicking
              }
              if (states.contains(WidgetState.focused)) {
                return focusedColor ??
                    buttonColor.withOpacity(0.7); // ✅ When focused
              }
              if (states.contains(WidgetState.hovered)) {
                return hoverColor ??
                    buttonColor.withOpacity(0.8); // ✅ When hovering
              }
              return buttonColor; // Default color
            },
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return (pressedColor ?? buttonColor.withOpacity(0.3))
                    .withOpacity(0.2); // ✅ Ensure press effect
              }
              return Colors.transparent;
            },
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: borderRadiusGeometry ??
                  BorderRadius.circular(borderRadius ?? 8),
            ),
          ),
        ),
        child: buttonWidget,
      ),
    );
  }
}

//Outline Button
class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    super.key,
    this.buttonHeight,
    this.buttonWidth,
    required this.buttonColor,
    this.onPressed,
    required this.borderColor,
    required this.buttonWidget,
    this.borderRadius,
    this.elevetion,
    this.padding,
    this.focusedColor,
    this.hoverColor,
    this.pressedColor,
  });

  final EdgeInsetsGeometry? padding;
  final double? buttonHeight;
  final double? buttonWidth;
  final Color buttonColor;
  final double? borderRadius;
  final Color? focusedColor; // When focused
  final Color? hoverColor; // When hovered
  final Color? pressedColor; // When clicked

  final Color borderColor;
  final void Function()? onPressed;
  final Widget buttonWidget;
  final double? elevetion;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight ?? 40,
      width: buttonWidth,
      child: OutlinedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(
              padding ??
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
            elevation: WidgetStatePropertyAll(elevetion ?? 0),
            shadowColor: const WidgetStatePropertyAll(Colors.black26),
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return pressedColor ??
                      buttonColor.withOpacity(0.5); // ✅ Color when clicking
                }
                if (states.contains(WidgetState.focused)) {
                  return focusedColor ??
                      buttonColor.withOpacity(0.7); // ✅ When focused
                }
                if (states.contains(WidgetState.hovered)) {
                  return hoverColor ??
                      buttonColor.withOpacity(0.8); // ✅ When hovering
                }
                return buttonColor; // Default color
              },
            ),
            overlayColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return (pressedColor ?? buttonColor.withOpacity(0.3))
                      .withOpacity(0.2); // ✅ Ensure press effect
                }
                return Colors.transparent;
              },
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
              ),
            ),
            side: WidgetStatePropertyAll(
              BorderSide(color: borderColor),
            ),
          ),
          child: Center(
            child: buttonWidget,
          )),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final Color color;
  final Color? hoverColor;
  final Widget icon;
  final void Function() onPressed;
  final Decoration? decoration;
  final double size;
  final bool isDisabled;

  const CustomIconButton({
    super.key,
    required this.color,
    required this.icon,
    required this.onPressed,
    this.decoration,
    this.size = 48.0,
    this.hoverColor,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: size,
        minHeight: size,
      ),
      decoration: decoration ??
          BoxDecoration(
            shape: BoxShape.circle,
            color: isDisabled ? Colors.transparent : color,
            border: Border.all(color: color, width: 0.7),
          ),
      child: Center(
        child: IconButton(
          iconSize: size * 0.6,
          hoverColor: hoverColor ?? color.withValues(alpha: 0.6),
          highlightColor: color.withOpacity(0.9),
          onPressed: onPressed,
          icon: icon,
          color: isDisabled ? Colors.transparent : color,
        ),
      ),
    );
  }
}
