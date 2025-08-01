// import 'package:flutter/material.dart';
// import 'package:on_book_shop_crm/general/utils/app_colors.dart';
// import 'package:on_book_shop_crm/general/utils/app_icons.dart';

// class CustomDropdown extends StatefulWidget {
//   final List<String> options;
//   final String? value;
//   final ValueChanged<String> onSelected;

//   const CustomDropdown({
//     super.key,
//     required this.options,
//     required this.value,
//     required this.onSelected,
//   });

//   @override
//   State<CustomDropdown> createState() => _CustomDropdownState();
// }

// class _CustomDropdownState extends State<CustomDropdown> {
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? _overlayEntry;
//   bool isDropdownOpen = false;

//   void _toggleDropdown() {
//     if (isDropdownOpen) {
//       _removeDropdown();
//     } else {
//       _showDropdown();
//     }
//   }

//   void _showDropdown() {
//     final RenderBox renderBox = context.findRenderObject() as RenderBox;
//     final size = renderBox.size;

//     _overlayEntry = OverlayEntry(
//       builder: (context) {
//         return Positioned(
//           width: size.width,
//           child: CompositedTransformFollower(
//             link: _layerLink,
//             offset: Offset(0, size.height + 4),
//             showWhenUnlinked: false,
//             child: Material(
//               elevation: 2,
//               borderRadius: BorderRadius.circular(8),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: ListView(
//                   shrinkWrap: true,
//                   padding: EdgeInsets.zero,
//                   children: widget.options.map((item) {
//                     return ListTile(
//                       title: Text(
//                         item,
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                       onTap: () {
//                         widget.onSelected(item);
//                         _removeDropdown();
//                       },
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );

//     Overlay.of(context).insert(_overlayEntry!);
//     setState(() => isDropdownOpen = true);
//   }

//   void _removeDropdown() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//     setState(() => isDropdownOpen = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CompositedTransformTarget(
//       link: _layerLink,
//       child: GestureDetector(
//         onTap: _toggleDropdown,
//         child: Container(
//           height: 35,
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: AppColors.lightGrey,
//             border: Border.all(color: AppColors.grey.withOpacity(0.4)),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 widget.value!,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.black,
//                 ),
//               ),
//               AnimatedRotation(
//                 turns: isDropdownOpen ? 0.5 : 0,
//                 duration: const Duration(milliseconds: 300),
//                 child: Image.asset(
//                   AppIcons.arrowDown,
//                   scale: 4.5,
//                   color: AppColors.primaryColor,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _removeDropdown();
//     super.dispose();
//   }
// }
