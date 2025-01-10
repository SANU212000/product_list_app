import 'package:flutter/material.dart';
import 'package:product_listing_app/screens/homescreen.dart';
import 'package:product_listing_app/screens/introscreen.dart';
import 'package:get/get.dart';
import 'package:product_listing_app/screens/login.dart';
import 'package:product_listing_app/screens/notfoundpage.dart';
import 'package:product_listing_app/screens/whitelistscreen.dart';

class MyApp extends StatelessWidget {
  final String? token;

  MyApp({Key? key, this.token}) : super(key: key);

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
