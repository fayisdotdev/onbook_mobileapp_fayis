import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:onbook_app/general/providers/booking_provider.dart';

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
    final bookingId = booking['serviceName'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shop: ${shop['name'] ?? ''}'),
            Text('City: ${shop['city'] ?? ''}'),
            const Divider(),
            Text('Date: ${bookingDetails['date'] != null ? (bookingDetails['date'] as Timestamp).toDate().toString() : 'N/A'}'),
            Text('Time: ${bookingDetails['timeSlot'] ?? 'N/A'}'),
            const Divider(),
            Text('Vehicle: ${vehicle['numberPlate'] ?? 'N/A'}'),
            Text('Services: $services'),
            Text('Notes: ${notes.isEmpty ? 'No notes' : notes}'),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text('Delete Booking'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Booking'),
                    content: const Text('Are you sure you want to delete this booking?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                    ],
                  ),
                );
                if (confirmed == true) {
                  final provider = Provider.of<BookingProvider>(context, listen: false);
                  await provider.deleteBooking(booking);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}