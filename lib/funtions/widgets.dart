import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:product_listing_app/screens/homescreen.dart';

Future<List<dynamic>> fetchProducts() async {
  final response = await http.get(
    Uri.parse("https://admin.kushinirestaurant.com/api/products/"),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load products');
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final double mrp;
  final double discount;
  final String imageUrl;
  final String avgRating;
  final RxBool inWishlist; // Reactive field for wishlist state

  ProductCard({
    required this.name,
    required this.mrp,
    required this.discount,
    required this.imageUrl,
    required this.avgRating,
    bool inWishlist = false,
  }) : inWishlist = RxBool(inWishlist);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image and Wishlist Icon
          Stack(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.white,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
              // Wishlist Icon
              Positioned(
                top: 8,
                right: 8,
                child: Obx(() {
                  return InkWell(
                    onTap: () {
                      inWishlist.value = !inWishlist.value; // Toggle wishlist
                    },
                    child: Icon(
                      inWishlist.value ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  );
                }),
              ),
            ],
          ),
          // Product Details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price and Rating
                Row(
                  children: [
                    // Original Price
                    if (discount > 0)
                      Text(
                        "₹${mrp.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    SizedBox(width: 8),
                    // Discounted Price
                    Text(
                      "₹${(mrp - (mrp * discount / 100)).toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Spacer(),
                    // Rating
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    SizedBox(width: 4),
                    Text(
                      avgRating,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                // Product Name
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 80,
              offset: Offset(0, 80),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            Container(
              width: 2,
              height: 25,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(Icons.search, color: Colors.black, size: 25),
            ),
          ],
        ),
      ),
    );
  }
}

class BannerSlider extends StatelessWidget {
  Future<List<String>> fetchBanners() async {
    final response = await http.get(
      Uri.parse('https://admin.kushinirestaurant.com/api/banners/'),
    );

    if (response.statusCode == 200) {
      List<dynamic> banners = json.decode(response.body);

      return banners.map((banner) => banner['image'] as String).toList();
    } else {
      throw Exception('Failed to load banners');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchBanners(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No banners available"));
        } else {
          List<String> bannerImages = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  padEnds: true,
                  enableInfiniteScroll: true,
                ),
                items: bannerImages.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }
}

class CustomBottomBar extends StatelessWidget {
  final ValueNotifier<int> selectedIndexNotifier;

  CustomBottomBar({required this.selectedIndexNotifier});

  final List<String> _labels = ['Home', 'Maps', 'Camera'];
  final List<Widget> _icons = const [
    Icon(Icons.home_outlined),
    Icon(Icons.explore_outlined),
    Icon(Icons.camera_alt_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Container(
          color: Colors.teal.withOpacity(0.1),
          child: TabBar(
            onTap: (x) {
              selectedIndexNotifier.value = x; // Update selected index
            },
            labelColor: Colors.white,
            unselectedLabelColor: Colors.blueGrey,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide.none,
            ),
            tabs: [
              for (int i = 0; i < _icons.length; i++)
                _tabItem(
                  _icons[i],
                  _labels[i],
                  isSelected: i == selectedIndexNotifier.value,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create a custom tab item
  Widget _tabItem(Widget icon, String label, {required bool isSelected}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.blueGrey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
