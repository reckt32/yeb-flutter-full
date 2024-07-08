import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cog_proh/models/token_manager.dart';

TextStyle textFont = GoogleFonts.poppins();
Color primaryColor = const Color.fromRGBO(1, 0, 91, 1);
/*
class Announcements extends StatelessWidget {
  const Announcements({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: primaryColor,
        title: const AppBarChild(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: const AnnouncementsScreenWidget(),
      bottomNavigationBar: const BottomNavBarChild(),
    );
  }
}*/

class Announcements extends StatefulWidget {
  const Announcements({Key? key}) : super(key: key);
  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  String? username = '';
  String? userId = '';
  void initState() {
    super.initState();
    fetchUserData();
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
        setState(() {
          userId = data['static_id'];
          username = data['username'];
        });
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: (100.0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0))),
        backgroundColor: Color.fromRGBO(1, 0, 91, 1),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Color(0xffE6E6E6),
            radius: 30,
            child: Icon(
              Icons.person,
              color: Color.fromRGBO(1, 0, 91, 1),
            ),
            // Replace with your image asset
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  username!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
                /*Text(
                  userId,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                ),*/
              ],
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Image.asset('assets/icons/logo.webp')),
          ],
        ),
      ),
      body: const AnnouncementsScreenWidget(),
      bottomNavigationBar: const BottomNavBarChild(),
    );
  }
}


