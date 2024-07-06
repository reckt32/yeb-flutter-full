import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/*void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faculty Directory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FacultyListScreen(),
    );
  }
}*/

class Staff {
  final String name;
  final String mobile;
  final List<String> students;
  final String? instruction;

  Staff({
    required this.name,
    required this.mobile,
    required this.students,
    this.instruction,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      name: json['name'],
      mobile: json['mobile'].toString(),
      students:
          (json['students'] as List<dynamic>).map((e) => e.toString()).toList(),
      instruction: json['instruction'],
    );
  }
}

class FacultyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty Directory'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransportStaffScreen()),
            );
          },
          child: Text('View Transport Staff'),
        ),
      ),
    );
  }
}

class TransportStaffScreen extends StatefulWidget {
  @override
  _TransportStaffScreenState createState() => _TransportStaffScreenState();
}

class _TransportStaffScreenState extends State<TransportStaffScreen> {
  Future<Staff>? _staffFuture;

  @override
  void initState() {
    super.initState();
    _staffFuture = _fetchStaffDetails();
  }

  Future<Staff> _fetchStaffDetails() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/accomodations/transport_staff'),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU1OTExMDI3LCJpYXQiOjE3MTk5MTEwMjcsImp0aSI6ImFkYTE2ZGE3NDZkYTQ4M2I4NTJiNGRjODdiYzJlMGIyIiwidXNlcl9pZCI6Mn0.G86CMYcQJyK88CyoVALqGFyfiimaQF7E4e_ltAsQayI',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Staff.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load staff details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transport Staff Details'),
      ),
      body: FutureBuilder<Staff>(
        future: _staffFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final staff = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${staff.name}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Mobile: ${staff.mobile}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  Text('Students:', style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: staff.students.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(staff.students[index]),
                        );
                      },
                    ),
                  ),
                  if (staff.instruction != null)
                    Text('Instruction: ${staff.instruction}',
                        style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
