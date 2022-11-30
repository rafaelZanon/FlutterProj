class Detalhes{
  int id;
  String nome;
  String data;

  Detalhes(
    this.id,
    this.nome,
    this.data,
   
  );

  Map toJson() => {'id': id, 'nome': nome,'data': data};

  factory Detalhes.fromJson(dynamic json) {

     if (json['id'] == null) json['id'] = '';
      if (json['nome'] == null) json['nome'] = '';
         if (json['data'] == null) json['data'] = '';

    return Detalhes(json['id'], json['nome'],json['data']);
  }

  @override
  String toString() {
    return '{$id,$nome,$data}';
  }
}