import 'package:http/http.dart' show Client;
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';

Client client = Client();

class ApiServiceForgotPasswordValidateEmail{

  static Future<String> validateEmail(String email) async {

    Map params = {
      "email": email
    };

    var bodyJson = json.encode(params);

    final response = await client.post(
      globals.URL_FORGOT_PASSWORD_VALIDATE_EMAIL,
      headers: {"content-type": "application/json"},
      body: bodyJson,
    );

    final statusCode = response.statusCode;

    if(statusCode == 200){

      var respJson = json.decode(response.body);
      var token = respJson["result"]["token"];

      Map map = {
        "status": 200,
        "token": token
      };

      return json.encode(map);

    }else{

      var respJson = json.decode(response.body);
      var message = respJson["messages"];

      Map map = {
        "status": statusCode,
        "messages": message
      };

      return json.encode(map);
    }

  }

  static Future<String> resendValidation(String email) async {

    Map params = {
      "email": email
    };

    var bodyJson = json.encode(params);

    final response = await client.post(
      globals.URL_RESEND_EMAIL_VALIDATION,
      headers: {"content-type": "application/json"},
      body: bodyJson,
    );

    final statusCode = response.statusCode;

    if(statusCode == 200){

      var respJson = json.decode(response.body);
      var token = respJson["result"]["token"];

      Map map = {
        "status": 200,
        "token": token
      };

      return json.encode(map);

    }else{

      var respJson = json.decode(response.body);
      var message = respJson["messages"];

      Map map = {
        "status": statusCode,
        "messages": message
      };

      return json.encode(map);
    }

  }

}