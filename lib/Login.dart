
import 'package:flutter/material.dart';
import 'package:frontend_progetto_piattaforme/models/LogInResult.dart';
import 'package:frontend_progetto_piattaforme/models/widgets/MyField.dart';
import 'package:http/http.dart';
import 'package:frontend_progetto_piattaforme/models/Model.dart';
import 'package:frontend_progetto_piattaforme/Layout.dart';
class PersonalArea extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() => _PersonalAreaState();
}

enum page{
  login, registration
}
class _PersonalAreaState extends State<PersonalArea>{
  page p = page.login;
  late Response data;
  TextEditingController _controllerUsername = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  TextEditingController _RegcontrollerNome = TextEditingController();
  TextEditingController _RegcontrollerCogn = TextEditingController();
  TextEditingController _RegcontrollerUser = TextEditingController();
  TextEditingController _RegcontrollerPass = TextEditingController();
  TextEditingController _RegcontrollerCF = TextEditingController();
  TextEditingController _RegcontrollerDataN = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return p == page.login?
        LoginPage():
        RegistrationPage();
  }

  Widget LoginPage(){
    return  Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.4,
            child: Image.asset("images/homeImage.jpg",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fitWidth ,
            ),
          ),
          Center(
            child:SizedBox(
              width: 400,
              height: 400,
              child: Column(
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  MyField(hint:"username", controller: _controllerUsername,submit: loginS),
                  MyField(hint:"password", controller: _controllerPassword,submit: loginS,),
                  IconButton( onPressed: login,
                    icon: Icon(Icons.login, size: 25,),),
                  Text("oppure"),
                  IconButton(
                    onPressed: () {
                      setState((){p= page.registration;});
                    },
                    icon:  Icon(
                        size: 25,
                        Icons.app_registration
                    ),
                  ),
                  Text("registrati ora"),
              ],
          ),
            ),
          ),
        ],
      )
    );
  }

  Widget RegistrationPage(){
    return  Scaffold(
        body: Stack(
          children: [
            Opacity(
              opacity: 0.4,
              child: Image.asset("images/homeImage.jpg",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fitWidth ,
              ),
            ),
            Center(
              child:SizedBox(
                width: 400,
                height: 800,
                child: Column(
                  children: [
                    const Text(
                      "Registrazione",
                      style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    MyField(hint:"username",controller: _RegcontrollerUser,),
                    MyField(hint:"password",controller: _RegcontrollerPass,),
                    MyField(hint: "nome",controller: _RegcontrollerNome,),
                    MyField(hint: "cognome",controller: _RegcontrollerCogn,),
                    MyField(hint: "codice fiscale", controller: _RegcontrollerCF),
                    MyField(hint:"data di nascita: AAAA-MM-DD",controller: _RegcontrollerDataN,),
                    IconButton(
                      onPressed: registrati,
                      icon:  Icon(
                          size: 25,
                          Icons.app_registration
                      ),
                    ),
                    Text("registrati ora"),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }

  void registrati(){
    //TODO
  }

  void loginS(String s){
    login();
  }
  void login()async{
    LogInResult res = await Model.sharedInstance.logIn(_controllerUsername.text, _controllerPassword.text);
    if(res == LogInResult.logged){
      setState((){
        Layout.steLogState(LogInResult.logged);
      });
    }
  }
}
