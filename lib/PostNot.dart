import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'qrcodeWriter.dart';

String URL = "https://www.slmm.com.br/CTC/pdmIns.php";

Future<String> fetchData() async {
  Map data = {'ra': '12345', 'lati': '23.00', 'longi': '-47.00', 'foto': ""};

  String body = json.encode(data);

  var response = await http.post(Uri.parse(URL),
      headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Erro inesperado');
  }
}

class PostNot extends StatefulWidget {
  const PostNot({Key? key}) : super(key: key);

  @override
  _PostNotState createState() => _PostNotState();
}

class _PostNotState extends State<PostNot> {
  final raController = TextEditingController();
  Future<String>? _dadosF;

  @override
  void dispose() {
    raController.dispose();
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

  ElevatedButton botao() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            _dadosF = fetchData();
          });
        },
        child: Text("enviar dados"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("post dados")),
      body: Container(
        padding: EdgeInsets.all(6),
        child: Column(children: [
          TextField(
              controller: raController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.person),
                  hintText: 'Informe o RA')),
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(raController.text),
                      );
                    });
                setState(() {
                  _dadosF = null;
                });
              },
              child: Text("Enviar"))
              ,ElevatedButton(
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(
                  builder: (context) => const QrcodeWriter(), 
                ));
              },
              child: Text("Tirar foto")),
          (_dadosF == null) ? botao() : buildFutureBuilder(),
        ]),
      ),
    );
  }
}
