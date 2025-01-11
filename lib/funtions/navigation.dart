import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:product_listing_app/screens/homescreen.dart';
import 'package:product_listing_app/screens/introscreen.dart';
import 'package:get/get.dart';
import 'package:product_listing_app/screens/login.dart';
import 'package:product_listing_app/screens/notfoundpage.dart';
import 'package:product_listing_app/screens/whitelistscreen.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, this.token});

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
          page: () =>
              (token != null && token!.isNotEmpty) ? HomePage() : LoginScreen(),
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
