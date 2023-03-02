
import 'package:flutter/material.dart';
import 'package:secondfirebaseproject/screen/Add_Employee.dart';
import 'package:secondfirebaseproject/screen/Add_Product.dart';
import 'package:secondfirebaseproject/screen/UpdateEmployee.dart';
import 'package:secondfirebaseproject/screen/UpdateProduct.dart';
import 'package:secondfirebaseproject/screen/ViewEmployee.dart';
import 'package:secondfirebaseproject/screen/View_Product.dart';

class Homepage extends StatefulWidget {

  @override
  State<Homepage> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase"),
      ),
      body: Center(
        child: Text("This is homepage"),
      ),
      drawer: Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text('Drawer Header'),
        ),
        ListTile(
          title:Text("Add Product"),
          onTap: () {

            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=>Addproduct())
            );
          },
        ),
        ListTile(
          title:Text("View Product"),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>View_Product())
            );
          },
        ),
        ListTile(
          title:Text("Add Employee"),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>AddEmployee())
            );
          },
        ),
        ListTile(
          title:Text("View Employee"),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>ViewEmployee())
            );
          },
        ),
      ],
    ),
    ),
    );
  }
}
