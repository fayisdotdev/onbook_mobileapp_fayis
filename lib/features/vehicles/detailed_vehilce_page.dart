import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onbook_app/general/models/vehicles/vehcles_model.dart';
import 'package:onbook_app/general/providers/auth_provider.dart';
import 'package:onbook_app/general/providers/vehicles_provider.dart';
import 'package:onbook_app/general/themes/app_colors.dart';

class VehicleDetailPagerScreen extends StatefulWidget {
  final List<VehicleModel> vehicles;
  final int initialIndex;

  const VehicleDetailPagerScreen({
    super.key,
    required this.vehicles,
    required this.initialIndex,
  });

  @override
  State<VehicleDetailPagerScreen> createState() =>
      _VehicleDetailPagerScreenState();
}

class _VehicleDetailPagerScreenState extends State<VehicleDetailPagerScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.vehicles.length,
        itemBuilder: (context, index) {
          return VehicleDetailPage(vehicle: widget.vehicles[index]);
        },
      ),
    );
  }
}

class VehicleDetailPage extends StatefulWidget {
  final VehicleModel vehicle;

  const VehicleDetailPage({super.key, required this.vehicle});

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> {
  late TextEditingController _modelController;
  late TextEditingController _plateController;
  late TextEditingController _ownerController;
  late TextEditingController _yearController;
  late TextEditingController _makeController;
  late TextEditingController _colorController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _modelController = TextEditingController(text: widget.vehicle.carModel);
    _plateController = TextEditingController(text: widget.vehicle.numberPlate);
    _ownerController = TextEditingController(text: widget.vehicle.ownerName);
    _yearController = TextEditingController(text: widget.vehicle.year);
    _makeController = TextEditingController(text: widget.vehicle.make);
    _colorController = TextEditingController(text: widget.vehicle.color);
  }

  Future<void> _saveChanges() async {
    final userDocId =
        Provider.of<AuthProvider>(context, listen: false).consumerDocId;
    if (userDocId == null) return;

    final updated = widget.vehicle.copyWith(
      carModel: _modelController.text,
      numberPlate: _plateController.text,
      ownerName: _ownerController.text,
      year: _yearController.text,
      make: _makeController.text,
      color: _colorController.text,
    );

    await Provider.of<VehicleProvider>(context, listen: false)
        .updateVehicle(updated, userDocId);

    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Vehicle updated")),
    );
  }

  Future<void> _deleteVehicle() async {
    final userDocId =
        Provider.of<AuthProvider>(context, listen: false).consumerDocId;
    if (userDocId == null) return;

    await Provider.of<VehicleProvider>(context, listen: false)
        .deleteVehicle(widget.vehicle.uid, userDocId);

    Navigator.pop(context, true); // exit pager after delete
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bggrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.secondary,
        title: Text(
          widget.vehicle.carModel,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: _buildFABs(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildImage(),
            const SizedBox(height: 20),
            _buildDetailCard("Car Model", _modelController),
            _buildDetailCard("Number Plate", _plateController),
            _buildDetailCard("Owner Name", _ownerController),
            _buildDetailCard("Year", _yearController),
            _buildDetailCard("Make", _makeController),
            _buildDetailCard("Color", _colorController),
          ],
        ),
      ),
    );
  }

  Widget _buildFABs() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(
          heroTag: "editSave",
          backgroundColor: _isEditing ? Colors.green : AppColors.primaryColor,
          icon: Icon(_isEditing ? Icons.check : Icons.edit),
          label: Text(_isEditing ? "Save" : "Edit"),
          onPressed: () {
            if (_isEditing) {
              _saveChanges();
            } else {
              setState(() => _isEditing = true);
            }
          },
        ),
        const SizedBox(height: 12),
        FloatingActionButton.extended(
          heroTag: "delete",
          backgroundColor: Colors.red.shade600,
          icon: const Icon(Icons.delete),
          label: const Text("Delete"),
          onPressed: _deleteVehicle,
        ),
      ],
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: widget.vehicle.imageUrl.isNotEmpty
          ? Image.network(
              widget.vehicle.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          : Container(
              height: 200,
              color: Colors.grey[200],
              child: const Icon(Icons.directions_car,
                  size: 100, color: Colors.black45),
            ),
    );
  }

  Widget _buildDetailCard(String label, TextEditingController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextField(
          controller: controller,
          enabled: _isEditing,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
