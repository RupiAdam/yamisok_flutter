
import 'package:yamisok/model/model_feeds.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/component/keyStore.dart'; 

Client client = Client();




class ApiServiceLoginSocial {
 


 static Future<String> apiloginSocial(String id, String name, String socialtoken, String email, String signature, String provider) async {
   
      print("masuk k api ");
      final apiregisterurl=globals.baseUrlApi;
      print("masuk k api2  social_id $id");
      print("masuk k api2  socialtoken $socialtoken");
      print("masuk k api2  signature $signature");
      print("masuk k api2  provider $provider");
      print("masuk k api2  email $email");
      Map data = {
        "social_id": id,
        "social_token":socialtoken,
        "email": email,
        "signature": signature,
        "provider": provider
       
      };
    //encode Map to JSON 18776 fauzan
    var bodyPost = json.encode(data);
    var url = "$apiregisterurl/v1/users/register-social-facebook";
    if(provider=='google'){
      url="$apiregisterurl/v1/users/register-social-google";
    }
    print('lihat body dan parse $url dan $bodyPost  ');
    final response = await client.post(
      "$url",
      headers: {"content-type": "application/json"},
      body: bodyPost,
    );
   final statusCode = response.statusCode;
    print('lihat  status code $statusCode ');
    // print(JSON.stringify(newtes);
    if (statusCode==200) {
          var jsn = json.decode(response.body);
            var message = jsn["messages"];
            var result = jsn["result"];
            var name = result["name"];
            var token = result["token"];
            var avatarurl = result["avatar_url"];
            var username = result["username"];
            var player_id = result["player_id"];
            var basicinfo = result["basic_info"];
            var gameconnect = result["player_game_connect"];

            // print('lihat token  body $jsn');
            // print("status api $statusCode $message");
              Map datarespon = {
                  "statusCode":200,
                  "status":true,
                  "messages":message,
                  "name":name,
                  "token":token,
                  "player_id":player_id,
                  "avatarurl":avatarurl,
                  "username":username,
                  "basic_info":basicinfo,
                  "game_connect":gameconnect

                };
                var respons = json.encode(datarespon);
             
            return respons;
    }else if(statusCode==202) {
          var jsn = json.decode(response.body);
            var message = jsn["messages"];
            

            // print('lihat token  body $jsn');
            // print("status api $statusCode $message");
              Map datarespon = {
                  "statusCode":202,
                  "messages":message,
                  "status":true
                };
                var respons = json.encode(datarespon);
             
            return respons;
    }  else {
          var jsn = json.decode(response.body);
            var message = jsn["messages"];
            print("respont api messages  $message");
            Map datarespon = {
                  "statusCode":400,
                  "status":false,
                  "messages":message
                };
                var respons = json.encode(datarespon);
            
            return respons;
    }

  }


}