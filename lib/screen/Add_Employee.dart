import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondfirebaseproject/screen/ViewEmployee.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  TextEditingController _firstname=TextEditingController();
  TextEditingController _lastname=TextEditingController();
  TextEditingController _middlename=TextEditingController();
  TextEditingController _price=TextEditingController();
  TextEditingController _description=TextEditingController();
  var _gender="male";
  var _category ="flutter";
  bool isloading=false;

   ImagePicker _picker = ImagePicker();
   File? selectefile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Employee"),
      ),
      body: SingleChildScrollView(
          child: (
              Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 10.0,right: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (selectefile==null)?Image.asset("img/demo.jpg"):Image.file(selectefile!,width: 100.0,),
                            SizedBox(height: 10.0,),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () async{  
                                    XFile? image = await _picker.pickImage(source: ImageSource.camera);
                                    setState(() {
                                      selectefile = File(image!.path);
                                    });
                                }, 
                                child: Text("Camera")),

                                ElevatedButton(
                                  onPressed: () async{
                                    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                                    setState(() {
                                      selectefile = File(image!.path);
                                    });
                                }, 
                                child: Text("Gallery")),
                              ],
                            ),
                            SizedBox(height: 10.0,),
                            Text("Firstname",style: TextStyle(
                                fontSize: 20.0
                            ),),
                            SizedBox(height: 5.0,),
                            TextField(
                              decoration: InputDecoration (
                                focusedBorder: OutlineInputBorder(
                                  borderSide:BorderSide(color: Colors.blue ),
                                ),
                                enabledBorder:  OutlineInputBorder(
                                  borderSide:BorderSide(color: Colors.black),
                                ),
                              ),
                              controller: _firstname,
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: 10.0,),
                            Text("Middlename",style: TextStyle(
                                fontSize: 20.0
                            ),),
                            SizedBox(height: 5.0,),
                            TextField(
                              decoration: InputDecoration (
                                focusedBorder: OutlineInputBorder(
                                  borderSide:BorderSide(color: Colors.blue ),
                                ),
                                enabledBorder:  OutlineInputBorder(
                                  borderSide:BorderSide(color: Colors.black),
                                ),
                              ),
                              controller: _middlename,
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: 10.0,),
                            Text("Lastname",style: TextStyle(
                                fontSize: 20.0
                            ),),
                            SizedBox(height: 5.0,),
                            TextField(
                              decoration: InputDecoration (
                                focusedBorder: OutlineInputBorder(
                                  borderSide:BorderSide(color: Colors.blue ),
                                ),
                                enabledBorder:  OutlineInputBorder(
                                  borderSide:BorderSide(color: Colors.black),
                                ),
                              ),
                              controller: _lastname,
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: 10.0,),
                            Text("Gender",style: TextStyle(
                                fontSize: 20.0
                            ),),
                            Row(
                              children: [
                                Radio(
                                  value: "Male", groupValue: _gender, onChanged: (value){
                                  setState(() {
                                    _gender=value!;
                                  });
                                },),
                                Text("Male") ,
                                Radio(
                                  value: "Female", groupValue: _gender, onChanged: (value){
                                  setState(() {
                                    _gender=value!;
                                  });
                                },),
                                Text("Female"),
                              ],
                            ),
                            Text("Discription",style: TextStyle(
                                fontSize: 20.0
                            ),),
                            SizedBox(height: 5.0,),
                            TextField(
                              decoration: InputDecoration (
                                focusedBorder: OutlineInputBorder(
                                  borderSide:BorderSide(color: Colors.blue ),
                                ),
                                enabledBorder:  OutlineInputBorder(
                                  borderSide:BorderSide(color: Colors.black),
                                ),
                              ),
                              controller: _description,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            ),
                            SizedBox(height: 15.0,),
                            Text("Position",style: TextStyle(
                                fontSize: 20.0
                            ),),
                            Container(child: DropdownButton(
                              value: _category,
                              onChanged: (val) {
                                setState(() {
                                  _category = val!;
                                });
                              },
                              items: [
                                DropdownMenuItem(
                                  child: Text("Flutter Developer",style: TextStyle(
                                    fontSize: 13.0,
                                  ),),
                                  value: "flutter",),
                                DropdownMenuItem(
                                  child: Text("Web Designer"),
                                  value: "designer",),
                                DropdownMenuItem(
                                  child: Text("UI/UX Designer"),
                                  value: "UI/UX",),
                                DropdownMenuItem(
                                  child: Text("Backend Devloper"),
                                  value: "backend",),
                              ],
                            ),
                            ),
                            Center(
                              child:  (isloading)?CircularProgressIndicator():ElevatedButton(onPressed: () async{
                               
                                var firstname=_firstname.text.toString();
                                var lastname=_lastname.text.toString();
                                var middlename=_middlename.text.toString();
                                var gender=_gender.toString();
                                var description=_description.text.toString();
                                var category=_category.toString();

                               

                                if(selectefile==null){
                                  Fluttertoast.showToast(
                                  msg: "please select the image",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                                }
                                else{
                                   setState(() {
                                      isloading = true;
                                      });
                               var uuid = Uuid();
                                var filename=uuid.v1().toString();

                                // get data of uploaded file

                                await FirebaseStorage.instance.ref("Employee/"+filename).putFile(selectefile!).whenComplete(() => (){}).then((filedata)async{

                                await filedata.ref.getDownloadURL().then((fileurl) async {
                                await FirebaseFirestore.instance.collection("Employees").add({
                                  "firstname":firstname,
                                  "lastname":lastname,
                                  "middlename":middlename,
                                  "gender":gender,
                                  "description":description,
                                  "position":category,
                                  "fileurl": fileurl,
                                  "filename": filename,
                                }).then((value) {
                                  setState(() {
                                    isloading = false;
                                  });
                                  print("Insert Succesfully!");
                                });
                              });
                                });
                                await FirebaseFirestore.instance.collection("Employees").add({
                                  "firstname":firstname,
                                  "lastname":lastname,
                                  "middlename":middlename,
                                  "gender":gender,
                                  "description":description,
                                  "position":category,
                                }).then((value){
                                  print("Inseted employee suceesfully!!!");
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=>ViewEmployee())
                                );
                                });
                                }
                                
                                print(firstname);
                                print(lastname);
                                print(middlename);
                                print(description);
                                print(gender);
                                print(category);

                              
                              }, child: Padding(
                                padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 10.0),
                                child: Text("Add",style: TextStyle(
                                    fontSize: 20.0
                                ),),
                              )),
                            )
                          ],
                        )
                    ),
                  ]
              )
          )
      ),
    );
  }
}
