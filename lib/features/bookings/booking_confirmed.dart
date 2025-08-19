import 'package:flutter/material.dart';
import 'package:onbook_app/general/models/shop/shop_public_model.dart';
import 'package:onbook_app/general/models/vehicles/vehcles_model.dart';
import 'package:onbook_app/features/approot/app_root.dart';
import 'package:intl/intl.dart';

class BookingConfirmedPage extends StatelessWidget {
  final ShopPublicModel shop;
  final DateTime date;
  final String timeSlot;
  final VehicleModel vehicle;
  final List<String> services;
  final String notes;

  const BookingConfirmedPage({
    super.key,
    required this.shop,
    required this.date,
    required this.timeSlot,
    required this.vehicle,
    required this.services,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AppRoot(initialTabIndex: 0)),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking Confirmed'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AppRoot(initialTabIndex: 0)),
                (route) => false,
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your booking is confirmed!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text('🏪 Shop: ${shop.shopName}'),
              Text('📍 Location: ${shop.city ?? ''}, ${shop.country ?? ''}'),
              const Divider(),
              Text('📅 Date: ${DateFormat.yMMMMd().format(date)}'),
              Text('⏰ Time: $timeSlot'),
              const Divider(),
              Text('🚗 Vehicle: ${vehicle.make} ${vehicle.carModel} (${vehicle.numberPlate})'),
              const Divider(),
              Text('🛠️ Services: ${services.join(', ')}'),
              const Divider(),
              Text('📝 Notes: ${notes.isEmpty ? 'No notes' : notes}'),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.home),
                      label: const Text('Go to Home'),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const AppRoot(initialTabIndex: 0)),
                          (route) => false,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.book_online),
                      label: const Text('Go to My Bookings'),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const AppRoot(initialTabIndex: 1)),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

