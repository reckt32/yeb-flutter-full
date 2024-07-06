import 'package:flutter/material.dart';

import 'a11.dart'; // Import your A1 screen
import 'a2.dart'; // Import your A2 screen
import 'a3.dart'; // Import your A3 screen
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'gd_screen.dart';


class StatusBasedScreen extends StatefulWidget {
  @override
  _StatusBasedScreenState createState() => _StatusBasedScreenState();
}

class _StatusBasedScreenState extends State<StatusBasedScreen> {
  late Future<String> _userStatusFuture;

  @override
  void initState() {
    super.initState();
    _userStatusFuture = getUserStatus();
  }
  Future<String> getUserStatus() async {
    final apiUrl = 'http://10.0.2.2:8000/users/user_status/'; // Replace with your actual API URL
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU1OTExMDI3LCJpYXQiOjE3MTk5MTEwMjcsImp0aSI6ImFkYTE2ZGE3NDZkYTQ4M2I4NTJiNGRjODdiYzJlMGIyIiwidXNlcl9pZCI6Mn0.G86CMYcQJyK88CyoVALqGFyfiimaQF7E4e_ltAsQayI', // Replace with actual token
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'];
      } else {
        print('Failed to load user status');
        return '';
      }
    } catch (e) {
      print('Error fetching user status: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _userStatusFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          switch (snapshot.data) {
            case 'signed_up':
            case 'profile_completed':
              return A3(); // Show A1 screen
            case 'application_submitted':
              return A3();
            case 'application_fee_paid':
              return A3();
            case 'application_approved':
              return GDScreen(); // Show A2 screen
            case 'application_rejected':
            case 'gd_confirmed':
              return GDscreen();
            case 'gd_attended':
              return A3();
            case 'gd_not_cleared':
            case 'gd_missed':
            case 'registration_payment_pending':
              return A2();
            case 'registered':
            case 'participant':
            case 'completed':
            case 'certificate_issued':
              //return A3(); // Show A3 screen
            default:
              return Text('Unknown status: ${snapshot.data}');
          }
        }
      },
    );
  }
}