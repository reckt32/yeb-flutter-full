import 'dart:convert';

import 'package:flutter/material.dart';
import 'l2.dart';
import 'l8.dart'; // Import MobileLoginScreen here
import 'package:http/http.dart' as http;
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();

}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String firstName = '';
  String lastName = '';
  String password = '';
  String confirmPassword = '';
  bool acceptTerms = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() async{
    print('fucl u');
    if (_formKey.currentState!.validate() && acceptTerms) {
      _formKey.currentState!.save();
      print('happening');


      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/users/signup/'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'mobile': '9339393934',
          'confirm_password': confirmPassword,
          'name': firstName+lastName
        }),
      );

      if (response.statusCode == 200)
        {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Access token not found')),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => MobileLoginScreen(
      //       email: email,
      //       firstName: firstName,
      //       lastName: lastName,
      //       password: password,
      //       confirmPassword: confirmPassword,
      //     ),
      //   ),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please accept the terms and conditions')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  color: Color.fromARGB(255, 249, 249, 249),
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('assets/icons/logo.webp', height: 100),
                ),
                SizedBox(height: 16),
                Text(
                  'Welcome to the YEB Family',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildTextField('Email ID', TextInputType.emailAddress,
                        (value) => email = value),
                SizedBox(height: 8),
                _buildTextField('First Name', TextInputType.text,
                        (value) => firstName = value),
                SizedBox(height: 8),
                _buildTextField('Last Name', TextInputType.text,
                        (value) => lastName = value),
                SizedBox(height: 8),
                _buildPasswordField(),
                SizedBox(height: 8),
                _buildConfirmPasswordField(),
                Row(
                  children: [
                    Checkbox(
                      value: acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          acceptTerms = value!;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        // Open terms and conditions
                      },
                      child: Text(
                        'I accept the terms and conditions',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color.fromARGB(255, 1, 33, 81),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // ElevatedButton(
                //   onPressed: (){
                //     _signUp;
                //     },
                //   child: Text('Sign Up'),
                //   style: ElevatedButton.styleFrom(
                //     foregroundColor: Colors.white,
                //     backgroundColor: const Color.fromARGB(255, 1, 33, 81),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8.0),
                //     ),
                //     padding: EdgeInsets.symmetric(vertical: 16.0),
                //   ),
                // ),
                TextButton(onPressed: _signUp, child: Text('sign up')),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already A Member?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Text('Log In'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hintText, TextInputType keyboardType, Function(String) onSaved) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $hintText';
          }
          return null;
        },
        onSaved: (value) {
          onSaved(value!);
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Password',
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        obscureText: !_isPasswordVisible,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
        onSaved: (value) {
          password = value!;
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: _confirmPasswordController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Confirm Password',
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
        onSaved: (value) {
          confirmPassword = value!;
        },
      ),
    );
  }
}
