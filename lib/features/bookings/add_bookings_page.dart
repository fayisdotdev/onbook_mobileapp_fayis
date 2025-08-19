import 'package:flutter/material.dart';
import 'package:onbook_app/features/bookings/booking_confirmed.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).setShop(widget.shop);
    });
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

  DateTime _combineDateAndTime(DateTime date, String timeSlot) {
    final timeParts = timeSlot.split(' ');
    final hourMinute = timeParts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);
    final isPM = timeParts[1].toLowerCase() == 'pm';
    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
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
    final bookingProvider = Provider.of<BookingProvider>(
      context,
      listen: false,
    );

    try {
      final bookingDateTime = _combineDateAndTime(selectedDate, selectedTime!);

      final success = await bookingProvider.createBooking(
        authProvider: authProvider,
        date: bookingDateTime,
        timeSlot: selectedTime!,
        services: selectedServices,
        notes: notesController.text,
        vehicle: selectedVehicle!,
      );

      // ...existing code...
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BookingConfirmedPage(
              shop: widget.shop,
              date: bookingDateTime,
              timeSlot: selectedTime!,
              vehicle: selectedVehicle!,
              services: selectedServices,
              notes: notesController.text,
            ),
          ),
        );
      } else {
        final errorMsg = bookingProvider.errorMessage ?? "Could not book slot.";
        _showError(errorMsg);
      }
      // ...existing code...
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
          todayDecoration: const BoxDecoration(),
          selectedDecoration: const BoxDecoration(),
          weekendTextStyle: const TextStyle(color: Colors.black),
          defaultTextStyle: const TextStyle(color: Colors.black),
        ),
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, day, focusedDay) {
            final isToday = isSameDay(day, DateTime.now());
            if (isToday) {
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          todayBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
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
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.5,
          children: timeSlots.map((slot) {
            final isSelected = selectedTime == slot;
            return ChoiceChip(
              label: Text(slot),
              selected: isSelected,
              onSelected: (_) => setState(() => selectedTime = slot),
              selectedColor: Colors.red.shade200,
              backgroundColor: Colors.white,
              side: BorderSide(
                color: isSelected ? Colors.red.shade800 : Colors.grey.shade400,
                width: 1.2,
              ),
              labelStyle: TextStyle(
                color: isSelected ? Colors.red.shade900 : Colors.black,
                fontWeight: FontWeight.w500,
              ),
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
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 3.2,
          children: services.map((service) {
            final isSelected = selectedServices.contains(service);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedServices.remove(service);
                  } else {
                    selectedServices.add(service);
                  }
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red.shade200 : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? Colors.red.shade800
                        : Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  service,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.red.shade900 : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
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
