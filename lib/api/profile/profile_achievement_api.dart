
import 'package:yamisok/model/model_feeds.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/component/keyStore.dart'; 

Client client = Client();




class ApiServiceProfileAchive {
 


 static Future<String> apiProfileAchivel() async {
   final bool statusApi = globals.statusApi;
    final String baseUrl = globals.baseUrlApi;
    final String baseUrlPro = globals.urlApiPro;
    var url="$baseUrl/v1/users/achievment";

    final userPlayerId = await keyStore.getPlayerId();
    final playerId=userPlayerId.toString();
    final userToken = await keyStore.getToken();
    
    if(statusApi==false){
      url="$baseUrl/v1/users/achievment";
    }else{
      url="$baseUrlPro/v1/users/achievment";
    }
    print('lihat body dan parse  $url ');
    final response = await client.get(
      "http://www.mocky.io/v2/5d9c598531000059992fc4eb",
       headers: {"token": userToken, "playerid":playerId }
    );
   final statusCode = response.statusCode;
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
        //  var jsn = json.decode(response.body);
            var message = "oops something wrong";
            // print("respont api messages  $message");
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
