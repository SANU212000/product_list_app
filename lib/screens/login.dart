import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:product_listing_app/screens/otpscreen.dart';
import 'package:product_listing_app/screens/username.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countrycodeController =
      TextEditingController(text: '+91');

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
                      String phoneNumber = countrycodeController.text +
                          '-' +
                          phoneController.text;
                      if (phoneNumber.isNotEmpty) {
                        Get.to(() => OtpScreen(phonenumber: phoneNumber));
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
