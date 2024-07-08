import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/token_manager.dart';

Color primaryColor = const Color.fromRGBO(1, 0, 91, 1);
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<dynamic> sessions = [];
  String? selectedSessionId;
  final TextEditingController feedbackController = TextEditingController();
  var token;

  @override
  void initState() {
    super.initState();
    fetchSessions();
    fetchUserData();
    TokenManager.getAccessToken().then((value) => <void>{
      setState(() {
        token = value;
      })
    });
  }
  String userId='';
  String username='';

  Future<void> fetchSessions() async {
    final url = Uri.parse('http://127.0.0.1:8000/events/list_sessions/');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include the token in the headers
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        sessions = jsonDecode(response.body);
      });
    } else {
      if (kDebugMode) {
        print('Failed to fetch sessions: ${response.reasonPhrase}');
      }
    }
  }

  Future<void> fetchUserData() async {
    final apiUrl = 'http://10.0.0.2:8000/users/user-info/'; // Agar tum chrome mai chala rahe ho toh ttp://127.0.0.1:8000/users/user-info/ use karna agar android emulator mai chalana hai to 10.0.2.2 kardo
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

  Future<void> submitFeedback(String sessionId, String feedback) async {
    final url = Uri.parse('http://127.0.0.1:8000/events/create_feedback/');
    const token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU2MTAxODgxLCJpYXQiOjE3MjAxMDE4ODEsImp0aSI6IjY2OWM1ZjYxZjE3ZDQxMmZiNmMzMjliMDg3MzA5YmFmIiwidXNlcl9pZCI6MTJ9.r7kCTXM81VkGtJqErSCNQh20ZMVBx35MeWPq75NhNcg'; // Replace with your actual token

    final payload = {
      'session_id': sessionId,
      'feedback': feedback,
    };

    if (kDebugMode) {
      print('Request payload: $payload');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include the token in the headers
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      // Handle successful submission
      if (kDebugMode) {
        print('Feedback submitted successfully');
      }
    } else {
      // Handle submission error
      if (kDebugMode) {
        print(
            'Failed to submit feedback: ${response.statusCode} ${response.reasonPhrase}');
        print('Response body: ${response.body}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Image.asset('assets/YEB.png')),//chjange kar dena tanvi ke path sse
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFF002366), // Use the exact shade of blue
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Column(
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.grey,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Riya Mittal',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        Text(
                          '@2021A42789P',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  const Text(
                    'PROVIDE FEEDBACK',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF002366), // Use the exact shade of blue
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hintText: 'Select Session',
                            fillColor: Colors.grey[100],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items:
                              sessions.map<DropdownMenuItem<String>>((session) {
                            return DropdownMenuItem<String>(
                              value: session['id'].toString(),
                              child: Text(session['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSessionId = value;
                            });
                          },
                          value: selectedSessionId,
                        ),
                        const SizedBox(height: 20.0),
                        TextField(
                          controller: feedbackController,
                          decoration: InputDecoration(
                            hintText: 'Feedback',
                            fillColor: Colors.grey[100],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Navigate back to the previous screen
                        },
                        child: const Text(
                          'Back',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: selectedSessionId == null
                            ? null
                            : () {
                                submitFeedback(
                                  selectedSessionId!,
                                  feedbackController.text,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                              0xFF002366), // Use the exact shade of blue
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
