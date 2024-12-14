import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'item.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:open_file/open_file.dart'; // Import the open_file package

class CalculatePage extends StatelessWidget {
  final List<Item> items;
  final String userName;

  CalculatePage({required this.items, required this.userName});

  @override
  Widget build(BuildContext context) {
    double grandTotal = items.fold(0, (sum, item) => sum + item.totalCost);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculate Cost',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF532DE0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
        ),
        child: SingleChildScrollView( // Add SingleChildScrollView to prevent overflow
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 90.0,
                    width: 200.0,
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  '-: Cost Estimate :-',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(1.7),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2.4),
                      3: FlexColumnWidth(2),
                    },
                    border: TableBorder.all(color: Colors.grey, width: 1.0),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Item',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Price',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Quantity',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (var item in items)
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '\$${item.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item.quantity.toString(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '\$${item.totalCost.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Grand Total',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox.shrink(),
                          SizedBox.shrink(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '\$${grandTotal.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final pdf = pw.Document();

                      // Load the images from assets
                      final ByteData logoBytes = await rootBundle.load('assets/logo.png');
                      final Uint8List logoByteList = logoBytes.buffer.asUint8List();
                      final ByteData signatureBytes = await rootBundle.load('assets/stamp.png');
                      final Uint8List signatureByteList = signatureBytes.buffer.asUint8List();

                      pdf.addPage(
                        pw.Page(
                          build: (pw.Context context) {
                            final String formattedDate = DateTime.now().toString().split('.')[0];
                            return pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Image(
                                    pw.MemoryImage(logoByteList),
                                    height: 90.0,
                                    width: 150.0,
                                  ),

                                pw.SizedBox(height: 20),
                                pw.Center(
                                  child: pw.Text(
                                    '-: Cost Estimate :-',
                                    style: pw.TextStyle(
                                      fontSize: 28.0,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                                pw.SizedBox(height: 20),
                                pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text(
                                      'Customer Name: $userName',
                                      style: pw.TextStyle(fontSize: 16),
                                    ),
                                    pw.Text(
                                      'Date: $formattedDate',
                                      style: pw.TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                pw.SizedBox(height: 20),
                                pw.Table.fromTextArray(
                                  border: null,
                                  headerDecoration: pw.BoxDecoration(
                                    color: PdfColors.grey300,
                                  ),
                                  headerStyle: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.black,
                                  ),
                                  headers: ['Item', 'Price', 'Quantity', 'Total'],
                                  data: items.map((item) => [
                                    item.name,
                                    '\$${item.price.toStringAsFixed(0)}',
                                    item.quantity.toString(),
                                    '\$${item.totalCost.toStringAsFixed(0)}'
                                  ]).toList(),
                                ),
                                pw.SizedBox(height: 10),
                                pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text('Grand Total: \$${grandTotal.toStringAsFixed(0)}',
                                        style: pw.TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: pw.FontWeight.bold,
                                        )),
                                    pw.SizedBox(width: 20),
                                    pw.SizedBox(height: 50),// Add some space between total and signature
                                    pw.Image(
                                      pw.MemoryImage(signatureByteList),
                                      height: 80.0,
                                      width: 160.0,
                                    ),
                                  ],
                                ),
                                pw.SizedBox(height: 10), // Increase space between the signature and founder’s name
                                pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Text(
                                      'DecorAR Studio',
                                      style: pw.TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                pw.Spacer(),
                                pw.Center(
                                  child: pw.Text(
                                    "This is System Generated Estimate.",
                                    style: pw.TextStyle(
                                      fontSize: 14.0,
                                      color: PdfColors.grey,
                                    ),
                                  ),
                                ),
                                pw.SizedBox(height: 5),
                                pw.Center(
                                  child: pw.Text(
                                    "Thank You",
                                    style: pw.TextStyle(
                                      fontSize: 14.0,
                                      color: PdfColors.grey,
                                      fontWeight: pw.FontWeight.bold,
                                    )
                                  )
                                )
                              ],
                            );
                          },
                        ),
                      );


                      // Get the Downloads directory
                      Directory? downloadsDirectory = await getDownloadsDirectory();

                      // Check if the Downloads directory is accessible
                      if (downloadsDirectory != null) {
                        final fileName = 'cost_estimate_${DateTime.now().millisecondsSinceEpoch}.pdf';
                        final file = File('${downloadsDirectory.path}/$fileName');
                        await file.writeAsBytes(await pdf.save());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('PDF saved at ${file.path}')),
                        );
                        OpenFile.open(file.path);
                      } else {
                        throw Exception("Downloads directory not found.");
                      }
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save PDF: $e')),
                      );
                    }
                  },
                  icon: Icon(Icons.picture_as_pdf,color: Colors.white,),
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Save As PDF',
                    style: TextStyle(
                      color: Colors.white,
                    ),),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF532DE0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
