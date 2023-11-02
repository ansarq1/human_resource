import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeDirectoryPage extends StatefulWidget {
  @override
  _EmployeeDirectoryPageState createState() => _EmployeeDirectoryPageState();
}

class _EmployeeDirectoryPageState extends State<EmployeeDirectoryPage> {
  List<DocumentSnapshot> employeeData = [];

  @override
  void initState() {
    super.initState();
    _fetchEmployeeData();
  }

  void _fetchEmployeeData() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot employeeSnapshot =
    await firestore.collection('employee data').get();

    setState(() {
      employeeData = employeeSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Directory"),
      ),
      body: ListView.builder(
        itemCount: employeeData.length,
        itemBuilder: (context, index) {
          var employee = employeeData[index].data() as Map<String, dynamic>?;
          if (employee != null) {
            return ListTile(
              title: Text(employee['employee name'] ?? 'Name not available'),
              subtitle: Text(employee['position'] ?? 'Position not available'),
              leading: const Icon(Icons.person),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // You can add code here to handle the tap event for each employee.
              },
            );
          } else {
            return ListTile(
              title: Text('Employee data not available'),
            );
          }
        },
      ),
    );
  }
}
