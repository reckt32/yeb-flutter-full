import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cog_proh/a11.dart';
import '../utils.dart';
import 'curve_paint.dart';
import 'package:cog_proh/otherCode/aad1.dart';
import 'package:cog_proh/statusScreen.dart';
import 'package:cog_proh/otherCode/aadi3.dart';
import 'package:cog_proh/Devik/CompleteProfile.dart';
import 'package:cog_proh/Devik/more.dart';
import 'package:cog_proh/Tanay/U5.dart';
import 'package:cog_proh/Tanay/U6.dart';
import 'package:cog_proh/login/l8.dart';

TextStyle textFont = GoogleFonts.poppins();
Color primaryColor = const Color.fromRGBO(1, 0, 91, 1);

class AnnouncementsScreenWidget extends StatelessWidget {
  const AnnouncementsScreenWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: rely(context, 0.68),
          child: Stack(
            children: [
              // To draw the curves between stages
              CustomPaint(
                size: Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                ),
                painter: DashedPathPainter(
                  context: context,
                  isCompleted: context.watch<AppState>().isCompleted,
                ),
              ),

              // start of [positioning text description of each stage].
              // using relx , rely to get relative position
              const MyPositionedText(
                x: 0.24,
                y: 0.17,
                text: "Click here to Complete Profile",
              ),
              const MyPositionedText(
                x: 0.47,
                y: 0.59,
                text: "Click here to proceed for payment",
              ),
              const MyPositionedText(
                x: 0.65,
                y: 0.3,
                text: "Applicant Now",
              ),
              const MyPositionedText(
                x: 0.6,
                y: 0.055,
                text: "Participant Now",
              ),
              const MyPositionedText(
                x: 0.25,
                y: 0.01,
                text: "Click here\nto Report",
              ),
              const MyPositionedText(
                x: 0,
                y: 0.385,
                text: "Click here to\napply for YEB",
              ),
              const MyPositionedText(
                x: 0.48,
                y: 0.16,
                text: "Proceed\nto register",
              ),
              // end of [positioning text description of each stage].

              // start of [positioning icon (clickable) of each stage].
              MyPositioned(
                isComplete: context.watch<AppState>().isCompleted[0],
                x: 0.1,
                y: 0.05,
                icon: Icons.home, // Google material icon used
                onTap: () {
                  // Attempting to mark a stage completed
                  bool isPossible = context.read<AppState>().markCompleted(0);
                  if (isPossible) {
                    // Navigator.push(context, route);
                    // // context.read<AppState>().markNotCompleted(0); // if previous stage is un succesfull
                  }
                },
              ),
              MyPositioned(
                isComplete: context.watch<AppState>().isCompleted[1],
                x: 0.17,
                y: 0.17,
                icon: Icons.person,
                onTap: () {
                  bool isPossible = context.read<AppState>().markCompleted(1);
                  if (isPossible) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                    // Navigator.push(context, route);
                    // // context.read<AppState>().markNotCompleted(1); // if previous stage is un succesfull
                  }
                },
              ),
              MyPositioned(
                isComplete: context.watch<AppState>().isCompleted[3],
                x: 0.60,
                y: 0.55,
                icon: Icons.payment,
                onTap: () {
                  bool isPossible = context.read<AppState>().markCompleted(1);
                  if (isPossible) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => U5()));
                    // Navigator.push(context, route);
                    // // context.read<AppState>().markNotCompleted(1); // if previous stage is un succesfull
                  }
                  // refer line [94 - 98]
                  context.read<AppState>().markCompleted(3);
                },
              ),
              MyPositioned(
                isComplete: context.watch<AppState>().isCompleted[4],
                x: 0.78,
                y: 0.32,
                icon: Icons.check_circle,
                onTap: () {
                  // refer line [94 - 98]
                  context.read<AppState>().markCompleted(4);
                },
              ),
              MyPositioned(
                isComplete: context.watch<AppState>().isCompleted[6],
                x: 0.7,
                y: 0.08,
                icon: Icons.check_circle,
                onTap: () {
                  // bool isPossible = context.read<AppState>().markCompleted(1);
                  // if (isPossible) {
                  //   Navigator.push(context,
                  //       MaterialPageRoute(builder: (context) => U5()));
                  //   // Navigator.push(context, route);
                  //   // // context.read<AppState>().markNotCompleted(1); // if previous stage is un succesfull
                  // }
                  // refer line [94 - 98]
                  context.read<AppState>().markCompleted(6);
                },
              ),
              MyPositioned(
                isComplete: context.watch<AppState>().isCompleted[7],
                x: 0.5,
                y: 0.01,
                icon: Icons.lightbulb,
                onTap: () {
                  // refer line [94 - 98]
                  context.read<AppState>().markCompleted(7);
                },
              ),
              // end of [positioning icon (clickable) of each stage].

              // start of [positioning App Icon [YEB] (clickable) of respective stage stage].
              Positioned(
                top: rely(context, 0.38),
                left: relx(context, 0.3),
                child: AppIcon(
                  onTap: () {
                    bool isPossible = context.read<AppState>().markCompleted(1);
                    if (isPossible) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Mymore()
                          )
                      );
                      // Navigator.push(context, route);
                      // // context.read<AppState>().markNotCompleted(1); // if previous stage is un succesfull
                    }
                    // refer line [94 - 98]
                    context.read<AppState>().markCompleted(2);
                  },
                  color: context.watch<AppState>().isCompleted[2]
                      ? primaryColor
                      : Colors.grey,
                ),
              ),
              Positioned(
                top: rely(context, 0.15),
                left: relx(context, 0.75),
                child: AppIcon(
                  onTap: () {
                    bool isPossible = context.read<AppState>().markCompleted(5);
                    if (isPossible) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => U5()));
                      // Navigator.push(context, route);
                      // // context.read<AppState>().markNotCompleted(1); // if previous stage is un succesfull
                    }
                    // refer line [94 - 98]
                    context.read<AppState>().markCompleted(5);
                  },
                  color: context.watch<AppState>().isCompleted[5]
                      ? primaryColor
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const ActionButtons(), // Buttons for GD Detials, T-Shirt, .....
        // "chat with us" link
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {}, //TODO : implement route for chat with us page
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Chat with us",
                  style: textFont.copyWith(
                    color: primaryColor,
                    decoration: TextDecoration.underline,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.chat_bubble,
                    size: 20,
                    color: primaryColor,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // TODO: Implement route for GD Details button
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StatusBasedScreen()),
                  );
                },
                child: Text("GD Details", style: textFont),
              ),
            ),
            Flexible(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // TODO: Implement route for T-Shirt button
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TShirtScreen()),
                  );
                },
                child: Text("T-Shirt", style: textFont),
              ),
            ),
            Flexible(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // TODO: Implement route for Transport button
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AirportSelectionScreen()),
                  );
                },
                child: Text("Transport", style: textFont),
              ),
            ),
          ],
        ),
        SizedBox(height: 10), // Add some spacing between the rows
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            // TODO: Implement route for Accommodation button
            Navigator.pushNamed(context, '/accommodation');
          },
          child: Text("Accommodation", style: textFont),
        ),
      ],
    );
  }
}

