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
  final RxBool inWishlist;

  ProductCard({
    required this.name,
    required this.mrp,
    required this.discount,
    required this.imageUrl,
    required this.avgRating,
    bool initialWishlistState = false,
  }) : inWishlist = RxBool(initialWishlistState);

  @override
  Widget build(BuildContext context) {
    final discountedPrice = (mrp - discount).clamp(0.0, mrp);
    final discountPercentage =
        ((discount / mrp) * 100).toStringAsFixed(1); // Calculate percentage

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      elevation: 0.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.white,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
              if (discount > 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '-${discountPercentage}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: Obx(() {
                  return InkWell(
                    onTap: () {
                      inWishlist.toggle();
                    },
                    child: Icon(
                      inWishlist.value ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 24,
                    ),
                  );
                }),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '₹${mrp.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '₹${discountedPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    Text(
                      avgRating,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
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
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200, // Matches the container height
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0, // Ensure full-width banners
                      padEnds: false, // Remove padding at edges
                      enableInfiniteScroll: true,
                      aspectRatio: 16 / 9,
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
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
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
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: bannerImages.asMap().entries.map((entry) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
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
