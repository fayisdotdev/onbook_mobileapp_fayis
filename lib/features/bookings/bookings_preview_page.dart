import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class BookingsPreviewScreen extends StatefulWidget {
  const BookingsPreviewScreen({super.key});

  @override
  State<BookingsPreviewScreen> createState() => _BookingsPreviewScreenState();
}

class _BookingsPreviewScreenState extends State<BookingsPreviewScreen> {
  DateTime selectedDate = DateTime.now();

  final List<Map<String, dynamic>> allBookings = [
    {
      'id': 'G001',
      'garageName': 'SpeedFix Garage',
      'place': 'Downtown Toronto, ON',
      'date': DateTime.now(),
      'time': '9:30 AM',
    },
    {
      'id': 'G002',
      'garageName': 'AutoCare Pro',
      'place': 'Richmond, Vancouver, BC',
      'date': DateTime.now(),
      'time': '11:00 AM',
    },
    {
      'id': 'G003',
      'garageName': 'QuickTune Workshop',
      'place': 'Scarborough, ON',
      'date': DateTime.now().add(const Duration(days: 1)),
      'time': '3:00 PM',
    },
    {
      'id': 'G004',
      'garageName': 'FixItFast Garage',
      'place': 'Calgary NW, AB',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'time': '2:00 PM',
    },
    {
      'id': 'G005',
      'garageName': 'MasterMech Garage',
      'place': 'Ottawa South, ON',
      'date': DateTime.now(),
      'time': '5:00 PM',
    },
  ];

  List<Map<String, dynamic>> get bookingsForSelectedDate {
    return allBookings
        .where((booking) =>
            DateUtils.isSameDay(booking['date'] as DateTime, selectedDate))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Calendar container with padding and shadow
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
              setState(() {
                selectedDate = selectedDay;
              });
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
          child: bookingsForSelectedDate.isEmpty
              ? const Center(child: Text("No bookings on this day."))
              : ListView.builder(
                  itemCount: bookingsForSelectedDate.length,
                  itemBuilder: (context, index) {
                    final booking = bookingsForSelectedDate[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
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
                              Text(
                                'Booking ID: ${booking['id'] ?? 'N/A'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                booking['garageName']?.toString() ??
                                    'Unnamed Garage',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                booking['place']?.toString() ??
                                    'Unknown Location',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const Divider(height: 20),
                              Text(
                                'Date: ${DateFormat.yMMMMd().format(booking['date'] ?? DateTime.now())}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Time: ${booking['time'] ?? 'N/A'}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
