import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Provinsi extends StatefulWidget {
  @override
  _ProvinsiState createState() => _ProvinsiState();
}

class _ProvinsiState extends State<Provinsi> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
              appBar: AppBar(
                // leading: ,
                backgroundColor: Color(0xFF141A1D),
                title: const Text('News'),
                actions: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                       Navigator.pop(context);
                      },
                    ),
                ],
              ),
            )

    );
  }
}