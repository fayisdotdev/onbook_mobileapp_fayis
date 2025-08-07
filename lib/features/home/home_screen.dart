import 'package:flutter/material.dart';
import 'package:onbook_app/features/shops/shop_detailed_page.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final shopProvider = Provider.of<ShopPublicProvider>(
      context,
      listen: false,
    );

    final userData = authProvider.userData;
    final role = userData?['role'];
    final shopId = userData?['shopId'];

    if (role == 'consumer' || shopId == null) {
      await shopProvider.fetchAllShops();
    } else {
      await shopProvider.fetchShop(shopId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final shopProvider = Provider.of<ShopPublicProvider>(context);

    final userData = authProvider.userData;
    final name = userData?['name'] ?? 'User';
    final role = userData?['role'] ?? 'unknown';
    final shop = shopProvider.shop;
    final isLoading = shopProvider.isLoading;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Greeting
              Text(
                'Hi, $name ',
                style: AppColors.poppinsBold(
                  fontSize: 22,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Find a nearby shop',
                style: AppColors.poppinsRegular(fontSize: 16),
              ),
              const SizedBox(height: 20),

              /// Search Bar
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search shops by name or location..',
                  hintStyle: const TextStyle(fontSize: 10),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              /// Conditional Content
              if (isLoading)
                const Center(child: CircularProgressIndicator())
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                  shop.shopName ?? 'Shop Name',
                  style: AppColors.poppinsBold(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text('📞 Phone: ${shop.phoneNumber ?? 'N/A'}'),
                Text('🌐 Website: ${shop.website ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('👤 Owner: ${shop.ownerName ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('📍 Location: ${shop.city ?? ''}, ${shop.province ?? ''}'),
                Text('🌎 Country: ${shop.country ?? 'N/A'}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicShopList(ShopPublicProvider shopProvider) {
    final allShops = shopProvider.availableShops;

    // Apply filtering
    final filteredShops = allShops.where((shop) {
      final query = _searchQuery.toLowerCase();
      return (shop.shopName ?? '').toLowerCase().contains(query) ||
          (shop.city ?? '').toLowerCase().contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title & Count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Explore Shops', style: AppColors.poppinsBold(fontSize: 20)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${filteredShops.length}',
                style: AppColors.poppinsRegular(
                  fontSize: 14,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (filteredShops.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'No shops found for "$_searchQuery"',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          )
        else
          ...filteredShops.map(
            (shop) => Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: shop.imageUrl != null && shop.imageUrl!.isNotEmpty
                        ? Image.network(
                            shop.imageUrl!,
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: 140,
                          )
                        : Image.asset(
                            'assets/images/norm.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 140,
                          ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      shop.shopName ?? 'No Name',
                      style: AppColors.poppinsBold(fontSize: 16),
                    ),
                    subtitle: Text(
                      shop.city ?? 'Unknown Location',
                      style: AppColors.poppinsRegular(color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      debugPrint('➡️ Tapped on shop: ${shop.shopName}');
                      // 👇 Add this navigation
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShopDetailScreen(shop: shop),
                        ),
                      );
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
