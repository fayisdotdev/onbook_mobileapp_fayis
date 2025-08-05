// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:onbook_app/general/themes/app_colors.dart';
import 'package:onbook_app/general/themes/app_icons.dart';

class ProfileInvoiceFrame extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool? showSubtitle;
  const ProfileInvoiceFrame({
    super.key,
    required this.title,
    this.subtitle,
    this.showSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   // height: 10,
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     color: AppColors.lightGrey,
        //     borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        //   ),
        //   child: Row(
        //     children: [Text('YOUR INFORMATION')],
        //   ),
        // ),
        // Container(
        //   height: 55,
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     color: AppColors.lightGrey,
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        //     child: Column(
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Row(
        //               children: [
        //                 Image.asset(AppIcons.invoiceIcon, scale: 4),
        //                 Gap(10),
        //                 Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(title,
        //                         style: TextStyle(
        //                             fontSize: 16,
        //                             fontWeight: FontWeight.w600,
        //                             color: AppColors.black)),
        //                     if (showSubtitle == true)
        //                       Text(subtitle!,
        //                           style: TextStyle(
        //                               color: AppColors.black,
        //                               fontSize: 14,
        //                               fontWeight: FontWeight.w400)),

        //                     // Text('Invoice',
        //                     //     style: TextStyle(
        //                     //         fontSize: 16,
        //                     //         fontWeight: FontWeight.w600,
        //                     //         color: AppColors.black)),
        //                     // Text('( 1 unpaid invoice)',
        //                     //     style: TextStyle(color: AppColors.black, fontSize: 14)),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //             Image.asset(AppIcons.rightIcon, scale: 4),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        Container(
          // height: 55, // ❌ REMOVE THIS
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start, // <- add this
                  children: [
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // <- add this
                      children: [
                        Image.asset(AppIcons.invoiceIcon, scale: 4),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            if (showSubtitle == true)
                              Text(
                                subtitle!,
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Image.asset(AppIcons.rightIcon, scale: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
