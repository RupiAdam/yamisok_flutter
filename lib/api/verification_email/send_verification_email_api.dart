import 'package:http/http.dart' show Client;
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';

Client client = Client();

class ApiServiceVerificationEmail {
  static Future<String> sendVerificationEmail(String email) async {
    Map params = {"email": email};

    var bodyJson = json.encode(params);

    final response = await client.post(
      globals.URL_SEND_VERIFICATION_EMAIL,
      headers: {"content-type": "application/json"},
      body: bodyJson,
    );

    final statusCode = response.statusCode;

    if (statusCode == 200) {
      var respJson = json.decode(response.body);
      var message = respJson["messages"];

      Map map = {"status": 200, "messages": message};

      return json.encode(map);
    } else {
      var respJson = json.decode(response.body);
      var message = respJson["messages"];

      Map map = {"status": statusCode, "messages": message};

      return json.encode(map);
    }
  }

  static Future<String> checkStatusEmail(String email) async {
    Map params = {"email": email};

    var bodyJson = json.encode(params);

    final response = await client.post(
      globals.URL_CHECK_VERIFICATION_EMAIL,
      headers: {"content-type": "application/json"},
      body: bodyJson,
    );

    final statusCode = response.statusCode;

    if (statusCode == 200) {
      print(response.body);
      var respJson = json.decode(response.body);
      var message = respJson["messages"];

      Map map = {"status": 200, "messages": message};

      return json.encode(map);
    } else {
      var respJson = json.decode(response.body);
      var message = respJson["messages"];

      Map map = {"status": statusCode, "messages": message};

      return json.encode(map);
    }
  }
}
