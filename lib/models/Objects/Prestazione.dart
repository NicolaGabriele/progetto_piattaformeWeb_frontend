class Prestazione{
  int id;
  String? descrizione;
  double? importo;
  int? nPosti;

  Prestazione({required this.id, this.descrizione,this.importo,this.nPosti});

  factory Prestazione.fromJson(Map<String,dynamic> json){
    return Prestazione(
        id: json['id'],
        descrizione: json['descrizione'],
        importo: json['importo'],
        nPosti: json['nPosti']
    );
  }

  Map<String,dynamic> toJson()=>{
    "id":id,
    "descrizione":descrizione,
    "importo":importo,
    "nPosti":nPosti
  };
}