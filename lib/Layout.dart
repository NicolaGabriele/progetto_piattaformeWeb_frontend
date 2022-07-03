
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend_progetto_piattaforme/HomePage.dart';
import 'package:frontend_progetto_piattaforme/Login.dart';
import 'package:frontend_progetto_piattaforme/models/LogInResult.dart';
import 'package:frontend_progetto_piattaforme/models/widgets/CercaPrenotazione.dart';
import 'package:frontend_progetto_piattaforme/models/widgets/NuovaPrenotazione.dart';

class Layout extends StatefulWidget{

  final String title;
  Layout({Key? key, required this.title}) : super(key: key);
  static _LayoutState layout = _LayoutState();
  @override
  State<StatefulWidget> createState() => layout;

  static void steLogState(LogInResult l){
    layout.setLogResult(l);
  }

}

class _LayoutState extends State<Layout>{
  String title = "MT Med";
  LogInResult logResult = LogInResult.error_wrong_credentials;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Column(
              children: const [Icon(Icons.logout), Text("logout")],
          ),
          onPressed: (){setLogResult(LogInResult.error_wrong_credentials);},
        ),
        appBar: AppBar(
          title: Center(
            child:Text(title,
              style: const TextStyle(
                fontSize: 50,
                fontStyle: FontStyle.italic,
                shadows: [Shadow(color: Colors.black, offset: Offset(1, 4), blurRadius: 1),
                          Shadow(color: Colors.blue, offset: Offset(2, 1), blurRadius: 2)]
              ),
          ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
            bottom: getBottom(),
        ),
        body: getBody(),
      ),
    );
  }

  Widget getBody(){
    return logResult == LogInResult.logged?
        TabBarView(children: [NuovaPrenotazione(), CercaPrenotazione()]):
    TabBarView(children:[HomePage(),PersonalArea()]);
  }

  void setLogResult(LogInResult l){
    setState((){
      this.logResult = l;
    });
  }

  PreferredSizeWidget getBottom(){
    return logResult != LogInResult.logged?
      const TabBar(
          tabs:[
            Tab(text: "Home",icon: Icon(Icons.home),),
            Tab(text: "AreaPersonale",icon: Icon(Icons.home),),
          ],
      ):const TabBar(tabs: [
        Tab(text: "Nuova Prenotazione",icon:Icon(Icons.medical_services)),
        Tab(text: "Cerca Prenotazione", icon: Icon(Icons.search),)
    ],);
  }
}