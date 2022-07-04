
import 'package:flutter/material.dart';
import 'package:frontend_progetto_piattaforme/models/Objects/Prenotazione.dart';

import '../Model.dart';
import 'CercaPrenotazione.dart';

class PrenotazioneItem extends StatelessWidget{

  String id, prestazione, data, ora;
  CercaPrenotazione? page;

  PrenotazioneItem({Key? key, required this.id, required this.prestazione, required this.data, required this.ora, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: 100,
        height: 45,
        decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                side: BorderSide(width: 1)
            ) ),
        child: Row(
          children: [
            getTestoFormattato(id),
            getTestoFormattato(prestazione),
            getTestoFormattato(data),
            getTestoFormattato(ora),
            MaterialButton(
                onPressed: delete,
                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide(width: 0.5)),
                child: const Text("delete", style: TextStyle(color: Colors.red),),
            )
          ],
        ),
      ),
    );
  }

  void delete() async{
    String response = await Model.sharedInstance.delete(int.parse(id));
    page!.refresh(int.parse(id));
    print(response);
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