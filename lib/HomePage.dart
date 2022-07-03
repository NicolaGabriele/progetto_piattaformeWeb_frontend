import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //backgroundColor: Colors.blue,
      body: Opacity(
        opacity: 0.4,
        child: Image.asset("images/homeImage.jpg",
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.fitWidth ,
      ),
      ),
    );
  }

}