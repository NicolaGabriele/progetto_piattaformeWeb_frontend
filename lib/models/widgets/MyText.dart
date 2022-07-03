import 'package:flutter/material.dart';

class MyText extends StatelessWidget{

  double? size;
  String data;
  MyText({required this.data, this.size});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:15,bottom: 15),
        child:Text(data, style: TextStyle(fontSize: size),textAlign: TextAlign.left,)
    );
  }

}