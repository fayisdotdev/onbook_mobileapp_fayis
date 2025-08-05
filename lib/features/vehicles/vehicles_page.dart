import 'package:flutter/material.dart';
import 'package:onbook_app/features/vehicles/add_vehicles.dart';
import 'package:onbook_app/general/models/vehicles/vehcles_model.dart';
import 'package:onbook_app/general/providers/auth_provider.dart';
import 'package:onbook_app/general/providers/vehicles_provider.dart';
import 'package:onbook_app/general/themes/app_colors.dart';
import 'package:onbook_app/general/themes/app_fonts.dart';
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
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  shadowColor: Colors.black.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: vehicle.imageUrl.isNotEmpty
                              ? Image.network(
                                  vehicle.imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.directions_car,
                                    size: 48,
                                    color: Colors.black45,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vehicle.carModel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // style: AppFonts.bold15,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              _infoRow("Number Plate", vehicle.numberPlate),
                              _infoRow("VIN", vehicle.vin),
                              if (vehicle.year.isNotEmpty)
                                _infoRow("Year", vehicle.year),
                              if (vehicle.make.isNotEmpty)
                                _infoRow("Make", vehicle.make),
                              if (vehicle.ownerName.isNotEmpty)
                                _infoRow("Owner", vehicle.ownerName),
                              if (vehicle.color.isNotEmpty)
                                _infoRow("Color", vehicle.color),
                            ],
                          ),
                        ),
                      ],
                    ),
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.grey,
              // AppFonts.medium13.copyWith(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                // AppFonts.regular13.copyWith(color: Colors.black),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
