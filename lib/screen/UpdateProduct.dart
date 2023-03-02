import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondfirebaseproject/screen/ViewEmployee.dart';
import 'package:secondfirebaseproject/screen/View_Product.dart';
import 'package:uuid/uuid.dart';

class UpdateProduct extends StatefulWidget {

  var updatedid="";
  UpdateProduct({required this.updatedid});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  TextEditingController _product = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _description = TextEditingController();
  var _type = "variable";
  var _category = "clothing";
  File? selectedfile;

  bool isloading = false;

  ImagePicker _picker = ImagePicker();

  var oldimagename="";
  var oldimageurl="";

  getsingledata() async
  {
    await FirebaseFirestore.instance.collection("Products").doc(widget.updatedid).get().then((document){
      _product.text = document["name"].toString();
      _price.text = document["price"].toString();
      _description.text = document["description"].toString();
      setState(() {
        _type= document["type"].toString();
        _category= document["category"].toString();
        oldimagename= document["filename"].toString();
        oldimageurl= document["fileurl"].toString();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsingledata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Product"),
      ),
      body: SingleChildScrollView(
          child: (Column(children: [
        Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (selectedfile == null)?(oldimageurl!="")?Image.network(oldimageurl)
                :Image.asset("img/demo.jpg"): Image.file(selectedfile!,width: 200, ),
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
                      groupValue: _type,
                      onChanged: (value) {
                        setState(() {
                          _type = value!;
                        });
                      },
                    ),
                    Text("simple"),
                    Radio(
                      value: "variable",
                      groupValue: _type,
                      onChanged: (value) {
                        setState(() {
                          _type = value!;
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
                    value: _category,
                    onChanged: (val) {
                      setState(() {
                        _category = val!;
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
                            var type = _type.toString();
                            var description = _description.text.toString();
                            var category = _category.toString();

                            var uuid = Uuid();
                            var filename = uuid.v4().toString();

                            if(selectedfile==null)
                            {
                              await FirebaseFirestore.instance.collection("Products").doc(widget.updatedid).update({
                                  "name": name,
                                  "price": price,
                                  "type": type,
                                  "description": description,
                                  "category": category,
                              }).then((value){
                                Navigator.of(context).pop();
                              });
                            }
                            else
                            {
                              await FirebaseStorage.instance.ref("products/" + oldimagename).delete().then((value) async{

                                  await FirebaseStorage.instance.ref("products/" + filename).putFile(selectedfile!).whenComplete(() {}).then((filedata) async {

                                    await filedata.ref.getDownloadURL().then((fileurl) async {

                                      await FirebaseFirestore.instance.collection("Products").doc(widget.updatedid).update({
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
                                        });
                                      });
                                    });
                                  });
                              });
                            }

                            
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Text(
                              "Update",
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
