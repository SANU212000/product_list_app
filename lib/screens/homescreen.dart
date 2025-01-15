import 'package:flutter/material.dart';
import 'package:product_listing_app/funtions/navigation.dart';
import 'package:product_listing_app/funtions/widgets.dart';
import 'package:product_listing_app/screens/profilescreen.dart';
import 'package:product_listing_app/screens/whitelistscreen.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final ValueNotifier<int> _selectedIndexNotifier = ValueNotifier<int>(0);

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndexNotifier,
      builder: (context, selectedIndex, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              IndexedStack(
                index: selectedIndex,
                children: [
                  HomeScreen(),
                  WishlistScreen(),
                  ProfileScreen(),
                ],
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: CustomBottomBar(
                  currentIndex: selectedIndex,
                  onTap: (index) {
                    _selectedIndexNotifier.value = index;
                  },
                  icons: const [
                    Icons.home,
                    Icons.favorite,
                    Icons.person,
                  ],
                  labels: const [
                    'Home',
                    'Whitelist',
                    'Profile',
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    mrp: double.tryParse(product['mrp']?.toString() ?? '0.0') ??
                        0.0,
                    discount: double.tryParse(
                            product['discount']?.toString() ?? '0.0') ??
                        0.0,
                    imageUrl: product['featured_image'] ??
                        'https://admin.kushinirestaurant.com/media/Banner_.png',
                    avgRating: product['category']?.toString() ?? '0.0',
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
  var inWishlist = false.obs;

  void toggleWishlist() {
    inWishlist.value = !inWishlist.value;
  }
}
