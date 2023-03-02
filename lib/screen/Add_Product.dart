import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondfirebaseproject/screen/ViewEmployee.dart';
import 'package:secondfirebaseproject/screen/View_Product.dart';
import 'package:uuid/uuid.dart';

class Addproduct extends StatefulWidget {
  const Addproduct({Key? key}) : super(key: key);

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  TextEditingController _product = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _description = TextEditingController();
  var _value = "variable";
  var _selected = "clothing";
  File? selectedfile;

  bool isloading = false;

  ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: SingleChildScrollView(
          child: (Column(children: [
        Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (selectedfile == null)? Image.asset("img/demo.jpg"): Image.file(selectedfile!,width: 200, ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          XFile? photo = await _picker.pickImage(
                              source: ImageSource.camera);
                          setState(() {
                            selectedfile = File(photo!.path);
                          });
                        },
                        child: Text("Camera")),
                    ElevatedButton(
                        onPressed: () async {
                          XFile? photo = await _picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            selectedfile = File(photo!.path);
                          });
                        },
                        child: Text("Gallery")),
                  ],
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Product Name",
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  controller: _product,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Price",
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  controller: _price,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Types",
                  style: TextStyle(fontSize: 20.0),
                ),
                Row(
                  children: [
                    Radio(
                      value: "simple",
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value!;
                        });
                      },
                    ),
                    Text("simple"),
                    Radio(
                      value: "variable",
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value!;
                        });
                      },
                    ),
                    Text("variable"),
                  ],
                ),
                Text(
                  "Discription",
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  controller: _description,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "Categories",
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 3.0,
                ),
                Container(
                  child: DropdownButton(
                    value: _selected,
                    onChanged: (val) {
                      setState(() {
                        _selected = val!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          "Clothing",
                          style: TextStyle(
                            fontSize: 13.0,
                          ),
                        ),
                        value: "clothing",
                      ),
                      DropdownMenuItem(
                        child: Text("Footwear"),
                        value: "Footwear",
                      ),
                      DropdownMenuItem(
                        child: Text("Furnitures"),
                        value: "Furnitures",
                      ),
                    ],
                  ),
                ),
                Center(
                  child: (isloading)
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isloading = true;
                            });
                            var name = _product.text.toString();
                            var price = _price.text.toString();
                            var type = _value.toString();
                            var description = _description.text.toString();
                            var category = _selected.toString();

                            var uuid = Uuid();
                            var filename = uuid.v4().toString();

                            await FirebaseStorage.instance.ref("products/" + filename).putFile(selectedfile!).whenComplete(() {}).then((filedata) async {
                              await filedata.ref.getDownloadURL().then((fileurl) async {
                                await FirebaseFirestore.instance.collection("Products").add({
                                  "name": name,
                                  "price": price,
                                  "type": type,
                                  "description": description,
                                  "category": category,
                                  "fileurl": fileurl,
                                  "filename": filename
                                }).then((value) {
                                  setState(() {
                                    isloading = false;
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                       MaterialPageRoute(builder: (context)=>View_Product())
                                    );
                                  });
                                  print("Insert Succesfully!");
                                });
                              });
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Text(
                              "Add",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          )),
                )
              ],
            )),
      ]))),
    );
  }
}
