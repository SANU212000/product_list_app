import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_listing_app/funtions/widgets.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  Future<List<dynamic>> fetchWishlistProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found.');
    }

    try {
      final response = await http.get(
        Uri.parse("https://admin.kushinirestaurant.com/api/wishlist/"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data is List
            ? data
            : []; // Return the list if the response is valid
      } else {
        throw Exception('Failed to load wishlist products');
      }
    } catch (error) {
      throw Exception('Failed to fetch data: $error'); // Handle network errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar setup
      appBar: AppBar(
        title: Text("My Wishlist"),
        backgroundColor: Colors.white, // Set the app bar to white
        foregroundColor: Colors.black, // Ensure text is black
        elevation: 0, // Remove app bar shadow
      ),
      backgroundColor: Colors.white, // Keep the screen background white
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: fetchWishlistProducts(), // Fetch wishlist data
          builder: (context, snapshot) {
            // Handle loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            // Handle error state
            else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error loading wishlist.',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        fetchWishlistProducts();
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No items in your wishlist",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            } else {
              final wishlistProducts = snapshot.data!;
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: wishlistProducts.length,
                itemBuilder: (context, index) {
                  final product = wishlistProducts[index];
                  return ProductCard(
                    productId: product['id']?.toString() ?? '',
                    name: product['name'] ?? 'Unknown Product',
                    mrp: double.tryParse(product['mrp'].toString()) ?? 0.0,
                    discount:
                        double.tryParse(product['discount_price'].toString()) ??
                            0.0,
                    imageUrl: product['featured_image'] ?? 'no photos',
                    avgRating: product['avg_rating']?.toString() ?? '0.0',
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
