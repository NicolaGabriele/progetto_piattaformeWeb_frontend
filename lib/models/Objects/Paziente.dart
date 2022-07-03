class Paziente{
  String codiceFiscale;
  String? nome,cognome;
  String? dataNascita;

  Paziente({required this.codiceFiscale,this.nome,this.cognome,this.dataNascita});

  @override
  factory Paziente.fromJson(Map<String, dynamic> json) {
    return Paziente(
      codiceFiscale: json['codiceFiscale'],
      nome: json['nome'],
      cognome: json['cognome'],
      dataNascita: json['dataNascita']
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'codiceFiscale': codiceFiscale,
    'nome': nome,
    'cognome': cognome,
    'dataNascita': dataNascita
  };
}