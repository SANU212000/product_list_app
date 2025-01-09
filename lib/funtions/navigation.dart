import 'package:flutter/material.dart';
import 'package:product_listing_app/screens/homescreen.dart';
import 'package:product_listing_app/screens/introscreen.dart';
import 'package:get/get.dart';

import 'package:product_listing_app/screens/login.dart';
import 'package:product_listing_app/screens/notfoundpage.dart';
import 'package:product_listing_app/screens/whitelistscreen.dart';

// Uncomment these imports when the corresponding screens are added
// import 'package:product_listing_app/screens/home_screen.dart';
// import 'package:product_listing_app/screens/product_detail_screen.dart';
class MyApp extends StatelessWidget {
  final String? token;

  MyApp({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Set the initial route
      getPages: [
        GetPage(
            name: '/',
            page: () => (token != null && token!.isNotEmpty)
                ? HomePage()
                : LoginScreen()),
        GetPage(name: '/whitelist', page: () => WishlistScreen()),
      ],

      // Optionally, you can also use the onGenerateRoute callback
      onGenerateRoute: (settings) {
        if (settings.name == '/whitelist') {
          return MaterialPageRoute(builder: (context) => WishlistScreen());
        }
        return null; // Return null if the route is not handled
      },
      // Define onUnknownRoute if needed
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => NotFoundPage());
      },
    );
  }
}

class AppRoutes {
  static const String whitelist = '/whitelist';
  // Add other routes as needed
}
