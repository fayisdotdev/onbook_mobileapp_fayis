import 'package:flutter/material.dart';
import 'package:onbook_app/general/themes/app_colors.dart';
import 'package:onbook_app/general/themes/app_icons.dart';

class ProfileInfoFrame extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool? showSubtitle;
  final void Function() onTap;
  final String? header;
  final String iconPath;

  const ProfileInfoFrame({
    super.key,
    required this.title,
    this.subtitle,
    this.showSubtitle = false,
    required this.iconPath,
    required this.onTap,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null && header!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              header!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
          ),
        Card(
          elevation: 0,
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          // color: AppColors.lightGrey,
          child: ListTile(
            tileColor: AppColors.bggrey,
            minTileHeight: 10,
            onTap: onTap,
            leading: Image.asset(iconPath, scale: 4),
            title: Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black),
            ),
            subtitle: showSubtitle == true && subtitle != null
                ? Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  )
                : null,
            trailing: Image.asset(AppIcons.rightIcon, scale: 4),
          ),
        ),
      ],
    );
  }
}
