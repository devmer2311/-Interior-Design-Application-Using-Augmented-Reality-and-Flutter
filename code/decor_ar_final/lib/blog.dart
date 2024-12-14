import 'package:flutter/material.dart';
import 'package:final_project/profile.dart';
import 'package:final_project/dashboard.dart';
import 'package:final_project/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {


  bool _isImageZoomed = false;
  int _zoomedImageIndex = 0;

  void _toggleImageZoom(int index) {
    setState(() {
      _isImageZoomed = !_isImageZoomed;
      _zoomedImageIndex = index;
    });
  }
  late List<DocumentSnapshot> _blogs;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData() async {
    setState(() {});
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final blogDate = timestamp.toDate();
    final difference = now.difference(blogDate);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return DateFormat.yMMMd().format(blogDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A2A),
      body: Stack(
        children: [
          // Custom AppBar for BlogPage with rounded bottom corners
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: kToolbarHeight + 40,
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
                  'Blogs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Main content with RefreshIndicator and StreamBuilder
          Positioned(
            top: kToolbarHeight + 40, // Adjusted to start below the custom header
            left: 0,
            right: 0,
            bottom: 0, // Make sure it takes up the remaining space
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refreshData,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('blogs')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  _blogs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: _blogs.length,
                    itemBuilder: (context, index) {
                      var blog = _blogs[index].data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
                        child: InkWell(
                          onTap: () {
                            _toggleImageZoom(index);
                          },
                          child: BlogCard(
                            timestamp: blog['timestamp'],
                            image: blog['image'],
                            title: blog['title'],
                            description: blog['description'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // Zoomed image overlay
          if (_isImageZoomed)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isImageZoomed = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: (_blogs[_zoomedImageIndex].data() as Map<String, dynamic>)['image'],
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.5,
                      fit: BoxFit.cover,
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
class BlogCard extends StatefulWidget {
  final Timestamp timestamp;
  final String image;
  final String title;
  final String description;

  const BlogCard({
    Key? key,
    required this.timestamp,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  _BlogCardState createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  bool isLiked = false;

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeAgo = _formatTimestamp(widget.timestamp);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
            ],
          ),
          const SizedBox(height: 15),
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.image,
                    width: 300,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 14,
                    //color: Colors.black87,
                    color: Colors.white54
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _toggleLike,
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.white,
                ),
              ),
              Text(
                timeAgo,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final blogDate = timestamp.toDate();
    final difference = now.difference(blogDate);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return DateFormat.yMMMd().format(blogDate);
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: BlogPage(),
  ));
}
