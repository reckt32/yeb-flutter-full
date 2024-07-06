import 'package:flutter/material.dart';

//saari details fetch karni hongi uske fuctions likho
class A1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: AppBar(
          toolbarHeight: (100.0),
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(10.0))),
          backgroundColor: Colors.blue[900],
          //toolbarHeight: 40,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              radius: 30,
              child: Icon(
                Icons.person,
                color: Color(0xffCCCCCC),
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Text(
                    'Shirish the Don',
                      style: TextStyle(color: Colors.white, fontSize: 38.0,),
                  ),
                  Text(
                    '@6969420',
                    style: TextStyle(color: Colors.white, fontSize: 20.0,),
                  ),
                ],
              ),
              Image.asset('assets/icons/google.png'),

            ],
          ),
          /*actions: [
            Icon(Icons.signal_cellular_alt),
            SizedBox(width: 10),
            Icon(Icons.wifi),
            SizedBox(width: 10),
            Icon(Icons.battery_full),
            SizedBox(width: 10),
          ],*/
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
                  color: Colors.blue[900]),
              textAlign: TextAlign.center,
            ),
            Text(
              'You have been selected for GD!',
              style: TextStyle(fontSize: 18, color: Colors.blue[900]),
              textAlign: TextAlign.center,
            ),
            Text(
              'Your GD is scheduled on DD/MM/YY at 4:30pm',
              style: TextStyle(fontSize: 18, color: Colors.blue[900]),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2), // Transparent grey color
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(16.0),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      child: const Text('Accept', style: TextStyle(fontSize: 16,color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.08
                        ),
                        backgroundColor: Colors.blue[900],
                        padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: const Text('Deny', style: TextStyle(fontSize: 16,color: Colors.white )),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.08
                        ),
                        backgroundColor: Colors.blue[900],
                        padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: const Text('Request Extension',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
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
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          // Handle navigation on tap
          switch (index) {
            case 0:
            // Navigate to Home
              break;
            case 1:
            // Navigate to Settings
              break;
            case 2:
            // Handle Logout
              break;
          }
        },
      ),
    );
  }
}
