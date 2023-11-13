import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:invoice_maker/components/customer_details.dart';
import 'package:invoice_maker/components/vehicle_details.dart';
import '../models/invoice_detail_model.dart';
import 'number_to_words.dart';

pw.Table createItemsTable(List<InvoiceDetail> items) {
  final columnWidths = {
    0: const pw.FlexColumnWidth(2), // Sr. No.
    1: const pw.FixedColumnWidth(200), // Labour Details
    2: const pw.FlexColumnWidth(2), // Qty
    3: const pw.FlexColumnWidth(2), // Rate
    4: const pw.FlexColumnWidth(2), // DIS%
    5: const pw.FlexColumnWidth(2), // Total
  };

  return pw.TableHelper.fromTextArray(
    headers: ['Sr. No.', 'Items', 'Qty', 'Rate', 'DIS%', 'Total'],
    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold,),
    headerDecoration: const pw.BoxDecoration(
      color: PdfColors.grey400,
    ),
    columnWidths: columnWidths,
    data: items.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final item = entry.value;
      final discount = item.discount;
      final price = item.price;
      final quantity = item.quantity;
      double total;
      if (discount > 0) {
        total = (1 - (discount / 100)) * price * quantity;
      } else {
        total = price * quantity;
      }
      return [
        index.toString(),
        item.name,
        item.quantity.toString(),
        item.price.toStringAsFixed(2),
        item.discount.toStringAsFixed(1),
        total.toStringAsFixed(2),
      ];
    }).toList(),

    headerAlignment: pw.Alignment.center,
    cellAlignment: pw.Alignment.center,
    cellAlignments: {
      0: pw.Alignment.center,
      1: pw.Alignment.centerLeft,
      2: pw.Alignment.center,
      3: pw.Alignment.center,
      4: pw.Alignment.center,
      5: pw.Alignment.center,
    },
    border: const pw.TableBorder(
      top: pw.BorderSide(),
      bottom: pw.BorderSide(),
      right: pw.BorderSide(),
      left: pw.BorderSide(),
      verticalInside: pw.BorderSide(),
      horizontalInside: pw.BorderSide.none,
    ),
  );
}


pw.Table createLaborTable(List<InvoiceDetail> labor) {
  double laborTotal = 0.0;
    final columnWidths = {
      0: const pw.FlexColumnWidth(2), // Sr. No.
      1: const pw.FixedColumnWidth(200), // Labour Details
      2: const pw.FlexColumnWidth(2), // Qty
      3: const pw.FlexColumnWidth(2), // Rate
      4: const pw.FlexColumnWidth(2), // DIS%
      5: const pw.FlexColumnWidth(2), // Total
    };

    return pw.TableHelper.fromTextArray(
      headers: ['Sr. No.', 'Labor Details', 'Qty', 'Rate', 'DIS%', 'Total'],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(
        color: PdfColors.grey400,
      ),
      columnWidths: columnWidths,
      data: labor
          .asMap()
          .entries
          .map((entry) {
        final index = entry.key + 1;
        final laborItem = entry.value;
        final discount = laborItem.discount;
        final rate = laborItem.rate;
        final quantity = laborItem.quantity;
        double total;
        if (discount > 0) {
          total = (1 - (discount / 100)) * rate * quantity;
        } else {
          total = rate * quantity;
        }
        laborTotal += total;
        return [
          index.toString(),
          laborItem.name,
          laborItem.quantity.toString(),
          laborItem.rate.toStringAsFixed(2),
          laborItem.discount.toStringAsFixed(1),
          total.toStringAsFixed(2),
        ];
      }).toList(),

      headerAlignment: pw.Alignment.center,
      cellAlignment: pw.Alignment.center,
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
      },
      border: const pw.TableBorder(
        top: pw.BorderSide(),
        bottom: pw.BorderSide(),
        right: pw.BorderSide(),
        left: pw.BorderSide(),
        verticalInside: pw.BorderSide(),
        horizontalInside: pw.BorderSide.none,
      ),
    );
  }

