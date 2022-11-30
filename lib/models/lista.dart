class Lista{
  int id;
  String nome;

  Lista(
    this.id,
    this.nome,
   
  );

  Map toJson() => {'id': id, 'nome': nome};

  factory Lista.fromJson(dynamic json) {

     if (json['id'] == null) json['id'] = '';
      if (json['nome'] == null) json['nome'] = '';

    return Lista(json['id'], json['nome']);
  }

  @override
  String toString() {
    return '{$id,$nome}';
  }
}