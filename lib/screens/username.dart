import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:product_listing_app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsernameScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final String phone;
  final String otpCode;

  UsernameScreen({super.key, required this.phone, required this.otpCode});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.transparent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.white),
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  counterText: "",
                  hintText: 'Enter Full Name',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final username = _usernameController.text;
                  if (username.isNotEmpty) {
                    await loginOrRegisterUser(context, username, phone);
                    print('Username: $username');

                    // Get.offAll(LoginScreen());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid name')),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> loginOrRegisterUser(
    BuildContext context, String username, String phone) async {
  const String apiUrl =
      'https://admin.kushinirestaurant.com/api/login-register/';

  try {
    final Map<String, String> requestBody = {
      "first_name": username,
      "phone_number": phone,
    };

    // Check if username or phone is empty
    if (username.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username and phone number cannot be empty')),
      );
      return;
    }

    // Make the HTTP POST request
    final response = await http
        .post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final token = data['token']['access'];
      final userId = data['user_id'];
      final message = data['message'];

      print('Message: $message');
      print('User ID: $userId');
      print('Token: $token');

      // If the token is available, store it and navigate
      if (token != null && token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful!')),
        );

        // Navigate to the Home Screen (or any other screen)
        Get.offAll(() => LoginScreen()); // Replace with your target screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token missing in response')),
        );
      }
    } else if (response.statusCode == 400) {
      final errorMessage = json.decode(response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request Failed: $errorMessage')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Unexpected Error (Status code: ${response.statusCode})')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  }
}

// void restartApp(BuildContext context, String token) {
//   Navigator.pushAndRemoveUntil(
//     context,
//     MaterialPageRoute(
//       builder: (context) => LoginScreen(token: token),
//     ),
//     (route) => false,
//   );
// }
