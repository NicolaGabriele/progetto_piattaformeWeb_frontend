
import 'package:flutter/material.dart';
import 'package:frontend_progetto_piattaforme/models/LogInResult.dart';
import 'package:frontend_progetto_piattaforme/models/widgets/MyField.dart';
import 'package:http/http.dart';
import 'package:frontend_progetto_piattaforme/models/Model.dart';
import 'package:frontend_progetto_piattaforme/Layout.dart';

import 'models/Objects/Paziente.dart';
import 'models/Objects/User.dart';
class PersonalArea extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() => _PersonalAreaState();
}

enum page{
  login, registration, progress
}
class _PersonalAreaState extends State<PersonalArea>{
  page p = page.login;
  late Response data;
  Text _alert = Text("");
  TextEditingController _controllerUsername = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  TextEditingController _RegcontrollerNome = TextEditingController();
  TextEditingController _RegcontrollerCogn = TextEditingController();
  TextEditingController _RegcontrollerUser = TextEditingController();
  TextEditingController _RegcontrollerPass = TextEditingController();
  TextEditingController _RegcontrollerCF = TextEditingController();
  TextEditingController _RegcontrollerDataN = TextEditingController();
  TextEditingController _RegcontrollerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return p == page.login?
        LoginPage():
        p == page.registration?
          RegistrationPage():
            const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
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
                  Text("accedi\noppure"),
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
                height: 900,
                child: Column(
                  children: [
                    _alert,
                    const Text(
                      "Registrazione",
                      style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    MyField(hint: "nome",controller: _RegcontrollerNome,),
                    MyField(hint: "cognome",controller: _RegcontrollerCogn,),
                    MyField(hint: "codice fiscale", controller: _RegcontrollerCF),
                    MyField(hint:"data di nascita: AAAA-MM-DD",controller: _RegcontrollerDataN,),
                    MyField(hint: "email", controller: _RegcontrollerEmail),
                    MyField(hint:"username",controller: _RegcontrollerUser,),
                    MyField(hint:"password",controller: _RegcontrollerPass,),
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
    setState((){
      p = page.progress;
    });
    User u = User(
        username: _RegcontrollerUser.text,
        password: _RegcontrollerPass.text,
        email: _RegcontrollerEmail.text,
        paziente: Paziente(
          codiceFiscale: _RegcontrollerCF.text,
          dataNascita: _RegcontrollerDataN.text,
          nome: _RegcontrollerNome.text,
          cognome: _RegcontrollerCogn.text
        )
    );
    Model.sharedInstance.registraUtente(u).then((value) {
      if( value.compareTo("registrazione completata") == 0) {
        setState((){
          _RegcontrollerCogn.clear();
          _RegcontrollerNome.clear();
          _RegcontrollerDataN.clear();
          _RegcontrollerCF.clear();
          _RegcontrollerPass.clear();
          _RegcontrollerUser.clear();
          _RegcontrollerEmail.clear();
          _alert = Text("");
          p = page.login;
        });
      }else{
        setState((){
          p = page.registration;
          _alert = const Text(
            "qualcosa è andato storto",
            style: TextStyle(
              color: Colors.red
            ),
          );
        });
      }
    });
  }

  void loginS(String s){
    login();
  }
  void login()async{
    setState((){
      p = page.progress;
    });
    LogInResult res = await Model.sharedInstance.logIn(_controllerUsername.text, _controllerPassword.text);
    if(res == LogInResult.logged){
      setState((){
        p = page.login;
        Layout.steLogState(LogInResult.logged);
      });
    }
  }
}
