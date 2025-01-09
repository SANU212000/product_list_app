import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:product_listing_app/funtions/widgets.dart';

class WishlistScreen extends StatelessWidget {
  Future<List<dynamic>> fetchWishlistProducts() async {
    final response = await http.get(
      Uri.parse(
          "https://admin.kushinirestaurant.com/api/products/?in_wishlist=true"),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load wishlist products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchWishlistProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
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
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wishlistProducts.length,
              itemBuilder: (context, index) {
                final product = wishlistProducts[index];
                return ProductCard(
                  name: product['name'] ?? 'Unknown',
                  mrp: product['mrp']?.toDouble() ?? 0.0,
                  discount: product['discount_price']?.toDouble() ?? 0.0,
                  imageUrl: product['featured_image'] ??
                      'https://admin.kushinirestaurant.com/media/Banner_.png',
                  avgRating: product['avg_rating']?.toString() ?? '0.0',
                  inWishlist: true,
                );
              },
            );
          }
        },
      ),
    );
  }
}
