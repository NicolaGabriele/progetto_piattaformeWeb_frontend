
class Medico{

  String?  nome, cognome;
  String matricola;

  Medico({required this.matricola,this.nome,this.cognome});


  factory Medico.fromJson(Map<String,dynamic> json){
    return Medico(
      matricola: json['matricola'],
      nome: json['nome'],
      cognome: json['cognome']
    );
  }

  Map<String,dynamic> toJson()=>{
    "matricola":matricola,
    "nome": nome,
    "cognome":cognome
  };

}