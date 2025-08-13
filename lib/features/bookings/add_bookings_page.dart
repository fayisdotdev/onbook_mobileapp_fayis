import 'package:flutter/material.dart';
import 'package:onbook_app/general/providers/shop_provider.dart';
import 'package:onbook_app/general/providers/vehicles_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:onbook_app/general/providers/auth_provider.dart';
import 'package:onbook_app/general/models/vehicles/vehcles_model.dart';
import 'package:onbook_app/general/providers/booking_provider.dart';
import 'package:onbook_app/general/models/shop/shop_public_model.dart';

class AddBookingPage extends StatefulWidget {
  final ShopPublicModel shop;

  const AddBookingPage({super.key, required this.shop});

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
  VehicleModel? selectedVehicle;
  List<VehicleModel> userVehicles = [];
  final notesController = TextEditingController();
  bool previewMode = false;
  bool loadingVehicles = true;

@override
void initState() {
  super.initState();
  _loadVehicles();
}


  Future<void> _loadVehicles() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final vehicleProvider = Provider.of<VehicleProvider>(
      context,
      listen: false,
    );
    if (authProvider.consumerDocId != null) {
      final vehicles = await vehicleProvider.fetchVehicles(
        authProvider.consumerDocId!,
      );
      setState(() {
        userVehicles = vehicles;
        loadingVehicles = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Book at ${widget.shop.shopName}'),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
      ),
      body: loadingVehicles
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  calendarView(),
                  const SizedBox(height: 12),
                  timeSlotSelector(),
                  const SizedBox(height: 12),
                  serviceGrid(),
                  const SizedBox(height: 12),
                  vehicleSelector(),
                  const SizedBox(height: 12),
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: bookingProvider.isSaving
                          ? null
                          : () async {
                              if (!previewMode) {
                                if (!_validateForm()) return;
                                setState(() => previewMode = true);
                              } else {
                                await _saveBooking(context);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: previewMode
                            ? Colors.green
                            : Colors.red.shade800,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: bookingProvider.isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(previewMode ? 'Confirm Booking' : 'Next'),
                    ),
                  ),
                  if (previewMode) const SizedBox(height: 20),
                  if (previewMode) previewCard(),
                ],
              ),
            ),
    );
  }

  bool _validateForm() {
    if (selectedTime == null) {
      _showError("Please select a time slot");
      return false;
    }
    if (selectedServices.isEmpty) {
      _showError("Please select at least one service");
      return false;
    }
    if (selectedVehicle == null) {
      _showError("Please select a vehicle");
      return false;
    }
    return true;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

Future<void> _saveBooking(BuildContext context) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final shopProvider = Provider.of<ShopPublicProvider>(context, listen: false);
  final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

  try {
    await bookingProvider.createBooking(
      authProvider: authProvider,
      shopProvider: shopProvider, // ✅ NEW
      date: selectedDate,
      timeSlot: selectedTime!,
      services: selectedServices,
      notes: notesController.text,
      vehicle: selectedVehicle!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking Confirmed!'),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {
      previewMode = false;
      selectedDate = DateTime.now();
      selectedTime = null;
      selectedServices.clear();
      selectedVehicle = null;
      notesController.clear();
    });

    Navigator.pop(context); // ✅ Auto-close after booking
  } catch (e) {
    _showError("Error saving booking: $e");
  }
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
            color: Colors.red.shade900,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.red.shade900),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Colors.red.shade900,
          ),
        ),
      ),
    );
  }

  Widget timeSlotSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Time",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
        const Text(
          "Select Services",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
        const Text(
          "Select Vehicle",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<VehicleModel>(
          value: selectedVehicle,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          items: userVehicles.map((v) {
            return DropdownMenuItem(
              value: v,
              child: Text("${v.make} ${v.carModel} - ${v.numberPlate}"),
            );
          }).toList(),
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
          Text("🏪 Shop: ${widget.shop.shopName}"),
          Text("📅 Date: ${DateFormat.yMMMMd().format(selectedDate)}"),
          Text("⏰ Time: ${selectedTime ?? 'Not selected'}"),
          Text(
            "🚗 Vehicle: ${selectedVehicle != null ? "${selectedVehicle!.make} ${selectedVehicle!.carModel}" : 'Not selected'}",
          ),
          Text(
            "🛠️ Services: ${selectedServices.isEmpty ? 'None' : selectedServices.join(', ')}",
          ),
          Text(
            "📝 Notes: ${notesController.text.isEmpty ? 'No notes' : notesController.text}",
          ),
        ],
      ),
    );
  }
}
