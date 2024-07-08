import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/token_manager.dart';
import 'test1.dart';
import 'test2.dart';
import 'test3.dart';
import 'package:cog_proh/models/gd_details.dart';
import 'package:cog_proh/services/request.dart';
import 'gd_deny.dart';
import 'gd_screen.dart';
import 'req_ext_gd.dart';
import 'announcements_screen/widgets.dart';
import 'announcements_screen/announcements_screen.dart';

Color primaryColor = const Color.fromRGBO(1, 0, 91, 1);

//saari details fetch karni hongi uske fuctions likho
class GDScreen extends StatefulWidget {
  @override
  State<GDScreen> createState() => _GDScreenState();
}

class _GDScreenState extends State<GDScreen> {
  String? username = '';
  String? userId = '';
  String? gdDate = '';
  String? gdTime = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
    Future<Gd_details> gdDetails = Request().fetchGDDetails();
    gdDetails.then((value) {
      setState(() {
        gdDate = value.date;
        gdTime = value.time;
      });
    });
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

  Future<void> sendPostRequest() async {
    final token= await TokenManager.getAccessToken();
    final url = Uri.parse('http://10.0.2.2:8000/events/updated-gd-status/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
        'Bearer $token',
      },
      body: json.encode({'key': 'value'}),
    );

    if (response.statusCode == 200) {
      print('Post request successful');
      print('Response: ${response.body}');
    } else {
      print('Post request failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'CONGRATULATIONS !',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(1, 0, 91, 1)),
              textAlign: TextAlign.center,
            ),
            Text(
              'You have been selected for GD!',
              style: TextStyle(fontSize: 18, color: primaryColor),
              textAlign: TextAlign.center,
            ),
            Text(
              'Your GD is scheduled on $gdDate at $gdTime',
              style: TextStyle(fontSize: 16, color: primaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 213, 212, 212),
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            await sendPostRequest();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GDscreen()),
                            );
                          },
                          child: const Text('Accept',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GDDeny()),
                            );
                          },
                          child: const Text('Deny',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GDExt()),
                            );
                          },
                          child: const Text('Request Extension',
                              style: const TextStyle(color: Colors.white))),
                    ),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                 // MaterialPageRoute(builder: (context) =>AnnouncementsScreenWidget() ),
                );
                // Handle back navigation
              },
              child: const Text(
                'Back',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          // Handle navigation on tap
          switch (index) {
            case 0:
            // Navigate to Home
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Announcements()),
                    (Route<dynamic> route) => false,
              );
              break;
            case 1:
            // Navigate to Settings
              break;
            case 2:
            // Handle Logout
              break;
          }
        },
      ),
    );
  }
}