
import 'package:yamisok/model/model_feeds.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/component/keyStore.dart'; 

Client client = Client();




class ApiServiceDetailuser {
 
    static Future<String> apidetailuser(String usernameParse) async {
       print('masuk k api detail user');
    final bool statusApi = globals.statusApi;
    final String baseUrl = globals.baseUrlApi;
    final String baseUrlPro = globals.urlApiPro;
    var urllink="v1/users/profile-info?username";
    var url="";

    final userPlayerId = await keyStore.getPlayerId();
    final playerId=userPlayerId.toString();
    final userToken = await keyStore.getToken();
    var userName = await keyStore.getUsername();
    if(usernameParse!=''){
     userName = usernameParse;
      
    }else{
     userName = await keyStore.getUsername();
   }
    
    
    
    if(statusApi==false){
      url="$baseUrl/$urllink=$userName";
    }else{
      url="$baseUrlPro/$urllink=$userName";
    }
   final response = await client.get(
      "$url",
      headers: {"token": userToken, "playerid":playerId },

    );
   final statusCode = response.statusCode;
    if (statusCode==200) {
        var jsn = json.decode(response.body);
          
            var message = "succes";
            var result = jsn["result"];
            print('lihat data detail player dari api $result');

           
            // print('lihat data detail player dari api parsedata $parsedata');
            // var parsedatajson=json.encode(parsedata);
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