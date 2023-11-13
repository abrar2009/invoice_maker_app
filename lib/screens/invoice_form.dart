import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:invoice_maker/components/items_details.dart';
import 'package:invoice_maker/components/customer_details.dart';
import 'package:invoice_maker/components/labor_details.dart';
import 'package:invoice_maker/components/vehicle_details.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../components/generate_invoice_pdf.dart';
import '../models/invoice_detail_model.dart';

class InvoiceForm extends StatefulWidget {
  const InvoiceForm({super.key});

  @override
  _InvoiceFormState createState() => _InvoiceFormState();
}

class _InvoiceFormState extends State<InvoiceForm> {
  late Uint8List pdfData;
  List<InvoiceDetail> selectedItems = [];
  List<InvoiceDetail> laborItems = [];
  bool isGeneratingPDF = false;


  DateTime selectedDate = DateTime.now();
  final TextEditingController invoiceNumberController = TextEditingController();
  final TextEditingController nextServiceKMController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  bool _isCustomerDetailsExpanded = false;

  void updateDetailList(InvoiceDetail detail) {
    setState(() {
      if (detail.type == "Item") {
        selectedItems.add(detail);
      } else if (detail.type == "Labor") {
        laborItems.add(detail);
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      if (index >= 0 && index < selectedItems.length) {
        selectedItems.removeAt(index);
      }
    });
  }

  void removeLabor(int index) {
    setState(() {
      if (index >= 0 && index < laborItems.length) {
        laborItems.removeAt(index);
      }
    });
  }

  Future<void> editItem(InvoiceDetail item) async {
    final editedItem = await showDialog<InvoiceDetail>(
      context: context,
      builder: (BuildContext context) {
        return AddItemDialog(initialItem: item);
      },
    );

    if (editedItem != null) {
      // Find the index of the item to edit
      final index = selectedItems.indexWhere((element) => element == item);
      if (index != -1) {
        // Update the item in the list
        selectedItems[index] = editedItem;
        setState(() {});
      }
    }
  }

  Future<void> editLabor(InvoiceDetail labor) async {
    final editedLabor = await showDialog<InvoiceDetail>(
      context: context,
      builder: (BuildContext context) {
        return AddLaborDialog(initialLabor: labor);
      },
    );

    if (editedLabor != null) {
      // Find the index of the labor to edit
      final index = laborItems.indexWhere((element) => element == labor);
      if (index != -1) {
        // Update the labor in the list
        laborItems[index] = editedLabor;
        setState(() {});
      }
    }
  }

  Future<void> _generatePDFContent() async {
    setState(() {
      isGeneratingPDF = true;
    });

    String regNumber = vehicleDetails.firstWhere((field) => field.title == 'Reg. No.').controller.text;
    String vehicleModel = vehicleDetails.firstWhere((field) => field.title == 'Model').controller.text;

    final Uint8List pdfData = await generatePDFContent(
      selectedDate,
      invoiceNumberController.text,
      selectedItems,
      laborItems,
    );

    final filePath = await savePDFFile(pdfData, regNumber, vehicleModel);
    await OpenFile.open(filePath);

    setState(() {
      isGeneratingPDF = false;
    });
  }

  Future<String> savePDFFile(Uint8List pdfData, String regNumber, String vehicleModel) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = '${vehicleModel}_$regNumber.pdf';
    final filePath = '${tempDir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(pdfData);
    return filePath;
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const Text(
                'New Invoice',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(thickness: 1),
          ListTile(
            title: const Text('Invoice Date:'),
            subtitle: Text(
              "${selectedDate.toLocal()}".split(' ')[0],
              style: const TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () {
              _selectDate(context);
            },
          ),
          const Divider(thickness: 1),
          ListTile(
            title: const Text('Invoice Number:'),
            subtitle: TextFormField(
              controller: invoiceNumberController,
              decoration: const InputDecoration(
                hintText: 'Enter invoice number',
              ),
            ),
          ),
          ListTile(
            title: const Text('Next Service Due:'),
            subtitle: TextFormField(
              controller: nextServiceKMController,
              decoration: const InputDecoration(
                hintText: 'Enter next service K.M',
              ),
            ),
          ),
          ExpansionTile(
            title: const Text('Customer Details'),
            trailing: Icon(
              _isCustomerDetailsExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
            onExpansionChanged: (expanded) {
              setState(() {
                _isCustomerDetailsExpanded = expanded;
              });
            },
            children: customerDetails.map((field) {
              return ListTile(
                title: Text('${field.title}:'),
                subtitle: TextFormField(
                  controller: field.controller,
                  inputFormatters: field.inputFormatters,
                  decoration: InputDecoration(
                    hintText: 'Enter ${field.title.toLowerCase()}',
                  ),
                ),
              );
            }).toList(),
          ),
          ExpansionTile(
            title: const Text('Vehicle Details'),
            children: vehicleDetails.map((field) {
              return ListTile(
                title: Text('${field.title}:'),
                subtitle: TextFormField(
                  controller: field.controller,
                  decoration: InputDecoration(
                    hintText: 'Enter ${field.title.toLowerCase()}',
                  ),
                ),
              );
            }).toList(),
          ),
          ExpansionTile(
            title: const Text('Items'),
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  final newItem = await showDialog<InvoiceDetail>(
                    context: context,
                    builder: (BuildContext context) {
                      return const AddItemDialog();
                    },
                  );
                  if (newItem != null) {
                    updateDetailList(newItem);
                  }
                },
                child: const Text('+ Add Item'),
              ),
              SingleChildScrollView(
                child: Column(
                  children: selectedItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return ListTile(
                      title: Text('Item: ${item.name}'),
                      subtitle: Text('Price: ${item.price}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              editItem(item);
                            }
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: (){
                              removeItem(index);
                            }
                          )
                        ],
                      )
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Labor'),
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  final newLabor = await showDialog<InvoiceDetail>(
                    context: context,
                    builder: (BuildContext context) {
                      return const AddLaborDialog();
                    },
                  );
                  if (newLabor != null) {
                    updateDetailList(newLabor);
                  }
                },
                child: const Text('+ Add Labor'),
              ),
              SingleChildScrollView(
                child: Column(
                  children: laborItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final labor = entry.value;
                    return ListTile(
                      title: Text('Labour: ${labor.name}'),
                      subtitle: Text('Rate: ${labor.rate}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              editLabor(labor);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: (){
                              removeLabor(index);
                            },
                          ),
                        ]
                      )
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: isGeneratingPDF
              ? const CircularProgressIndicator()
              : ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                textStyle: const TextStyle(fontSize: 18),),
                onPressed: _generatePDFContent,
                child: const Text('Generate Invoice'),
            ),
          ),
        ],
      ),
    );
  }
}
