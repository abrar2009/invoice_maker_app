import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomerDetailField {
  final String title;
  final TextEditingController controller;
  final List<TextInputFormatter> inputFormatters;

  CustomerDetailField({
    required this.title,
    List<TextInputFormatter>? inputFormatters,
  }) : controller = TextEditingController(),
        inputFormatters = inputFormatters ?? [];
}

List<CustomerDetailField> customerDetails = [
  CustomerDetailField(title: 'Name'),
  CustomerDetailField(
    title: 'Phone',
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      LengthLimitingTextInputFormatter(10),
    ],
  ),
  CustomerDetailField(title: 'Email'),
  CustomerDetailField(title: 'Address'),
];