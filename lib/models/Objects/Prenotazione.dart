import 'package:frontend_progetto_piattaforme/models/Objects/Paziente.dart';
import 'package:frontend_progetto_piattaforme/models/Objects/Prestazione.dart';

import 'Medico.dart';

class Prenotazione{

  int id;
  Paziente paziente;
  Prestazione prestazione;
  Medico medico;
  String data;
  String ora;

  Prenotazione({required this.id, required this.paziente,
                required this.prestazione,required this.medico,
                required this.data,required this.ora});

  factory Prenotazione.fromJson(Map<String,dynamic> json){
    String dataOra = DateTime.fromMillisecondsSinceEpoch(json['data']).toString();
    return Prenotazione(
      id: json['id'],
      paziente: Paziente.fromJson(json['paziente']),
      prestazione: Prestazione.fromJson(json['prestazione']),
      medico: Medico.fromJson(json['medico']),
      data: dataOra.split(" ")[0],
      ora: json['ora'].toString()
    );
  }

  Map<String,dynamic> toJson() =>{
    "id": id,
    "paziente":paziente.toJson(),
    "prestazione": prestazione.toJson(),
    "medico": medico.toJson(),
    "data":data,
    "ora":ora
  };



}