// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:on_book_shop_crm/features/app_root/presentation/provider/app_root_provider.dart';
// import 'package:on_book_shop_crm/features/authentication/presentation/provider/authentication_provider.dart';
// import 'package:on_book_shop_crm/general/utils/app_colors.dart';
// import 'package:on_book_shop_crm/general/utils/app_icons.dart';
// import 'package:provider/provider.dart';

// class CustomSliverAppbar extends StatelessWidget {
//   const CustomSliverAppbar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppRootProvider>(
//       builder: (context, appRootState, _) {
//         return Consumer<AuthenticationProvider>(
//           builder: (context, authState, _) {
//             final shopModel = authState.shopModel;
//             final staffUser = authState.staffUser;

//             final bool isStaff = staffUser != null;
//             final bool isOwner = shopModel != null && staffUser == null;

//             // Logs for debugging
//             if (isStaff) {
//               debugPrint("🟢 Staff User logged in:");
//               debugPrint("firstName: ${staffUser.firstName}");
//               debugPrint("lastName: ${staffUser.lastName}");
//               debugPrint("email: ${staffUser.email}");
//               debugPrint("phone: ${staffUser.phone}");
//               debugPrint("roleId: ${staffUser.roleId}");
//               debugPrint("shopId: ${staffUser.shopId}");
//             } else if (isOwner) {
//               debugPrint("🟢 ShopModel fetched:");
//               debugPrint(
//                   "Name: ${shopModel.ownerFirstName} ${shopModel.ownerSecondName}");
//               debugPrint("Shop Name: ${shopModel.shopName}");
//               debugPrint("Email: ${shopModel.email}");
//               debugPrint("Status: ${shopModel.status}");
//               debugPrint("Certifications: ${shopModel.certifications?.length}");
//             }

//             // ❗️Redirect and skip rendering if no user/shop
//             if (!isStaff && !isOwner) {
//               return const SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.all(16),
//                   child: LinearProgressIndicator(),
//                 ),
//               );
//             }

//             final userName = isStaff
//                 ? "${staffUser.firstName ?? ''} ${staffUser.lastName ?? ''}"
//                     .trim()
//                 : (shopModel?.ownerName ?? 'Owner');

//             final shopName = shopModel?.shopName ?? 'Shop';

//             final initials = isStaff
//                 ? ((staffUser.firstName?.isNotEmpty ?? false) &&
//                         (staffUser.lastName?.isNotEmpty ?? false))
//                     ? (staffUser.firstName![0] + staffUser.lastName![0])
//                         .toUpperCase()
//                     : 'U'
//                 : ((shopModel?.ownerName?.isNotEmpty ?? false)
//                     ? shopModel!.ownerName
//                         ?.split(' ')
//                         .where((e) => e.isNotEmpty)
//                         .map((e) => e[0])
//                         .take(2)
//                         .join()
//                         .toUpperCase()
//                     : 'O');
//             return SliverAppBar(
//               toolbarHeight: 70,
//               automaticallyImplyLeading: false,
//               titleSpacing: 0,
//               backgroundColor: AppColors.white,
//               surfaceTintColor: AppColors.white,
//               pinned: true,
//               forceElevated: true,
//               elevation: 5,
//               shadowColor: AppColors.black.withOpacity(0.6),
//               title: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Row(
//                   children: [
//                     Image.asset(AppIcons.smileyIcon, scale: 3.5),
//                     const Gap(5),
//                     Expanded(
//                       child: Text(
//                         "Hey $userName, welcome to OnBook—let's get started!",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 Image.asset(AppIcons.historyIcon, scale: 3.5),
//                 const Gap(24),
//                 Image.asset(AppIcons.searchIcon, scale: 3.5),
//                 const Gap(24),
//                 InkWell(
//                   onTap: appRootState.openChatDrawer,
//                   child: Image.asset(AppIcons.chatIcon, scale: 3.5),
//                 ),
//                 const Gap(24),
//                 InkWell(
//                   onTap: appRootState.openNotificationDrawer,
//                   child: Image.asset(AppIcons.notificationIcon, scale: 3.5),
//                 ),
//                 const Gap(24),
//                 VerticalDivider(
//                   color: AppColors.black,
//                   endIndent: 10,
//                   indent: 10,
//                 ),
//                 const Gap(24),
//                 PopupMenuButton<String>(
//                   offset: const Offset(0, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: CircleAvatar(
//                     radius: 20,
//                     backgroundColor: AppColors.primaryColor,
//                     child: Text(
//                       initials!,
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   onSelected: (value) {
//                     if (value == 'settings') {
//                       GoRouter.of(context).go('/settingsScreen/profile');
//                     } else if (value == 'logout') {
//                       authState.signOut(context);
//                     } else if (value == 'whatsNew') {
//                       debugPrint('Whats New clicked');
//                     } else if (value == 'changePassword') {
//                       context.go('/settingsScreen/changePassword');
//                     }
//                   },
// // changes from
//                   itemBuilder: (context) => [
//                     PopupMenuItem(
//                       enabled: false,
//                       padding: const EdgeInsets.only(
//                           left: 16, right: 16, top: 12, bottom: 4),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             userName,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 15,
//                               color: AppColors.primaryColor,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             shopName,
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const PopupMenuDivider(),
//                     // Show for owner always, for staff only if they have permission
//                     if (isOwner ||
//                         (authState.staffUser?.roleModel?.permissions
//                                 .hasAccess('settings') ??
//                             false))
//                       const PopupMenuItem(
//                         value: 'settings',
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                         child: Row(
//                           children: [
//                             Icon(Icons.settings_outlined,
//                                 color: Colors.black87, size: 20),
//                             SizedBox(width: 12),
//                             Text('Settings', style: TextStyle(fontSize: 14)),
//                           ],
//                         ),
//                       ),
//                     if (isOwner ||
//                         (authState.staffUser?.roleModel?.permissions
//                                 .hasAccess('settings') ??
//                             false))
//                       const PopupMenuItem<String>(
//                         value: 'changePassword',
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                         child: Row(
//                           children: [
//                             Icon(Icons.lock_outline,
//                                 color: Colors.black87, size: 20),
//                             SizedBox(width: 12),
//                             Text('Change Password',
//                                 style: TextStyle(fontSize: 14)),
//                           ],
//                         ),
//                       ),
//                     if (isOwner ||
//                         (authState.staffUser?.roleModel?.permissions
//                                 .hasAccess('settings') ??
//                             false))
//                       const PopupMenuDivider(),
//                     const PopupMenuItem<String>(
//                       value: 'whatsNew',
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Row(
//                         children: [
//                           Icon(Icons.new_releases_outlined,
//                               color: Colors.black87, size: 20),
//                           SizedBox(width: 12),
//                           Text('What\'s New', style: TextStyle(fontSize: 14)),
//                         ],
//                       ),
//                     ),
//                     const PopupMenuDivider(),
//                     const PopupMenuItem(
//                       value: 'logout',
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Row(
//                         children: [
//                           Icon(Icons.logout, color: Colors.redAccent, size: 20),
//                           SizedBox(width: 12),
//                           Text('Logout', style: TextStyle(fontSize: 14)),
//                         ],
//                       ),
//                     ),
//                   ],
// // changed till here
//                 ),
//                 const Gap(16),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
