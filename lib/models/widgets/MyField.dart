import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyField extends StatelessWidget{

  final String hint;
  final TextEditingController controller;
  final void Function(String s)? submit;
  MyField({Key? key, required this.hint, required this.controller, this.submit}):super(key: key);


  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: 75,
        width: 200,
        alignment: Alignment.center,
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          )
        ),
        child:TextField(
        enabled: true,
        onSubmitted: submit ,
        obscureText: hint.compareTo("password") == 0,
        controller: controller,
        //maxLength: 50,
        decoration:  InputDecoration(
          hintText: hint,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30),
            )
          ),
        ),
          style:const TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
      ),
      );

  }

}