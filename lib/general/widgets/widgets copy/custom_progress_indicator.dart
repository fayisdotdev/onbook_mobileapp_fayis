// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:on_book_shop_crm/general/utils/app_lotties.dart';

// void customProgressIndicator<T>(BuildContext context) {
//   showDialog<T>(
//     barrierColor: Colors.black.withOpacity(0.2),
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return PopScope(
//         canPop: false,
//         child: Material(
//           type: MaterialType.transparency,
//           child: Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                     child: Lottie.asset(
//                   AppLotties.loading,
//                   height: 40,
//                   width: 80,
//                 )),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

// void customProgressBarrier<T>(BuildContext context) {
//   showDialog<T>(
//     barrierColor: Colors.black.withOpacity(0.2),
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return const PopScope(
//         canPop: false,
//         child: Material(
//           type: MaterialType.transparency,
//           child: Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
