import 'package:yamisok/model/profile_model.dart';
import 'package:yamisok/model/model_feeds.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'api_master.dart';
import 'package:yamisok/component/keyStore.dart'; 

Client client = Client();





class ApiService {
    Future<FeedsModel> fetchPost() async {
      final token = await keyStore.getToken();
      Map data2 = {
        "token": token,
        "offset": 0,
        "limit": 30
      };
    //encode Map to JSON 18776 fauzan
    var body = json.encode(data2);


    final response = await client.post(
      "$apibase/feeds/posts",
      headers: {"content-type": "application/json"},
      body: body,
    );
    // final response = await client.get("$baseUrl3/posts/1");
    //  final datates = json.decode(response.body);
    // FeedsModel newtes = new FeedsModel.fromJson(response.statusCode);
    // Map bodyresult = json.decode(response.body);
    // Map newtes2 = json.decode(response.body);
    
    
 
     final statuslihat = response.statusCode;
     print('lihat feeds status $statuslihat ');
    // print(JSON.stringify(newtes);
    if (statuslihat == 200) {
      print("masuk k 200");
     return FeedsModel.fromJson(json.decode(response.body));
    } else {
      return null;
    }

  }
 
}

