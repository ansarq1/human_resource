import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddEmployeePage extends StatefulWidget {
  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saving() async {
    setState(() {
      isSaving = true;
    });

    final employeeData = {
      'employee name': nameController.text,
      'position': positionController.text,
      'email': emailController.text
    };

    await _firestore.collection('employee data').add(employeeData);

    setState(() {
      nameController.clear();
      positionController.clear();
      emailController.clear();
      isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "Employee Added Successfully",
            style: TextStyle(
              fontSize: 16
            ),
            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Employee"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: positionController,
                decoration: const InputDecoration(
                  labelText: "Position",
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a position';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isSaving ? null : () async {
                  if (_formKey.currentState!.validate()) {
                    await _saving();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: isSaving ? const CircularProgressIndicator(
                  color: Colors.black,
                ) :
                const Text(
                  "Save Employee",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

