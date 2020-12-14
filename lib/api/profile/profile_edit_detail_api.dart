import 'package:http/http.dart' show Client;
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';

Client client = Client();

class ApiServiceUpdateProfile {
  static Future<String> updateProfile(
      String username,
      String token,
      String realName,
      bool isShowEmail,
      bool isShowDoB,
      bool isShowTelp,
      String dateBorn,
      String idGender,
      String idCity,
      String address,
      String telp,
      String facebookURL,
      String twitterURL,
      String instagramURL,
      String youtubeURL) async {
    Map params = {
      "token": token,
      "real_name": realName,
      "url": username,
      "hidden_email": isShowEmail,
      "hidden_date_of_birth": isShowDoB,
      "hidden_phone": isShowTelp,
      "date_of_born": dateBorn,
      "gender": idGender.toString(),
      "city": idCity,
      "player_address": address,
      "phone_number": telp,
      "facebook_url": facebookURL,
      "instagram_url": instagramURL,
      "twitter_url": twitterURL,
      "youtube_url": youtubeURL
    };

    var bodyJson = json.encode(params);

    print("bodyJson" + bodyJson);

    final response = await client.put(
      globals.URL_UPDATE_PROFILE + username,
      headers: {"content-type": "application/json"},
      body: bodyJson,
    );

    print(response);
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
