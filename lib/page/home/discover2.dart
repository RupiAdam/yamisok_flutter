import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'dart:async';

Client client = Client();

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  List<String> dogImages = new List();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    if(dogImages.length==0){
        fetchFive();
    }
    
    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        fetchFive();
      }

    });
    super.initState();
  }
  @override
  void dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
              controller: _scrollController,
              itemCount: dogImages.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
              itemBuilder:(BuildContext context, int index){
          final newtes = dogImages[index];
          print('lihat print  $newtes');
          return Container(
            constraints: BoxConstraints.tightFor(height: 150.0),
            // child :Image.network("src")
            child:Image.network(newtes, fit: BoxFit.fitWidth,)
          );
        },
      ),
      
    );
  }
  fetch() async {
  final response = await client.get('https://dog.ceo/api/breeds/image/random',
                                    headers: {"content-type": "application/json"});
    final statuscodeprint = response.statusCode;
    print('lihat status code $statuscodeprint');
    if(response.statusCode==200){
      setState(() {
        dogImages.add(json.decode(response.body)['message']);
      
      });
    }else{
      throw Exception('failed to load images');
    }
  }
  fetchFive(){
    for(int i = 0; i < 18; i++){
      fetch();
    }
  }
}

