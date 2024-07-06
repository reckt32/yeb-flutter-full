import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cog_proh/announcements_screen/widgets.dart';

class Mymore extends StatefulWidget {
  const Mymore({Key? key}) : super(key: key);

  @override
  State<Mymore> createState() => _MymoreState();
}

class _MymoreState extends State<Mymore> {
  String? _selectedEvent;
  String? _eventname;
  bool _isSubmissionSuccessful = false;
  String username = '';
  String userId = '';
  String userStatus = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchUserStatus();
  }

  final String apiUrl = 'http://10.0.2.2:8000/events/event_list/';
  final String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU1OTExMDI3LCJpYXQiOjE3MTk5MTEwMjcsImp0aSI6ImFkYTE2ZGE3NDZkYTQ4M2I4NTJiNGRjODdiYzJlMGIyIiwidXNlcl9pZCI6Mn0.G86CMYcQJyK88CyoVALqGFyfiimaQF7E4e_ltAsQayI'; // Replace with your actual token

  Future<void> fetchUserStatus() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/users/user_status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        userStatus = data['status'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load user status');
    }
  }

  Future<List<dynamic>> fetchEvents() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load events');
    }
  }

  void _submitForm() async {
    if (_selectedEvent != null && _eventname != null) {
      // Ensure _eventname is also not null
      final url = Uri.parse('http://10.0.2.2:8000/users/has_applied/');
      final String _token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU1OTExMDI3LCJpYXQiOjE3MTk5MTEwMjcsImp0aSI6ImFkYTE2ZGE3NDZkYTQ4M2I4NTJiNGRjODdiYzJlMGIyIiwidXNlcl9pZCI6Mn0.G86CMYcQJyK88CyoVALqGFyfiimaQF7E4e_ltAsQayI'; // Replace with your actual token

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
          body: jsonEncode({
            'static_id': _selectedEvent!,
            'name': _eventname!,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print('Success: ${responseData['message']}');
          setState(() {
            _isSubmissionSuccessful = true;
          });
        } else {
          print('Failed: ${response.statusCode}');
          print('Error: ${response.body}');
          setState(() {
            _isSubmissionSuccessful = false;
          });
        }
      } catch (e) {
        print('Exception caught: $e');
        setState(() {
          _isSubmissionSuccessful = false;
        });
      }
    } else {
      print('Please select an event first.');
    }
  }

  Future<void> fetchUserData() async {
    final apiUrl = 'http://10.0.2.2:8000/users/user-info/';
    final token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU1OTExMDI3LCJpYXQiOjE3MTk5MTEwMjcsImp0aSI6ImFkYTE2ZGE3NDZkYTQ4M2I4NTJiNGRjODdiYzJlMGIyIiwidXNlcl9pZCI6Mn0.G86CMYcQJyK88CyoVALqGFyfiimaQF7E4e_ltAsQayI'; // Replace with your actual token

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
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
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 130,
          backgroundColor: Color.fromARGB(255, 1, 0, 94),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade300,
              ),
              Text(
                username,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ), // Spacer to push the logo to the right
              Image.asset(
                'assets/icons/logo.webp',
                width: 100, // Adjust the width as needed
                height: 100, // Adjust the height as needed
              ),
            ],
          ),
        ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userStatus == 'profile_completed'
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _showEventSelectionDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color.fromARGB(255, 1, 0, 94),
                          side:
                              BorderSide(color: Color.fromARGB(255, 1, 0, 94)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_selectedEvent == null
                                ? 'Apply for YEB event'
                                : _eventname!),
                            const Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 1, 0, 94),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text('Submit Application'),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (_isSubmissionSuccessful)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green, size: 98),
                              const SizedBox(height: 15),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  'Application Submitted',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Back'),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    'Already applied',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: '',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          {
            switch (index) {
              case 0:
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AnnouncementsScreenWidget()),
                );
                break;
              case 1:
                break;
              case 2:
                break;
            }
            // Handle bottom navigation bar tap if needed
          }
          ;
          // Handle bottom navigation bar tap if needed
        },
      ),
    );
  }

  void _showEventSelectionDialog(BuildContext context) async {
    try {
      List<dynamic> events = await fetchEvents();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select YEB Event'),
            content: SingleChildScrollView(
              child: ListBody(
                children: events.map((event) {
                  return GestureDetector(
                    child: Text(event['name']),
                    onTap: () {
                      setState(() {
                        _selectedEvent = event['static_id'];
                        _eventname = event['name'];
                      });
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Exception caught: $e');
    }
  }
}
