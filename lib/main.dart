import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Loading(),));
}

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<void> validation() async {
    try {
      final url = "http://localhost/validate.php";
      final response = await http.get(
        Uri.parse(url),
      );
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> MyApp()));
      });
    } catch (ex) {
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
         title: Text("Error"),
          content: Text("Server Not Found"),
        );
      });

     Timer(Duration(seconds: 3), () {Navigator.pop(context); });
      validation();
    }
  }

  @override
  void initState() {
    validation();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network("https://cdn.pixabay.com/animation/2023/04/30/14/04/14-04-54-16_512.gif", height: 100,),
            Text("Inventory App", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(height: 20,),
            LinearProgressIndicator(color: Colors.red,)
          ],
        ),
      ),
    );
  }
}


