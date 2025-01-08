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




 // Container(
            //   height: 150,
            //   decoration: BoxDecoration(
            //     color: Colors.blue[50],
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         flex: 2,
            //         child: Padding(
            //           padding: const EdgeInsets.all(12.0),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Text(
            //                 "Paragon Kitchen - Lulu Mall",
            //                 style: TextStyle(
            //                     fontSize: 16, fontWeight: FontWeight.bold),
            //               ),
            //               SizedBox(height: 8),
            //               Text(
            //                 "Flat 50% Off!",
            //                 style: TextStyle(fontSize: 22, color: Colors.blue),
            //               ),
            //               SizedBox(height: 8),
            //               ElevatedButton(
            //                 onPressed: () {},
            //                 child: Text("KNOW MORE"),
            //                 style: ElevatedButton.styleFrom(
            //                   backgroundColor: Colors.blue,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         flex: 1,
            //         child: Image.network(
            //           "https://via.placeholder.com/150", // Replace with your image
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
