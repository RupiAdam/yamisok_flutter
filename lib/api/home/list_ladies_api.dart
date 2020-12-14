import 'package:yamisok/model/model_feeds.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/component/keyStore.dart';

Client client = Client();

class ApiLadiesGamers {
  static Future<String> apiladiesgamers() async {
    final bool statusApi = globals.statusApi;
    final String baseUrl = globals.baseUrlApi;
    final String baseUrlPro = globals.urlApiPro;
    var urllink = "v1/search/search-popular-gamers?pid";
    var url = "";

    final userPlayerId = await keyStore.getPlayerId();
    final playerId = userPlayerId.toString();
    final userToken = await keyStore.getToken();
    final userName = await keyStore.getUsername();

    if (statusApi == false) {
      url = "$baseUrl/$urllink=$playerId&key=&gender=W&offset=0&limit=10";
    } else {
      url = "$baseUrlPro/$urllink=$playerId&key=&gender=W&offset=0&limit=10";
    }
    print('lihat body dan parse  $url ');
    final response = await client
        .get("$url", headers: {"token": userToken, "playerid": playerId});
    final statusCode = response.statusCode;
    print('lihat status code api list game ladies $statusCode');
    if (statusCode == 200) {
      var jsn = json.decode(response.body);

      var message = jsn["messages"];
      var result = jsn["result"];
      Map datarespon = {"status": true, "messages": message, "result": result};
      var respons = json.encode(datarespon);
      return respons;
    } else if (statusCode == 500) {
      var message = "oops something wrong";
      Map datarespon = {"status": false, "messages": message};
      var respons = json.encode(datarespon);

      return respons;
    } else {
      var jsn = json.decode(response.body);
      var message = jsn["messages"];
      // print("respont api messages  $message");
      Map datarespon = {"status": false, "messages": message};
      var respons = json.encode(datarespon);

      return respons;
    }
  }
}
