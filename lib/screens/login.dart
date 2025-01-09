import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Add this import

import 'package:flutter/services.dart';
import 'package:product_listing_app/screens/homescreen.dart';
import 'dart:convert';
import 'package:product_listing_app/screens/otpscreen.dart';
import 'package:product_listing_app/screens/username.dart';

Future<void> makeAuthenticatedRequest() async {
  try {
    // Retrieve the saved token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      // Get.snackbar('Error', 'Authentication token not found');
      return;
    }

    final url = Uri.parse('https://admin.kushinirestaurant.com/api/verify/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add token to headers
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Request successful: ${response.body}');
    } else {
      print('Request failed: ${response.statusCode}');
      Get.snackbar('Error', 'Failed to access protected resource');
    }
  } catch (e) {
    print('Error occurred: $e');
    Get.snackbar('Error', 'An unexpected error occurred');
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countrycodeController =
      TextEditingController(text: '+91');
  String get phoneNumberdetails =>
      countrycodeController.text + '-' + phoneController.text;
  String get phoneNumber => phoneController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 100.0),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 8.0),
                Text(
                  "Let’s Connect with Lorem Ipsum..!",
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 40.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: countrycodeController,
                        keyboardType: TextInputType.phone,
                        maxLength: 3,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: '+91',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: 'Enter Phone',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          hintStyle: TextStyle(color: Colors.grey[300]!),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                SizedBox(
                  height: 55.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (phoneNumber.isNotEmpty) {
                        verifyUser(phoneNumber, phoneNumberdetails).then((_) {
                          print('Verification completed successfully');
                        }).catchError((error) {
                          Get.snackbar('Error', 'Failed to verify user');
                          print('Verification failed: $error');
                        });
                      } else {
                        Get.snackbar('Error', 'Phone number is invalid');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(172, 82, 80, 223),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: 3.0,
                  child: Text.rich(
                    TextSpan(
                      text: "By continuing, you agree to our ",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Terms of Use",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: " & "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> verifyUser(String phoneNumber, String phoneNumberdetails) async {
  final url = Uri.parse('https://admin.kushinirestaurant.com/api/verify/');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone_number': phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data != null && data.containsKey('otp') && data.containsKey('user')) {
        final otp = data['otp'];
        final user = data['user'];

        // Check if token exists in response
        final token =
            data.containsKey('token') ? data['token']['access'] : null;

        if (token != null) {
          print('Login Successful!');
          print('OTP: $otp');
          print('User: $user');
          print('Token: $token');

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
        } else {
          print('Token is missing, proceeding without it.');
        }

        // Navigate based on user verification status
        if (user == true) {
          // User is verified and exists in the database
          Get.off(() => HomePage());
        } else {
          // User not registered, navigate to OTP screen for registration
          Get.to(() => OtpScreen(phonenumber: phoneNumberdetails, otp: otp));
        }
      } else {
        print('Unexpected response structure or missing OTP: ${response.body}');
        Get.snackbar(
            'Error', 'Failed to verify user due to incomplete response');
        // Proceed to OTP screen if response is incomplete
        Get.to(() => OtpScreen(phonenumber: phoneNumberdetails, otp: ''));
      }
    } else {
      print('Login failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      Get.snackbar('Error', 'Failed to verify user');
      // Handle moving to OTP screen in case of failed response
      Get.to(() => OtpScreen(phonenumber: phoneNumberdetails, otp: ''));
    }
  } catch (e) {
    print('Error occurred during login: $e');
    Get.snackbar('Error', 'An unexpected error occurred');
    // Handle moving to OTP screen in case of error
    Get.to(() => OtpScreen(phonenumber: phoneNumberdetails, otp: ''));
  }
}
