import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:human_resource/screen/add_employee.dart';
import 'package:human_resource/screen/employee_directory.dart';
import 'package:human_resource/screen/login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  String userEmail = '';

  @override
  void initState(){
    super.initState();
    _loadUserData();
    user = _auth.currentUser;
}

  Future<void> _loadUserData() async {
    if(user != null){
      setState(() {
        userEmail = user!.email ?? 'Loading';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HR Management"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('image/monkey.jpg')
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Employee Directory"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmployeeDirectoryPage()));
              }
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Add Employee"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddEmployeePage() ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen() ));
              },
            )
          ],
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Welcome to \n HR Management",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
