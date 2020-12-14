
import 'package:yamisok/model/model_feeds.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/component/keyStore.dart'; 

Client client = Client();




class ApiServiceteam {

 static Future<String> apilistteam(String idteam) async {
   
    final bool statusApi = globals.statusApi;
    final String baseUrl = globals.baseUrlApi;
    final String baseUrlPro = globals.urlApiPro;
    var url="$baseUrl/v1/teams/members?team_id=$idteam&offset=0";
   
    final userPlayerId = await keyStore.getPlayerId();
    final playerId=userPlayerId.toString();
    final userToken = await keyStore.getToken();
    
    if(statusApi==false){
      url = "$baseUrl/v1/teams/members?team_id=$idteam&offset=0";
    }else{
      url = "$baseUrlPro/v1/teams/members?team_id=$idteam&offset=0"; 
    }
    print('lihat body dan parse  $url ');
    final response = await client.get(
      "$url",
       headers: {"token": userToken, "playerid":playerId }
    );
   final statusCode = response.statusCode;
    if (statusCode==200) {
        var jsn = json.decode(response.body);
          
            var message = jsn["message"];
            //  print('lihat message $message');
            var result = jsn["result"];
            //  print('lihat  masuk k result list team $result');
            // var token = result["token"];
            // var player_id = result["player_id"];

           
            // print('lihat message $result');
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
            // print("respont api messages  $message");
              Map datarespon = {
                  "status":false,
                  "messages":message
                };
                var respons = json.encode(response.body);
            
            return respons;
    }

  }


}