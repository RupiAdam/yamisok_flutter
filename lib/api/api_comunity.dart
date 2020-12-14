import 'package:flutter/foundation.dart';
import 'package:yamisok/model/comunity_model.dart';
import 'package:yamisok/component/globals.dart' as global;
import 'package:http/http.dart' show Client;
import 'dart:async';
import 'dart:convert';
import 'api_master.dart';
import 'package:yamisok/component/keyStore.dart'; 

Client client = Client();

class ApiServiceComunity { 
  
    Future<Community> fetchPost() async { 
    final token = await keyStore.getToken();

     Map data2 = {
      'token': token,
      'player_id':'17698',
      'offset': 0,
      'limit': 500,
      'game_group_id':'all',
      'country_id':1
    };
    //encode Map to JSON 18776 fauzan
    var body = json.encode(data2);

    print('home_Community body : $body');
    final response = await client.post(
      "$apibase/communities",
      headers: {"content-type": "application/json"},
      body: body,
    );
    // final response = await client.get("$baseUrl3/posts/1");
     final datates = json.decode(response.body);
    Community newtes = new Community.fromJson(datates);
    Map bodyresult = json.decode(response.body);
    
    // print('lihat profile $bodyresult');
    
    if (newtes.status == 200) {
     return Community.fromJson(json.decode(response.body));
    } else {
      return null;
    }

  }
 
}

