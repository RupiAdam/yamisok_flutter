
import 'package:yamisok/model/model_feeds.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/component/keyStore.dart'; 

Client client = Client();




class ApiService {
 static Future<String> apimyteam(int offset) async {
   final String baseUrl = globals.baseUrlApi;
    // final baseUrl=GlobalKey.baseUrlApi;
    // final userToken ="sadasdasdasd";
    final userPlayerId = await keyStore.getPlayerId();
    final playerId=userPlayerId.toString();
    final userToken = await keyStore.getToken();
    print("masuk k api ");
     
    // var bodyPost = json.encode(data);
    var url = "$baseUrl/v1/teams/my-team?offset=$offset&limit=5";
    // var url ="http://www.mocky.io/v2/5d7497f33300004f6c081980";
    print('lihat body dan parse  $url ');
    final response = await client.get(
      "$url",
       headers: {"token": userToken, "playerid":playerId }
    );
   final statusCode = response.statusCode;
    print('lihat  status code $statusCode ');
    // print(JSON.stringify(newtes);
    if (statusCode==200) {
        print('lihat  masuk k 200');
          var jsn = json.decode(response.body);
          
            var message = jsn["message"];
             print('lihat message $message');
            var result = jsn["result"];
             print('lihat  masuk k result $result');
            // var token = result["token"];
            // var player_id = result["player_id"];

           
            print('lihat message $result');
            // print("status api $statusCode $message");
              Map datarespon = {
                  "status":true,
                  "messages":message,
                  "result":result
                };
                var respons = json.encode(datarespon);
             
            return respons;
    } else {
          var jsn = json.decode(response.body);
            var message = jsn["message"];
            print("respont api messages  $message");
              Map datarespon = {
                  "status":false,
                  "messages":message
                };
                var respons = json.encode(response.body);
            
            return respons;
    }

  }


}