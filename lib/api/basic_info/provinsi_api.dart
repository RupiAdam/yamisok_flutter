
import 'package:yamisok/model/model_feeds.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/component/keyStore.dart'; 

Client client = Client();




class ApiServiceProvinsi {
 


 static Future<String> apiprovinsi() async {
   print('lihat body api provinsi ');
    final bool statusApi = globals.statusApi;
    final String baseUrl = globals.baseUrlApi;
    final String baseUrlPro = globals.urlApiPro;
    var urllink="v1/references/provinces";
    var url="";

    // final userPlayerId = await keyStore.getPlayerId();
    // final playerId=userPlayerId.toString();
    // final userToken = await keyStore.getToken();
    
    if(statusApi==false){
      url="$baseUrl/$urllink";
    }else{
      url="$baseUrlPro/$urllink";
    }
    print('lihat body dan parse  $url ');
    final response = await client.get(
      "$url",
        headers: {"Content-Type" : "application/json"}
    );
    // final response = await client.get(
    //   "$url",
    //    headers: {"token": userToken, "playerid":playerId }
    // );
   final statusCode = response.statusCode;
    print('lihat status code api basic info provinsi $statusCode');
    if (statusCode==200) {
        var jsn = json.decode(response.body);
          
            var message = jsn["messages"];
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