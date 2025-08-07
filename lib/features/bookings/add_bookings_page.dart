import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AddBookingPage extends StatefulWidget {
  const AddBookingPage({super.key});

  @override
  State<AddBookingPage> createState() => _AddBookingPageState();
}

class _AddBookingPageState extends State<AddBookingPage> {
  DateTime selectedDate = DateTime.now();
  String? selectedTime;
  final List<String> timeSlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '1:00 PM',
    '2:00 PM',
    '4:00 PM',
  ];

  final List<String> services = [
    'Oil Change',
    'Brake Inspection',
    'Tire Rotation',
    'Battery Check',
    'AC Service',
    'Engine Diagnostics',
    'Car Wash',
    'Wheel Alignment',
  ];

  List<String> selectedServices = [];
  String? selectedVehicle;
  final notesController = TextEditingController();
  bool previewMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Booking'),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Calendar
            calendarView(),

            const SizedBox(height: 12),

            /// Time slots
            timeSlotSelector(),

            const SizedBox(height: 12),

            /// Services
            serviceGrid(),

            const SizedBox(height: 12),

            /// Vehicle dropdown
            vehicleSelector(),

            const SizedBox(height: 12),

            /// Notes
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            /// Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!previewMode) {
                    setState(() => previewMode = true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Booking Confirmed (Dummy)'),
                      backgroundColor: Colors.green,
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      previewMode ? Colors.green : Colors.red.shade800,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(previewMode ? 'Confirm Booking' : 'Next'),
              ),
            ),

            if (previewMode) const SizedBox(height: 20),

            if (previewMode) previewCard(),
          ],
        ),
      ),
    );
  }

  Widget calendarView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      padding: const EdgeInsets.all(8),
      child: TableCalendar(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: selectedDate,
        selectedDayPredicate: (day) => isSameDay(day, selectedDate),
        onDaySelected: (selected, _) {
          setState(() => selectedDate = selected);
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Colors.red.shade700,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.red.shade300,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
              color: Colors.red.shade900, fontWeight: FontWeight.bold),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.red.shade900),
          rightChevronIcon:
              Icon(Icons.chevron_right, color: Colors.red.shade900),
        ),
      ),
    );
  }

  Widget timeSlotSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Time", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: timeSlots.map((slot) {
            final isSelected = selectedTime == slot;
            return ChoiceChip(
              label: Text(slot),
              selected: isSelected,
              onSelected: (_) => setState(() => selectedTime = slot),
              selectedColor: Colors.red.shade200,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget serviceGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Services", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: 42,
          ),
          itemBuilder: (context, index) {
            final service = services[index];
            final isSelected = selectedServices.contains(service);
            return FilterChip(
              label: Text(service),
              selected: isSelected,
              onSelected: (value) {
                setState(() {
                  if (value) {
                    selectedServices.add(service);
                  } else {
                    selectedServices.remove(service);
                  }
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget vehicleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Vehicle", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedVehicle,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          items: const [
            DropdownMenuItem(value: 'Toyota Corolla', child: Text('Toyota Corolla')),
            DropdownMenuItem(value: 'Honda Civic', child: Text('Honda Civic')),
            DropdownMenuItem(value: 'Ford F-150', child: Text('Ford F-150')),
          ],
          onChanged: (value) => setState(() => selectedVehicle = value),
        ),
      ],
    );
  }

  Widget previewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.red.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("📅 Date: ${DateFormat.yMMMMd().format(selectedDate)}"),
          Text("⏰ Time: ${selectedTime ?? 'Not selected'}"),
          Text("🚗 Vehicle: ${selectedVehicle ?? 'Not selected'}"),
          Text("🛠️ Services: ${selectedServices.isEmpty ? 'None' : selectedServices.join(', ')}"),
          Text("📝 Notes: ${notesController.text.isEmpty ? 'No notes' : notesController.text}"),
        ],
      ),
    );
  }
}
