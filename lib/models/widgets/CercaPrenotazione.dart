
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_progetto_piattaforme/models/widgets/MyField.dart';

import '../Model.dart';
import '../Objects/Prenotazione.dart';

class CercaPrenotazione extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _CercaPrenotazioneState();

}

enum _StatoRicerca {
  CERCANDO, NESSUN_RISULTATO, RISULTATI
}

  class _CercaPrenotazioneState extends State<CercaPrenotazione>{

  TextEditingController _controllerID = TextEditingController(),
                        _controllerCF = TextEditingController();
  List<Prenotazione> prenotazioni = [];
  _StatoRicerca stato = _StatoRicerca.CERCANDO;
  ScrollController _scrollController = ScrollController();

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
              child: stato == _StatoRicerca.CERCANDO?
                  formDiRicerca():
                  stato == _StatoRicerca.RISULTATI?
                      viewRisultati():
                      nessunRisultatoView(),
            )
          ],
        )
    );
  }

  Widget formDiRicerca(){
    return Container(
      width: 400,
      height: 300,
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
                "RICERCA",
                style: TextStyle(
                   fontSize: 25,
                    fontStyle: FontStyle.italic
                ),
              ),
            ),
          MyField(hint: "ID PRENOTAZIONE", controller: _controllerID),
          MyField(hint: "CODICE FISCALE", controller: _controllerCF),
          Padding(
              padding: EdgeInsets.only(top:20),
              child: FloatingActionButton(
                onPressed: cerca,
                child: const Icon(Icons.search),
              ),
          )
        ],
      ),
    );
  }

  void cerca(){
    String id = _controllerID.text;
    RegExp r = RegExp(r'(\d+)');
    var match = r.firstMatch(id);
    if(match == null)
      ricercaPerCf(_controllerCF.text);
    else {
      int sid = int.parse(id.substring(match.start, match.end));
      ricercaPerId(sid);
    }
  }

  void ricercaPerId(int id){
    Model.sharedInstance.getPrenotazioneById({"id":id.toString()}).then((value){
      if(value.compareTo("nessun risultato") == 0)
        nessunRisultato();
      else
        setState((){
          prenotazioni = [Prenotazione.fromJson(jsonDecode(value))];
          stato = _StatoRicerca.RISULTATI;
        });
    });
  }

  void ricercaPerCf(String cf){
    Model.sharedInstance.ricercaPrenotazioneByCf(cf).then((value){
      if( value.compareTo("nessun risultato")==0)
        nessunRisultato();
      else
        risultatiEsistenti(value);
    });
  }

  void nessunRisultato(){
    setState((){
      stato = _StatoRicerca.NESSUN_RISULTATO;
    });
  }

  void risultatiEsistenti(String value){
    List<dynamic> l = jsonDecode(value);
    List<Prenotazione> risultato = [];
    l.forEach((element) {risultato.add(Prenotazione.fromJson(element));});
    setState((){
      prenotazioni = risultato;
      stato = _StatoRicerca.RISULTATI;
    });
  }

  void nuovaRicerca(){
    setState((){
      _controllerCF.clear();
      _controllerID.clear();
      stato = _StatoRicerca.CERCANDO;
    });
  }

  Widget nessunRisultatoView(){
    return Center(
      child: Container(
        color: Colors.white,
        width: 200,
        height: 200,
        child: Column(
          children:[
            getTestoFormattato("nessunRisultato"),
            IconButton(onPressed: indietro, icon: const Icon(Icons.arrow_back))
          ]
        ),
      ),
    );
  }
  List<Row> rappresentazionePrenotazioni(){
    List<Row> ret = [];
    ret.add(
      Row(
        children: [
          getTestoFormattato("ID"),
          getTestoFormattato("PRESTAZIONE"),
          getTestoFormattato("    DATA"),
          getTestoFormattato("    ORA")
        ],
      )
    );
    prenotazioni.forEach((element) {
      ret.add(
          Row(
            children: [
              getTestoFormattato(element.id.toString()),
              getTestoFormattato(element.prestazione.descrizione.toString()),
              getTestoFormattato(element.data.toString()),
              getTestoFormattato(element.ora.toString())
            ],
          )
      );
    });
    return ret;
  }
  Widget viewRisultati(){
    return Center(
      child: Container(
        width: 700,
        height: 700,
        child: Column(
          children: [
            Container(
              width: 500,
              height: 100,
              color: Colors.white,
              child: Row(
                children: [
                  getTestoFormattato("ID"),
                  getTestoFormattato("  PRESTAZIONE"),
                  getTestoFormattato("       DATA"),
                  getTestoFormattato("       ORA")
                ],
              ),
            ),
            Container(
              width: 500,
              height: 300,
              color: Colors.white,
              child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: prenotazioni.length,
                      itemBuilder: (BuildContext context, int index){
                        return Row(
                          children: [
                            getTestoFormattato(prenotazioni[index].id.toString()),
                            getTestoFormattato(prenotazioni[index].prestazione.descrizione.toString()),
                            getTestoFormattato(prenotazioni[index].data.toString()),
                            getTestoFormattato(prenotazioni[index].ora.toString())
                          ],
                        );
                      }
                  )
              ),
            ),
            FloatingActionButton(
                onPressed: indietro,
                child: const Icon(Icons.arrow_back),
            )
          ],
        )
      ),
    );
  }

  void indietro(){
    setState((){
      prenotazioni = [];
      _controllerID.clear();
      _controllerCF.clear();
      stato = _StatoRicerca.CERCANDO;
    });
  }

  Widget getTestoFormattato(String text){
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        style:
          const TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.italic
          )
      ),
    );
  }

}



