import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:ar_flutter_plugin_engine/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_engine/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_engine/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_engine/models/ar_node.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'package:path_provider/path_provider.dart'; // To get storage directory
import 'package:flutter/services.dart'; // To capture the screenshot
import 'dart:ui' as ui; // Import dart:ui for image manipulation

class LocalAndWebObjectsWidget extends StatefulWidget {
  @override
  _LocalAndWebObjectsWidgetState createState() => _LocalAndWebObjectsWidgetState();
}

class _LocalAndWebObjectsWidgetState extends State<LocalAndWebObjectsWidget> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  List<Map<String, dynamic>> products = [];
  Map<String, ARNode> addedObjects = {}; // Track added objects by filename

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();
    setState(() {
      products = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  Future<String> getModelDownloadUrl(String filename) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    return await storage.ref('Models/$filename.glb').getDownloadURL(); // Append .glb to filename
  }

  Future<void> saveScreenshot() async {
    try {
      // Capture the AR screen as an image
      var imageProvider = await arSessionManager!.snapshot();

      // Convert ImageProvider to Uint8List
      if (imageProvider is ImageProvider) {
        final image = await _getImageBytes(imageProvider);

        // Generate a unique file name based on timestamp
        String fileName = 'screenshot_${DateTime.now().millisecondsSinceEpoch}.png';

        // Get a reference to the Firebase Storage 'screenshots' folder
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('screenshots/$fileName');

        // Upload the screenshot to Firebase Storage
        UploadTask uploadTask = ref.putData(image);

        // Wait for the upload to complete
        TaskSnapshot snapshot = await uploadTask;

        // Get the download URL for the uploaded screenshot
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Get current user's email
        String? userEmail = FirebaseAuth.instance.currentUser?.email;

        // Save the download URL, user email, and added objects to Firestore
        await FirebaseFirestore.instance.collection('designs').add({
          'image': downloadUrl,
          'userEmail': userEmail,
          'addedObjects': addedObjects.keys.toList(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Show success message with the download URL
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Screenshot uploaded successfully! URL: $downloadUrl'),
        ));
      } else {
        // Handle unexpected type
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to capture screenshot.'),
        ));
      }
    } catch (e) {
      // Handle error and show failure message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save screenshot: $e'),
      ));
    }
  }

  // Helper function to convert ImageProvider to Uint8List
  Future<Uint8List> _getImageBytes(ImageProvider imageProvider) async {
    final Completer<ui.Image> completer = Completer();
    final ImageStream stream = imageProvider.resolve(ImageConfiguration());
    final listener = ImageStreamListener((ImageInfo image, bool synchronousCall) {
      completer.complete(image.image);
    });
    stream.addListener(listener);

    final ui.Image img = await completer.future;
    final ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make the app bar transparent
        elevation: 0, // Remove elevation
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.purple), // Save button in purple
            onPressed: saveScreenshot, // Trigger screenshot function
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white), // Close button
            onPressed: () {
              Navigator.pop(context); // Go back to home screen
            },
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 100, // Set height for the button area
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () => onProductButtonPressed(product['filename']),
                          child: Container(
                            width: 100, // Set width for buttons
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0x46484849),
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(product['img']), // Fetch the image URL from Firestore
                                fit: BoxFit.cover,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              product['name'], // Assuming there's a 'name' field in your Firestore
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0x46000000), fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: false,
      handleTaps: true,
    );
    this.arObjectManager!.onInitialize();
  }

  Future<void> onProductButtonPressed(String filename) async {
    if (addedObjects.containsKey(filename)) {
      // Remove the object if it already exists
      await arObjectManager!.removeNode(addedObjects[filename]!);
      setState(() {
        addedObjects.remove(filename);
      });
    } else {
      // Add new object
      String downloadUrl = await getModelDownloadUrl(filename); // Fetch the model URL using the filename
      var newNode = ARNode(
        type: NodeType.webGLB,
        uri: downloadUrl,
        scale: vector_math.Vector3(2, 2, 2),
        position: vector_math.Vector3(addedObjects.length.toDouble(), -3, -5.5), // Position objects side by side
        rotation: vector_math.Vector4(1, 0, 0, 0),
      );

      bool? added = await arObjectManager!.addNode(newNode);
      if (added!) {
        setState(() {
          addedObjects[filename] = newNode;
        });
      }
    }
  }
}
