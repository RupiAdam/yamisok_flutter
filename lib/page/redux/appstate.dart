import 'dart:convert';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:yamisok/api/basic_info/provinsi_api.dart';
import 'package:yamisok/api/basic_info/provinsi_kota.dart';
import 'package:yamisok/api/esport/esport_api.dart';
import 'package:yamisok/api/profile/profile_detailuser_api.dart';
import 'package:yamisok/api/profile/profile_follow.dart';
import 'package:yamisok/page/redux/action.dart' as AppAction;

// AppState
Map profile = {
  "nama": "akua man24",
  "data": [
    {
      "nama": 'aaa',
    }
  ]
};

class AppState {
  Map state;
  Map initialState = {
    "profile": profile,
    "quote": "This is Default Quote",
    "popular" : {
      "loading": false,
      "content" : new Map()
    },
    "news" : {
      "loading": false,
      "content" : new List()
    },
    "provinsi" : {
      "content" : new List()
    },
    "kota" : {
      "loading": false,
      "content" : new List()
    },
    "following":{
        "is_loading": false,
        "data": new List(),
        "has_more": true,
    },
    "followers":{
        "is_loading": false,
        "data": new List(),
        "has_more": true,
    },
    "following_followers":{
        "is_loading": false,
        "data": List(),
        "has_more": true
    },
    "detailplayer":{
        "is_loading": false,
        "content": new List()
    },
    "author": "",
    "temp":{
        "new_profile_picture": ""
    }
  };

  AppState() {
    print("Initialize Main State");
    this.state = this.initialState;
  }

  String get quote => this.state['quote'];
  String get author => this.state['author'];
  // List get news_data => this.state['news']['content'];

  String get new_profile_picture => this.state["temp"]["new_profile_picture"];
  set new_profile_picture(String path){
    this.state["temp"]["new_profile_picture"] = path;
  }


  set quote (String quote) {
    this.state['quote'] = quote;
  }

 
  //news
  List get news_content => this.state["news"]["content"];
  set news_content (List content) {
    this.state["news"]["content"] = content;
  }

  //provinsi
  List get provinsi_content => this.state["provinsi"]["content"];
  set provinsi_content (List content) {
    this.state["provinsi"]["content"] = content;
  }

  //Kota
  List get kota_content => this.state["kota"]["content"];
    set kota_content (List content) {
    this.state["kota"]["content"] = content;
  }

   // BasicInfo
  List get detailuser_content => this.state["detailplayer"]["content"];
    set detailuser_content (List content) {
    this.state["detailplayer"]["content"] = content;
  }

  // Following
  List get list_following => this.state["following"]["data"];
  set list_following(List data){
    this.state["following"]["data"] = data;
  }
  bool get has_more_following => this.state["following"]["has_more"];
  set has_more_following(bool state){
      this.state["following"]["has_more"] = state;
  }

  // Followers
  List get list_followers => this.state["followers"]["data"];
  set list_followers(List data){
      this.state["followers"]["data"] = data;
  }
  bool get has_more_followers => this.state["followers"]["has_more"];
  set has_more_followers(bool state){
      this.state["followers"]["has_more"] = state;
  }

  // Following + followers
  List get list_following_followers => this.state["following_followers"]["data"];
  set list_following_followers(List data){
      this.state["following_followers"]["data"] = data;
  }
  bool get has_more_following_followers => this.state["following_followers"]["has_more"];
  set has_more_following_followers(bool state){
      this.state["following_followers"]["has_more"] = state;
  }

 
 
  
}

class Profile {
  int _counter;
  String _quote;
  String _author;

  int get counter => _counter;
  String get quote => _quote;
  String get author => _author;



  Profile(this._counter, this._quote, this._author);
}

class ViewModel {
  final AppState state;
   void Function(String quote) updateQuote;

   void Function() updateNews;

   //provinsi
   void Function() updateprovinsi;

    //kota
   void Function(String provinsi) updatekota;

   // Following
   void Function(int id, String token) getFollowing;

   // Followers
   void Function(int id, String token) getFollowers;

   //BasicInfo
   void Function() updatedetailplayer;


