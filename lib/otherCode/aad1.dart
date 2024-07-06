import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/*void main() {
  runApp(TShirtApp());
}

class TShirtApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T-Shirt Sizing Chart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TShirtScreen(),
    );
  }
}*/

class TShirtScreen extends StatefulWidget {
  @override
  _TShirtScreenState createState() => _TShirtScreenState();
}

class _TShirtScreenState extends State<TShirtScreen> {
  String _selectedSize = 'M';
  String _selectedColor = 'Red';

  Future<void> updateTshirt() async {
    final String apiUrl =
        'http://10.0.2.2:8000/users/tshirt/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU1OTExMDI3LCJpYXQiOjE3MTk5MTEwMjcsImp0aSI6ImFkYTE2ZGE3NDZkYTQ4M2I4NTJiNGRjODdiYzJlMGIyIiwidXNlcl9pZCI6Mn0.G86CMYcQJyK88CyoVALqGFyfiimaQF7E4e_ltAsQayI', // Replace with actual token
        },
        body: jsonEncode(<String, String>{
          'size': _selectedSize,
          'colour': _selectedColor,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('T-shirt preferences saved successfully!')),
        );
      } else {
        throw Exception('Failed to update T-shirt preferences');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('T-Shirt Sizing Chart'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                  child: SizedBox(
                      width: 300.0,
                      height: 500.0,
                      child: Image.asset('assets/icons/sizechart.jpg'))),
              SizedBox(height: 20),
              Text(
                'Select Size:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _selectedSize,
                items: <String>['XS', 'S', 'M', 'L', 'XL', 'XXL']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSize = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                'Select Color:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _selectedColor,
                items: <String>['Red', 'Blue', 'Green', 'Black']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedColor = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateTshirt,
                child: Text('Save T-shirt Preferences'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
