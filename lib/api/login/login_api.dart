
import 'package:yamisok/model/model_feeds.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/component/keyStore.dart'; 

Client client = Client();




class ApiServiceLogin {
 


 static Future<String> apilogin(String username,String pass) async {
   
      print("masuk k api ");
      final apiregisterurl=globals.baseUrlApi;
      print("masuk k api2 ");
      Map data = {
       "email": username,
       "password": pass,
       
      };
    //encode Map to JSON 18776 fauzan
    var bodyPost = json.encode(data);
    
    var url = "$apiregisterurl/v1/users/login";
    print('lihat body dan parse $bodyPost dan $url ');
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
            var token = result["token"];
            var avatar_url = result["avatar_url"];
            var name = result["name"];
            var username = result["username"];
            var email = result["email"];
            var player_id = result["player_id"];
            var basic_info = result["basic_info"];
            var verified = result["verified"];
            var game_connect=result["player_game_connect"];
            // print('lihat token  body $jsn');
            // print("status api $statusCode $message");
              Map datarespon = {
                  "status":true,
                  "messages":message,
                  "token":token,
                  "name":name,
                  "player_id":player_id,
                  "token":token,
                  "avatar_url":avatar_url,
                  "basic_info":basic_info,
                  "verified":verified,
                  "email":email,
                  "game_connect":game_connect,
                  "username":username
                };
                var respons = json.encode(datarespon);
             
            return respons;
      } else if(statusCode==500) {
          // var jsn = json.decode(response.body);
            var message = '#500 oops please try again later';
            print("respont api messages  $message");
            Map datarespon = {
                  "status":false,
                  "messages":message
                };
                var respons = json.encode(datarespon);
            
            return respons;
    }else {
          var jsn = json.decode(response.body);
            var message = jsn["messages"];
            print("respont api messages  $message");
            Map datarespon = {
                  "status":false,
                  "messages":message
                };
                var respons = json.encode(datarespon);
            
            return respons;
    }

  }


}