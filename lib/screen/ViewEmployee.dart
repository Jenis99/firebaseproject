import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:secondfirebaseproject/screen/UpdateEmployee.dart';
import 'package:secondfirebaseproject/screen/UpdateProduct.dart';

class ViewEmployee extends StatefulWidget {
  @override
  State<ViewEmployee> createState() => _ViewEmployeeState();
}

class _ViewEmployeeState extends State<ViewEmployee> {
  bool isload=false;
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("View Employee"),
        ),
        body:(isload)?CircularProgressIndicator(): StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Employees").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasData){

              if(snapshot.data!.size<0){
               return Center(
                  child: Text("Their is no Employee"),
                );
              }
              else{
                return ListView(
                  children: snapshot.data!.docs.map((document){

                  return Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.black12
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                           FadeInImage.assetNetwork(placeholder: "img/demo.jpg", image:document["fileurl"].toString(),width: 50.0),
                          // Image.network(document["fileurl"].toString(),width: 50.0,),
                          Text("Employee Name : "+document["firstname"].toString()),
                          Text("lastname : "+document["lastname"].toString()),
                          Text("middlename : "+document["middlename"].toString()),
                          Text("gender : "+document["gender"].toString()),
                          Text("description : "+document["description"].toString()),
                          Text("Position : "+document["position"].toString()),
                          Center(
                            child: ElevatedButton(
                              onPressed: ()async{
                                var id=document.id.toString();
                                var filename=document["filename"].toString();
                                setState(() {
                                  isload=true;
                                });
                                await FirebaseStorage.instance.ref("Employee/"+filename).delete().then((value) async{
                                   await FirebaseFirestore.instance.collection("Employees").doc(id).delete().then((value) {
                                  print("Data Deleted");
                                  setState(() {
                                  isload=false;
                                });
                                });
                                });
                               
                              },
                              child:Text("Delete") ),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async{
                                var id = document.id.toString();

                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=>UpdateEmployee(employeeid: id))
                                );
                                
                                
                              },
                              child: Text("Update")),
                          )
                        ],
                      ),
                    ),
                    // child: ListTile(
                    // title: Text(document["name"].toString()),
                    // trailing: Text(document["price"].toString()),
                    // leading: ElevatedButton(child: ),
                  );
                  }).toList()
                );
              }
            }
            else{
             return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
          )
      ); 
    }
  }

