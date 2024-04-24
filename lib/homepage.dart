import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _item = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _search = TextEditingController();
  final server = "http://localhost/";
  List<dynamic> product = [];
  Future<void> loadData() async {

    final url = server + "data.php";
    final response = await http.get(
        Uri.parse(url)
    );
    setState(() {
      print(response.body);
      try {
        product = jsonDecode(response.body);
      } catch (ex) {
        product = [];
      }

    });
  }

  Future<void> insertData() async {
    final url = server + "insertData.php";
    Map<String, dynamic> data = {
      "ITEM" : _item.text,
      "DESCRIPTION" : _description.text
    };
    final response = await http.post(
        Uri.parse(url),
        body: data
    );
    print(response.body);
    loadData();
  }

  Future<void> deleteData(String index) async {
    final url = server + "deleteData.php";
    Map<String, dynamic> data = {
      "id" : index
    };
    final response = await http.post(
        Uri.parse(url),
        body: data
    );
    print(response.body);
    loadData();
  }

  Future<void> updateData(String index, String description) async {
    final url = server + "updateData.php";
    Map<String, dynamic> data = {
      "id" : index,
      "DESCRIPTION" : description,
    };
    final response = await http.post(
        Uri.parse(url),
        body: data
    );

    print(response.body);
    loadData();
  }

  Future<void> searchData() async {
    final url = server + "searchData.php";
    Map<String, dynamic> data = {
      "ITEM" : _search.text,
    };
    final response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    setState(() {
      try {
        product = jsonDecode(response.body);
      } catch (ex) {
        product = [];
      }
    });
  }
  @override
  void initState() {
    loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (text){
            searchData();
          },
          controller: _search,
          decoration:  InputDecoration(

          ),
        ),
        centerTitle: true,

      ),
      body: ListView.builder(
          itemCount: product.length,
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              title: Text("${index + 1}. ${product[index]["ITEM"]}"),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product[index]["DESCRIPTION"]),

                  Row(
                    children: [
                      IconButton(onPressed: (){
                        deleteData(product[index]["id"]);
                      }, icon: Icon(Icons.delete_outline, color: Colors.red,)),
                      IconButton(onPressed: (){
                        TextEditingController _editDescription = TextEditingController(text: product[index]["DESCRIPTION"]);
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Update ${product[index]["ITEM"]}"),
                            content: TextField(
                              controller: _editDescription,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Desciption'
                              ),
                            ),
                            actions: [
                              TextButton(onPressed: (){
                                updateData(product[index]["id"], _editDescription.text );
                                Navigator.pop(context);
                              }, child: Text("Save", style: TextStyle(color: Colors.green),))
                            ],
                          );
                        });
                      }, icon: Icon(Icons.edit_outlined, color: Colors.green,)),
                    ],
                  )
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(onPressed: (){
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            title: Text("Add Product"),
            content: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _item,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Item'
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _description,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description'
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: (){
                insertData();
                _item.text = "";
                _description.text = "";
                Navigator.pop(context);

              }, child: Text("Save", style: TextStyle(color: Colors.green),))
            ],
          );
        });
      }, child: Icon(Icons.add),),
    );
  }
}
