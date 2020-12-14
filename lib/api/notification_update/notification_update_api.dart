import 'package:http/http.dart' show Client;
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';

Client client = Client();

class ApiServiceNotificationUpdate {
  static Future<String> getNotificationFirst(
      String playerId, String username, String token) async {
    final response = await client.get(
      globals.URL_LIST_NOTIFICATION + "?offset=0&limit=10&",
      headers: {
        "content-type": "application/json",
        "playerid": playerId,
        "token": token
      },
    );

    final statusCode = response.statusCode;

    if (statusCode == 200) {
      var respJson = json.decode(response.body);
      var list = respJson["result"]["list"];

      Map map = {
        "status": 200,
        "data": list,
      };

      return json.encode(map);
    } else {
      var respJson = json.decode(response.body);
      var message = respJson["messages"];

      Map map = {"status": statusCode, "messages": message};

      return json.encode(map);
    }
  }

  static Future<String> getNotificationMore(
      String playerId, String offset, String token) async {
    print("NILAI " + offset);
    final response = await client.get(
      globals.URL_LIST_NOTIFICATION + "?offset=" + offset + "&limit=10&",
      headers: {
        "content-type": "application/json",
        "playerid": playerId,
        "token": token
      },
    );

    final statusCode = response.statusCode;

    if (statusCode == 200) {
      var respJson = json.decode(response.body);
      var list = respJson["result"]["list"];

      Map map = {
        "status": 200,
        "data": list,
      };

      return json.encode(map);
    } else {
      var respJson = json.decode(response.body);
      var message = respJson["messages"];

      Map map = {"status": statusCode, "messages": message};

      return json.encode(map);
    }
  }

  static Future<String> getUpdateFirst(
      String playerId, String username, String token) async {
    final response = await client.get(
      globals.URL_LIST_UPDATE,
      headers: {
        "content-type": "application/json",
        "playerid": playerId,
        "token": token,
        "offset": "0",
        "limit": "10"
      },
    );

    final statusCode = response.statusCode;

    if (statusCode == 200) {
      var respJson = json.decode(response.body);
      var list = respJson["result"];

      Map map = {
        "status": 200,
        "data": list,
      };

      return json.encode(map);
    } else {
      var respJson = json.decode(response.body);
      var message = respJson["messages"];

      Map map = {"status": statusCode, "messages": message};

      return json.encode(map);
    }
  }

  static Future<String> getUpdateMore(
      String playerId, String offset, String token) async {
    print("NILAI " + offset);
    final response = await client.get(
      globals.URL_LIST_UPDATE,
      headers: {
        "content-type": "application/json",
        "playerid": playerId,
        "token": token,
        "offset": offset,
        "limit": "10"
      },
    );

    final statusCode = response.statusCode;

    if (statusCode == 200) {
      var respJson = json.decode(response.body);
      var list = respJson["result"];

      Map map = {
        "status": 200,
        "data": list,
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
