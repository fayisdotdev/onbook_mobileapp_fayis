import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:onbook_app/general/providers/auth_provider.dart';
import 'package:onbook_app/general/themes/app_colors.dart';
import 'package:onbook_app/general/themes/app_theme.dart';
import 'package:provider/provider.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  String? placeName;
  final RefreshIndicatorState? _refreshIndicatorKey = null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.userData?['location'] == null) {
        _handleLocationUpdate(context, autoRequest: true);
      } else {
        final loc = authProvider.userData?['location'] as GeoPoint?;
        if (loc != null) {
          _getPlaceName(loc.latitude, loc.longitude);
        }
      }
    });
  }

  Future<void> _getPlaceName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          placeName =
              "${place.street}, ${place.locality}, ${place.administrativeArea}";
        });
      }
    } catch (e) {
      print("Error fetching place name: $e");
    }
  }

  Future<void> _handleLocationUpdate(BuildContext context,
      {bool autoRequest = false}) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!autoRequest) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location services are disabled. Please enable them.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!autoRequest) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Location permission denied. Cannot update location.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!autoRequest) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permission permanently denied. Enable it in settings.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      await Geolocator.openAppSettings();
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final geoPoint = GeoPoint(position.latitude, position.longitude);
      final result = await authProvider.updateUserLocation(geoPoint);

      await _getPlaceName(position.latitude, position.longitude);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ?? 'Location updated successfully'),
          backgroundColor: result == null ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      if (!autoRequest) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to get location. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadUserData();

    final loc = authProvider.userData?['location'] as GeoPoint?;
    if (loc != null) {
      await _getPlaceName(loc.latitude, loc.longitude);
    }
  }

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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: userData == null
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: Text('No user data available.',
                          style: AppTheme.subtitle),
                    ),
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(20.0),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Container(
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
                        _buildDetailRow(
                          icon: Icons.location_on,
                          label: 'Coordinates',
                          value: userData['location'] == null
                              ? 'Location not provided'
                              : 'Lat: ${(userData['location'] as GeoPoint).latitude.toStringAsFixed(4)}, '
                                'Lng: ${(userData['location'] as GeoPoint).longitude.toStringAsFixed(4)}',
                        ),
                        _buildDetailRow(
                          icon: Icons.map,
                          label: 'Place Name',
                          value: placeName ?? 'Unknown',
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.my_location),
                          label: const Text('Add/Update Location'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () => _handleLocationUpdate(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _showChangePasswordDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.lock_outline, color: Colors.white),
                      label: const Text(
                        'Change Password',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
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

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final ValueNotifier<bool> showCurrent = ValueNotifier(false);
    final ValueNotifier<bool> showNew = ValueNotifier(false);
    final ValueNotifier<bool> showConfirm = ValueNotifier(false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: showCurrent,
                  builder: (context, value, _) => TextField(
                    controller: currentPasswordController,
                    obscureText: !value,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          value ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => showCurrent.value = !value,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder(
                  valueListenable: showNew,
                  builder: (context, value, _) => TextField(
                    controller: newPasswordController,
                    obscureText: !value,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          value ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => showNew.value = !value,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder(
                  valueListenable: showConfirm,
                  builder: (context, value, _) => TextField(
                    controller: confirmPasswordController,
                    obscureText: !value,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          value ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => showConfirm.value = !value,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final current = currentPasswordController.text.trim();
                final newPass = newPasswordController.text.trim();
                final confirm = confirmPasswordController.text.trim();

                if (newPass.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'New password must be at least 6 characters long'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (newPass != confirm) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Passwords do not match'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                final result = await authProvider.changeUserPassword(
                  currentPassword: current,
                  newPassword: newPass,
                );

                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result == null
                        ? 'Password updated successfully'
                        : result),
                    backgroundColor:
                        result == null ? Colors.green : Colors.red,
                  ),
                );
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
