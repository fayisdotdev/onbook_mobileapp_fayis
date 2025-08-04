import 'package:flutter/material.dart';
import 'package:onbook_app/features/vehicles/add_vehicles.dart';
import 'package:onbook_app/general/models/vehicles/vehcles_model.dart';
import 'package:onbook_app/general/providers/auth_provider.dart';
import 'package:onbook_app/general/providers/vehicles_provider.dart';
import 'package:provider/provider.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

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
      // appBar: AppBar(title: const Text('My Vehicles')),
      body: FutureBuilder<List<VehicleModel>>(
        future: Provider.of<VehicleProvider>(
          context,
          listen: false,
        ).fetchVehicles(userDocId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return const Center(child: Text('Failed to load vehicles'));
          final vehicles = snapshot.data ?? [];

          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return ListTile(
                leading: Image.network(
                  vehicle.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(vehicle.carModel),
                subtitle: Text(vehicle.numberPlate),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddVehicleScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
