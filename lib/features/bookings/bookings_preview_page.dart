import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onbook_app/features/bookings/bookings_details_page.dart';
import 'package:onbook_app/general/providers/auth_provider.dart';
import 'package:onbook_app/general/providers/booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingsPreviewScreen extends StatefulWidget {
  const BookingsPreviewScreen({super.key});

  @override
  State<BookingsPreviewScreen> createState() => _BookingsPreviewScreenState();
}

class _BookingsPreviewScreenState extends State<BookingsPreviewScreen> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> allBookings = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final authProvider = context.read<AuthProvider>();
    final bookingProvider = context.read<BookingProvider>();

    setState(() => isLoading = true);

    final bookings = await bookingProvider.fetchBookings(authProvider);

    setState(() {
      allBookings = bookings;
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> get bookingsForSelectedDate {
    return allBookings.where((booking) {
      final bookingDate =
          (booking['bookingDetails']?['date'] as Timestamp?)?.toDate() ??
          DateTime.now();
      return DateUtils.isSameDay(bookingDate, selectedDate);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Calendar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: selectedDate,
            selectedDayPredicate: (day) => isSameDay(day, selectedDate),
            onDaySelected: (selectedDay, _) {
              setState(() => selectedDate = selectedDay);
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.red.shade700,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.red.shade400,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
              weekendTextStyle: const TextStyle(color: Colors.redAccent),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.redAccent),
              weekdayStyle: TextStyle(color: Colors.black87),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: Colors.red.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Colors.red.shade900,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.red.shade900,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Booking List
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : bookingsForSelectedDate.isEmpty
              ? const Center(child: Text("No bookings on this day."))
              : ListView.builder(
                  itemCount: bookingsForSelectedDate.length,
                  itemBuilder: (context, index) {
                    final booking = bookingsForSelectedDate[index];
                    final shop = booking['shop'] ?? {};
                    final bookingDetails = booking['bookingDetails'] ?? {};
                    final bookingDate = (bookingDetails['date'] as Timestamp?)
                        ?.toDate();
                    final vehicle = booking['vehicle'] ?? {};
                    final services =
                        (bookingDetails['services'] as List?)?.join(', ') ??
                        'N/A';

                    // ...existing code...
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BookingDetailsPage(booking: booking),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Shop Name
                                Text(
                                  shop['name']?.toString() ?? 'Unnamed Garage',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                // Shop City
                                Text(
                                  shop['city']?.toString() ??
                                      'Unknown Location',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),

                                const Divider(color: Colors.black),

                                // Date
                                Text(
                                  'Date: ${bookingDate != null ? DateFormat.yMMMMd().format(bookingDate) : 'N/A'}',
                                  style: const TextStyle(fontSize: 14),
                                ),

                                // Time
                                Text(
                                  'Time: ${bookingDetails['timeSlot'] ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const Divider(color: Colors.black),
                                // Vehicle
                                Text(
                                  'Vehicle: ${vehicle['numberPlate'] ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const Divider(color: Colors.black),

                                // Services
                                Text(
                                  'Services: $services',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                    // ...existing code...
                  },
                ),
        ),
      ],
    );
  }
}
