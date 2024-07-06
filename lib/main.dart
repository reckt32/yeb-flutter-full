import 'package:cog_proh/a2.dart';
import 'package:cog_proh/a3.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'a1.dart';
import 'a11.dart';
import 'package:cog_proh/otherCode/aad1.dart';
import 'package:cog_proh/otherCode/aadi2.dart';
import 'package:cog_proh/otherCode/aadi3.dart';
import 'gd_screen.dart';
import 'announcements_screen/announcements_screen.dart';
import 'package:provider/provider.dart';
import 'package:cog_proh/utils.dart';
import 'req_ext_gd.dart';


void main() {
  runApp(
    // AppState to manage the stages of completion.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child:  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
   MyApp({super.key});

  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Announcements(),
      //home: FeedbackScreen(),
    );
  }

//   Widget build (BuildContext context){
//     return MaterialApp(
//       title: 'Login-Screen',
//       theme: ThemeData(
//         primarySwatch:  Colors.deepOrange,
//       ),
//       //home: GDScreen(),
//       //home: A2(),
//       //home: A3(),
//       //home: AirportSelectionScreen(),
//       // home: FacultyListScreen(),
//       //home: TShirtScreen(),
//       //home: GDscreen(),
//       home:  Announcements(),
//     );
//   }
// }
//
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: InstructorListScreen(),
//       theme: ThemeData(
//         primaryColor: Colors.orange,
//         colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrange),
//         hintColor: Colors.deepOrange,
//         fontFamily: 'Roboto', // Change the font
//         textTheme: TextTheme(
//           bodyText2: TextStyle(color: Colors.black87),
//         ),
//       ),
//     );
//   }
// }
//
// class InstructorListScreen extends StatefulWidget {
//   @override
//   _InstructorListScreenState createState() => _InstructorListScreenState();
// }
//
// class _InstructorListScreenState extends State<InstructorListScreen> {
//   final List<Instructor> instructors = List.generate(
//     20,
//         (index) => Instructor(
//       name: 'Instructor ${index + 1}',
//       specialty: 'Specialty ${(index % 5) + 1}',
//       rating: (3 + Random().nextInt(3)).toDouble(), // Random rating between 3 and 5
//     ),
//   );
//
//   List<Instructor> filteredInstructors = [];
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     filteredInstructors = instructors;
//   }
//
//   void filterInstructors() {
//     setState(() {
//       String query = searchController.text.toLowerCase();
//       filteredInstructors = instructors.where((instructor) {
//         return instructor.name.toLowerCase().contains(query);
//       }).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.orange,
//         title: Text(
//           'Explore Instructors',
//           style: TextStyle(color: Colors.black), // Set title color to black
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               onChanged: (value) {
//                 filterInstructors();
//               },
//               decoration: InputDecoration(
//                 hintText: 'Search',
//                 prefixIcon: Icon(Icons.search, color: Colors.orange),
//                 filled: true,
//                 fillColor: Colors.orange[50],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30.0),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 FilterChip(
//                   label: Text('Stars'),
//                   onSelected: (bool value) {},
//                   backgroundColor: Colors.orange[100],
//                   selectedColor: Colors.orange[300],
//                 ),
//                 SizedBox(width: 8),
//                 FilterChip(
//                   label: Text('Category'),
//                   onSelected: (bool value) {},
//                   backgroundColor: Colors.orange[100],
//                   selectedColor: Colors.orange[300],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredInstructors.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
//                   child: InstructorCard(instructor: filteredInstructors[index]),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomAppBar(
//         shape: CircularNotchedRectangle(),
//         notchMargin: 8.0,
//         child: BottomNavigationBar(
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.settings),
//               label: 'Settings',
//             ),
//             BottomNavigationBarItem(
//               icon: SizedBox.shrink(),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.star),
//               label: 'Premium',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: 'Profile',
//             ),
//           ],
//           selectedItemColor: Colors.orange,
//           unselectedItemColor: Colors.grey,
//           showSelectedLabels: false,
//           showUnselectedLabels: false,
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.white,
//           elevation: 8.0,
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         backgroundColor: Colors.orange,
//         child: Icon(Icons.video_call, color: Colors.white),
//         elevation: 4.0,
//       ),
//     );
//   }
// }
//
// class Instructor {
//   final String name;
//   final String specialty;
//   final double rating;
//
//   Instructor({
//     required this.name,
//     required this.specialty,
//     required this.rating,
//   });
// }
//
// class InstructorCard extends StatelessWidget {
//   final Instructor instructor;
//
//   InstructorCard({required this.instructor});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       elevation: 5,
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundImage: NetworkImage('https://via.placeholder.com/150'),
//         ),
//         title: Text(instructor.name),
//         subtitle: Text(instructor.specialty),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.star, color: Colors.orange),
//             Text(instructor.rating.toString()),
//           ],
//         ),
//         onTap: () {},
//       ),
//     );
//   }
// }


}