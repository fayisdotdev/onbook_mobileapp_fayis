import 'package:flutter/material.dart';
import 'package:onbook_app/features/bookings/add_bookings_page.dart';
import 'package:onbook_app/general/models/shop/shop_public_model.dart';
import 'package:onbook_app/general/themes/app_colors.dart';
import 'package:onbook_app/features/chats/chat_screen.dart';

class ShopDetailScreen extends StatelessWidget {
  final ShopPublicModel shop;

  const ShopDetailScreen({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final fullAddress =
        [
          shop.address1,
          shop.address2,
          shop.city,
          shop.province,
          shop.postcode,
          shop.country,
        ]
        .where((element) => element != null && element.trim().isNotEmpty)
        .join(', ');

    return Scaffold(
      appBar: AppBar(
        title: Text(shop.shopName ?? 'Shop Details'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Cover image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: shop.imageUrl != null && shop.imageUrl!.isNotEmpty
                  ? Image.network(
                      shop.imageUrl!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      'assets/images/norm.png',
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 20),

            /// Shop name
            Text(
              shop.shopName ?? 'Unnamed Shop',
              style: AppColors.poppinsBold(fontSize: 22),
            ),
            const SizedBox(height: 6),

            /// Status badge
            if (shop.status != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  shop.status!.name.toUpperCase(),
                  style: AppColors.poppinsRegular(
                    fontSize: 12,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),

            const SizedBox(height: 16),
            Divider(),
            const SizedBox(height: 10),

            /// Info tiles
            _infoTile('👤 Owner', shop.ownerName),
            _infoTile('📞 Phone', shop.phoneNumber),
            _infoTile('✉️ Email', shop.shopEmail),
            _infoTile('🌐 Website', shop.website),
            _infoTile('📍 Address', fullAddress),

            const SizedBox(height: 16),

            /// Booking button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddBookingPage(shop: shop),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            /// Call & Message buttons under Book Now
            const SizedBox(height: 12),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.phone, color: Colors.white),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '📞 You pressed Call for ${shop.shopName ?? 'this shop'}',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.message, color: Colors.white),
                    label: const Text('Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            shopId: shop.shopId ?? '',
                            shopName: shop.shopName ?? '',
                            shopCity: shop.city,
                            shopEmail: shop.shopEmail ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Certifications
            if (shop.certifications != null && shop.certifications!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Certifications',
                    style: AppColors.poppinsBold(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ...shop.certifications!.map(
                    (cert) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified,
                            size: 18,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Certified as ${cert.certificationName} (${cert.certificationNumber ?? 'N/A'})",
                              style: AppColors.poppinsRegular(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: ', style: AppColors.poppinsBold(fontSize: 14)),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: AppColors.poppinsRegular(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}