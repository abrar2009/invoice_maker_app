import 'package:flutter/material.dart';

class VehicleDetailField {
  final String title;
  final TextEditingController controller;

  VehicleDetailField({
    required this.title,
  }) : controller = TextEditingController();
}

List<VehicleDetailField> vehicleDetails = [
  VehicleDetailField(title: 'Reg. No.'),
  VehicleDetailField(title: 'Make'),
  VehicleDetailField(title: 'Model'),
  VehicleDetailField(title: 'K.M.'),
  VehicleDetailField(title: 'Engine No.'),
  VehicleDetailField(title: 'Chassis No.'),
];
