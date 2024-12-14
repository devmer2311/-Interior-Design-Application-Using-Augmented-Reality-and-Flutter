import 'dart:async'; // Import dart:async for Completer
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:firebase_core/firebase_core.dart';

class ViewPage extends StatelessWidget {
  final CollectionReference designsCollection =
  FirebaseFirestore.instance.collection('designs');

  // Get current user's email
  final String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A2A),
      appBar: AppBar(
        title: Text(
          'My Saved Designs',
          style: GoogleFonts.lato(color: Colors.white), // Apply Google Font
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF532DE0),
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the back arrow icon
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: designsCollection
                  .where('userEmail', isEqualTo: userEmail) // Filter by userEmail
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final savedDesigns = snapshot.data?.docs ?? [];

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: savedDesigns.length,
                  itemBuilder: (context, index) {
                    final design = savedDesigns[index];
                    final designImage = design['image'];

                    return GestureDetector(
                      onTap: () => _showDesignPreview(context, designImage),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF532DE0),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(4, 4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                  child: Image.network(
                                    designImage ?? 'assets/default.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Center(child: Icon(Icons.error)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      label: Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        _deleteDesign(design.id, context);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        backgroundColor: Colors.transparent,
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8), // Add spacing between buttons
                                    TextButton.icon(
                                      icon: Icon(Icons.monetization_on, color: Colors.green),
                                      label: Text(
                                        'Get Cost Estimate',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      onPressed: () {
                                        _getCostEstimate(design.id, context);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.green,
                                        backgroundColor: Colors.transparent,
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Designed by DecorAR Studio',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }void _getCostEstimate(String designId, BuildContext context) async {
    try {
      // Get the design document based on the design ID
      final designDoc = await designsCollection.doc(designId).get();
      final designData = designDoc.data() as Map<String, dynamic>?;  // Cast to Map<String, dynamic>

      if (designData != null) {
        // Extract the addedObjects array from the design data
        final List<dynamic> addedObjects = designData['addedObjects'] ?? [];

        // If there are no added objects, show a message
        if (addedObjects.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No objects were added to this design.')),
          );
          return;
        }

        // Fetch product details for the objects in addedObjects
        double totalCost = 0.0;
        for (String objectName in addedObjects) {
          // Query the products collection to find the product with the matching name
          final productSnapshot = await FirebaseFirestore.instance
              .collection('products')
              .where('filename', isEqualTo: objectName)
              .limit(1) // Limit the result to one match
              .get();

          // If the product is found, add its price to the total cost
          if (productSnapshot.docs.isNotEmpty) {
            final productData = productSnapshot.docs.first.data();

            // Convert the price to a double, ensuring compatibility with both int and double
            final double productPrice = (productData['price'] is int)
                ? (productData['price'] as int).toDouble()
                : (productData['price'] as double);

            totalCost += productPrice;
          }
        }

        // Show the total cost in a popup dialog
        _showCostEstimationDialog(context, totalCost);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Design data not found.')),
        );
      }
    } catch (e) {
      print('Error fetching cost estimate: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get cost estimate.')),
      );
    }
  }

  void _showCostEstimationDialog(BuildContext context, double totalCost) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2A2A2A),
          title: Text(
            'Cost Estimation',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'The total cost estimation for this design is: \Rs${totalCost.toStringAsFixed(2)}',
            style: GoogleFonts.lato(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDesignPreview(BuildContext context, String? image) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows the user to dismiss the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: FutureBuilder(
            future: _fetchImageSize(image),
            builder: (context, AsyncSnapshot<Size?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Icon(Icons.error, size: 100, color: Colors.white));
              } else {
                final size = snapshot.data;

                return Container(
                  width: size?.width ?? 300, // Fallback width if size is null
                  height: size?.height ?? 300, // Fallback height if size is null
                  color: Colors.black.withOpacity(0.7), // Semi-transparent background
                  child: Image.network(
                    image ?? 'assets/default.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.error, size: 100, color: Colors.white),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Future<Size?> _fetchImageSize(String? imageUrl) async {
    if (imageUrl == null) return null;

    final Completer<Size> completer = Completer();

    final Image image = Image.network(imageUrl);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo imageInfo, bool synchronousCall) {
          final Size size = Size(imageInfo.image.width.toDouble(),
              imageInfo.image.height.toDouble());
          completer.complete(size);
        },
        onError: (dynamic error, StackTrace? stackTrace) {
          completer.completeError(error, stackTrace);
        },
      ),
    );

    return completer.future;
  }

  // Function to delete the design
  Future<void> _deleteDesign(String designId, BuildContext context) async {
    try {
      await designsCollection.doc(designId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Design deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete design.')),
      );
    }
  }
}
