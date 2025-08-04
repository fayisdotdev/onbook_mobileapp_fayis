import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
import 'package:onbook_app/general/models/vehicles/vehcles_model.dart';
import 'package:onbook_app/general/providers/auth_provider.dart';
import 'package:onbook_app/general/providers/vehicles_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _carModelController = TextEditingController();
  final _numberPlateController = TextEditingController();
  final _ownerNameController = TextEditingController();
  File? _pickedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  Future<String> _uploadImage(String vehicleUid, String userDocId) async {
    final ref = FirebaseStorage.instance.ref().child(
      'vehicle_images/$userDocId/$vehicleUid.jpg',
    );
    await ref.putFile(_pickedImage!);
    return await ref.getDownloadURL();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _pickedImage == null) return;

    setState(() => _isUploading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userDocId = authProvider.consumerDocId ?? "";

      final carModel = _carModelController.text.trim();
      final numberPlate = _numberPlateController.text.trim();
      final uploaderName = authProvider.userData?['name']?.trim() ?? "Unknown";
      final vehicleUid = '$carModel-$numberPlate'
          .replaceAll(' ', '-')
          .toLowerCase();
      final now = DateTime.now();
      // final vehicleUid = const Uuid()
      // .v4(); // OR make your own combo from inputs

      // ...existing code...
      final imageUrl = await _uploadImage(vehicleUid, userDocId);

      final vehicle = VehicleModel(
        uid: vehicleUid,
        carModel: carModel,
        numberPlate: numberPlate,
        ownerName: _ownerNameController.text.trim(),
        uploadedBy: uploaderName,
        uploadedAt: Timestamp.fromDate(now),
        imageUrl: imageUrl,
      );

      await Provider.of<VehicleProvider>(
        context,
        listen: false,
      ).addVehicle(vehicle, userDocId); // Pass docId instead of uid
      // ...existing code...
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading vehicle: $e')));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Vehicle")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    image: _pickedImage != null
                        ? DecorationImage(
                            image: FileImage(_pickedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _pickedImage == null
                      ? const Center(child: Text("Tap to select image"))
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _carModelController,
                decoration: const InputDecoration(labelText: "Car Model"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _numberPlateController,
                decoration: const InputDecoration(labelText: "Number Plate"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ownerNameController,
                decoration: const InputDecoration(labelText: "Owner Name"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 20),
              _isUploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text("Add Vehicle"),
                      onPressed: _submit,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
