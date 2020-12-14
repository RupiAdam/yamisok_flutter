import 'package:http/http.dart' show Client;
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';

Client client = Client();

class ApiServicePrivacyPolicy {
  static Future<String> getPrivacyPolicy() async {
    final response = await client.get(
      globals.URL_PRIVACY_POLICY,
      headers: {"content-type": "application/json"},
    );

    final statusCode = response.statusCode;

    if (statusCode == 200) {
      var respJson = json.decode(response.body);
      var description = respJson["result"]["description"];

      Map map = {
        "status": 200,
        "description": description,
      };

      return json.encode(map);
    } else {
      var respJson = json.decode(response.body);
      var message = respJson["messages"];

      Map map = {"status": statusCode, "messages": message};

      return json.encode(map);
    }
  }
}
