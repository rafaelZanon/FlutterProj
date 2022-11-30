import 'package:flutter/material.dart';
import 'package:flutter_qrcode/models/lista.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'models/detahes.dart';

const String URL = "https://www.slmm.com.br/CTC/ctcApi.php";
// Montando os DBO(que no caso aqui são ABO) com os dados da API
Future<List<Lista>> fetchData() async {
  var response = await http.get(
      Uri.parse("https://www.slmm.com.br/CTC/getLista.php"),
      headers: {"Accept": "application/json"});
  print(response.body);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    print(jsonResponse);
    return jsonResponse.map((data) => new Lista.fromJson(data)).toList();
  } else {
    throw Exception('Erro inesperado...');
  }
}

maisDetalhes(dynamic context, int id) async {
  http.get(Uri.parse("https://www.slmm.com.br/CTC/getDetalhe.php?id=$id"),
      headers: {"Accept": "application/json"}).then(
    (data) {
      print(data.body);
      List<dynamic> jsonData = json.decode(data.body);
      List<Detalhes> dados =
          jsonData.map((data) => Detalhes.fromJson(data)).toList();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Id: " + dados.map((e) => e.id.toString()).first),
          content: SizedBox(
            width: 100,
            height: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nome: " + dados.map((e) => e.nome).first),
                Text("Data: " + dados.map((e) => e.data).first),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> delete(String id, context, String nome) async {
  final response = await http.delete(
      Uri.parse("https://www.slmm.com.br/CTC/" + "delete.php?id=" + id),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    print(jsonDecode(response.body));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Deletado"),
        content: SizedBox(
          width: 100,
          height: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$nome deletado!"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const getRa(),
                )),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  } else {
    throw Exception('DELETE ERROR.');
  }
}

class getRa extends StatefulWidget {
  const getRa({Key? key}) : super(key: key);

  @override
  _getRaState createState() => _getRaState();
}

class _getRaState extends State<getRa> {
  late Future<List<Lista>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("lista RA")),
      body: Container(
        padding: EdgeInsets.all(10),
        child: FutureBuilder<List<Lista>>(
          future: futureData,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              List<Lista> data = snapshot.data!;
              return ListView.builder(
                  itemCount: data.length,
                  // biuld por elementos que aqui no caso vem da API
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        color: Color.fromARGB(255, 75, 99, 232),
                        child: Container(
                            child: Column(
                          children: <Widget>[
                            //Imagem que busco na api

                            Text(
                              "Nome: ${data[index].nome}",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  delete((data[index].id).toString(), context,
                                      data[index].nome);
                                },
                                child: Text("Deletar")),
                            ElevatedButton(
                                onPressed: () {
                                  maisDetalhes(context, data[index].id);
                                },
                                child: Text("Detalhes"))
                          ],
                        )));
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          }),
        ),
      ),
    );
  }
}
