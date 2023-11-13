import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/manage_customers_model.dart';

class ManageCustomersPage extends StatefulWidget {
  const ManageCustomersPage({super.key});

  @override
  State<ManageCustomersPage> createState() => _ManageCustomersPageState();
}

class _ManageCustomersPageState extends State<ManageCustomersPage> {
  final List<CustomerCard> customers = [];
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState(){
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final loadedCustomers = await dbHelper.getCustomers();
    setState(() {
      customers.clear();
      customers.addAll(loadedCustomers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index){
                      final customer = customers[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(customer.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                    Text(customer.vehicleName, style: const TextStyle(color: Colors.grey),),
                                    Text(customer.regNo, style: const TextStyle(color: Colors.grey),),
                                    const SizedBox(height: 10,),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Due Amt.', style: TextStyle(fontSize: 15, color: Colors.grey)),
                                    Text(customer.dueAmount.toStringAsFixed(2),
                                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.red[900]),),
                                    const SizedBox(height: 10),
                                    Text('Paid Amt.: ${customer.paidAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey),),
                                    const SizedBox(height: 10,),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: (){
                                    deleteCustomer(index);
                                  },
                                ),
                                const Text('Delete', style: TextStyle(color: Colors.red),),
                                const Spacer(),
                                IconButton(
                                    icon: Icon(Icons.edit, color: Colors.red[900]),
                                    onPressed: (){
                                      _editCustomer(context, customer, index);
                                    }
                                ),
                                Text('Edit', style: TextStyle(color: Colors.red[900]),),
                              ],
                            )
                        ),
                      );
                    },
                  )
              ),
              ElevatedButton(
                onPressed: (){
                  _addCustomerDialog(context);
                },
                child: const Text('Add Customer'),
              ),
            ],
          )
      ),
    );
  }

  void _addCustomerDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          final TextEditingController nameController = TextEditingController();
          final TextEditingController vehicleNameController = TextEditingController();
          final TextEditingController regNoController = TextEditingController();
          final TextEditingController dueAmountController = TextEditingController();
          final TextEditingController paidAmountController = TextEditingController();

          return AlertDialog(
            title: const Text('Add Customer'),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Customer Name'),
                  ),
                  TextField(
                    controller: vehicleNameController,
                    decoration: const InputDecoration(labelText: 'Vehicle'),
                  ),
                  TextField(
                    controller: regNoController,
                    decoration: const InputDecoration(labelText: 'Reg. No.'),
                  ),
                  TextField(
                    controller: dueAmountController,
                    decoration: const InputDecoration(labelText: 'Due Amount'),
                  ),
                  TextField(
                    controller: paidAmountController,
                    decoration: const InputDecoration(labelText: 'Paid Amount'),
                  ),
                ]
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final customer = CustomerCard(
                    name: nameController.text,
                    vehicleName: vehicleNameController.text,
                    regNo: regNoController.text,
                    dueAmount: double.parse(dueAmountController.text) ?? 0.0,
                    paidAmount: double.parse(paidAmountController.text) ?? 0.0,
                  );
                  await dbHelper.insertCustomer(customer);
                  _loadCustomers();
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              )
            ],
          );
        }
    );
  }

  void _editCustomer(BuildContext context, CustomerCard customer, int index) {
    final TextEditingController nameController = TextEditingController(text: customer.name);
    final TextEditingController vehicleNameController = TextEditingController(text: customer.vehicleName);
    final TextEditingController regNoController = TextEditingController(text: customer.regNo);
    final TextEditingController dueAmountController = TextEditingController(text: customer.dueAmount.toString());
    final TextEditingController paidAmountController = TextEditingController(text: customer.paidAmount.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Customer Name'),
              ),
              TextField(
                controller: vehicleNameController,
                decoration: const InputDecoration(labelText: 'Vehicle'),
              ),
              TextField(
                controller: regNoController,
                decoration: const InputDecoration(labelText: 'Reg. No.'),
              ),
              TextField(
                controller: dueAmountController,
                decoration: const InputDecoration(labelText: 'Due Amount'),
              ),
              TextField(
                controller: paidAmountController,
                decoration: const InputDecoration(labelText: 'Paid Amount'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final updatedCustomer = CustomerCard(
                  id: customer.id,
                  name: nameController.text,
                  vehicleName: vehicleNameController.text,
                  regNo: regNoController.text,
                  dueAmount: double.parse(dueAmountController.text) ?? 0.0,
                  paidAmount: double.parse(paidAmountController.text) ?? 0.0,
                );

                await dbHelper.updateCustomer(updatedCustomer);

                setState(() {
                  customers[index] = updatedCustomer;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
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

  void deleteCustomer(int index) async {
    final customer = customers[index];
    bool deletionConfirmed = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this customer?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  customers.removeAt(index);
                });
                deletionConfirmed = true;
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                deletionConfirmed = false;
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    ).then((_) async {
      if (deletionConfirmed){
        final db = await dbHelper.database;
        await db.delete('customers', where: 'id = ?', whereArgs: [customer.id]);
      }
    });
  }
}