  ViewModel({this.state, 
            this.updateQuote, 
            this.updateNews, 
            this.updateprovinsi, 
            this.updatekota,
            this.getFollowing,
            this.getFollowers,
            this.updatedetailplayer});

 
}
class NewMiddleware implements MiddlewareClass<AppState> {
 
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
      //esport
      if (action is AppAction.UpdateNews) {
        store.dispatch(AppAction.LoadingNews); // Start Loading
        var limit = action.limit;
        ApiServiceEsport.apiesport(limit).then((result) async {
          var resultdt = json.decode(result);
          final messages = resultdt['messages'];
          final status = resultdt['status'];
          if (status == true) {
            var resultlist = resultdt['result'];
            Map result = new Map();
            store.dispatch(AppAction.LoadingNews); // End Loading
            store.dispatch(AppAction.SuccessNews(content : resultlist));
          } else {
            print("Call api Error");
          }
        });
      }

      if (action is AppAction.SuccessNews) {
        store.state.news_content = action.content;
        var dataprint = action.content;
//        print('lihat data succes $dataprint');
      }

      //provinsi
      if (action is AppAction.UpdateProvinsi) {
        ApiServiceProvinsi.apiprovinsi().then((result) async {
          var resultdt = json.decode(result);
          final messages = resultdt['messages'];
          final status = resultdt['status'];
          if (status == true) {
           
            var resultlist = resultdt['result'];
            //  print('lihat data parsing provinsi $resultlist');
            Map result = new Map();
            // store.dispatch(AppAction.LoadingNews); // End Loading
            store.dispatch(AppAction.SuccessProvinsi(content : resultlist));
          } else {
            print("Call api Error");
          }
        });
      }
      if (action is AppAction.SuccessProvinsi) {
      store.state.provinsi_content = action.content;
      }

      //kota
       if (action is AppAction.UpdateKota) {
         print('masuk k update kota');
          var provinsi = action.provinsi;
        ApiServiceKota.apikota(provinsi).then((result) async {
          var resultdt = json.decode(result);
          final messages = resultdt['messages'];
          final status = resultdt['status'];
          if (status == true) {

            var resultlist = resultdt['result'];
            //  print('lihat data parsing provinsi $resultlist');
            Map result = new Map();
            // store.dispatch(AppAction.LoadingNews); // End Loading
            store.dispatch(AppAction.SuccessKota(content : resultlist));
          } else {
            print("Call api Error");
          }
        });
      }
      if (action is AppAction.SuccessKota) {
        store.state.kota_content = action.content;
      }

      //basic info //detail profile
       if (action is AppAction.UpdateDetailPlayer) {
         print('masuk k update detail player redux');
         var usernameParse = action.usernameParse;
        ApiServiceDetailuser.apidetailuser(usernameParse).then((result) async {
          var resultdt = json.decode(result);
          final messages = resultdt['messages'];
          final status = resultdt['status'];
          if (status == true) {

            List datasample=[];
            datasample.add(resultdt['result']);

            var resultlist = resultdt['result'];
           
            //  print('lihat data parsing datasample $datasample');
            Map result = new Map();
            // store.dispatch(AppAction.LoadingNews); // End Loading
            store.state.detailuser_content.clear();
            store.dispatch(AppAction.SuccessDetailPlayer(content : datasample));
          } else {
            print("Call api Error");
          }
        });
      }
      if (action is AppAction.SuccessDetailPlayer) {
        
        store.state.detailuser_content = action.content;
      }

        // Get following
        if(action is AppAction.GetFollowingAction){

            ApiServiceProfileFollow.getFollowing(action.otherId, action.selfId, action.token).then((result) async {

                var data = json.decode(result);
                var status = data['status'];

                if(status == 200){
                    var list_following = data['data'];
                    store.dispatch(AppAction.OnLoadedFollowingAction(data: list_following));
                }

            });
        }
        if(action is AppAction.OnLoadedFollowingAction){
            store.state.list_following = action.data;
        }

