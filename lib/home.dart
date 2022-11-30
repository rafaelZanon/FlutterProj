import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'qrcodeWriter.dart';
import 'package:localstorage/localstorage.dart';
import 'getLista.dart';
import 'package:intl/intl.dart';

final LocalStorage storage = new LocalStorage('localstorage_app');

class PostNot extends StatefulWidget {
  const PostNot({Key? key}) : super(key: key);

  @override
  _PostNotState createState() => _PostNotState();
}

class _PostNotState extends State<PostNot> {
  final TextEditingController nomeController = TextEditingController();

  Future<String>? _dadosF;

  @override
  void dispose() {
    nomeController.dispose();

    super.dispose();
  }

  FutureBuilder<String> buildFutureBuilder() {
    return FutureBuilder(
        future: _dadosF,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }

  Future<void> enviar() async {
    DateTime dataAgora = DateTime.now();
    DateFormat teste = new DateFormat("yy/MM/dd HH:mm:ss");
    Map data = {'nome': nomeController.text, 'data': teste.format(dataAgora)};

    String body = json.encode(data);

    var response = await http.post(
        Uri.parse("https://www.slmm.com.br/CTC/insere.php"),
        headers: {"Content-Type": "application/json"},
        body: body);
    if (response.statusCode == 200) {
      print(response.body);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Adicionado"),
          content: SizedBox(
            width: 100,
            height: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nomeController.text + " inserido na lista!"),
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
      throw Exception('Erro inesperado');
    }
  }

  // ElevatedButton botao() {
  //   return ElevatedButton(
  //       onPressed: () {
  //         setState(() {
  //           _dadosF = fetchData();
  //         });
  //       },
  //       child: Text("enviar dados"));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de dados")),
      body: Container(
        padding: EdgeInsets.all(6),
        child: Column(children: [
          TextField(
              controller: nomeController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.person),
                  hintText: 'Insira o nome')),
          Container(
            margin: EdgeInsets.all(3),
            child: ElevatedButton(
                onPressed: () {
                  enviar();
                },
                child: Text("Enviar")),
          ),
          Container(
            margin: EdgeInsets.all(6),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QrcodeWriter(),
                      ));
                },
                child: Text("Pegar a api")),
          ),
          Container(
            margin: EdgeInsets.all(6),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const getRa(),
                      ));
                },
                child: Text("Lista de dados")),
          ),
        ]),
      ),
    );
  }
}
