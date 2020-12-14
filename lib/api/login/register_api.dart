
import 'package:yamisok/model/model_feeds.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/component/keyStore.dart'; 

Client client = Client();


class ApiServicenew{
    final String name;
    final String username; 
    final String email;
    final String pass;

    const ApiServicenew({this.name, this.username, this.email, this.pass});


    Future<String> apiregister() async {
      
      print("masuk k api ");
          final apiregisterurl=globals.baseUrlApi;
      print("masuk k api2 ");
          Map data = {
          "name": name,
            "username": username,
            "email": email,
            "password": pass,
            "country": 7,
            "is_subscribe": 0
          };
        //encode Map to JSON 18776 fauzan
        var bodyPost = json.encode(data);;
        var url = "$apiregisterurl/v1/users/register";
        print('lihat body dan parse $bodyPost dan $url ');
        final response = await client.post(
          "$url",
          headers: {"content-type": "application/json"},
          body: bodyPost,
        );
      final statusCode = response.statusCode;
        print('lihat  status code regis $statusCode ');
        // print(JSON.stringify(newtes);
        if (statusCode==200) {
              var jsn = json.decode(response.body);
                var message = jsn["messages"];
                print("status api $statusCode $message");
                
                  var respons={
                    "status":true,
                    "messages":message
                  };
                return "$respons";
        }  else if(statusCode==400) {
           var jsn = json.decode(response.body);
                var message = jsn["messages"];
                print("respont api messages  $message");
                var respons={
                    "status":false,
                    "messages":message

                  };
                
              return '$respons';
        }else {
              // var jsn = json.decode(response.body);
                var message = "opps something orror";
                print("respont api messages  $message");
                var respons={
                    "status":false,
                    "messages":message

                  };
                
                return '$respons';
        }

      }





}


class ApiService2 {
 


 static Future<String> apiregister(String username, String email, String pass) async {
   
      final apiregisterurl=globals.baseUrlApi;
      Map data = {
        "username": username,
        "email": email,
        "password": pass
      };
    //encode Map to JSON 18776 fauzan
    var bodyPost = json.encode(data);
    var url = "$apiregisterurl/v1/users/new_register";
    print('lihat body dan parse $bodyPost dan $url ');
    final response = await client.post(
      "$url",
      headers: {"content-type": "application/json"},
      body: bodyPost,
    );
   final statusCode = response.statusCode;
    print('lihat  status code $statusCode ');
    // print(JSON.stringify(newtes);
    if (statusCode==202) {
          var jsn = json.decode(response.body);
            var message = jsn["messages"];
            print("status api $statusCode $message");
              Map datarespon = {
                  "status":true,
                  "messages":message
                };
                var respons = json.encode(datarespon);
             
            return respons;
        }else if(statusCode==400) {
           var jsn = json.decode(response.body);
                var message = jsn["messages"];
                print("respont api messages  $message");
                Map datarespon= {
                    "status":false,
                    "messages":message

                  };
                var respons = json.encode(datarespon);
              return respons;
        }else {
              // var jsn = json.decode(response.body);
                var message = "oops something wrong";
                print("respont api messages  $message");
                Map datarespon= {
                    "status":false,
                    "messages":message

                  };
                var respons = json.encode(datarespon);
                return respons;
        }

  }


}