import 'package:flutter/material.dart';
import 'package:product_listing_app/screens/introscreen.dart';
import 'package:get/get.dart';

import 'package:product_listing_app/screens/login.dart';

// Uncomment these imports when the corresponding screens are added
// import 'package:product_listing_app/screens/home_screen.dart';
// import 'package:product_listing_app/screens/product_detail_screen.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Product Listing App',
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppRoutes {
  // Define route names as constants
  static const String intro = '/intro';
  static const String home = '/home';
  static const String productDetail = '/productDetail';
  static const String login = '/login';

  static const String initialRoute = intro;

  static final List<GetPage> routes = [
    GetPage(name: intro, page: () => IntroScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    // Add routes for other screens here
    // GetPage(name: home, page: () => HomeScreen()),
    // GetPage(name: productDetail, page: () => ProductDetailScreen()),
  ];

  // static Route<dynamic> _undefinedRoute(String? name) {
  //   return MaterialPageRoute(
  //     builder: (_) => Scaffold(
  //       body: Center(
  //         child: Text('No route defined for $name'),
  //       ),
  //     ),
  //   );
  // }
}
