import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class OtpVerificationScreen extends StatelessWidget {
  final String mobileNumber;
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  OtpVerificationScreen({required this.mobileNumber});

  void _handleTextChange(String value, int index, BuildContext context) {
    if (value.length == 1 && index < _focusNodes.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  Future<void> _submitOtp(BuildContext context) async {
    final otp = int.parse(
        _otpControllers.map((e) => e.text).join()); // Convert OTP to integer
    print("Collected OTP: $otp"); // Debug print to verify OTP
    print(
        "Collected Mobile Number: $mobileNumber"); // Debug print to verify Mobile Number

    if (_otpControllers.every((controller) => controller.text.isNotEmpty)) {
      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/users/verify_otp/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'otp': otp, // Send OTP as an integer
            'mobile': mobileNumber,
          }),
        );

        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['access'] != null) {
            print("OTP Verified! Token: ${data['access']}");

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                'access_token', data['access']); // Save the access token

            // Navigate to another screen or handle success further
          } else {
            print("OTP Verified but no access token found.");
            _showErrorDialog(
                context, "OTP Verified but no access token found.");
          }
        } else if (response.statusCode == 400) {
          // Handles case for wrong OTP
          print("Invalid OTP");
          _showErrorDialog(context, "Invalid OTP");
        } else {
          // Handles any other HTTP status codes
          print("Failed to verify OTP: ${response.statusCode}");
          _showErrorDialog(context,
              "Failed to verify OTP. Status code: ${response.statusCode}");
        }
      } catch (e) {
        // Handles exceptions thrown by http.post or jsonDecode
        print("Error: $e");
        _showErrorDialog(context, "An error occurred while verifying OTP.");
      }
    } else {
      // Handles case where OTP length is incorrect
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 4-digit OTP')),
      );
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter Verification Code",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "We are automatically detecting an SMS\nsent to your mobile number ******${mobileNumber.substring(mobileNumber.length - 4)}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  height: 50,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    textAlign: TextAlign.center,
                    onChanged: (value) =>
                        _handleTextChange(value, index, context),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _submitOtp(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 1, 33, 81),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              ),
              child: Text(
                'Verify',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                print("Resend OTP for mobile number: $mobileNumber");
              },
              child: Text(
                'Resend OTP',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 1, 33, 81),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
