
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend_progetto_piattaforme/models/Objects/Paziente.dart';
import 'package:frontend_progetto_piattaforme/models/Objects/Prenotazione.dart';
import 'package:frontend_progetto_piattaforme/models/Objects/Prestazione.dart';
import 'package:frontend_progetto_piattaforme/models/widgets/MyField.dart';
import 'package:frontend_progetto_piattaforme/models/Model.dart';
import 'package:frontend_progetto_piattaforme/models/widgets/MyText.dart';

import '../Objects/Medico.dart';

class NuovaPrenotazione extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _NuovaPrenotazioneState();

}

enum StatoPrenotazione{
  inserimento, elaborazione, riepilogo;
}

class _NuovaPrenotazioneState extends State<NuovaPrenotazione>{

  TextEditingController _controllerCF = TextEditingController();
  TextEditingController _controllerData = TextEditingController();
  String? _medico = "scegli un medico";
  String? _prestazione = "scegli una prestazione";
  List<DropdownMenuItem<String>> itemsMedici = [];
  Map<String,String> matricole = {};
  Map<String,int> idPrestazione = {};
  List<DropdownMenuItem<String>> itemsPrestazioni = [];
  Prenotazione? _prenotazione;
  Text alert = Text("");
  StatoPrenotazione _stato = StatoPrenotazione.inserimento;

  @override
  void initState(){
    leggiMedici();
    leggiPrestazioni();
    Timer.periodic(Duration(minutes: 5), (timer) {leggiMedici(); leggiPrestazioni(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: _stato == StatoPrenotazione.inserimento?
                        formPrenotazione():
                     _stato == StatoPrenotazione.riepilogo?
                        riepilogoPrenotazione():
                         const Center(child: SizedBox(width: 50,height: 50,child: CircularProgressIndicator(),),)
            )
          ],
        )
    );
  }

  void prenota() async{
    setState(()=> _stato = StatoPrenotazione.elaborazione);
    var rnd = Random();
    int ore = 8 + rnd.nextInt(17);
    int m = rnd.nextInt(10);
    String ora = ore.toString()+":";
    if( m <= 5)
      ora+="00:00";
    else
      ora+="30:00";
    Prenotazione p = Prenotazione(
        id: 1,
        paziente: Paziente(codiceFiscale: _controllerCF.text),
        prestazione: Prestazione(id: idPrestazione[_prestazione] as int),
        medico: Medico(matricola: matricole[_medico] as String),
        data: _controllerData.text,
        ora: ora
    );
    String ver = await Model.sharedInstance.ricercaPrenotazione(p);
    if(ver.compareTo("nessun risultato") != 0){
      alert = const Text("qualcosa è andato storto, riprova",
              style: TextStyle(color: Colors.red),);
    }
    String res = await Model.sharedInstance.prenota(p);
    setState((){
      _prenotazione = Prenotazione.fromJson(jsonDecode(res));
      _stato = StatoPrenotazione.riepilogo;
    });

  }

  Widget formPrenotazione(){
    return Container(
      width: 400,
      height: 400,
      decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          color: Colors.white
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top:10,bottom: 10),
            child: Text(
              "NUOVA PRENOTAZIONE",
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10,bottom: 10),
            child: alert,
          ),
          MyField(hint: "codice fiscale", controller: _controllerCF),
          MyField(hint: "data YYYY-MM-DD", controller: _controllerData),
          sceltaMedico(),
          sceltaPrestazione(),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )
                  )
              ),
              onPressed: prenota,
              child: const Text(
                "PRENOTA",
                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget riepilogoPrenotazione(){
    return Container(
      width: 400,
      height: 400,
      decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          color: Colors.white
      ),
      child: Column(
        children: [
          Center(child:MyText(data: "PRENOTAZIONE COMPLETATA",size: 20,)),
          Center(child:MyText(data: "RIEPILOGO", size: 18,)),
          MyText(data: "ID PRENOTAZIONE: "+_prenotazione!.id.toString(), size: 15,),
          MyText(data: "TIPO DI PRESTAZIONE: "+_prestazione!, size: 15,),
          MyText(data: "DATA: "+_prenotazione!.data, size: 15),
          MyText(data: "ORA: "+_prenotazione!.ora, size: 15,),
          FloatingActionButton(child:Text("OK"),onPressed: okButton)
        ],
      ),
    );
  }

  void okButton(){
    setState((){
      _stato = StatoPrenotazione.inserimento;
      _prenotazione = null;
      _controllerData.clear();
      _controllerCF.clear();
      _medico = "scegli un medico";
      _prestazione = "scegli una prestazione";
    });
  }
  void leggiMedici()async{
    List<DropdownMenuItem<String>> items = [];
    Map<String,String> matricole = {};
    List<dynamic> l = jsonDecode(await Model.sharedInstance.getMedici());
    l.forEach((element) {
      Map<String,dynamic> map = element;
      String item = (map['nome'] as String) +" "+ (map['cognome'] as String);
      items.add(DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      ));
      matricole[item] = map['matricola'];
    });
    setState((){
      this.itemsMedici = items;
      this.matricole = matricole;
    });
  }

  void leggiPrestazioni() async{
    List<DropdownMenuItem<String>> items = [];
    Map<String,int> idPrestazioni = {};
    String json = await Model.sharedInstance.getPrestazioni();
    List<dynamic> l = jsonDecode(json);
    l.forEach((element) {
      Map<String,dynamic> map = element;
      double importo = map['importo'];
      String item = map['descrizione']+" €"+importo.toString();
      items.add(DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      ));
      idPrestazioni[item] = map['id'];
    });
    setState((){
      this.itemsPrestazioni = items;
      this.idPrestazione = idPrestazioni;
    });
  }

  Widget sceltaMedico(){
    return DropdownButton<String>(
      icon: Text(_medico!,
            style: const TextStyle(
              fontSize: 18),
        ),
        items: itemsMedici,
        onChanged: (String? selection)async{
          setState(()=>_medico = selection);
        },
    );
  }

  Widget sceltaPrestazione(){
    return DropdownButton<String>(
      icon: Text(_prestazione!,
        style: const TextStyle(
            fontSize: 18),),
      items: itemsPrestazioni,
      onChanged: (String? selection){
        setState(()=>_prestazione = selection);
      },
    );
  }



}