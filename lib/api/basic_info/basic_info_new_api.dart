
import 'package:yamisok/model/model_feeds.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/component/keyStore.dart'; 

Client client = Client();




class ApiServiceBasicNew {
 
 static Future<String> apibasicinfonew(name,username,email,password,gender,idkota) async {
    final bool statusApi = globals.statusApi;
    final String baseUrl = globals.baseUrlApi;
    final String baseUrlPro = globals.urlApiPro;
    var urllink="v1/users/submit-register";
    var url="";

    // final userPlayerId = await keyStore.getPlayerId();
    // final playerId=userPlayerId.toString();
    // final userToken = await keyStore.getToken();
     Map data = {
      "name": name,
        "username": username,
        "email": email,
        "password": password,
        "gender": gender.toString()=='1' ? 'P' : 'W',
        "country": 1,
        "city": idkota
      };

     
        //encode Map to JSON 18776 fauzan
    var bodyPost = json.encode(data);
    if(statusApi==false){
      url="$baseUrl/$urllink";
    }else{
      url="$baseUrlPro/$urllink";
    }
    print('lihat body dan parse $bodyPost dan $url ');
    final response = await client.post(
      "$url",
      headers: {"content-type": "application/json"},
      body: bodyPost,
    );
   final statusCode = response.statusCode;
    print('lihat status code api basic info submit register $statusCode');
    if (statusCode==200) {
        var jsn = json.decode(response.body);
          
            var message = jsn["messages"];
            var result = jsn["result"];
            var token = result["token"];
            var name = result["name"];
            var avatar_url = result["avatar_url"];
            var username = result["username"];
            var email = result["email"];
            var player_id = result["player_id"];
            
             Map datarespon = {
                  "status":true,
                  "messages":message,
                  "token":token,
                  "name":name,
                  "avatar_url":avatar_url,
                  "username":username,
                  "email":email,
                  "player_id":player_id
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