Future<Uint8List> generatePDFContent(
    DateTime selectedDate,
    String invoiceNumber,
    List<InvoiceDetail> selectedItems,
    List<InvoiceDetail> laborItems,
    ) async {
  final pdf = pw.Document(
    theme: pw.ThemeData.withFont(
      base: pw.Font.ttf(
        await rootBundle.load("assets/fonts/NotoSans-Regular.ttf"),
      ),
    ),
    pageMode: PdfPageMode.fullscreen,
  );

  final pdfImage = pw.MemoryImage(
    (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
  );

  const addressText =
      'A 1 AUTO SOLUTIONS\nMULTI CAR BRAND SERVICE\n'
      'G BLOCK AJANTA NAGAR NEAR CNG PUMP THERMAX CHOWK\n'
      'Phone-9960714786, Mob-9960437786, Email: a1autosolutionspune11@gmail.com';

  final signatureImage = pw.MemoryImage(
    (await rootBundle.load('assets/images/signature.png')).buffer.asUint8List(),
  );

  pdf.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.a4.copyWith(
          marginTop: 25,
          marginBottom: 25,
          marginLeft: 25,
          marginRight: 25,
        )
      ),
      build: (pw.Context context) {
        return [
          pw.Header(
            level: 0,
            child: pw.Row(
              children: [
                // Logo
                pw.Container(
                  width: 90,
                  height: 70,
                  child: pw.Image(pdfImage),
                ),
                pw.SizedBox(width: 35),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                    pw.Text(
                      'A 1 AUTO SOLUTIONS',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15, color: PdfColors.red900),
                    ),
                    pw.Text(
                      'MULTI CAR BRAND SERVICE',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15, color: PdfColors.red900),
                    ),
                    for (final line in addressText.split('\n').sublist(2))
                      pw.Text(line,
                      style: const pw.TextStyle(fontSize: 10)),
                      //pw.SizedBox(height: 5)
                  ]
                )
              ],
            ),
          ),
          pw.TableHelper.fromTextArray(
            cellAlignment: pw.Alignment.topLeft,
            cellAlignments: {
              0: pw.Alignment.topLeft,
              1: pw.Alignment.topLeft,
            },
            border: pw.TableBorder.all(
              width: 0.5,
            ),
            tableWidth: pw.TableWidth.max,
            headerAlignment: pw.Alignment.center,
            headers: ['Customer Details', 'Invoice Details'],
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey400,
            ),
            data: [
              [
                pw.Column(
                  children: customerDetails.map((field) {
                    return pw.Row(
                      children: [
                        pw.Text('${field.title}: '),
                        pw.Text(field.controller.text),
                      ],
                    );
                  }).toList(),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Text('Invoice Date: '),
                        pw.Text('${selectedDate.toLocal()}'.split(' ')[0]),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Text('Invoice Number: '),
                        pw.Text(invoiceNumber),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Text('Next Service Due: '),
                        pw.Text(invoiceNumber),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
          pw.TableHelper.fromTextArray(
            cellAlignment: pw.Alignment.topLeft,
            cellAlignments: {
              0: pw.Alignment.topLeft,
              //1: pw.Alignment.topLeft,
            },
            border: pw.TableBorder.all(
              width: 0.5,
            ),
             headerAlignment: pw.Alignment.center,
            headers: ['Vehicle Details'],
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey400,
            ),
            data: [
              [
                pw.Column(
                  children: vehicleDetails.map((field) {
                    return pw.Row(
                      children: [
                        pw.Text('${field.title}: '),
                        pw.Text(field.controller.text),
                      ],
                    );
                  }).toList(),
                ),
                pw.Container(),
              ],
            ],
          ),
            pw.SizedBox(height: 20),
            createItemsTable(selectedItems),
            pw.SizedBox(height: 10),
            pw.SizedBox(height: 10),
            createLaborTable(laborItems),
            pw.SizedBox(height: 10),

          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              // Total amount in words on the left
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Total Amount in Words:',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,)),
                  pw.Text(
                    totalAmountInWords(selectedItems, laborItems),
                    maxLines: 2,
                    overflow: pw.TextOverflow.visible,
                  ),
                ],
              ),
            ],
          ),


          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
                  // Total amount for items on the left
                  pw.Text('Total Items: ${calculateItemsTotal(selectedItems).toStringAsFixed(2)}'),
                  // Total amount for labor on the right
                  pw.Text('Total Labor: ${calculateLaborTotal(laborItems).toStringAsFixed(2)}'),

                  pw.Text('Total Discount: ${calculateTotalDiscount(selectedItems, laborItems).toStringAsFixed(2)}'),

                  pw.Divider(),

                  pw.Text('Total Amount: ${(calculateItemsTotal(selectedItems) + calculateLaborTotal(laborItems)).toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,),
              ),
            ],
          ),
          pw.Divider(),
          pw.Text('Note: ',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                )),
          pw.Text('1. I certify that I have taken delivery of my vehicle & work has been done to my entire satisfaction.',
              style: const pw.TextStyle(
                  fontSize: 9,

              )),
          pw.Text('2. I certify that the original parts which has been replaced under this bill has been collected by me/Has been permitted to be retained at outlet.',
              style: const pw.TextStyle(
                fontSize: 9,
              )),
          pw.Divider(),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Spacer(),
                  pw.Text('For A 1 AUTO SOLUTIONS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ]
              ),
          //pw.SizedBox(height: 40),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Spacer(),
              pw.Image((signatureImage), width: 100, height: 100),
              pw.SizedBox(width: 10)
            ]
          ),
          pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Receiver\'s Signature', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Spacer(),
                pw.Text('Authorised Signature', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ]
          ),
          pw.Divider(),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Disclaimer: Customers should check their complaints about the vehicle after completion of the work.\nNo Warranty for Electrical material & imported spares.',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 8
                  ))
            ]
          ),
          pw.Divider(),
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Text('RECOMMENDED MAINTENANCE ADVICE', style: const pw.TextStyle(decoration: pw.TextDecoration.underline)),
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: 'Weekly Check: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
                    ),
                    pw.TextSpan(
                      text: 'Engine oil level dipstick, Brake fluid level, Tyre pressure as per company guide.',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 9),
                    ),
                    pw.TextSpan(
                      text: '\nOnce a Month Check: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
                    ),
                    pw.TextSpan(
                      text: 'Operation of the handbrake, Ensure battery terminals are clean, Power steering fluid level, Coolant level.',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 9),
                    ),
                  ],
                ),
              ),
              pw.Text('SAFET DRIVING TIPS(**Always be Habitual**)', style: const pw.TextStyle(decoration: pw.TextDecoration.underline)),
              pw.Text('Good Mileage, Good Starting, Good Tyre Condition & Pollution free all this things are possible when your car is serviced from time to time.',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 9))
            ]
          ),
          pw.Divider(),
        ];
      },
    ),
  );

  return pdf.save();
}


