import 'dart:io';
import 'package:cog_proh/announcements_screen/announcements_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';

import '../announcements_screen/widgets.dart';
import '../models/token_manager.dart'; // Add this import for mime type

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _isFormSubmitted = false;
  String username = '';
  String userId = '';
  String userStatus = '';
  bool isError = false;
  bool isLoading = true;
  File? _selectedImage;
  File? _pdf;

  late List<Widget> _pages;
  late Map<String, dynamic> _formData;

  @override
  void initState() {
    super.initState();
    _formData = {}; // Initialize an empty map for form data
    _pages = [
      GeneralPage(
        formData: _formData,
        moveToNextSection: () => _onItemTapped(1),
        pickImage: _pickImage,
        selectedImage: _selectedImage,
      ),
      AchievementsPage(
        formData: _formData,
        moveToNextSection: () => _onItemTapped(2),
        pickPDF: _pickPDF,
        pdf: _pdf,
      ),
      ScoresPage(
        formData: _formData,
        moveToNextSection: () => _onItemTapped(3),
      ),
      MiscellaneousPage(
        formData: _formData,
        submitForm: _submitForm,
      ),
    ];
    fetchUserData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _formData['photo'] = pickedFile.path; // Update formData
      });
    }
  }

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdf = File(result.files.single.path!);
        _formData['proof'] = result.files.single.path; // Update formData
      });
    }
  }

  Future<void> _submitForm() async {
    final token= await TokenManager.getAccessToken();
    try {
      var url = Uri.parse('http://10.0.2.2:8000/users/complete_profile/');

      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';

      // Add form fields
      request.fields['gender'] = _formData['gender'] ?? '';
      request.fields['grade'] = _formData['grade'] ?? '';
      request.fields['school'] = _formData['schoolName'] ?? '';
      request.fields['class_8_score'] = _formData['class_8_score'] ?? '';
      request.fields['class_9_score'] = _formData['class_9_score'] ?? '';
      request.fields['class_10_score'] = _formData['class_10_score'] ?? '';
      request.fields['class_11_score'] = _formData['class_11_score'] ?? '';
      request.fields['achievement1'] = _formData['achievement1'] ?? '';
      request.fields['achievement2'] = _formData['achievement2'] ?? '';
      request.fields['achievement3'] = _formData['achievement3'] ?? '';
      request.fields['reason'] = 'hjdhsd';
      request.fields['inspiring_startup_name'] = _formData['startupName'] ?? '';
      request.fields['challenges_ahead'] = _formData['challengesAhead'] ?? '';
      request.fields['oppurtunities_ahead'] =
          _formData['opportunitiesAhead'] ?? '';
      request.fields['tshirt_colour'] = 'red';

      // Add image file
      if (_selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_pic', // Field name in the API
          _selectedImage!.path,
          contentType:
          MediaType('image', 'jpeg'), // Adjust mime type if necessary
        ));
      }

      // Add PDF file
      if (_pdf != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'file', // Field name in the API
          _pdf!.path,
          contentType: MediaType('application', 'pdf'),
        ));
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        print('Data submitted successfully');
        setState(() {
          _isFormSubmitted = true;
        });
        _onItemTapped(_selectedIndex + 1);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data submitted successfully')),
        );
      } else {
        print('Failed to submit data. Error ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to submit data. Please try again later.')),
        );
      }
    } catch (e) {
      print('Error submitting data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error submitting data. Please try again later.')),
      );
    }
  }

  Future<void> fetchUserData() async {
    final token= await TokenManager.getAccessToken();
    final apiUrl = 'http://10.0.2.2:8000/users/user-info/';

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

  Future<void> fetchUserStatus() async {
    final token= await TokenManager.getAccessToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/users/user_status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
        'Bearer $token',
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

  Widget _buildNavButton(String text, int index) {
    bool isSelected = _selectedIndex == index;
    return TextButton(
      onPressed: () => _onItemTapped(index),
      style: TextButton.styleFrom(
        backgroundColor:
        isSelected ? Color.fromARGB(255, 1, 0, 94) : Colors.transparent,
        side: BorderSide(color: const Color.fromARGB(255, 1, 0, 94)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade300,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Spacer(), // Spacer to push the logo to the right
            Padding(
              padding: const EdgeInsets.only(
                  right: 16.0), // Adjust padding as needed
              child: Image.asset(
                'assets/icons/logo.webp',
                width: 100, // Adjust the width as needed
                height: 100, // Adjust the height as needed
              ),
            ),
          ],
        ),
      ),
      body:
      // isLoading
      //     ? Center(child: CircularProgressIndicator())
      //     : userStatus == 'profile_completed'
      //         ? Center(
      //             child: Text(
      //               'Profile Submitted!',
      //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //             ),
      //           ),
      //         : Center(
      //             child: Text(
      //               'Already applied',
      //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //             ),
      //           ),

      Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavButton('General', 0),
                    _buildNavButton('Achievements', 1),
                    _buildNavButton('%Score', 2),
                    _buildNavButton('Miscellaneous', 3),
                  ],
                ),
                SizedBox(height: 20), // Adjust spacing as needed
                _isFormSubmitted
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green, size: 98),
                      SizedBox(height: 15),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'Profile Completed',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : SizedBox
                    .shrink(), // Use SizedBox.shrink() to conditionally hide the widget
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
        ],
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
        },
      ),
    );
  }
}

