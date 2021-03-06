
import 'package:yamisok/model/model_feeds.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/component/keyStore.dart'; 

Client client = Client();




class ApiUnFollow {
  
    static Future<String> apiunfollow(playerIdOthers) async {
    final bool statusApi = globals.statusApi;
    final String baseUrl = globals.baseUrlApi;
    final String baseUrlPro = globals.urlApiPro;
    var urllink="v1/users/unfollow";
    var url="";

    final userPlayerId = await keyStore.getPlayerId();
    final playerId=userPlayerId.toString();
    final userToken = await keyStore.getToken();
    final userName = await keyStore.getUsername();
    
    Map data = {
      "token": userToken,
      "player_id": playerIdOthers,
     
    };
   

    var bodyPost = json.encode(data);
     print('lihat body dan parse $bodyPost dan $url ');
    if(statusApi==false){
      url="$baseUrl/$urllink";
    }else{
      url="$baseUrlPro/$urllink";
    }
    print('lihat body dan parse  $url ');
    final response = await client.post(
      "$url",
       headers: {"token": userToken, "playerid":playerId,
                "content-type": "application/json"},
       body: bodyPost
    );
   final statusCode = response.statusCode;
    
    // print('lihat status code api bady info $bodyPost');
    // print('lihat body game connect $jsn');
    print('status Code api set follow $statusCode');
    if (statusCode==200) {
        var jsn = json.decode(response.body);
            print('lihat body $jsn');
            var message = jsn["messages"];
            var result = jsn["result"];
            //  print('lihat Result $result');
            Map datarespon = {
                  "status":true,
                  "messages":message,
                  "result":result
                };
                var respons = json.encode(datarespon);
        return respons;
    } else if(statusCode==500){
         var message = "oops something wrong";
             Map datarespon = {
                  "status":false,
                  "messages":message
                };
              var respons = json.encode(datarespon);
             
            return respons;
    }else{
         var jsn = json.decode(response.body);
            var message = jsn["messages"];
            // print("respont api messages  $message");
              Map datarespon = {
                  "status":false,
                  "messages":message
                };
                var respons = json.encode(datarespon);
             
            return respons;
    }
 }

}