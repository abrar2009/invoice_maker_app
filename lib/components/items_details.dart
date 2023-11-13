import 'package:flutter/material.dart';
import '../models/invoice_detail_model.dart';

class AddItemDialog extends StatefulWidget {
  final InvoiceDetail? initialItem;
  const AddItemDialog({this.initialItem, Key? key}) : super(key: key);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Populate the fields with initial item details if provided
    if (widget.initialItem != null) {
      nameController.text = widget.initialItem!.name;
      priceController.text = widget.initialItem!.price.toString();
      quantityController.text = widget.initialItem!.quantity.toString();
      discountController.text = widget.initialItem!.discount.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Item Name', fillColor: Colors.grey),
          ),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Price'),
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
            final double price = double.tryParse(priceController.text) ?? 0.0;
            final int quantity = int.tryParse(quantityController.text) ?? 1;
            final double discount = double.tryParse(discountController.text) ?? 0.0;

            if (name.isNotEmpty && price > 0 && quantity > 0) {
              final newItem = InvoiceDetail(name: name, price: price, discount: discount, type: "Item", quantity: quantity);
              Navigator.of(context).pop(newItem);            }
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

class Item {
  final String name;
  final double price;
  double quantity;
  double discount;

  Item({required this.name, required this.price, required this.quantity, required this.discount});
}