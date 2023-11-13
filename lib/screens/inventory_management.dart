import 'package:flutter/material.dart';

class InventoryManagementPage extends StatefulWidget {
  const InventoryManagementPage({super.key});

  @override
  State<InventoryManagementPage> createState() => _InventoryManagementPageState();
}

class _InventoryManagementPageState extends State<InventoryManagementPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController partNumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<InventoryItem> inventory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /*Card(
              child: InkWell(
                onTap: () {
                  _openRegisterDialog(context);
                },
                child: const ListTile(
                  title: Text('Add Item')
                ),
              ),
            ),*/
            Row(
              children: [
                Text('Items',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    _openRegisterDialog(context);
                  },
                  child: Container(
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      //color: Colors.white,
                      border: Border.all(color: Colors.black),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      shape: BoxShape.rectangle,
                    ),
                    child: Center(child: Text('+ New Item', style: TextStyle(color: Colors.red[900]))),
                  )
                ),
              ],
            ),
            // Display the current inventory list
            ListView.builder(
              shrinkWrap: true,
              itemCount: inventory.length,
              itemBuilder: (context, index) {
                final item = inventory[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Quantity: ${item.quantity}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Register New Item'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: partNumberController,
                  decoration: const InputDecoration(labelText: 'Part Number'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newItem = InventoryItem(
                  name: nameController.text,
                  quantity: int.tryParse(quantityController.text) ?? 0,
                  partNumber: partNumberController.text,
                  description: descriptionController.text,
                );
                setState(() {
                  inventory.add(newItem);
                });
                nameController.clear();
                quantityController.clear();
                partNumberController.clear();
                descriptionController.clear();
                Navigator.of(context).pop();
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
      },
    );
  }
}

class InventoryItem {
  final String name;
  final int quantity;
  final String partNumber;
  final String description;

  InventoryItem({
    required this.name,
    required this.quantity,
    required this.partNumber,
    required this.description,
  });
}
