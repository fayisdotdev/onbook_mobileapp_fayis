import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:onbook_app/features/vehicles/add_vehicles.dart';
import 'package:onbook_app/general/models/vehicles/vehcles_model.dart';
import 'package:onbook_app/general/providers/auth_provider.dart';
import 'package:onbook_app/general/providers/vehicles_provider.dart';
import 'package:onbook_app/general/themes/app_colors.dart';
import 'package:provider/provider.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  late Future<List<VehicleModel>> _vehiclesFuture;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  void _loadVehicles() {
    final userDocId = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).consumerDocId;
    if (userDocId != null) {
      _vehiclesFuture = Provider.of<VehicleProvider>(
        context,
        listen: false,
      ).fetchVehicles(userDocId);
    }
  }

  Future<void> _refreshVehicles() async {
    _loadVehicles();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userDocId = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).consumerDocId;

    if (userDocId == null) {
      return const Center(child: Text('User not found'));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshVehicles,
        child: FutureBuilder<List<VehicleModel>>(
          future: _vehiclesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Failed to load vehicles'));
            }

            final vehicles = snapshot.data ?? [];

            if (vehicles.isEmpty) {
              return const Center(child: Text('No vehicles found.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehicle Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: vehicle.imageUrl.isNotEmpty
                            ? Image.network(
                                vehicle.imageUrl,
                                width: double.infinity,
                                height: 160,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: double.infinity,
                                height: 160,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.directions_car,
                                  size: 64,
                                  color: Colors.black45,
                                ),
                              ),
                      ),
                      const Gap(12),

                      // First row
                      infoRow3(
                        'Model',
                        vehicle.carModel,
                        'Number Plate',
                        vehicle.numberPlate,
                        'Owner',
                        vehicle.ownerName,
                      ),
                      const Divider(),

                      // Second row
                      infoRow3(
                        'Year',
                        vehicle.year,
                        'Make',
                        vehicle.make,
                        'Color',
                        vehicle.color,
                      ),
                      const Divider(),

                      // // Third row (conditionally)
                      // if (vehicle.vin.isNotEmpty) ...[
                      //   infoRow3('VIN', vehicle.vin, '', '', '', ''),
                      //   const Divider(),
                      // ],
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddVehicleScreen()),
          );
          _refreshVehicles();
        },
        backgroundColor: AppColors.primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Vehicle'),
      ),
    );
  }

  // Moved this function above infoRow3 to fix reference error
  Widget labelValue(String label, String value) {
    if (label.isEmpty || value.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget infoRow3(
    String label1,
    String value1,
    String label2,
    String value2,
    String label3,
    String value3,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: labelValue(label1, value1)),
          Expanded(child: labelValue(label2, value2)),
          Expanded(child: labelValue(label3, value3)),
        ],
      ),
    );
  }
}
