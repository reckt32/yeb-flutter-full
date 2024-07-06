 import 'package:flutter/material.dart';

 class GDAcceptedScreen extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: Text('GD Accepted')),
       body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(
               Icons.check_circle_outline,
               color: Colors.green,
               size: 100.0,
             ),
             SizedBox(height: 20),
             Text(
               'You have accepted the GD',
               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
             ),
           ],
         ),
       ),
     );
   }
 }
