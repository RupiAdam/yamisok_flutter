import 'package:http/http.dart' show Client;
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';

Client client = Client();

class ApiServiceUpdateAboutme {
  static Future<String> updateAboutMe(
      String username, String token, String aboutMe) async {
    Map params = {"about_me": aboutMe, "token": token};

    var bodyJson = json.encode(params);

    final response = await client.put(
      globals.URL_UPDATE_ABOUT_ME + username,
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
}
