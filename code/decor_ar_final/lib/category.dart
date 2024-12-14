import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:final_project/profile.dart';
import 'package:final_project/dashboard.dart';
import 'package:final_project/blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MaterialApp(
    home: Category(),
  ));
}

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();
  bool _isLoading = true;
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadAllCategoriesAndImages();
  }

  Future<void> _loadAllCategoriesAndImages() async {
    try {
      // Fetch all categories
      List<Map<String, dynamic>> categories = await fetchCategories();

      // Load and preload images for all categories
      for (var category in categories) {
        List<Map<String, dynamic>> products = await fetchProducts(category['name']);
        category['products'] = products;

        // Preload images for this category
        await Future.wait(products.map((product) {
          return precacheImage(NetworkImage(product['img']), context);
        }));
      }

      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (error) {
      // Handle any errors here
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A2A),
      body: Stack(
        children: [
          // AppBar with custom header content and rounded bottom corners
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: kToolbarHeight + 50,
              decoration: BoxDecoration(
                color: Color(0xFF532DE0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(47),
                  bottomRight: Radius.circular(47),
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(
                  'Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // RefreshIndicator with scrollable content
          Positioned(
            top: kToolbarHeight + 60,
            left: 0,
            right: 0,
            bottom: 0,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 14),
                      ..._categories.map((category) {
                        return CategorySection(
                          categoryName: category['name'],
                          products: category['products'],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomIconBar(),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadAllCategoriesAndImages();
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    List<Map<String, dynamic>> categories = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').get();
    for (var doc in querySnapshot.docs) {
      categories.add({'name': doc['name']});
    }
    return categories;
  }

  Future<List<Map<String, dynamic>>> fetchProducts(String categoryName) async {
    List<Map<String, dynamic>> products = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: categoryName)
        .limit(5)
        .get();
    for (var doc in querySnapshot.docs) {
      products.add({
        'id': doc.id,
        'name': doc['name'],
        'price': doc['price'],
        'img': doc['img'],
        'description': doc['description'],
      });
    }
    return products;
  }
}







class CategorySection extends StatefulWidget {
  final String categoryName;
  final List<Map<String, dynamic>> products;

  CategorySection({required this.categoryName, required this.products});

  @override
  _CategorySectionState createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.categoryName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('More'),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepPurple),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              var product = widget.products[index];
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 8.0 : 0, right: 8.0),
                child: ProductItem(product: product),
              );
            },
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}




class ProductItem extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductItem({required this.product});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showProductDetailsDialog(context);
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white54, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(widget.product['img']),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.product['name'],
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showProductDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2A2A2A),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.product['name'],
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${widget.product['description']}',
                style: TextStyle(color: Colors.white54),
              ),
              SizedBox(height: 10),
              Text(
                'Price:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${widget.product['price']}',
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();

                // Open the camera
                final ImagePicker _picker = ImagePicker();
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);

                if (image != null) {
                  // Handle the captured image
                  print('Image Path: ${image.path}');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF532DE0), // Background color of the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
              ),
              child: Text(
                'View in AR',
                style: TextStyle(color: Colors.white), // White text color
              ),
            ),
          ],
        );
      },
    );
  }


}


class BottomIconBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 2.6,
            colors: [Color(0xFF1C2A9F), Color(0xFF2F2B2B)],
          ),
        ),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
              child: Icon(Icons.home_filled, color: Colors.white),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Category()),
                );
              },
              child: Icon(Icons.category_outlined, color: Colors.white),
            ),
            GestureDetector(
              onTap: () async {
                // Add onTap action for camera icon
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF532DE0),
                ),
                padding: EdgeInsets.all(15),
                child: Icon(Icons.camera_alt, color: Colors.white, size: 28),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlogPage()),
                );
              },
              child: Icon(Icons.trending_up, color: Colors.white),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProfile()),
                );
              },
              child: Icon(Icons.person_outline, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
