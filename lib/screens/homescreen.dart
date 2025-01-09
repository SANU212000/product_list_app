import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:product_listing_app/funtions/navigation.dart';
import 'package:product_listing_app/funtions/widgets.dart';
import 'package:product_listing_app/screens/profilescreen.dart';
import 'package:product_listing_app/screens/whitelistscreen.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final ValueNotifier<int> _selectedIndexNotifier = ValueNotifier<int>(0);

  // Function to fetch products (you can modify this to fetch from your API)
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

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController = Get.put(WishlistController());
    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndexNotifier,
      builder: (context, selectedIndex, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: IndexedStack(
            index: selectedIndex,
            children: [
              // Home Screen
              HomeScreen(),
              // Wishlist Screen
              WishlistScreen(),
              // Profile Screen
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              if (index == 1) {
                Get.toNamed(
                    AppRoutes.whitelist); // Navigate to the wishlist screen
              } else {
                _selectedIndexNotifier.value = index; // Update selected index
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Whitelist',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          CustomSearchBar(),
          SizedBox(height: 20),
          BannerSlider(),
          SizedBox(height: 20),
          Text(
            "Popular Products",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          FutureBuilder<List<dynamic>>(
            future: fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No products found'));
              }

              final products = snapshot.data!;
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    name: product['name'] ?? 'Unknown',
                    mrp: product['mrp']?.toDouble() ?? 0.0,
                    discount: product['discount_price']?.toDouble() ?? 0.0,
                    imageUrl: product['featured_image'] ??
                        'https://admin.kushinirestaurant.com/media/Banner_.png', // Replace with actual field name
                    avgRating: product['avg_rating']?.toString() ?? '0.0',
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class WishlistController extends GetxController {
  var inWishlist = false.obs; // .obs makes it observable

  void toggleWishlist() {
    inWishlist.value = !inWishlist.value; // Toggle the state
  }
}
