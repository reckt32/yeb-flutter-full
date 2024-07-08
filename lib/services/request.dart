import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cog_proh/models/gd_details.dart';
import 'package:cog_proh/models/gd_request.dart';

import '../models/token_manager.dart';

class Request {
  Future<Gd_details> fetchGDDetails() async {
    final token= await TokenManager.getAccessToken();
    final apiUrl =
        'http://10.0.2.2:8000/events/gd_details'; // Replace with your actual API URL
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Gd_details.fromJson(data);
      } else {
        print('Failed to load GD details');
        return Gd_details();
      }
    } catch (e) {
      print('Error fetching GD details: $e');
      throw e;
    }
  }

  Future<void> fetchUserData() async {
    final token= await TokenManager.getAccessToken();
    final apiUrl =
        'http://10.0.2.2:8000/users/user-info/'; // Replace with your actual API URL
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization':
              'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['username'];
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
