import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'l3.dart'; // Import this for TextInputFormatter

class MobileLoginScreen extends StatefulWidget {
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String confirmPassword;

  MobileLoginScreen({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.confirmPassword,
  });

  @override
  _MobileLoginScreenState createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  final TextEditingController _mobileController = TextEditingController();

  void _verifyMobileNumber() async {
    final mobileNumber = _mobileController.text;
    final fullName = '${widget.firstName} ${widget.lastName}';

    if (mobileNumber.length == 10) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/users/signup/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': fullName,
          'email': widget.email,
          'mobile': mobileNumber,
          'password': widget.password,
          'confirm_password': widget.confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OtpVerificationScreen(mobileNumber: mobileNumber),
          ),
        );
      } else if (response.statusCode == 400) {
        // 409 Conflict typically used to indicate a resource conflict (like a duplicate email)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'This email/mobile number is already registered. Please log in.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed: ${response.statusCode}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter a valid 10-digit mobile number')),
      );
    }
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
              "Enter your mobile number",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "We will send you a confirmation code",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Text(
                  '+91',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _mobileController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter mobile number',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 1, 33, 81),
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 1, 33, 81),
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 1, 33, 81),
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _verifyMobileNumber,
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
          ],
        ),
      ),
    );
  }
}
