import 'package:flutter/material.dart';
import 'package:onbook_app/general/providers/auth_provider.dart';
import 'package:onbook_app/general/themes/app_colors.dart';
import 'package:onbook_app/general/themes/app_theme.dart';
import 'package:provider/provider.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context).userData;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'User Details',
          style: AppColors.poppinsBold(fontSize: 18, color: AppColors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: AppColors.scaffoldBg,
      body: userData == null
          ? Center(
              child: Text('No user data available.', style: AppTheme.subtitle),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.bggrey,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'USER PROFILE',
                      style: AppColors.poppinsBold(
                        fontSize: 18,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow(
                      icon: Icons.person,
                      label: 'Name',
                      value: userData['name'],
                    ),
                    _buildDetailRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: userData['email'],
                    ),
                    _buildDetailRow(
                      icon: Icons.phone,
                      label: 'Phone',
                      value: userData['phone'],
                    ),
                    // UID and Document ID are hidden for smoother view
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryColor.withOpacity(0.08),
            child: Icon(icon, color: Colors.black87, size: 22),
          ),
          const SizedBox(width: 16),
          Text(
            '$label:',
            style: AppColors.poppinsMedium(
              fontSize: 15,
              color: AppColors.black,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'Not available',
              style: AppColors.poppinsRegular(
                fontSize: 15,
                color: AppColors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
