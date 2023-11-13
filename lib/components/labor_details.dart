import 'package:flutter/material.dart';
import '../models/invoice_detail_model.dart';

class AddLaborDialog extends StatefulWidget {
  final InvoiceDetail? initialLabor;

  const AddLaborDialog({this.initialLabor, Key? key}) : super(key: key);
  @override
  _AddLaborDialogState createState() => _AddLaborDialogState();
}

class _AddLaborDialogState extends State<AddLaborDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Populate the fields with initial item details if provided
    if (widget.initialLabor != null) {
      nameController.text = widget.initialLabor!.name;
      rateController.text = widget.initialLabor!.rate.toString();
      quantityController.text = widget.initialLabor!.quantity.toString();
      discountController.text = widget.initialLabor!.discount.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Labour'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Labour'),
          ),
          TextField(
            controller: rateController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Rate'),
          ),
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          TextField(
            controller: discountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Discount (%)'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Validate and save the input data
            final String name = nameController.text;
            final double rate = double.tryParse(rateController.text) ?? 0.0;
            final int quantity = int.tryParse(quantityController.text) ?? 1;
            final double discount = double.tryParse(discountController.text) ?? 0.0;

            if (name.isNotEmpty && rate > 0 && quantity > 0) {
              Navigator.of(context).pop(InvoiceDetail(
                name: name,
                price: 0.0,
                type: "Labor",
                rate: rate,
                discount: discount,
                quantity: quantity,
              ));
            }
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class NewLaborDetails {
  final String name;
  final double rate;
  int quantity;
  double discount;

  NewLaborDetails({required this.name, required this.rate, required this.quantity, required this.discount});
}

