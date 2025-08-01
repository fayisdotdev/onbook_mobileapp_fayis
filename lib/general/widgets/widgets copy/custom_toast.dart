// import 'package:flutter/material.dart';
// import 'package:toastification/toastification.dart';

// class CToast {
//   static void success(String message) {
//     // Fluttertoast.showToast(
//     //   msg: message,
//     //   toastLength: Toast.LENGTH_SHORT,
//     //   gravity: ToastGravity.CENTER,
//     //   timeInSecForIosWeb: 2,
//     //   //GREEN HEX COLOR CODE FOR WEB
//     //   webBgColor: "#00A610",
//     //   textColor: Colors.white,
//     //   fontSize: 16.0,
//     // );\
//     toastification.show(
//       type: ToastificationType.success,
//       style: ToastificationStyle.minimal,
//       autoCloseDuration: const Duration(seconds: 4),
//       // title: const Text(
//       //   'Error',
//       //   style: TextStyle(fontWeight: FontWeight.w600),
//       // ),
//       // you can also use RichText widget for title and description parameters
//       description: RichText(text: TextSpan(text: message)),
//       alignment: Alignment.topRight,
//       direction: TextDirection.ltr,
//       animationDuration: const Duration(milliseconds: 300),
//       animationBuilder: (context, animation, alignment, child) {
//         return FadeTransition(
//           opacity: animation,
//           // turns: animation,
//           child: child,
//         );
//       },
//       icon: const Icon(Icons.check),
//       showIcon: true, // show or hide the icon
//       primaryColor: Colors.green,
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.black,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: const [
//         BoxShadow(
//           color: Color(0x07000000),
//           blurRadius: 16,
//           offset: Offset(0, 16),
//           spreadRadius: 0,
//         )
//       ],
//       showProgressBar: true,
//       progressBarTheme: const ProgressIndicatorThemeData(color: Colors.green),
//       // closeButton: ToastCloseButton(
//       //   showType: CloseButtonShowType.onHover,
//       //   buttonBuilder: (context, onClose) {
//       //     return OutlinedButton.icon(
//       //       onPressed: onClose,
//       //       icon: const Icon(Icons.close, size: 20),
//       //       label: const Text('Close'),
//       //     );
//       //   },
//       // ),
//       closeOnClick: false,
//       pauseOnHover: true,
//       dragToClose: true,
//       applyBlurEffect: true,
//       // callbacks: ToastificationCallbacks(
//       //   onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
//       //   onCloseButtonTap: (toastItem) => print('Toast ${toastItem.id} close button tapped'),
//       //   onAutoCompleteCompleted: (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
//       //   onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
//       // ),
//     );
//   }

//   static void error(String message) {
//     // Fluttertoast.showToast(
//     //   msg: message,
//     //   toastLength: Toast.LENGTH_SHORT,
//     //   gravity: ToastGravity.CENTER,
//     //   timeInSecForIosWeb: 2,
//     //   webBgColor: "#FF0000",
//     //   textColor: Colors.white,
//     //   fontSize: 16.0,
//     // );
//     toastification.show(
//       type: ToastificationType.error,
//       style: ToastificationStyle.minimal,
//       autoCloseDuration: const Duration(seconds: 4),
//       // title: const Text(
//       //   'Error',
//       //   style: TextStyle(fontWeight: FontWeight.w600),
//       // ),
//       // you can also use RichText widget for title and description parameters
//       description: RichText(text: TextSpan(text: message)),
//       alignment: Alignment.topRight,
//       direction: TextDirection.ltr,
//       animationDuration: const Duration(milliseconds: 300),
//       animationBuilder: (context, animation, alignment, child) {
//         return FadeTransition(
//           opacity: animation,
//           // turns: animation,
//           child: child,
//         );
//       },
//       icon: const Icon(Icons.close),
//       showIcon: true, // show or hide the icon
//       primaryColor: Colors.red,
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.black,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: const [
//         BoxShadow(
//           color: Color(0x07000000),
//           blurRadius: 16,
//           offset: Offset(0, 16),
//           spreadRadius: 0,
//         )
//       ],
//       showProgressBar: true,
//       progressBarTheme: const ProgressIndicatorThemeData(color: Colors.red),
//       // closeButton: ToastCloseButton(
//       //   showType: CloseButtonShowType.onHover,
//       //   buttonBuilder: (context, onClose) {
//       //     return OutlinedButton.icon(
//       //       onPressed: onClose,
//       //       icon: const Icon(Icons.close, size: 20),
//       //       label: const Text('Close'),
//       //     );
//       //   },
//       // ),
//       closeOnClick: false,
//       pauseOnHover: true,
//       dragToClose: true,
//       applyBlurEffect: true,
//       // callbacks: ToastificationCallbacks(
//       //   onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
//       //   onCloseButtonTap: (toastItem) => print('Toast ${toastItem.id} close button tapped'),
//       //   onAutoCompleteCompleted: (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
//       //   onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
//       // ),
//     );
//   }


//   static void info(String message) {
//     toastification.show(
//       type: ToastificationType.info,
//       style: ToastificationStyle.minimal,
//       autoCloseDuration: const Duration(seconds: 4),
//       description: RichText(text: TextSpan(text: message)),
//       alignment: Alignment.topRight,
//       direction: TextDirection.ltr,
//       animationDuration: const Duration(milliseconds: 300),
//       animationBuilder: (context, animation, alignment, child) {
//         return FadeTransition(
//           opacity: animation,
//           child: child,
//         );
//       },
//       icon: const Icon(Icons.info_outline, color: Colors.blueAccent),
//       showIcon: true,
//       primaryColor: Colors.blueAccent,
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.black,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: const [
//         BoxShadow(
//           color: Color(0x07000000),
//           blurRadius: 16,
//           offset: Offset(0, 16),
//         )
//       ],
//       showProgressBar: true,
//       progressBarTheme: const ProgressIndicatorThemeData(color: Colors.blueAccent),
//       closeOnClick: false,
//       pauseOnHover: true,
//       dragToClose: true,
//       applyBlurEffect: true,
//     );
//   }

//   static void updated(String message) {
//     toastification.show(
//       type: ToastificationType.info,
//       style: ToastificationStyle.minimal,
//       autoCloseDuration: const Duration(seconds: 3),
//       description: RichText(text: TextSpan(text: message)),
//       alignment: Alignment.topRight,
//       direction: TextDirection.ltr,
//       animationDuration: const Duration(milliseconds: 300),
//       animationBuilder: (context, animation, alignment, child) {
//         return FadeTransition(opacity: animation, child: child);
//       },
//       icon: const Icon(Icons.done_all_rounded, color: Colors.blue),
//       showIcon: true,
//       primaryColor: Colors.blue,
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.black,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: const [
//         BoxShadow(
//           color: Color(0x07000000),
//           blurRadius: 16,
//           offset: Offset(0, 16),
//         )
//       ],
//       showProgressBar: true,
//       progressBarTheme: const ProgressIndicatorThemeData(color: Colors.blue),
//       closeOnClick: false,
//       pauseOnHover: true,
//       dragToClose: true,
//       applyBlurEffect: true,
//     );
//   }
// }





