import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onbook_app/general/themes/app_icons.dart';
import 'package:provider/provider.dart';
import 'package:onbook_app/general/providers/booking_provider.dart';
// import 'package:onbook_app/assets/icons/app_icons.dart'; // adjust path if needed

class BookingDetailsPage extends StatelessWidget {
  final Map<String, dynamic> booking;
  const BookingDetailsPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final shop = booking['shop'] ?? {};
    final bookingDetails = booking['bookingDetails'] ?? {};
    final vehicle = booking['vehicle'] ?? {};
    final services = (bookingDetails['services'] as List?)?.join(', ') ?? 'N/A';
    final notes = bookingDetails['notes'] ?? '';
    final date = bookingDetails['date'] != null
        ? (bookingDetails['date'] as Timestamp).toDate()
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(AppIcons.backbttn, height: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _detailCard(
              context,
              title: "Shop Information",
              icon: AppIcons.locationIcon,
              children: [
                _detailRow("Shop", shop['name']),
                _detailRow("City", shop['city']),
                _detailRow("Address", shop['address']),
              ],
            ),
            const SizedBox(height: 12),
            _detailCard(
              context,
              title: "Booking Details",
              icon: AppIcons.repairicon,
              children: [
                _detailRow(
                  "Date",
                  date != null
                      ? "${date.day}-${date.month}-${date.year}"
                      : "N/A",
                ),
                _detailRow("Time", bookingDetails['timeSlot']),
                _detailRow("Services", services),
                _detailRow("Notes", notes.isEmpty ? "No notes" : notes),
              ],
            ),
            const SizedBox(height: 12),
            _detailCard(
              context,
              title: "Vehicle Information",
              icon: AppIcons.vehicles,
              children: [
                _detailRow("Plate No.", vehicle['numberPlate']),
                _detailRow("Make", vehicle['make']),
                _detailRow("Model", vehicle['carModel']),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete, color: Colors.white),
              label: const Text("Delete Booking"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 28),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    title: const Text('Delete Booking'),
                    content: const Text(
                        'Are you sure you want to delete this booking?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          )),
                    ],
                  ),
                );
                if (confirmed == true) {
                  final provider =
                      Provider.of<BookingProvider>(context, listen: false);
                  await provider.deleteBooking(booking);
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _detailCard(BuildContext context,
      {required String title,
      required String icon,
      required List<Widget> children}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(icon, height: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Flexible(
            child: Text(
              value?.toString() ?? "N/A",
              textAlign: TextAlign.right,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