// Widget to postion Stage ico
class MyPositioned extends StatelessWidget {
  const MyPositioned({
    super.key,
    required this.x,
    required this.y,
    required this.icon,
    required this.isComplete,
    required this.onTap,
  });

  final double x, y; // relavtive postion [in percent / 100 units]
  final IconData icon; // Icon to position
  final bool isComplete; // is the stage completed [to alter the color]
  final Function() onTap; // callback

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: relx(context, x),
      top: rely(context, y),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          icon,
          color: isComplete ? primaryColor : Colors.grey,
          size: 40,
        ),
      ),
    );
  }
}

// similar to [MyPositioned]
class MyPositionedText extends StatelessWidget {
  const MyPositionedText({
    super.key,
    required this.x,
    required this.y,
    required this.text,
  });

  final double x, y;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: relx(context, x),
      top: rely(context, y),
      child: SizedBox(
        width: relx(context, 0.35),
        child: Text(
          text,
          style: textFont.copyWith(color: primaryColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// The app child widget
class AppBarChild extends StatelessWidget {
  const AppBarChild({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color.fromARGB(255, 186, 174, 174),
          ),
          Column(
            children: [
              Text(
                "Riya Mittal", // TODO : callback to get user name
                style: textFont.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              // TODO : callback to get user id
              Text("@2021A42789P", style: textFont),
            ],
          ),
          const AppIcon(),
        ],
      ),
    );
  }
}

// Dummy function [used for default parameter]
void dummyCallBack() {}

// App icon [YEB Icon]
class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    this.color = const Color.fromRGBO(1, 0, 91, 1),
    this.onTap = dummyCallBack,
  });

  final Color color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        // TODO : Change text widget to orginal icon widget.
        child: Center(
          child: Text(
            "YEB",
            style: textFont.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

// Button Nav bar child widget
class BottomNavBarChild extends StatelessWidget {
  const BottomNavBarChild({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: primaryColor,
      // TODO: implement the on click
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app),
          label: "",
        ),
      ],
    );
  }
}
