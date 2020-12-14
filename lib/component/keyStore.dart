import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sharedPreferences;

const KEY_LATEST_POKED = "latest_poked";


saveLocallogin(String token, int playerID, String avatar_url, String username) async {
  //  SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
     
      prefs.setString("token", token);
      prefs.setInt("id_player", playerID);
      prefs.setString("avatar_url", avatar_url);
      prefs.setString("username", username);
      String usernamedt = prefs.getString('username');
      print("lihat username pas login: $usernamedt");
      // String avatar_urldt = prefs.getString('avatar_url');
      // print("lihat avatar_urldt pas login: $avatar_urldt");
}

setKotaForSearch(String idkota, String namekota, String nameProvinsi) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("idKotaForSearch", idkota);
  prefs.setString("nameKotaForSearch", namekota);
  prefs.setString("nameProvinsiForSearch", nameProvinsi);

}

setKotaForSearchMabar(String idkota, String namekota,String nameProvinsi ) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("idKotaForSearchMabar", idkota);
  prefs.setString("nameKotaForSearchMabar", namekota);
  prefs.setString("nameProvinsiForSearchMabar", nameProvinsi);
}

setGenderForSearch(String idgenderforkota) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("idgenderForSearch", idgenderforkota);
  // prefs.setString("nameKotaForSearch", namekota);
}

setLatestPage(String latestPage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("latest_page", latestPage);
}

setEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("email", email);
}

setResetPasswordToken(String token) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("reset_password_token", token);
}

disableLandingPage() async {
//  SharedPreferences.setMockInitialValues({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("is_show_landing", false);

  bool isshow = prefs.getBool("is_show_landing");
  print("UPDATED IS SHOW $isshow");
}

isShowLandingPage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isShow = prefs.getBool("is_show_landing");
  return isShow;
}


setLogout()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
}

class keyStore {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  final String _kNotificationsPrefs = "allowNotifications";
  static final String _token = "token";

  static Future<String> getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var rst = await sharedPreferences.getString("token");
    print(" CEK GetToken : $rst");
    return await sharedPreferences.getString("token") ?? 'null';
  }

  static Future<int> getPlayerId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var rst = await sharedPreferences.getInt("id_player");
    return await sharedPreferences.getInt("id_player") ?? null;
  }
  static Future<String> getNameKotaForSearch() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var rst = await sharedPreferences.getString("nameKotaForSearch");
    return await sharedPreferences.getString("nameKotaForSearch") ?? null;
  }
  static Future<String> getNameProvinsiForSearch() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var rst = await sharedPreferences.getString("nameProvinsiForSearch");
    return await sharedPreferences.getString("nameProvinsiForSearch") ?? null;
  }

  static Future<String> getNameKotaForSearchMabar() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var rst = await sharedPreferences.getString("nameKotaForSearchMabar");
    return await sharedPreferences.getString("nameKotaForSearchMabar") ?? null;
  }
  static Future<String> getidKotaForSearchMabar() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var rst = await sharedPreferences.getString("idKotaForSearchMabar");
    return await sharedPreferences.getString("idKotaForSearchMabar") ?? null;
  }
  static Future<String> getNameProvinsiForSearchMabar() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var rst = await sharedPreferences.getString("nameProvinsiForSearchMabar");
    return await sharedPreferences.getString("nameProvinsiForSearchMabar") ?? null;
  }

   
  static Future<String> getidKotaForSearch() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var rst = await sharedPreferences.getString("idKotaForSearch");
    return await sharedPreferences.getString("idKotaForSearch") ?? null;
  }

  

  static Future<String> getGenderForSearch() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var rst = await sharedPreferences.getString("idgenderForSearch");
    return await sharedPreferences.getString("idgenderForSearch") ?? '';
  }



  static Future<bool> setToken(String value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("CEK setToken ,$value");
    // return await prefs.setString(_token, value);
    return await sharedPreferences.setString("token", value);
  }

    static Future<bool> setTokenId(String token, int id, String avatarurl, String username) async {
    sharedPreferences = await SharedPreferences.getInstance();
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("CEK setToken ,$value");
    // return await prefs.setString(_token, value);
    
    await sharedPreferences.setString("token", token);
    await sharedPreferences.setInt("id_player", id);
    await sharedPreferences.setString("avatar_url", avatarurl);
    await sharedPreferences.setString("username", username);
    return true;
  }

  static Future<String> getUsername() async {
    sharedPreferences = await SharedPreferences.getInstance();
   
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
   var result = sharedPreferences.getString("username");
    return result ?? 'null';
  }

  static Future<String> getEmail() async {
    sharedPreferences = await SharedPreferences.getInstance();
   
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
   var result = sharedPreferences.getString("email");
    return result ?? 'null';
  }
  

  static Future<String> getAvatar() async {
    sharedPreferences = await SharedPreferences.getInstance();
    // final SharedPreferences prefs = await SharedPreferences.getInstaance();
    var rst = sharedPreferences.getString("avatar_url");
    return rst ?? 'null';
  }

  static Future<bool> setUsername(String value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString("username", value);
  }

  static Future<String> getLatestPage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var rst = sharedPreferences.getString("latest_page");
    return rst ?? 'null';
  }

  static Future<String> getResetPasswordToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var rst = sharedPreferences.getString("reset_password_token");
    return rst ?? 'null';
  }

  static setPokedTime(String userId, int timestamp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var rawJson = prefs.getString(KEY_LATEST_POKED) ?? '{\"poke_waiting_time\": {}}';

    var pureJson = json.decode(rawJson);
    pureJson["poke_waiting_time"][userId] = timestamp;

    // before store to sharedpref, encode json first,
    // or you'll get wrong json format / string
    prefs.setString(KEY_LATEST_POKED, json.encode(pureJson));
  }

  static Future<int> getLatestPokedTIme(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var rawJson = prefs.getString(KEY_LATEST_POKED) ?? '{\"poke_waiting_time\": {}}';

    var pureJson = json.decode(rawJson);
    return pureJson["poke_waiting_time"][userId];
  }


// sharedPreferences.clear();

}