double calculateItemsTotal(List<InvoiceDetail> items) {
  double total = 0.0;
  for (var item in items) {
    final discount = item.discount;
    final price = item.price;
    final quantity = item.quantity;
    double itemTotal;

    if (discount > 0) {
      itemTotal = (1 - (discount / 100)) * price * quantity;
    } else {
      itemTotal = price * quantity;
    }

    total += itemTotal;
  }
  return total;
}

double calculateLaborTotal(List<InvoiceDetail> labor) {
  double total = 0.0;
  for (var laborItem in labor) {
    final discount = laborItem.discount;
    final rate = laborItem.rate;
    final quantity = laborItem.quantity;
    double laborTotal;

    if (discount > 0) {
      laborTotal = (1 - (discount / 100)) * rate * quantity;
    } else {
      laborTotal = rate * quantity;
    }

    total += laborTotal;
  }
  return total;
}

double calculateTotalDiscount(List<InvoiceDetail> items, List<InvoiceDetail> laborItems) {
  double totalDiscount = 0.0;

  // Calculate total discount for items
  for (var item in items) {
    // Calculate the discount amount based on the percentage
    double discountAmount = (item.discount / 100) * (item.price * item.quantity);
    totalDiscount += discountAmount;
  }

  // Calculate total discount for labor items
  for (var laborItem in laborItems) {
    double discountAmount = (laborItem.discount / 100) * (laborItem.rate * laborItem.quantity);
    totalDiscount += discountAmount;
  }

  return totalDiscount;
}

double calculateTotal(List<InvoiceDetail> items, List<InvoiceDetail> labor) {
  double total = calculateItemsTotal(items) + calculateLaborTotal(labor);
  return total;
}

String totalAmountInWords(List<InvoiceDetail> items, List<InvoiceDetail> labor) {
  double total = calculateTotal(items, labor);
  return numberToWords(total.toInt());
}