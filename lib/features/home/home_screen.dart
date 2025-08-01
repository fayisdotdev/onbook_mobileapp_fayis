import 'package:flutter/material.dart';
import 'package:onbook_app/general/providers/auth_provider.dart';
import 'package:onbook_app/general/providers/shop_provider.dart';
import 'package:onbook_app/general/themes/app_colors.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final shopProvider = Provider.of<ShopPublicProvider>(
      context,
      listen: false,
    );

    final userData = authProvider.userData;
    final role = userData?['role'];
    final shopId = userData?['shopId'];

    if (role == 'consumer' || shopId == null) {
      debugPrint(
        '👤 Logged in as consumer or missing shopId. Fetching all public shops...',
      );
      shopProvider.fetchAllShops();
    } else {
      debugPrint('🏪 Logged in as shop owner. Fetching shop with ID: $shopId');
      shopProvider.fetchShop(shopId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final shopProvider = Provider.of<ShopPublicProvider>(context);

    final userData = authProvider.userData;
    final name = userData?['name'] ?? 'Unknown User';
    final email = userData?['email'] ?? 'Unknown Email';
    final role = userData?['role'] ?? 'unknown';

    final shop = shopProvider.shop;
    final isLoading = shopProvider.isLoading;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Icon(Icons.home, size: 80, color: AppColors.primaryColor),
              const SizedBox(height: 20),
              Text(
                'Welcome to OnBook!',
                style: AppColors.poppinsBold(
                  fontSize: 24,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Hi - $name',
                style: AppColors.poppinsRegular(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Email: $email',
                style: AppColors.poppinsRegular(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 30),

              /// Content based on user type
              if (isLoading)
                const CircularProgressIndicator()
              else if (role == 'consumer' || shop == null)
                _buildPublicShopList(shopProvider)
              else
                _buildShopCard(shop),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopCard(shop) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              'assets/images/services_img.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shop Name: ${shop.shopName ?? 'N/A'}',
                  style: AppColors.poppinsBold(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text('Phone: ${shop.phoneNumber ?? 'N/A'}'),
                Text('Website: ${shop.website ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Owner: ${shop.ownerName ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Location: ${shop.city ?? ''}, ${shop.province ?? ''}'),
                const SizedBox(height: 8),
                Text('Country: ${shop.country ?? 'N/A'}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildPublicShopList(ShopPublicProvider shopProvider) {
  final shops = shopProvider.availableShops;

  if (shops.isEmpty) {
    debugPrint('❌ No public shops found in Firestore or none are approved.');
    return const Text('No public shops available at the moment.');
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Explore Shops',
            style: AppColors.poppinsBold(fontSize: 18),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${shops.length}',
              style: AppColors.poppinsRegular(
                fontSize: 14,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      ...shops.map(
        (shop) => Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  'assets/images/services_img.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                ),
              ),
              ListTile(
                title: Text(shop.shopName ?? 'No Name'),
                subtitle: Text(shop.city ?? 'Unknown Location'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  debugPrint('➡️ Tapped on shop: ${shop.shopName}');
                },
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

}