        if(action is AppAction.LoadMoreFollowingItemAction){
            ApiServiceProfileFollow.loadMoreFollowing(action.otherId, action.selfId, action.token, action.page).then((result) async {
                var data = json.decode(result);
                var status = data['status'];

                if(status == 200){
                    var list_following = data['data'];
                    store.dispatch(AppAction.AddMoreFollowingItem(data: list_following));
                }
            });
        }
        if(action is AppAction.AddMoreFollowingItem){
            if(action.data.length > 0){
                store.state.has_more_following = true;
                store.state.list_following.addAll(action.data);
            }else{
                store.state.has_more_following = false;
            }
        }


        // Get followers
        if(action is AppAction.GetFollowersAction){
            ApiServiceProfileFollow.getFollowers(action.otherId, action.selfId, action.token).then((result) async {

                var data = json.decode(result);
                var status = data['status'];

                if(status == 200){
                    var listFollowers = data['data'];
                    store.dispatch(AppAction.OnLoadedFollowersAction(data: listFollowers));
                }

            });
        }
        if(action is AppAction.OnLoadedFollowersAction){
            store.state.list_followers = action.data;
        }

        

        if(action is AppAction.LoadMoreFollowersItemAction){
            print('on fetch action loadmore followers');
            ApiServiceProfileFollow.loadMoreFollowers(action.otherId, action.selfId, action.token, action.page).then((result) async {
                var data = json.decode(result);
                var status = data['status'];

                if(status == 200){
                    var listFollowers = data['data'];
                    store.dispatch(AppAction.AddMoreFollowersItem(data: listFollowers));
                }
            });
        }
        if(action is AppAction.AddMoreFollowersItem){
            print('data length is: ${action.data.length}');
            if(action.data.length > 0){
                store.state.has_more_followers = true;
                store.state.list_followers.addAll(action.data);
            }else{
                store.state.has_more_followers = false;
            }
        }

        // search following
        if(action is AppAction.AddMoreSearchFollowing){
            if(action.data.length > 0){
                store.state.has_more_following = true;
                store.state.list_following.addAll(action.data);
            }else{
                store.state.has_more_following = false;
            }
        }
        if(action is AppAction.ReplaceSearchFollowingAction){
            store.state.list_following = action.data;
        }

        //search followers
        if(action is AppAction.AddMoreSearchFollowers){
          if(action.data.length > 0){
              store.state.has_more_followers = true;
              store.state.list_followers.addAll(action.data);
          }else{
              store.state.has_more_followers = false;
          }
        }
        if(action is AppAction.ReplaceSearchFollowersAction){
            store.state.list_followers = action.data;
        }

        // replace follow status
        if(action is AppAction.ReplaceFollowingStatus){
            store.state.list_followers[action.position]['hasFollowed'] = action.status;
        }


        // following + followers
        if(action is AppAction.ReplaceFollowingFollowers){
            store.state.has_more_following_followers = true;
            store.state.list_following_followers = action.data;
        }
        if(action is AppAction.AddMoreFollowingFollowers){
            print('in state');
            if(action.data.length > 0){
                store.state.has_more_following_followers = true;
                store.state.list_following_followers.addAll(action.data);
            }else{
                store.state.has_more_following_followers = false;
            }
        }


    // Make sure to forward actions to the next middleware in the chain!
    next(action);
  }
}


class PopularMiddleware implements MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {

    if (action is AppAction.UpdateListPopular) {

      store.dispatch(AppAction.LoadingListPopular); // Start Loading

      // TODO Get List Popular from API
        var limit = action.limit;
        ApiServiceEsport.apiesport(limit).then((result) async {
            var resultdt = json.decode(result);
            final messages = resultdt['messages'];
            final status = resultdt['status'];
            if (status == true) {
              print('masuk k satstus 200');
              var resultlist = resultdt['result'];
              // print('lihat body, $resultlist');
              Map result = new Map();

              store.dispatch(AppAction.LoadingListPopular); // End Loading
              store.dispatch(AppAction.SuccessListPopular(content : resultlist));
            
            } else {
              print("status false");
            }
          });
        }


    // Make sure to forward actions to the next middleware in the chain!
    next(action);
  }
}

class QuoteMiddleware implements MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action is AppAction.UpdateQuoteAction ) {
      store.state.quote = action.quote;
    }

    // Make sure to forward actions to the next middleware in the chain!
    next(action);
  }
}
