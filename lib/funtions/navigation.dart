import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:product_listing_app/screens/homescreen.dart';
import 'package:product_listing_app/screens/introscreen.dart';
import 'package:get/get.dart';
import 'package:product_listing_app/screens/login.dart';
import 'package:product_listing_app/screens/notfoundpage.dart';
import 'package:product_listing_app/screens/whitelistscreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/intro',
      getPages: [
        GetPage(
          name: '/intro',
          page: () => IntroScreen(),
        ),
        GetPage(
          name: '/',
          page: () => FutureBuilder<Widget>(
            future: _buildHomeScreen(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while fetching token
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Handle any errors
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                // Return the appropriate widget based on token availability
                return snapshot.data ?? LoginScreen();
              }
            },
          ),
        ),
        GetPage(
          name: '/whitelist',
          page: () => WishlistScreen(),
        ),
      ],
      onGenerateRoute: (settings) {
        if (settings.name == '/whitelist') {
          return MaterialPageRoute(builder: (context) => WishlistScreen());
        }
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => NotFoundPage());
      },
    );
  }

  Future<Widget> _buildHomeScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      return HomePage();
    } else {
      return LoginScreen();
    }
  }
}

class AppRoutes {
  static const String intro = '/intro';
  static const String whitelist = '/whitelist';
  static const String home = '/';
}

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

Future<void> makeAuthenticatedRequest() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('Token retrieved: $token');

    if (token == null) {
      Get.snackbar('Error', 'No token found, please login again');
      return;
    }

    final url = Uri.parse('https://admin.kushinirestaurant.com/api/verify/');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('Request successful: ${response.body}');
    } else if (response.statusCode == 401) {
      Get.snackbar('Unauthorized', 'Session expired, please login again');
      // Redirect to login screen (if using GetX)
      Get.offAll(() => LoginScreen());
    } else {
      print('Request failed: ${response.statusCode}');
      Get.snackbar('Error', 'Failed to access protected resource');
    }
  } catch (e) {
    print('Error occurred: $e');
    Get.snackbar('Error', 'An unexpected error occurred');
  }
}
