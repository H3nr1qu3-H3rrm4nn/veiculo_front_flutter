class Veiculo {
  int? id;
  String nome;
  String modelo;
  int ano;
  String cor;
  String placa;
  bool unicoDono;

  Veiculo({
    this.id,
    required this.nome,
    required this.modelo,
    required this.ano,
    required this.cor,
    required this.placa,
    required this.unicoDono,
  });

  factory Veiculo.fromJson(Map<String, dynamic> json) {
    return Veiculo(
      id: json['id'],
      nome: json['nome'],
      modelo: json['modelo'],
      ano: json['ano'],
      cor: json['cor'],
      placa: json['placa'],
      unicoDono: json['unicoDono'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'nome': nome,
      'modelo': modelo,
      'ano': ano,
      'cor': cor,
      'placa': placa,
      'unicoDono': unicoDono,
    };
  }
}
