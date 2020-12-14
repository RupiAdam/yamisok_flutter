import 'package:http/http.dart' show Client;
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';

Client client = Client();

class ApiServiceResetPassword{

  static Future<String> resetPassword(String email, String password) async {
      Map params = {
        "email": email,
        "password": password
      };

      var reqBody = json.encode(params);

      final response = await client.post(
        globals.URL_RESET_PASSWORD,
        headers: {"content-type": "application/json"},
        body: reqBody,
      );

      final statusCode = response.statusCode;

      if (statusCode == 200) {

        Map map = {
          "status": 200,
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