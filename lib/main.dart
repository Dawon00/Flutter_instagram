import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.blue),
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
            color: Colors.white,
            actionsIconTheme: IconThemeData(color: Colors.black),
          ),
          textTheme: TextTheme(bodyText2: TextStyle(color: Colors.black))),
      home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instagram"),
        actions: [Icon(Icons.add_box_outlined, size: 25)],
      ),
      body: Icon(Icons.star),
    );
  }
}
