import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_listing_app/funtions/widgets.dart';
import 'dart:convert';

class WishlistScreen extends StatelessWidget {
  Future<List<dynamic>> fetchWishlistProducts() async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://admin.kushinirestaurant.com/api/products/?in_wishlist=true"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data is List ? data : [];
      } else {
        throw Exception('Failed to load wishlist products');
      }
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("My Wishlist"),
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.black,
      //   elevation: 0,
      // ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: fetchWishlistProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
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
                        // Trigger a rebuild
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
                  mainAxisSpacing: 16, // Space between rows
                  childAspectRatio: 0.75, // Adjust the height-to-width ratio
                ),
                itemCount: wishlistProducts.length,
                itemBuilder: (context, index) {
                  final product = wishlistProducts[index];
                  return ProductCard(
                    name: product['name'] ?? 'Unknown Product',
                    mrp: double.tryParse(product['mrp'].toString()) ?? 0.0,
                    discount:
                        double.tryParse(product['discount_price'].toString()) ??
                            0.0,
                    imageUrl: product['featured_image'] ??
                        'https://admin.kushinirestaurant.com/media/Banner_.png',
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
