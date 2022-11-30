import 'package:flutter/material.dart';
import 'qrcode_page.dart';
import 'package:localstorage/localstorage.dart';

class QrcodeWriter extends StatelessWidget {
  const QrcodeWriter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 206, 203, 255),
      ),
      body: MaterialApp(
        title: 'QRCode Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.grey[900],
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.tealAccent,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 36),
              onPrimary: Colors.black,
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        themeMode: ThemeMode.dark,
        home: const QRCodePage(),
      ),
    );
  }
}
