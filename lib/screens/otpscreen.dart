import 'dart:ui';

import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter/gestures.dart';
import 'package:product_listing_app/screens/homescreen.dart';
import 'package:product_listing_app/screens/username.dart';

class OtpScreen extends StatelessWidget {
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();

  final String phonenumber;
  final String otp;
  OtpScreen({super.key, required this.phonenumber, required this.otp}) {
    print('phonenumber is $phonenumber');
    print('otp is $otp');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                          color: Colors.white, // Background color
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
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'OTP VERIFICATION',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    text: "Enter the OTP sent to -",
                    style: TextStyle(color: Colors.grey[600], fontSize: 15.0),
                    children: <TextSpan>[
                      TextSpan(
                        text: phonenumber,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'OTP is $otp',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOtpTextField(context, _otpController1),
                  SizedBox(width: 10),
                  _buildOtpTextField(context, _otpController2),
                  SizedBox(width: 10),
                  _buildOtpTextField(context, _otpController3),
                  SizedBox(width: 10),
                  _buildOtpTextField(context, _otpController4),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              CountdownTimer(
                endTime: DateTime.now()
                    .add(Duration(seconds: 120))
                    .millisecondsSinceEpoch,
                onEnd: () {
                  print('Timer finished');
                },
                widgetBuilder: (_, time) {
                  if (time == null) {
                    return Text(
                      '00:0 Sec',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    );
                  }
                  return Text(
                    '00:${time.sec} Sec',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text.rich(TextSpan(
                text: "Don't receive code?",
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Re-send',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ],
              )),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (textotp == otp) {
                      Get.to(() =>
                          UsernameScreen(phone: phonenumber, otpCode: otp));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid OTP!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(172, 82, 80, 223),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpTextField(
      BuildContext context, TextEditingController controller) {
    return SizedBox(
      width: 80,
      height: 60,
      child: Container(
        decoration: const BoxDecoration(),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(8.0),
            ),
            border: InputBorder.none,
          ),
          // decoration: BoxDecoration(
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.black.withOpacity(0.1),
          //       spreadRadius: 1,
          //       blurRadius: 4,
          //       offset: Offset(2, 2),
          //     ),
          //   ],
          // ),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          buildCounter: (BuildContext context,
                  {int? currentLength, int? maxLength, bool? isFocused}) =>
              null,
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            if (!RegExp(r'^[0-9]$').hasMatch(value)) {
              return '';
            }
            return null;
          },
        ),
      ),
    );
  }

  String get textotp =>
      _otpController1.text +
      _otpController2.text +
      _otpController3.text +
      _otpController4.text;
}
