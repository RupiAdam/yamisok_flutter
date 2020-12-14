
import 'package:yamisok/model/model_feeds.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/component/keyStore.dart'; 

Client client = Client();




class ApiServiceProfile {
    static Future<String> apiprofile(parseUsername) async {
    final bool statusApi = globals.statusApi;
    final String baseUrl = globals.baseUrlApi;
    final String baseUrlPro = globals.urlApiPro;
    var urllink="v1/profile_player";
    var url="";

    final userPlayerId = await keyStore.getPlayerId();
    final playerId=userPlayerId.toString();
    final userToken = await keyStore.getToken();
    var userName =parseUsername;
    if(parseUsername!=''){
       userName = parseUsername;
    }else{
       userName = await keyStore.getUsername();
    }
    
    
    
    if(statusApi==false){
      url="$baseUrl/$urllink/$userName?token=$userToken";
    }else{
      url="$baseUrlPro/$urllink/$userName?token=$userToken";
    }
    print('lihat body dan parse  $url ');
    final response = await client.get(
      "$url",
      headers: {"content-type": "application/json"},

    );
   final statusCode = response.statusCode;
    print('lihat status code api level $statusCode');
    if (statusCode==200) {
        var jsn = json.decode(response.body);
          
            var message = "succes";
            var result = jsn["result"];
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
            var message = jsn["message"];
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