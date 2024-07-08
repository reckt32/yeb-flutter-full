import 'package:cog_proh/Tanay/U5.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/token_manager.dart';
import 'test1.dart';
import 'test2.dart';


Color primaryColor = const Color.fromRGBO(1, 0, 91, 1);
//saari details fetch karni hongi uske fuctions likho
class A2 extends StatefulWidget {
  State<A2> createState() => _A2state();
}
class _A2state extends State<A2>{
  String username = '';
  String userId = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final token= await TokenManager.getAccessToken();
    final apiUrl = 'http://10.0.2.2:8000/users/user-info/'; // Replace with your actual API URL
    try {
      final response = await http.get(Uri.parse(apiUrl),headers: <String, String>{
        'Authorization': 'Bearer $token',
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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: (100.0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0))),
        backgroundColor: primaryColor,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Color(0xffE6E6E6),
            radius: 30,
            child: Icon(
              Icons.person,
              color: Color(0xffCCCCCC),
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
                  username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
               /* Text(
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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'CONGRATULATIONS !',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
              textAlign: TextAlign.center,
            ),
            Text(
              'You have been selected for GD!',
              style: TextStyle(fontSize: 18, color: primaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height:100, ),
            Text(
              'To register yourself for YEB,'
                  ' complete the payment process',
              style: TextStyle(fontSize: 18, color: primaryColor),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => U5()),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.08
                ),
                backgroundColor: primaryColor,
                padding:
                const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),

                  child: Text('Proceed to payment', style: TextStyle(fontSize: 12,color: Colors.white))),


            /* Expanded(
              child: Container(
                //padding: EdgeInsets.all(16.0),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.08
                        ),
                        backgroundColor: Colors.blue[900],
                        padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: const Text('Proceed to payment', style: TextStyle(fontSize: 12,color: Colors.white)),
                    ),
                    const SizedBox(height: 20, width: 40,),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),*/
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                 // MaterialPageRoute(builder: (context) => ScreenTwo()),
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
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          const BottomNavigationBarItem(
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
              Navigator.pop(
                context,
               // MaterialPageRoute(builder: (context) => ScreenTwo()),
              );
            // Navigate to Home
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenTwo()),
              );
            // Navigate to Settings
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenTwo()),
              );
            // Handle Logout
              break;
          }
        },
      ),
    );
  }
}
