import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AirportSelectionScreen(),
    );
  }
}
*/
class AirportSelectionScreen extends StatefulWidget {
  @override
  _AirportSelectionScreenState createState() => _AirportSelectionScreenState();
}

class _AirportSelectionScreenState extends State<AirportSelectionScreen> {
  String? _selectedAirportId;
  String? _selectedType;
  List<Map<String, dynamic>> _airports = [];
  bool _isLoading = true;

  final List<String> _types = ['pickup', 'drop'];

  @override
  void initState() {
    super.initState();
    _fetchAirports();
  }

  Future<void> _fetchAirports() async {
    final url = 'http://10.0.2.2:8000/accomodations/airport_list';
    final headers = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU1OTExMDI3LCJpYXQiOjE3MTk5MTEwMjcsImp0aSI6ImFkYTE2ZGE3NDZkYTQ4M2I4NTJiNGRjODdiYzJlMGIyIiwidXNlcl9pZCI6Mn0.G86CMYcQJyK88CyoVALqGFyfiimaQF7E4e_ltAsQayI',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> airportsData = json.decode(response.body);
        setState(() {
          _airports = List<Map<String, dynamic>>.from(airportsData);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load airports');
      }
    } catch (e) {
      print('Error fetching airports: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading airports. Please try again.')),
      );
    }
  }

  Future<void> _createTransport() async {
    if (_selectedAirportId == null || _selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select airport/terminal and type')),
      );
      return;
    }

    final url = 'http://10.0.2.2:8000/accomodations/create_transport/';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU1OTExMDI3LCJpYXQiOjE3MTk5MTEwMjcsImp0aSI6ImFkYTE2ZGE3NDZkYTQ4M2I4NTJiNGRjODdiYzJlMGIyIiwidXNlcl9pZCI6Mn0.G86CMYcQJyK88CyoVALqGFyfiimaQF7E4e_ltAsQayI',
    };

    final body = json.encode({
      'airport_static_id': _selectedAirportId,
      'type': _selectedType,
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to create transport: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Airport and Terminal'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedAirportId,
                    decoration: InputDecoration(
                      labelText: 'Select Airport and Terminal',
                      border: OutlineInputBorder(),
                    ),
                    items: _airports.map((airport) {
                      return DropdownMenuItem<String>(
                        value: airport['static_id'],
                        child: Text(
                            '${airport['name']} Terminal ${airport['terminal_name']}'),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedAirportId = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: 'Select Type',
                      border: OutlineInputBorder(),
                    ),
                    items: _types.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _createTransport,
                      child: Text('Create Transport'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
