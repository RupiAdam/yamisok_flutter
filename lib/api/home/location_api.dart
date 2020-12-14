
// import 'package:yamisok/component/all_library.dart';
// import 'package:yamisok/model/model_feeds.dart';
// import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/component/keyStore.dart'; 

//redux
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:yamisok/redux/action.dart';
// import 'package:yamisok/redux/appstate.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:yamisok/page/redux/action.dart';
import 'package:yamisok/page/redux/appstate.dart';
// import 'package:yamisok/redux/reducer.dart';


Client client = Client();





  ThunkAction<AppState> apigetlocation = (Store<AppState> store) async {
    final bool statusApi = globals.statusApi;
    final String baseUrl = globals.baseUrlApi;
    final String baseUrlPro = globals.urlApiPro;
    var url="$baseUrl/v1/users/lat-lng-location?lat=-6.257451&lng=106.562024";
    // var url="https://baconipsum.com/api/?type=all-meat&paras=2&start-with-lorem=1";
    final userPlayerId = await keyStore.getPlayerId();
    final playerId=userPlayerId.toString();
    final userToken = await keyStore.getToken();
    
    if(statusApi==false){
      url="$baseUrl/v1/users/lat-lng-location?lat=-6.257451&lng=106.562024";
    }else{
      url="$baseUrlPro/v1/users/lat-lng-location?lat=-6.257451&lng=106.562024";
    }
   final response = await client.get(
      "$url",
       headers: {"token": userToken, "playerid":playerId }
    );
  var resultdt = json.decode(response.body);

  var quote=resultdt["result"];

  String author = "adang";

  print("lihat dari api $quote");

  // store.dispatch(new UpdateQuoteAction(quote, author));
};



