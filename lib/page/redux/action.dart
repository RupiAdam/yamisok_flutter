// Reducer
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:yamisok/page/redux/appstate.dart';

class UpdateQuoteAction {
  String quote;

  UpdateQuoteAction({this.quote});
}

class UpdateListPopular {
  String limit;
  UpdateListPopular({this.limit});
}


class LoadingListPopular {
}

class SuccessListPopular {
  Map content;
  SuccessListPopular({this.content});
}



class FailListPopular {

}
//Esport
class UpdateNews {
  String limit;
  UpdateNews({this.limit});
}
class SuccessNews {
  List content;
  SuccessNews({this.content});
}

//provinsi
class UpdateProvinsi {
  UpdateProvinsi();
}

class SuccessProvinsi {
  List content;
  SuccessProvinsi({this.content});
}

//Kota
class UpdateKota {
  String provinsi;
  UpdateKota({this.provinsi});
}

class SuccessKota {
  List content;
  SuccessKota({this.content});
}


//Detail Player
class UpdateDetailPlayer {
  String usernameParse;
  UpdateDetailPlayer({this.usernameParse});
}

class SuccessDetailPlayer {
  List content;
  SuccessDetailPlayer({this.content});
}

class LoadingNews{

}
class RefreshNews{
  String limit;

  RefreshNews({this.limit});
}

class GetFollowingAction{
  String otherId;
  String selfId;
  String token;
  GetFollowingAction({this.otherId, this.selfId, this.token});
}

class GetFollowersAction{
  String otherId;
  String selfId;
  String token;
  GetFollowersAction({this.otherId, this.selfId, this.token});
}

class OnLoadedFollowingAction{
  List data;
  OnLoadedFollowingAction({this.data});
}

class OnLoadedFollowersAction{
  List data;
  OnLoadedFollowersAction({this.data});
}

class LoadMoreFollowingItemAction{
  String otherId;
  String selfId;
  String token;
  int page;
  LoadMoreFollowingItemAction({this.otherId, this.selfId, this.token, this.page});
}

class LoadMoreFollowersItemAction{
  String otherId;
  String selfId;
  String token;
  int page;
  LoadMoreFollowersItemAction({this.otherId, this.selfId, this.token, this.page});
}

class AddMoreFollowingItem{
    List data;
    AddMoreFollowingItem({this.data});
}

class AddMoreFollowersItem{
    List data;
    AddMoreFollowersItem({this.data});
}

class SearchFollowingAction{
  BuildContext context;
  int id;
  String token;
  String key;
  int page;
  SearchFollowingAction({this.context, this.id, this.token, this.key, this.page});
}

class SearchFollowersAction{
  BuildContext context;
  int id;
  String token;
  String key;
  int page;
  SearchFollowersAction({this.context, this.id, this.token, this.key, this.page});
}

class ReplaceSearchFollowingAction{
  List data;
  ReplaceSearchFollowingAction({this.data});
}

class ReplaceSearchFollowersAction{
  List data;
  ReplaceSearchFollowersAction({this.data});
}

class AddMoreSearchFollowing{
  List data;
  AddMoreSearchFollowing({this.data});
}

class AddMoreSearchFollowers{
  List data;
  AddMoreSearchFollowers({this.data});
}

class ReplaceFollowingStatus{
  int position;
  bool status;
  ReplaceFollowingStatus({this.position, this.status});
}

// ignore: slash_for_doc_comments
/**
 * Action untuk following + followers
 * on done init => replace data di redux
 * add more => tambah data di redux
 **/

class ReplaceFollowingFollowers{
  List data;
  ReplaceFollowingFollowers({this.data});
}


class AddMoreFollowingFollowers{
  List data;
  AddMoreFollowingFollowers({this.data});
}