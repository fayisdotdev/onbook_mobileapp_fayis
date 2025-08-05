// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:onbook_app/features/approot/app_root.dart';
// import 'package:onbook_app/features/profile/presentation/view/widget/profile_info_frame.dart';
// import 'package:onbook_app/features/profile/presentation/view/widget/profile_invoice_frame.dart';
// import 'package:onbook_app/general/themes/app_colors.dart';
// import 'package:onbook_app/general/themes/app_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:onbook_app/general/providers/auth_provider.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userData = Provider.of<AuthProvider>(context).userData;
//     final name = userData?['name'] ?? 'Unknown User';
//     final phone = userData?['phone'] ?? 'No Number';

//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             backgroundColor: AppColors.scaffoldBg,
//             title: const Center(
//               child: Text(
//                 'Profile',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Stack(
//                 children: [
//                   Column(
//                     children: [
//                       Container(
//                         height: 100,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: AppColors.secondary,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                           child: Row(
//                             children: [
//                               Container(
//                                 height: 50,
//                                 width: 50,
//                                 decoration: BoxDecoration(
//                                   color: AppColors.white,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Image.asset(
//                                   AppIcons.profileIcon,
//                                   scale: 8,
//                                 ),
//                               ),
//                               const Gap(20),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     name,
//                                     style: TextStyle(
//                                       color: AppColors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                   Text(
//                                     phone,
//                                     style: TextStyle(
//                                       color: AppColors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Gap(20),
//                       ProfileInvoiceFrame(
//                         title: 'Invoice',
//                         subtitle: '( 2 Unpaid Invoices )',
//                         showSubtitle: true,
//                       ),
//                       Gap(20),
//                       Gap(20),
//                       Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: AppColors.bggrey,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                 left: 18.0,
//                                 top: 18,
//                               ),
//                               child: Text(
//                                 ' YOUR INFORMATION',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                             ),
//                             ProfileInfoFrame(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => AppRoot(),
//                                   ),
//                                 );
//                               },
//                               iconPath: AppIcons.profileuser,
//                               title: 'Profile',
//                               showSubtitle: false,
//                             ),
//                             ProfileInfoFrame(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => AppRoot(),
//                                   ),
//                                 );
//                               },
//                               iconPath: AppIcons.newVehicle,
//                               title: 'Add New Vehicle',
//                               showSubtitle: false,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Gap(20),
//                       Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: AppColors.bggrey,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                 left: 18.0,
//                                 top: 18,
//                               ),
//                               child: Text(
//                                 ' OTHER INFORMATION',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                             ),
//                             ProfileInfoFrame(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => AppRoot(),
//                                   ),
//                                 );
//                               },
//                               iconPath: AppIcons.customerService,
//                               title: 'Customer Support',
//                               showSubtitle: false,
//                             ),
//                             ProfileInfoFrame(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => AppRoot(),
//                                   ),
//                                 );
//                               },
//                               iconPath: AppIcons.shareIcon,
//                               title: 'Share App',
//                               showSubtitle: false,
//                             ),
//                             ProfileInfoFrame(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => AppRoot(),
//                                   ),
//                                 );
//                               },
//                               iconPath: AppIcons.rateappIcon,
//                               title: 'Rate This App',
//                               showSubtitle: false,
//                             ),
//                             ProfileInfoFrame(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => AppRoot(),
//                                   ),
//                                 );
//                               },
//                               iconPath: AppIcons.faqIcon,
//                               title: 'FAQ',
//                               showSubtitle: false,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Gap(20),
//                       InkWell(
//                         onTap: () {},
//                         child: Container(
//                           height: 50,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               width: .8,
//                               color: AppColors.secondary,
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(AppIcons.logoutIcon, scale: 4),
//                               Gap(10),
//                               Text(
//                                 'Log Out',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.secondary,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     bottom: 60,
//                     right: 20,
//                     child: InkWell(
//                       onTap: () {
//                         // Action to open chat
//                         print("Chat Button Clicked");
//                       },
//                       child: Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           color: AppColors.secondary,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black26,
//                               blurRadius: 10,
//                               offset: Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Center(
//                           child: Image.asset(AppIcons.bubbleicon, scale: 4.5),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
