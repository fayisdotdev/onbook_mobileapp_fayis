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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
        child: Column(
          children: [
            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search Your Vehicle',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),

            Expanded(
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

                  // 🔎 Filtering logic
                  final filteredVehicles = vehicles.where((vehicle) {
                    final query = _searchQuery.toLowerCase();
                    return vehicle.carModel.toLowerCase().contains(query) ||
                        vehicle.numberPlate.toLowerCase().contains(query) ||
                        vehicle.make.toLowerCase().contains(query) ||
                        vehicle.ownerName.toLowerCase().contains(query);
                  }).toList();

                  if (filteredVehicles.isEmpty) {
                    return Center(
                      child: Text(
                        'No vehicles found for "$_searchQuery"',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredVehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = filteredVehicles[index];
                      return _buildVehicleCard(vehicle);
                    },
                  );
                },
              ),
            ),
          ],
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

  Widget _buildVehicleCard(VehicleModel vehicle) {
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
          infoRow3(
            'Model', vehicle.carModel,
            'Number Plate', vehicle.numberPlate,
            'Owner', vehicle.ownerName,
          ),
          const Divider(),
          infoRow3(
            'Year', vehicle.year,
            'Make', vehicle.make,
            'Color', vehicle.color,
          ),
        ],
      ),
    );
  }

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
    String label1, String value1,
    String label2, String value2,
    String label3, String value3,
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