// General Page

class GeneralPage extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback moveToNextSection;
  final Future<void> Function() pickImage;
  final File? selectedImage;

  GeneralPage(
      {required this.formData,
        required this.moveToNextSection,
        required this.pickImage,
        required this.selectedImage});

  @override
  _GeneralPageState createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  String? _selectedGender;

  TextEditingController _schoolAddressController = TextEditingController();
  TextEditingController _schoolNameController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();

  @override
  void dispose() {
    _schoolAddressController.dispose();
    _schoolNameController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        ListTile(
          leading: Icon(Icons.person_outline),
          title: Text('Gender'),
          subtitle: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: RadioListTile<String>(
                    title: Text(
                      'Male',
                      style: TextStyle(fontSize: 10.0),
                    ),
                    value: 'Male',
                    groupValue: _selectedGender,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedGender = value;
                        widget.formData['gender'] = value; // Update formData
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: RadioListTile<String>(
                    title: Text(
                      'Female',
                      style: TextStyle(fontSize: 10.0),
                    ),
                    value: 'Female',
                    groupValue: _selectedGender,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedGender = value;
                        widget.formData['gender'] = value; // Update formData
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _gradeController,
          decoration: InputDecoration(
            labelText: 'Grade',
            filled: true,
            fillColor: Colors.grey.shade200,
            prefixIcon: Icon(Icons.grade),
          ),
          onChanged: (value) =>
          widget.formData['grade'] = value, // Update formData
        ),
        SizedBox(height: 10),
        TextField(
          controller: _schoolNameController,
          decoration: InputDecoration(
            labelText: 'School Name',
            filled: true,
            fillColor: Colors.grey.shade200,
            prefixIcon: Icon(Icons.school),
          ),
          onChanged: (value) =>
          widget.formData['schoolName'] = value, // Update formData
        ),
        SizedBox(height: 10),
        TextField(
          controller: _schoolAddressController,
          decoration: InputDecoration(
            labelText: 'School Address',
            filled: true,
            fillColor: Colors.grey.shade200,
            prefixIcon: Icon(Icons.location_on),
          ),
          onChanged: (value) =>
          widget.formData['schoolAddress'] = value, // Update formData
        ),
        SizedBox(height: 10),
        ListTile(
          leading: Icon(Icons.photo_camera),
          title: Text('Upload passport size photo'),
          onTap: widget.pickImage,
        ),
        if (widget.selectedImage != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Image.file(widget.selectedImage!),
          ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            widget.moveToNextSection(); // Move to next section
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Color.fromARGB(255, 1, 0, 94)), // Background color
            foregroundColor:
            MaterialStateProperty.all(Colors.white), // Text color
          ),
          child: Text(
            'Next',
            style: TextStyle(color: Colors.white), // Text color
          ),
        ),
      ],
    );
  }
}

// Achievements Page

class AchievementsPage extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback moveToNextSection;
  final Future<void> Function() pickPDF;
  final File? pdf;

  AchievementsPage(
      {required this.formData,
        required this.moveToNextSection,
        required this.pickPDF,
        required this.pdf});

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  TextEditingController _achievement1Controller = TextEditingController();
  TextEditingController _achievement2Controller = TextEditingController();
  TextEditingController _achievement3Controller = TextEditingController();

  @override
  void dispose() {
    _achievement1Controller.dispose();
    _achievement2Controller.dispose();
    _achievement3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        TextField(
          controller: _achievement1Controller,
          decoration: InputDecoration(
            labelText: 'Achievement 1',
            filled: true,
            fillColor: Colors.grey.shade200,
            prefixIcon: Icon(Icons.star),
          ),
          onChanged: (value) =>
          widget.formData['achievement1'] = value, // Update formData
        ),
        SizedBox(height: 10),
        TextField(
          controller: _achievement2Controller,
          decoration: InputDecoration(
            labelText: 'Achievement 2',
            filled: true,
            fillColor: Colors.grey.shade200,
            prefixIcon: Icon(Icons.star),
          ),
          onChanged: (value) =>
          widget.formData['achievement2'] = value, // Update formData
        ),
        SizedBox(height: 10),
        TextField(
          controller: _achievement3Controller,
          decoration: InputDecoration(
            labelText: 'Achievement 3',
            filled: true,
            fillColor: Colors.grey.shade200,
            prefixIcon: Icon(Icons.star),
          ),
          onChanged: (value) =>
          widget.formData['achievement3'] = value, // Update formData
        ),
        SizedBox(height: 10),
        ListTile(
          leading: Icon(Icons.attachment),
          title: Text('Attach proof if any. Only in PDF format'),
          trailing: IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: widget.pickPDF,
          ),
        ),
        if (widget.pdf != null) ...[
          SizedBox(height: 10),
          Text('PDF Selected: ${widget.pdf!.path.split('/').last}'),
        ],
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            widget.moveToNextSection(); // Move to next section
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Color.fromARGB(255, 1, 0, 94)), // Background color
            foregroundColor:
            MaterialStateProperty.all(Colors.white), // Text color
          ),
          child: Text(
            'Next',
            style: TextStyle(color: Colors.white), // Text color
          ),
        ),
      ],
    );
  }
}

