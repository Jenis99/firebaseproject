import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:secondfirebaseproject/screen/UpdateProduct.dart';

class View_Product extends StatefulWidget {
  @override
  State<View_Product> createState() => _View_ProductState();
}

class _View_ProductState extends State<View_Product> {
  bool isloading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Product"),
      ),
      body: (isloading)? CircularProgressIndicator():StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Products").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData)
          {
            if(snapshot.data!.size<=0)
            {
              return Center(
                child: Text("No Data"),
              );
            }
            else
            {
              var count=1;
              return ListView(
                children: snapshot.data!.docs.map((document){

                   Widget mywidget =Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.black12
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          FadeInImage.assetNetwork(placeholder: "img/demo.jpg", image:document["fileurl"].toString(),width: 100.0),
                          Text("Product Count : "+count.toString()),
                          Text("Product Name : "+document["name"].toString()),
                          Text("Product Price : "+document["price"].toString()),
                          Text("Type : "+document["type"].toString()),
                          Text("Category : "+document["category"].toString()),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async{
                                var id = document.id.toString();
                                var filename = document["filename"].toString();

                                setState(() {
                                  isloading=true;
                                });

                                await FirebaseStorage.instance.ref("products/"+filename).delete().then((value) async{
                                  await FirebaseFirestore.instance.collection("Products").doc(id).delete().then((value){
                                     setState(() {
                                      isloading=false;
                                    });
                                    print("Deleted");
                                  });
                                });
                                
                              },
                              child: Text("Delete")),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async{
                                var id = document.id.toString();

                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=>UpdateProduct(updatedid: id))
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
                   count++;
                  return mywidget;
                 
                }).toList(),
              );
            }
          }
          else
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
