
import 'package:yamisok/model/model_feeds.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/component/keyStore.dart'; 

Client client = Client();




class ApiNotifReadAll {
    static Future<String> apinotifreadall() async {
    final bool statusApi = globals.statusApi;
    final String baseUrl = globals.baseUrlApi;
    final String baseUrlPro = globals.urlApiPro;
    var urllink="v1/notification/read/all";
    var url="";

    final userPlayerId = await keyStore.getPlayerId();
    final playerId=userPlayerId.toString();
    final userToken = await keyStore.getToken();
    final userName = await keyStore.getUsername();
    
    
    if(statusApi==false){
      url="$baseUrl/$urllink";
    }else{
      url="$baseUrlPro/$urllink";
    }
    print('lihat body dan parse notif read all $url ');
    final response = await client.post(
      "$url",
       headers: {
        "token": userToken, 
        "playerid":playerId.toString(),
      },
      body: {
        
      }
    );
   final statusCode = response.statusCode;
    print('lihat status code api notif read all $statusCode');
    if (statusCode==200) {
        var jsn = json.decode(response.body);
          
            var message = jsn["messages"];
            var result = jsn["result"];
            // var unread = jsn["result"]['unread'];

        // print('lihat result api notif $unread $result');
            
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