// Scores Page

class ScoresPage extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback moveToNextSection;

  ScoresPage({required this.formData, required this.moveToNextSection});

  @override
  _ScoresPageState createState() => _ScoresPageState();
}

class _ScoresPageState extends State<ScoresPage> {
  TextEditingController _class8ScoreController = TextEditingController();
  TextEditingController _class9ScoreController = TextEditingController();
  TextEditingController _class10ScoreController = TextEditingController();
  TextEditingController _class11ScoreController = TextEditingController();

  @override
  void dispose() {
    _class8ScoreController.dispose();
    _class9ScoreController.dispose();
    _class10ScoreController.dispose();
    _class11ScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        TextField(
          controller: _class8ScoreController,
          decoration: InputDecoration(
            labelText: 'Class 8 Score',
            filled: true,
            fillColor: Colors.grey.shade200,
            prefixIcon: Icon(Icons.score),
          ),
          onChanged: (value) =>
          widget.formData['class_8_score'] = value, // Update formData
        ),
        SizedBox(height: 10),
        TextField(
          controller: _class9ScoreController,
          decoration: InputDecoration(
            labelText: 'Class 9 Score',
            filled: true,
            fillColor: Colors.grey.shade200,
            prefixIcon: Icon(Icons.score),
          ),
          onChanged: (value) =>
          widget.formData['class_9_score'] = value, // Update formData
        ),
        SizedBox(height: 10),
        TextField(
          controller: _class10ScoreController,
          decoration: InputDecoration(
            labelText: 'Class 10 Score',
            filled: true,
            fillColor: Colors.grey.shade200,
            prefixIcon: Icon(Icons.score),
          ),
          onChanged: (value) =>
          widget.formData['class_10_score'] = value, // Update formData
        ),
        SizedBox(height: 10),
        TextField(
          controller: _class11ScoreController,
          decoration: InputDecoration(
            labelText: 'Class 11 Score',
            filled: true,
            fillColor: Colors.grey.shade200,
            prefixIcon: Icon(Icons.score),
          ),
          onChanged: (value) =>
          widget.formData['class_11_score'] = value, // Update formData
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            widget.moveToNextSection(); // Move to next section
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Color.fromARGB(255, 1, 0, 94)), // Background color
            foregroundColor:
            MaterialStateProperty.all(Colors.white), // Text color
          ),
          child: Text(
            'Next',
            style: TextStyle(color: Colors.white), // Text color
          ),
        ),
      ],
    );
  }
}

// Miscellaneous Page

class MiscellaneousPage extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback submitForm;

  MiscellaneousPage({required this.formData, required this.submitForm});

  @override
  _MiscellaneousPageState createState() => _MiscellaneousPageState();
}

class _MiscellaneousPageState extends State<MiscellaneousPage> {
  TextEditingController _startupNameController = TextEditingController();
  TextEditingController _challengesAheadController = TextEditingController();
  TextEditingController _opportunitiesAheadController = TextEditingController();

  @override
  void dispose() {
    _startupNameController.dispose();
    _challengesAheadController.dispose();
    _opportunitiesAheadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        TextField(
          controller: _startupNameController,
          decoration: InputDecoration(
            labelText: 'Inspiring Startup Name',
            filled: true,
            fillColor: Colors.grey.shade200,
            prefixIcon: Icon(Icons.business),
          ),
          onChanged: (value) =>
          widget.formData['startupName'] = value, // Update formData
        ),
        SizedBox(height: 10),
        TextField(
          controller: _challengesAheadController,
          decoration: InputDecoration(
            labelText: 'Challenges Ahead',
            filled: true,
            fillColor: Colors.grey.shade200,
            prefixIcon: Icon(Icons.warning),
          ),
          onChanged: (value) =>
          widget.formData['challengesAhead'] = value, // Update formData
        ),
        SizedBox(height: 10),
        TextField(
          controller: _opportunitiesAheadController,
          decoration: InputDecoration(
            labelText: 'Opportunities Ahead',
            filled: true,
            fillColor: Colors.grey.shade200,
            prefixIcon: Icon(Icons.lightbulb_outline),
          ),
          onChanged: (value) =>
          widget.formData['opportunitiesAhead'] = value, // Update formData
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            widget.submitForm();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Color.fromARGB(255, 1, 0, 94)), // Background color
            foregroundColor:
            MaterialStateProperty.all(Colors.white), // Text color
          ),
          child: Text(
            'Submit',
            style: TextStyle(color: Colors.white), // Text color
          ),
        ),
      ],
    );
  }
}
