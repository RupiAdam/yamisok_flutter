import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
// import 'package:yamisok/component/globals.dart' as global;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yamisok/api/esport/esport_api.dart';
import 'package:yamisok/api/game/list_game_api.dart';
import 'package:yamisok/api/home/list_gamer_didekat_api.dart';
import 'package:yamisok/api/home/list_ladies_api.dart';
import 'package:yamisok/api/home/list_popular_api.dart';
import 'package:yamisok/api/home/list_role_cocok_api.dart';
import 'package:yamisok/api/home/list_same_role_api.dart';
import 'package:yamisok/api/online_status/set_status_online_api.dart';
import 'package:yamisok/api/profile/profile_detailuser_api.dart';
import 'package:yamisok/app/FirebaseDatabaseUtil.dart';
// import 'package:yamisok/component/styleyami.dart' as prefix0;
import 'package:yamisok/page/esports/esport_webview.dart';
import 'package:yamisok/page/find_friend/find_friend.dart';
import 'package:yamisok/page/game/connect_game_manual.dart';
import 'package:yamisok/page/game/connect_game_ocr.dart';
import 'package:yamisok/page/game/connect_game_steam.dart';
import 'package:yamisok/page/helper/check_connection.dart';
import 'package:yamisok/page/profile/profile_others.dart';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/redux/action.dart' as AppAction;

import 'package:yamisok/component/keyStore.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
// import 'package:yamisok/component/styleyami.dart';
import 'package:yamisok/page/login/login.dart';
import 'package:yamisok/api/profile/profile_detail_api.dart';
import 'package:yamisok/api/profile/profile_achievement_api.dart';
import 'package:yamisok/api/profile/profile_upcoming_api.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/page/utilities/style.dart';

import 'package:yamisok/page/game/connect_game.dart';
import 'package:yamisok/widget/home/upcoming_widget.dart';

import 'filter_lokasi.dart';

import 'package:yamisok/page/search_friend/search_friend.dart';

Client client = Client();
List<String> dogImages = new List();
List listData = [];
List listDataProfileDetail = [];
List listDataDetail = [];
List listAchievement = [];
List listGammers = [];
List listSameRole = [];
bool noDataSameRole = false;
List listPopular = [];
bool noDataPopular = false;
List listCocok = [];
bool noDataCocok = false;
List listTerdekat = [];
bool noDataTerdekat = false;
List listLadies = [];
bool noDataLadies = false;
String namaKotaForSeach = '';
String namaProvinsiForSeach = '';
List listGameConnect = [];

bool isLoadTerdekat = true;
bool isLoadSameGame = true;
bool isLoadRoleCocok = true;
bool isLoadLadies = true;

List listEsport = [];
List<Container> listnews = new List();

//images default
String imagesDefault = 'https://yamisok.com/assets/images/default/default.png';

//firebase analitics
// final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
FirebaseAnalytics analytics = FirebaseAnalytics();
//home
String username = '';
String avataruser = '';
//upcomingmatch
bool statusUpcoming = false;
bool statusUpcomingData = false;
String titleUpcoming = '';
String dateUpcoming = '';
String timeUpcoming = '';
String nameTeam1 = '';
String avatarTeam1 = '';
String nameTeam2 = '';
String avatarTeam2 = '';
String totalOnline = '';
FirebaseDatabase database = new FirebaseDatabase();
// DatabaseReference _counterRef;

StreamSubscription<Event> _counterSubscription;
StreamSubscription<Event> _onTodoChangedSubscription;
Map _counterOnline;

RefreshController _scrollController = RefreshController(initialRefresh: false);
RefreshController _refreshController = RefreshController(initialRefresh: false);

class HomeNew extends StatefulWidget {
  static String tag = 'home-ve2';
  @override
  _HomeNewState createState() => _HomeNewState();
}

class _HomeNewState extends State<HomeNew> {
  final _searchController = TextEditingController();
  //cleardata
  void clearUpcoming() {
    statusUpcoming = false;
    statusUpcomingData = false;
    titleUpcoming = '';
    dateUpcoming = '';
    timeUpcoming = '';
    nameTeam1 = '';
    avatarTeam1 = '';
    nameTeam2 = '';
    avatarTeam2 = '';
  }

  //get api achieve

  void setapistatusonline() {
    ApiSetOnline.apisetonline().then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        print("status online true");
      } else {
        print("status online false");
      }
    });
  }

  void getapisamerole() {
    setState(() {
      isLoadSameGame = true;
    });
    ApiSameRole.apisamerole().then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        listSameRole.clear();
        var resultlist = resultdt['result'];
        if (mounted) {
          setState(() {
            isLoadSameGame = false;
            if (resultlist.length == 0) {
              noDataSameRole = true;
            } else {
              noDataSameRole = false;
            }
            listSameRole.addAll(resultlist);
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void getapipopular() {
    listPopular.clear();
    ApiPopular.apipopular().then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        // print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        // print('Lihat Body Popular, $resultlist');
        if (mounted) {
          setState(() {
            listPopular.addAll(resultlist);
            //  listdiscover.addAll()
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void getapirolecocok() {
    setState(() {
      isLoadRoleCocok = true;
    });
    ApiRoleCocok.apirolecocok().then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        listCocok.clear();
        var resultlist = resultdt['result'];
        if (mounted) {
          setState(() {
            isLoadRoleCocok = false;
            if (resultlist.length == 0) {
              noDataCocok = true;
            } else {
              noDataCocok = false;
            }
            listCocok.addAll(resultlist);
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void getapiterdekat() {
    setState(() {
      isLoadTerdekat = true;
    });
    ApiGamerTerdekat.apigamersterdekat().then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k status 200');
        listTerdekat.clear();
        var resultlist = resultdt['result'];
        if (mounted) {
          setState(() {
            isLoadTerdekat = false;
            if (resultlist.length == 0) {
              noDataTerdekat = true;
            } else {
              noDataTerdekat = false;
            }
            listTerdekat.addAll(resultlist);
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void getapiladies() {
    setState(() {
      isLoadLadies = true;
    });
    ApiLadiesGamers.apiladiesgamers().then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        listLadies.clear();
        var resultlist = resultdt['result'];
        // print("DATA LADIES HARUSNYA");
        // print(resultdt);
        if (mounted) {
          setState(() {
            isLoadLadies = false;
            if (resultlist.length == 0) {
              noDataLadies = true;
            } else {
              noDataLadies = false;
            }
            listLadies.addAll(resultlist);
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void getplayerinfo() {
    listLadies.clear();
    var usernameparse = '';
    ApiServiceDetailuser.apidetailuser(usernameparse).then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        // print('masuk k satstus 200');
        var resultlist = resultdt['result'];

        if (mounted) {
          setState(() {
            var citydt = resultlist['city'] ?? '3173';
            namaKotaForSeach = resultlist['cityName'] ?? 'Jakarta';
            namaProvinsiForSeach = resultlist['province_name'] ?? 'Jakarta';
            print('lihat cityName $citydt $namaKotaForSeach $namaProvinsiForSeach');

            setKotaForSearch(citydt.toString(), namaKotaForSeach.toString(), namaProvinsiForSeach.toString())
              .then((val) {
              // Navigator.pop(context);
              getapipopular();
              getapisamerole();
              getapirolecocok();
              getapiterdekat();
              getapiladies();
            });
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void getapilistgame() {
    listGameConnect.clear();
    var usernameparse = '';
    ApiServiceListGame.apilistgame().then((result) async {
      var resultdt = json.decode(result);
      final messages = resultdt['messages'];
      final status = resultdt['status'];
      if (status == true) {
        // print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        // print('lihat body api game length, ${resultlist.length}');
        if (mounted) {
          setState(() {
            List listGameConnectdt = [];
            // listGameConnectdt.clear();
            listGameConnectdt.addAll(resultlist);
            listGameConnect.clear();
            //
            for (var i = 0; i < listGameConnectdt.length; i++) {
              if (listGameConnectdt[i]['is_connected'] == 1) {
                listGameConnect.add(
                  {
                    "id": listGameConnectdt[i]['id'],
                    "name": listGameConnectdt[i]['name'],
                    "url": listGameConnectdt[i]['url'],
                    "avatar_url": listGameConnectdt[i]['avatar_url'],
                    "cover_url": listGameConnectdt[i]['cover_url'],
                    "cover_url_off": listGameConnectdt[i]['cover_url_off'],
                    "cover_url_3_4": listGameConnectdt[i]['cover_url_3_4'],
                    "is_connected": listGameConnectdt[i]['is_connected'],
                    "in_game_id": listGameConnectdt[i]['in_game_id'],
                    "is_steam_game": listGameConnectdt[i]['is_steam_game'],
                    "is_mobile_legend": listGameConnectdt[i]
                        ['is_mobile_legend'],
                    "is_joined_tournament": listGameConnectdt[i]
                        ['is_joined_tournament'],
                    "is_joined_challenge": listGameConnectdt[i]
                        ['is_joined_challenge'],
                    "nickname": listGameConnectdt[i]['nickname'],
                    "avatar_banner_mobile": listGameConnectdt[i]
                        ['avatar_banner_mobile'],
                    "banner_game_connect_mobile": listGameConnectdt[i]
                        ['banner_game_connect_mobile'],
                    "has_pick_role" : listGameConnectdt[i]['has_pick_role'] ?? 0
                  },
                );
              }
            }

            listGameConnect.add(
              {
                "id": 999,
                "name": 'name-null',
                "url": '',
                "avatar_url": '',
                "cover_url": '',
                "cover_url_off": '',
                "cover_url_3_4": '',
                "is_connected": 999,
                "in_game_id": '',
                "is_steam_game": '',
                "is_mobile_legend": '',
                "is_joined_tournament": '',
                "is_joined_challenge": '',
                "nickname": '',
                "avatar_banner_mobile": '',
                "banner_game_connect_mobile": 'null'
              },
            );
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void _showModalSheet(id, String nama, String images) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0)),
              color: backgroundPrimary,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    // onDoubleTap: _modaltap,
                    // onTapUp: _modaltap,
                    // onTap: ,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 5.0,
                          width: 40.0,
                          decoration: new BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            color: Color(0xFF707070),
                          ),
                        ),
                        Container(
                          height: 2.0,
                        ),
                        Container(
                          height: 5.0,
                          width: 40.0,
                          decoration: new BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            color: Color(0xFF707070),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                new Hero(
                  tag: id,
                  // child: new InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Container(
                      color: Color(0xFF151a1d),
                      height: 100.0,
                      width: 100.0,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          child: Container(
                              color: Color(0xFF151a1d),
                              child: new Image.network(
                                images ??
                                    'https://yamisok.com/assets/images/default/default.png',
                                fit: BoxFit.fitHeight,
                              ))),
                    ),
                  ),
                  // ),
                ),
                Text(
                  nama,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ],
            ),
            padding: EdgeInsets.only(bottom: 30.0, top: 10.0),
          );
        });
  }

  void getusername() async {
    username = "";
    avataruser = "";
    final usernameget = await keyStore.getUsername();
    final avataruserdt = await keyStore.getAvatar();
    avataruser = avataruserdt;
    username = usernameget;
  }

  void kotaforSearch() async {
    var namakota = await keyStore.getNameKotaForSearch();
    // print('liat namakota $namakota');
    setState(() {
      if (namakota != null) {
        namaKotaForSeach = namakota;
        getapipopular();
        getapisamerole();
        getapirolecocok();
        getapiterdekat();
        getapiladies();
        getapilistgame();
      } else {
        getplayerinfo();
        getapipopular();
        getapisamerole();
        getapirolecocok();
        getapiterdekat();
        getapiladies();
        getapilistgame();
      }
    });
  }

  void initdata() {
    setState(() {
      listData = [];
      listDataProfileDetail = [];
      listDataDetail = [];
      listAchievement = [];
      listGammers = [];
      listSameRole = [];
      noDataSameRole = false;
      listPopular = [];
      noDataPopular = false;
      listCocok = [];
      noDataCocok = false;
      listTerdekat = [];
      noDataTerdekat = false;
      listLadies = [];
      noDataLadies = false;
    });
  }

  void getidusers() async{
    var idplayers = await keyStore.getPlayerId();
    print('set id player to firebase $idplayers');
      setState(() {
        analytics.setUserId('$idplayers');
      });
  }

  onlineusers(idusers) {

  }

  @override
  void initState() {
    
     
     SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    var _firebaseRef = database.reference().child('onlinestat/players/online');
    totalOnline = '-';
    _firebaseRef.keepSynced(true);

    _counterSubscription = _firebaseRef.onValue.listen((Event event) {
      // error = null;
      _counterOnline = event.snapshot.value ?? '0';
        if (mounted) {
          totalOnline = '${_counterOnline.length}';
        }


      // print('----- > lihat total data online ${_counterOnline.length}');
    }, onError: (Object o) {
      print('----- > lihat total data online  error $o');
    });

    
    
    kotaforSearch();
    initdata();
    setapistatusonline();


    //firebase analityc
    // analytics.setCurrentScreen(screenName: "/page_home");
    analytics.logEvent(name: 'Home');
    getidusers();
    
    // apiDetail();
    // getusername();
    // apiAchive();
    // apiUpcoming();

    // store.dispatch(apigetlocation);
 
    // storeapp.dispatch(apipopular);

    
    super.initState();
  }

  @override
  void dispose() {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    // listDataMembers.clear();
    // _scrollController.dispose();
    _onTodoChangedSubscription.cancel();

    super.dispose();
  }

  onEntryChanged(Event event) {
    // var oldEntry = _todoList.singleWhere((entry) {
    //   return entry.key == event.snapshot.key;
    // });
    var data = event.snapshot;
    print('lihat data $data');
    // setState(() {
    //   _todoList[_todoList.indexOf(oldEntry)] =
    //       Todo.fromSnapshot(event.snapshot);
    // });
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;

    // var size = MediaQuery.of(context).size;
    void _onRefresh() async {
      Timer _timer;
      _timer = new Timer(const Duration(milliseconds: 10000), () {
        if (mounted) {
          setState(() {
            _scrollController.refreshCompleted();
          });
        }
      });
      kotaforSearch();
      initdata();

      print('on refresh');
    }

    void _onLoading() {
      print('on load');
      Timer _timer;
      _timer = new Timer(const Duration(milliseconds: 20000), () {
        if (mounted) {
          setState(() {
            _scrollController.loadComplete();
          });
        }
      });
    }

    Widget _lokasisaatini() {
      return Container(
        height: mediaquery.width / 6,
        child: GestureDetector(
          onTap: () async {
             analytics.logEvent(name: 'Filter_lokasi_dashboard');

            String result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PageFilterLokasi()),
            );
            setState(() {
              if (result == 'succes') {
                kotaforSearch();
              } else {

              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Lokasi anda saat ini",
                        style: TextStyle(
                            fontSize: mediaquery.width / textSize16sp,
                            color: textColor1,
                            fontFamily: 'ProximaRegular')),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Row(children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.room,
                              size: mediaquery.width / textSize16sp,
                              color: Colors.red,
                            ),
                          ),
                          Text(namaKotaForSeach,
                              style: TextStyle(
                                  fontSize: mediaquery.width / textSize16sp,
                                  color: textColor1,
                                  fontFamily: 'ProximaBold')),
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.expand_more,
                              size: mediaquery.width / textSize18sp,
                              color: textColor2,
                            ),
                          )
                        ]),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchFriend()),
                    );
                  },
                  child: Icon(
                    Icons.search,
                    color: textColor2,
                    size: mediaquery.width / textSize20sp,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget _onlineUser() {
      return Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        padding: EdgeInsets.only(left: 15, right: 15),
        height: mediaquery.width / 6.5,
        decoration: BoxDecoration(
            // border: Border.all(
            //   color: Color(0xFF34424e),
            //   width: 1,
            // ),
            borderRadius: BorderRadius.all(
                Radius.circular(5.0) //         <--- border radius here
                ),
            // gradient: LinearGradient(
            //   colors: [backgroundPrimary, backgroundPrimary],
            //   begin: Alignment(-1.0, -2.0),
            //   end: Alignment(1.0, 2.0),
            // ),
            color: backgroundYellow),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Online users",
                style: TextStyle(
                    fontSize: mediaquery.width / textSize16sp,
                    color: Colors.black,
                    fontFamily: 'ProximaBold')),
            Text(totalOnline == '' ? '-' : totalOnline,
                style: TextStyle(
                    fontSize: mediaquery.width / textSize20sp,
                    color: Colors.black,
                    fontFamily: 'ProximaBold')),
          ],
        ),
      );
    }

    Widget _titleHome(){
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Row(
          children: <Widget>[
            Text(
              "Cari Temen",
              style: TextStyle(
                  fontSize: mediaquery.width / textSize20sp,
                  color: Colors.white,
                  fontFamily: 'ProximaBold'),
            ),
          ],
        ),
      );
    }

    Widget _subtitleHome(){
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Row(
          children: <Widget>[
            Text(
              "Main Bareng Disini!",
              style: TextStyle(
                  fontSize: mediaquery.width / textSize20sp,
                  color: Colors.white,
                  fontFamily: 'ProximaBold'),
            ),
          ],
        ),
      );
    }

    Widget _onlineUserNew() {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              totalOnline + " Gamers online",
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: textColor2,
                  fontFamily: 'ProximaRegular'),
            ),
          ],
        ),
      );
    }

    Widget _labelupcoming(text) {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: textColor2,
                  fontFamily: 'ProximaRegular'),
            ),
          ],
        ),
      );
    }

    Widget _labelmygame(text) {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: textColor2,
                  fontFamily: 'ProximaRegular'),
            ),
          ],
        ),
      );
    }

    var dataMenuGame = Container(
        child: GridView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: listGameConnect.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: mediaquery.width / 2.5,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              childAspectRatio: 1.50,
            ),
            itemBuilder: (BuildContext context, int index) {
              final _avatarUrl = listGameConnect[index]
                      ['banner_game_connect_mobile'] ??
                  'https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/26d2ad5b-0170-48af-8186-7fef4fa3f606.png';

              final isConnected = listGameConnect[index]['is_connected'];
              var gameid = listGameConnect[index]['id'] ?? '';
              var gamename = listGameConnect[index]['name'] ?? '';
              var isRoleConnect = listGameConnect[index]['has_pick_role'].toString() =='null' ? '0' : listGameConnect[index]['has_pick_role'].toString();
              var statusGameOcr = listGameConnect[index]['is_mobile_legend'];
              var statusGameSteam = listGameConnect[index]['is_steam_game'];
              // bool statusGameOthers = listGameConnect[index]['is_other_game'] ?? false;
              var gameName= listGameConnect[index]['name'].toString();
              var nickName= listGameConnect[index]['nickname'];
              var inGameId= listGameConnect[index]['in_game_id'].toString();
              var idGameGrup = listGameConnect[index]['id'];


              if (isConnected == 0) {
                return Container();
              } else if (isConnected == 999) {
                return Container(
                  width: mediaquery.width / 3.5,
                  child: InkWell(
                    onTap: () async {
                      analytics.logEvent(name: 'Tambah_game');
                      String result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ConnectGame(rotefrom: 'profile')),
                      );
                      setState(() {
                        if (result == 'succes') {
                          getapilistgame();

                          // print('-->Profile return trus');
                        } else {
                          // print('-->Profile return false');
                        }
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          width: mediaquery.width / 3.5,
                          child: Image.asset(
                            'assets/images/home/addgame.png',
                            frameBuilder: (BuildContext context, Widget child,
                                int frame, bool wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded) {
                                return child;
                              }
                              return AnimatedOpacity(
                                child: child,
                                opacity: frame == null ? 0 : 1,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeOut,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  width: mediaquery.width / 3.5,
                  child: InkWell(
                    onTap: ()async {
                      
                      if(isRoleConnect=='0'){
                      analytics.logEvent(name: 'Validasi_belum_ada_role');

                        if(statusGameSteam==1){
                            String result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=>
                                GameSteamPage(
                                  idgame:idGameGrup,
                                  ingameid:inGameId,
                                  isjointour:false,
                                  nicname:nickName,
                                  name:gameName
                                  )
                              ),
                            );
                            setState((){
                              if(result=='succes'){
                                  var dataparse= [
                                    {
                                      "id": listGameConnect[index]['id'],
                                      "name": listGameConnect[index]['name'],
                                      "url": listGameConnect[index]['url'],
                                      "avatar_url": listGameConnect[index]['avatar_url'],
                                      "cover_url": listGameConnect[index]['cover_url'],
                                      "cover_url_off": listGameConnect[index]['cover_url_off'],
                                      "cover_url_3_4": listGameConnect[index]['cover_url_3_4'],
                                      "is_connected": listGameConnect[index]['is_connected'],
                                      "in_game_id": listGameConnect[index]['in_game_id'],
                                      "is_steam_game": listGameConnect[index]['is_steam_game'],
                                      "is_mobile_legend": listGameConnect[index]
                                          ['is_mobile_legend'],
                                      "is_joined_tournament": listGameConnect[index]
                                          ['is_joined_tournament'],
                                      "is_joined_challenge": listGameConnect[index]
                                          ['is_joined_challenge'],
                                      "nickname": listGameConnect[index]['nickname'],
                                      "avatar_banner_mobile": listGameConnect[index]
                                          ['avatar_banner_mobile'],
                                      "banner_game_connect_mobile": listGameConnect[index]
                                          ['banner_game_connect_mobile'],
                                      "has_pick_role" : 1
                                    }
                                    ];
                                    setState(() {
                                        listGameConnect.replaceRange(index, index+1, dataparse);
                                    });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FindFriend(idGame: gameid, nameGame: gamename)),
                                  );
                              }else{
                              }
                            });
                        }else if(statusGameOcr==1){
                            String result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=>
                                GameOcrPage(
                                  idgame:idGameGrup,
                                  ingameid:inGameId,
                                  isjointour:false,
                                  nicname:nickName,
                                  name:gameName
                                )
                              ),
                            );
                            setState((){
                              if(result=='succes'){
                                var dataparse= [
                                    {
                                      "id": listGameConnect[index]['id'],
                                      "name": listGameConnect[index]['name'],
                                      "url": listGameConnect[index]['url'],
                                      "avatar_url": listGameConnect[index]['avatar_url'],
                                      "cover_url": listGameConnect[index]['cover_url'],
                                      "cover_url_off": listGameConnect[index]['cover_url_off'],
                                      "cover_url_3_4": listGameConnect[index]['cover_url_3_4'],
                                      "is_connected": listGameConnect[index]['is_connected'],
                                      "in_game_id": listGameConnect[index]['in_game_id'],
                                      "is_steam_game": listGameConnect[index]['is_steam_game'],
                                      "is_mobile_legend": listGameConnect[index]
                                          ['is_mobile_legend'],
                                      "is_joined_tournament": listGameConnect[index]
                                          ['is_joined_tournament'],
                                      "is_joined_challenge": listGameConnect[index]
                                          ['is_joined_challenge'],
                                      "nickname": listGameConnect[index]['nickname'],
                                      "avatar_banner_mobile": listGameConnect[index]
                                          ['avatar_banner_mobile'],
                                      "banner_game_connect_mobile": listGameConnect[index]
                                          ['banner_game_connect_mobile'],
                                      "has_pick_role" : 1
                                    }
                                    ];
                                    setState(() {
                                        listGameConnect.replaceRange(index, index+1, dataparse);
                                    });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FindFriend(idGame: gameid, nameGame: gamename)),
                                  );
                              }else{
                              }
                            });
                        }else{
                          String result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=>
                                GameManualPage(
                                  idgame:idGameGrup,
                                  ingameid:inGameId,
                                  isjointour:false,
                                  nicname:nickName,
                                  name:gameName
                                  )
                              ),
                            );
                            setState((){
                              if(result=='succes'){
                                var dataparse= [
                                    {
                                      "id": listGameConnect[index]['id'],
                                      "name": listGameConnect[index]['name'],
                                      "url": listGameConnect[index]['url'],
                                      "avatar_url": listGameConnect[index]['avatar_url'],
                                      "cover_url": listGameConnect[index]['cover_url'],
                                      "cover_url_off": listGameConnect[index]['cover_url_off'],
                                      "cover_url_3_4": listGameConnect[index]['cover_url_3_4'],
                                      "is_connected": listGameConnect[index]['is_connected'],
                                      "in_game_id": listGameConnect[index]['in_game_id'],
                                      "is_steam_game": listGameConnect[index]['is_steam_game'],
                                      "is_mobile_legend": listGameConnect[index]
                                          ['is_mobile_legend'],
                                      "is_joined_tournament": listGameConnect[index]
                                          ['is_joined_tournament'],
                                      "is_joined_challenge": listGameConnect[index]
                                          ['is_joined_challenge'],
                                      "nickname": listGameConnect[index]['nickname'],
                                      "avatar_banner_mobile": listGameConnect[index]
                                          ['avatar_banner_mobile'],
                                      "banner_game_connect_mobile": listGameConnect[index]
                                          ['banner_game_connect_mobile'],
                                      "has_pick_role" : 1
                                    }
                                    ];
                                    setState(() {
                                        listGameConnect.replaceRange(index, index+1, dataparse);
                                    });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FindFriend(idGame: gameid, nameGame: gamename)),
                                  );
                              }else{
                              }
                            });

                        }
                      }else{
                      analytics.logEvent(name: 'Cari_temen');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FindFriend(idGame: gameid, nameGame: gamename)),
                      );
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                            width: mediaquery.width / 3.5,
                            child: Image.network(
                              _avatarUrl,
                              frameBuilder: (BuildContext context, Widget child,
                                  int frame, bool wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) {
                                  return child;
                                }
                                return AnimatedOpacity(
                                  child: child,
                                  opacity: frame == null ? 0 : 1,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOut,
                                );
                              },
                            ))
                      ],
                    ),
                  ),
                );
              }
            }));

    var shimmerMenuGame = Container(
        // padding: const EdgeInsets.only(left: 10.0),
        child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Shimmer.fromColors(
                    baseColor: colorShimer,
                    // highlightColor: Colors.grey[300],
                    // baseColor: Colors.grey[100],
                    highlightColor: colorlightShimer,
                    // direction: ,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: colorShimer,
                      ),
                      margin: EdgeInsets.only(right: mediaquery.width / 30),
                      width: mediaquery.width / 3.5,
                      height: mediaquery.width / 5.5,
                    )),
                Shimmer.fromColors(
                    baseColor: colorShimer,
                    // highlightColor: Colors.grey[300],
                    // baseColor: Colors.grey[100],
                    highlightColor: colorlightShimer,
                    // direction: ,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: colorShimer,
                      ),
                      // margin: EdgeInsets.only(left: 10, right: 10),
                      width: mediaquery.width / 3.5,
                      height: mediaquery.width / 5.5,
                    )),
                Shimmer.fromColors(
                    baseColor: colorShimer,
                    // highlightColor: Colors.grey[300],
                    // baseColor: Colors.grey[100],
                    highlightColor: colorlightShimer,
                    // direction: ,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: colorShimer,
                      ),
                      margin: EdgeInsets.only(left: mediaquery.width / 30),
                      width: mediaquery.width / 3.5,
                      height: mediaquery.width / 5.5,
                    )),
              ],
            ),
          ),
          SizedBox(
            height: mediaquery.width / 30,
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Shimmer.fromColors(
                    baseColor: colorShimer,
                    // highlightColor: Colors.grey[300],
                    // baseColor: Colors.grey[100],
                    highlightColor: colorlightShimer,
                    // direction: ,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: colorShimer,
                      ),
                      margin: EdgeInsets.only(right: mediaquery.width / 30),
                      width: mediaquery.width / 3.5,
                      height: mediaquery.width / 5.5,
                    )),
                Shimmer.fromColors(
                    baseColor: colorShimer,
                    // highlightColor: Colors.grey[300],
                    // baseColor: Colors.grey[100],
                    highlightColor: colorlightShimer,
                    // direction: ,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: colorShimer,
                      ),
                      // margin: EdgeInsets.only(left: 10, right: 10),
                      width: mediaquery.width / 3.5,
                      height: mediaquery.width / 5.5,
                    )),
                Shimmer.fromColors(
                    baseColor: colorShimer,
                    // highlightColor: Colors.grey[300],
                    // baseColor: Colors.grey[100],
                    highlightColor: colorlightShimer,
                    // direction: ,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: colorShimer,
                      ),
                      margin: EdgeInsets.only(left: mediaquery.width / 30),
                      width: mediaquery.width / 3.5,
                      height: mediaquery.width / 5.5,
                    )),
              ],
            ),
          ),
        ],
      ),
    ));

    Widget _menugame() {
      if (listGameConnect.length != 0) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: dataMenuGame,
        );
      } else {
        return shimmerMenuGame;
      }
    }

    Widget _labelpopulergame(text) {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: backgroundYellow,
                  fontFamily: 'ProximaBold'),
            ),
          ],
        ),
      );
    }

    // Widget badgeFeatured(featuredStatus) {
    //   if (featuredStatus == "1") {
    //     return Container(
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //           borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(10.0),
    //             bottomRight: Radius.circular(10.0),
    //           ),
    //           color: Colors.orange),
    //       width: mediaquery.width / 4.5,
    //       padding: EdgeInsets.only(
    //           top: mediaquery.width / 60, bottom: mediaquery.width / 60),
    //       child: Text(
    //         "Featured",
    //         style: TextStyle(
    //             fontSize: mediaquery.width / textSize14sp,
    //             fontWeight: FontWeight.bold),
    //       ),
    //     );
    //   } else {
    //     return Container();
    //   }
    // }

    Widget badgeFeatured(featuredStatus) {
      if (featuredStatus == "1") {
        return Container(
          alignment: Alignment.topRight,
          width: mediaquery.width / 1.7,
          child: Container(
            padding: EdgeInsets.only(right: mediaquery.width / 20),
            child: new Image.asset(
              "assets/images/home/featured.png",
              width: mediaquery.width / 10,
            ),
          ),
        );
      } else {
        return Container();
      }
    }

    var dataGamers = Align(
        alignment: Alignment.centerLeft,
        child: Container(
            height: mediaquery.width / 1.6,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: listPopular.length,
              itemBuilder: (context, index) {
                final id = listPopular[index]['id'].toString() ?? '';

                final username =
                    listPopular[index]['username'].toString() ?? '';
                final gameList =
                    listPopular[index]['game_list'].toString() ?? '';
                final gender = listPopular[index]['gender'].toString() ?? '';
                final cityName =
                    listPopular[index]['city_name'].toString() ?? '';
                final mutualFollowing =
                    listPopular[index]['mutual_following'].toString() ?? '';
                final onlineStatus =
                    _counterOnline[id].toString() != 'null' ? '1' : '0';
                String idhero = 'popular$id';
                final featuredStatus =
                    listPopular[index]['featured'].toString();

                // print('lihat online status popular $onlineStatus');

                final avatarUrl = listPopular[index]['avatar_url'].toString() ??
                    'https://yamisok.com/img/default.png';
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new InkWell(
                    onTap: (){
                      if(featuredStatus=='1'){
                        analytics.logEvent(name: 'Gamers_populer_featured');
                      }
                      analytics.logEvent(name: 'Gamers_populer');
                      Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => ProfileOthers(
                            id: id,
                            username: username,
                            images: avatarUrl,
                            idhero: idhero),
                      ));
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: mediaquery.width / 1.7,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.only(
                                //     topLeft: Radius.circular(10.0),
                                //     topRight: Radius.circular(10.0),
                                //   ),
                                //   color: backgroundBlackDefault,
                                // ),
                                height: mediaquery.width / 2.6,
                                width: mediaquery.width / 1.7,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        child: Center(
                                          child: new Image.asset(
                                            "assets/images/smiley.png",
                                            height: mediaquery.width / 25,
                                          ),
                                        ),
                                        color: Color(0xFF22272b),
                                      ),
                                      Positioned(
                                        child: Center(child: Hero(
                                          tag: idhero,
                                          child: Container(
                                            child: new Image.network(
                                              avatarUrl,
                                              fit: BoxFit.cover,
                                              width: mediaquery.width / 1.7
                                            ),
                                          ),
                                        ))
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              badgeFeatured(featuredStatus),
                              Container(
                                height: mediaquery.width / 2.6,
                                width: mediaquery.width / 1.7,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.0),
                                          Colors.black.withOpacity(0.9),
                                        ],
                                      ),
                                    ),
                                    height: mediaquery.width / 8,
                                    width: mediaquery.width / 1.7,
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(username,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: mediaquery.width /
                                                      textSize16sp,
                                                  color: Colors.white,
                                                  fontFamily: 'ProximaBold')),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(right: 5),
                                              height: mediaquery.width / 25,
                                              width: mediaquery.width / 25,
                                              child: Image.asset(gender == 'P'
                                                  ? 'assets/images/home/male.png'
                                                  : gender == '1'
                                                      ? 'assets/images/home/male.png'
                                                      : 'assets/images/home/female.png'),
                                            ),
                                            Container(
                                              height: mediaquery.width / 22,
                                              width: mediaquery.width / 2,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(cityName,
                                                    style: TextStyle(
                                                        fontSize:
                                                            mediaquery.width /
                                                                textSize14sp,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'ProximaRegular')),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: mediaquery.width / 1.7,
                          height: mediaquery.width / 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    10.0), //         <--- border radius here
                                bottomRight: Radius.circular(
                                    10.0) //         <--- border radius here

                                ),
                            color: backgroundSecond,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(gameList,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: mediaquery.width /
                                                  textSize14sp,
                                              color: textColor1,
                                              fontFamily: 'ProximaRegular')),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Text(mutualFollowing ?? '',
                                                    style: TextStyle(
                                                        fontSize:
                                                            mediaquery.width /
                                                                textSize14sp,
                                                        color: textColor2,
                                                        fontFamily:
                                                            'ProximaBold')),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text("friends",
                                                      style: TextStyle(
                                                          fontSize:
                                                              mediaquery.width /
                                                                  textSize14sp,
                                                          color: textColor2,
                                                          fontFamily:
                                                              'ProximaRegular')),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: mediaquery.width / 30,
                                            width: mediaquery.width / 30,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xFF34424e),
                                                  width: 1,
                                                ),
                                                color: onlineStatus == '0'
                                                    ? Colors.grey
                                                    : onlineStatus == 'null'
                                                        ? Colors.grey
                                                        : Colors.green,
                                                shape: BoxShape.circle),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )));

    var shimmerGamers = Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.29,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.28,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.28,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
            ],
          ),
        ));

    Widget _gamerspopuler() {
      if (listPopular.length != 0) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: dataGamers,
        );
      } else {
        return shimmerGamers;
      }

      // }
    }

    Widget _labelterdekat(text) {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: backgroundYellow,
                  fontFamily: 'ProximaBold'),
            ),
            // Text(
            //   '_errorname',
            //   style: TextStyle(
            //     fontSize: mediaquery.width/textSize14sp,
            //     color: Colors.red,
            //     fontFamily: 'ProximaRegular'
            //   ),
            // ),
          ],
        ),
      );
    }

    var dataTerdekat = Align(
        alignment: Alignment.centerLeft,
        child: Container(
            height: mediaquery.width / 1.6,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: listTerdekat.length,
              itemBuilder: (context, index) {
                // final id = listGammers[index]['player_username'];
                final id = listTerdekat[index]['id'].toString() ?? '';

                final username =
                    listTerdekat[index]['username'].toString() ?? '';
                final gameList =
                    listTerdekat[index]['game_list'].toString() ?? '';
                final gender = listTerdekat[index]['gender'].toString() ?? '';
                final cityName =
                    listTerdekat[index]['city_name'].toString() ?? '';

                // final description = listGammers[index]['description'];
                final avatarUrl =
                    listTerdekat[index]['avatar_url'].toString() ??
                        'https://yamisok.com/img/default.png';
                final mutualFollowing =
                    listTerdekat[index]['mutual_following'].toString() ?? '';
                final onlineStatus =
                    _counterOnline[id].toString() != 'null' ? '1' : '0';

                bool statusonline = false;
                // var _userOnline='0';

                // var _firebaseRefUser = database.reference().child('onlinestat/players/online/$id');

                // _counterSubscription = _firebaseRefUser.onChildAdded.listen((Event event) {
                //   // error = null;
                //  _userOnline = event.snapshot.value ?? '0';
                //   // Map data = event.snapshot.value ?? '0';

                //     //  if(_userOnline==0){
                //     //    setState(() {
                //     //      statusonline=true;
                //     //    });
                //     //  }else{
                //     //    setState(() {
                //     //      statusonline=false;
                //     //    });
                //     //  }
                //     // setState(() {
                //          statusonline=true;
                //     //    });
                //  print('----- > lihat total data online $username  $_userOnline');
                // }, onError: (Object o) {

                //   print('----- > lihat total data online  error $o');
                //   statusonline=false;
                // });

                String idhero = 'terdekat$id';

                // print('lihat gender didekat $gender');
                // final title = "blabla";
                // final description = "bla bla";
                // final avatarUrlnew = "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/a161727e-91f5-4896-b41b-4d9f1853950a.png";
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new InkWell(
                    onTap: () {
                      analytics.logEvent(name: 'Gamers_terdekat');
                      Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => ProfileOthers(
                          id: id,
                          username: username,
                          images: avatarUrl,
                          idhero: idhero),
                      ));
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: mediaquery.width / 2.6,
                                width: mediaquery.width / 2.6,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        child: Center(
                                          child: new Image.asset(
                                            "assets/images/smiley.png",
                                            height: mediaquery.width / 25,
                                          ),
                                        ),
                                        color: Color(0xFF22272b),
                                      ),
                                      Positioned(
                                        child: Center(child: Hero(
                                          tag: idhero,
                                          child: Container(
                                            child: new Image.network(
                                              avatarUrl,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ))
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: mediaquery.width / 2.6,
                                width: mediaquery.width / 2.6,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.0),
                                          Colors.black.withOpacity(0.9),
                                        ],
                                      ),
                                    ),
                                    height: mediaquery.width / 8,
                                    width: mediaquery.width / 2.6,
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(username,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: mediaquery.width /
                                                      textSize16sp,
                                                  color: Colors.white,
                                                  fontFamily: 'ProximaBold')),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(right: 5),
                                              height: mediaquery.width / 25,
                                              width: mediaquery.width / 25,
                                              child: Image.asset(gender == 'P'
                                                  ? 'assets/images/home/male.png'
                                                  : gender == '1'
                                                      ? 'assets/images/home/male.png'
                                                      : 'assets/images/home/female.png'),
                                            ),
                                            Container(
                                              height: mediaquery.width / 22,
                                              width: mediaquery.width / 3.4,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(cityName,
                                                    style: TextStyle(
                                                        fontSize:
                                                            mediaquery.width /
                                                                textSize14sp,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'ProximaRegular')),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: mediaquery.width / 2.6,
                          height: mediaquery.width / 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    10.0), //         <--- border radius here
                                bottomRight: Radius.circular(
                                    10.0) //         <--- border radius here

                                ),
                            color: backgroundSecond,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(gameList,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: mediaquery.width /
                                                  textSize14sp,
                                              color: textColor1,
                                              fontFamily: 'ProximaRegular')),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Text(mutualFollowing ?? '',
                                                    style: TextStyle(
                                                        fontSize:
                                                            mediaquery.width /
                                                                textSize14sp,
                                                        color: textColor2,
                                                        fontFamily:
                                                            'ProximaBold')),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text("friends",
                                                      style: TextStyle(
                                                          fontSize:
                                                              mediaquery.width /
                                                                  textSize14sp,
                                                          color: textColor2,
                                                          fontFamily:
                                                              'ProximaRegular')),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: mediaquery.width / 30,
                                            width: mediaquery.width / 30,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xFF34424e),
                                                  width: 1,
                                                ),
                                                color: onlineStatus == '0'
                                                    ? Colors.grey
                                                    : onlineStatus == 'null'
                                                        ? Colors.grey
                                                        : Colors.green,
                                                shape: BoxShape.circle),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )));

    var shimmerTerdekat = Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.29,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.28,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.28,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
            ],
          ),
        ));

    Widget _terdekat() {
      if (isLoadTerdekat == true) {
        return shimmerTerdekat;
      } else {
        if (listTerdekat.length != 0) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: dataTerdekat,
          );
        } else {
          return Container(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
            height: (mediaquery.width / 20) + (mediaquery.width / 3),
            width: (mediaquery.width / 2.28) * 2,
            decoration: new BoxDecoration(
              color: backgroundSecond,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Tidak ada gamers Yamisok',
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: mediaquery.width / textSize16sp,
                          color: textColor1,
                          fontFamily: 'ProximaRegular')),
                  Text('di daerah kamu',
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: mediaquery.width / textSize16sp,
                          color: textColor1,
                          fontFamily: 'ProximaRegular'))
                ],
              ),
            ),
          );
        }
      }
    }

    var dataRolesama = Align(
        alignment: Alignment.centerLeft,
        child: Container(
            height: mediaquery.width / 1.6,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: listSameRole.length,
              itemBuilder: (context, index) {
                // final id = listGammers[index]['player_username'];
                final id = listSameRole[index]['id'].toString() ?? '';

                final username =
                    listSameRole[index]['username'].toString() ?? '';
                final gameList =
                    listSameRole[index]['game_list'].toString() ?? '';
                final gender = listSameRole[index]['gender'].toString() ?? '';
                final cityName =
                    listSameRole[index]['city_name'].toString() ?? '';

                // final description = listGammers[index]['description'];
                final avatarUrl =
                    listSameRole[index]['avatar_url'].toString() ??
                        'https://yamisok.com/img/default.png';
                final mutualFollowing =
                    listSameRole[index]['mutual_following'].toString() ?? '';
                final onlineStatus =
                    _counterOnline[id].toString() != 'null' ? '1' : '0';

                String idhero = 'rolesama$id';

                // final title = "blabla";
                // final description = "bla bla";
                // final avatarUrlnew = "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/a161727e-91f5-4896-b41b-4d9f1853950a.png";
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new InkWell(
                    onTap: () {
                      analytics.logEvent(name: 'Gamers_Rolesama');
                        Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => ProfileOthers(
                          id: id,
                          username: username,
                          images: avatarUrl,
                          idhero: idhero),
                    ));
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.only(
                                //     topLeft: Radius.circular(10.0),
                                //     topRight: Radius.circular(10.0),
                                //   ),
                                //   color: backgroundBlackDefault,
                                // ),
                                height: mediaquery.width / 2.6,
                                width: mediaquery.width / 2.6,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        child: Center(
                                          child: new Image.asset(
                                            "assets/images/smiley.png",
                                            height: mediaquery.width / 25,
                                          ),
                                        ),
                                        color: Color(0xFF22272b),
                                      ),
                                      Positioned(
                                        child: Center(child: Hero(
                                          tag: idhero,
                                          child: Container(
                                            child: new Image.network(
                                              avatarUrl,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ))
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: mediaquery.width / 2.6,
                                width: mediaquery.width / 2.6,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.0),
                                          Colors.black.withOpacity(0.9),
                                        ],
                                      ),
                                    ),
                                    height: mediaquery.width / 8,
                                    width: mediaquery.width / 2.6,
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(username,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: mediaquery.width /
                                                      textSize16sp,
                                                  color: Colors.white,
                                                  fontFamily: 'ProximaBold')),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(right: 5),
                                              height: mediaquery.width / 25,
                                              width: mediaquery.width / 25,
                                              child: Image.asset(gender == 'P'
                                                  ? 'assets/images/home/male.png'
                                                  : gender == '1'
                                                      ? 'assets/images/home/male.png'
                                                      : 'assets/images/home/female.png'),
                                            ),
                                            Container(
                                              height: mediaquery.width / 22,
                                              width: mediaquery.width / 3.4,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(cityName,
                                                    style: TextStyle(
                                                        fontSize:
                                                            mediaquery.width /
                                                                textSize14sp,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'ProximaRegular')),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: mediaquery.width / 2.6,
                          height: mediaquery.width / 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    10.0), //         <--- border radius here
                                bottomRight: Radius.circular(
                                    10.0) //         <--- border radius here

                                ),
                            color: backgroundSecond,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(gameList,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: mediaquery.width /
                                                  textSize14sp,
                                              color: textColor1,
                                              fontFamily: 'ProximaRegular')),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Text(mutualFollowing ?? '',
                                                    style: TextStyle(
                                                        fontSize:
                                                            mediaquery.width /
                                                                textSize14sp,
                                                        color: textColor2,
                                                        fontFamily:
                                                            'ProximaBold')),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text("friends",
                                                      style: TextStyle(
                                                          fontSize:
                                                              mediaquery.width /
                                                                  textSize14sp,
                                                          color: textColor2,
                                                          fontFamily:
                                                              'ProximaRegular')),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: mediaquery.width / 30,
                                            width: mediaquery.width / 30,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xFF34424e),
                                                  width: 1,
                                                ),
                                                color: onlineStatus == '0'
                                                    ? Colors.grey
                                                    : onlineStatus == 'null'
                                                        ? Colors.grey
                                                        : Colors.green,
                                                shape: BoxShape.circle),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )));

    var shimmerRolesama = Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.29,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.28,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.28,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
            ],
          ),
        ));

    Widget _rolesama() {
      if (isLoadSameGame == true) {
        return shimmerRolesama;
      } else {
        if (listSameRole.length != 0) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: dataRolesama,
          );
        } else {
          return Container(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
            height: (mediaquery.width / 20) + (mediaquery.width / 3),
            width: (mediaquery.width / 2.28) * 2,
            decoration: new BoxDecoration(
              color: backgroundSecond,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Tidak ada gamers Yamisok',
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: mediaquery.width / textSize16sp,
                          color: textColor1,
                          fontFamily: 'ProximaRegular')),
                  Text('yang memainkan game yang sama',
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: mediaquery.width / textSize16sp,
                          color: textColor1,
                          fontFamily: 'ProximaRegular')),
                  Text('dengan kamu',
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: mediaquery.width / textSize16sp,
                          color: textColor1,
                          fontFamily: 'ProximaRegular'))
                ],
              ),
            ),
          );
        }
      }
    }

    var dataRolecocok = Align(
        alignment: Alignment.centerLeft,
        child: Container(
            height: mediaquery.width / 1.6,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: listCocok.length,
              itemBuilder: (context, index) {
                // final id = listGammers[index]['player_username'];
                final id = listCocok[index]['id'].toString() ?? '';

                final username = listCocok[index]['username'].toString() ?? '';
                final gameList = listCocok[index]['game_list'].toString() ?? '';
                final gender = listCocok[index]['gender'].toString() ?? '';
                final cityName = listCocok[index]['city_name'].toString() ?? '';

                // final description = listGammers[index]['description'];
                final avatarUrl = listCocok[index]['avatar_url'].toString() ??
                    'https://yamisok.com/img/default.png';
                final mutualFollowing =
                    listCocok[index]['mutual_following'].toString() ?? '';
                final onlineStatus =
                    _counterOnline[id].toString() != 'null' ? '1' : '0';

                String idhero = 'rolecocok$id';

                // print('lihat gender role cocok $gender');

                // final title = "blabla";
                // final description = "bla bla";
                // final avatarUrlnew = "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/a161727e-91f5-4896-b41b-4d9f1853950a.png";
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new InkWell(
                    onTap: () {
                      analytics.logEvent(name: 'Gamers_Rolecocok');
                        Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => ProfileOthers(
                          id: id,
                          username: username,
                          images: avatarUrl,
                          idhero: idhero),
                    ));
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: mediaquery.width / 2.6,
                                width: mediaquery.width / 2.6,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        child: Center(
                                          child: new Image.asset(
                                            "assets/images/smiley.png",
                                            height: mediaquery.width / 25,
                                          ),
                                        ),
                                        color: Color(0xFF22272b),
                                      ),
                                      Positioned(
                                        child: Center(child: Hero(
                                          tag: idhero,
                                          child: Container(
                                            child: new Image.network(
                                              avatarUrl,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ))
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: mediaquery.width / 2.6,
                                width: mediaquery.width / 2.6,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.0),
                                          Colors.black.withOpacity(0.9),
                                        ],
                                      ),
                                    ),
                                    height: mediaquery.width / 8,
                                    width: mediaquery.width / 2.6,
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(username,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: mediaquery.width /
                                                      textSize16sp,
                                                  color: Colors.white,
                                                  fontFamily: 'ProximaBold')),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(right: 5),
                                              height: mediaquery.width / 25,
                                              width: mediaquery.width / 25,
                                              child: Image.asset(gender == 'P'
                                                  ? 'assets/images/home/male.png'
                                                  : gender == '1'
                                                      ? 'assets/images/home/male.png'
                                                      : 'assets/images/home/female.png'),
                                            ),
                                            Container(
                                              height: mediaquery.width / 22,
                                              width: mediaquery.width / 3.4,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(cityName,
                                                    style: TextStyle(
                                                        fontSize:
                                                            mediaquery.width /
                                                                textSize14sp,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'ProximaRegular')),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: mediaquery.width / 2.6,
                          height: mediaquery.width / 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    10.0), //         <--- border radius here
                                bottomRight: Radius.circular(
                                    10.0) //         <--- border radius here

                                ),
                            color: backgroundSecond,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(gameList,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: mediaquery.width /
                                                  textSize14sp,
                                              color: textColor1,
                                              fontFamily: 'ProximaRegular')),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Text(mutualFollowing ?? '',
                                                    style: TextStyle(
                                                        fontSize:
                                                            mediaquery.width /
                                                                textSize14sp,
                                                        color: textColor2,
                                                        fontFamily:
                                                            'ProximaBold')),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text("friends",
                                                      style: TextStyle(
                                                          fontSize:
                                                              mediaquery.width /
                                                                  textSize14sp,
                                                          color: textColor2,
                                                          fontFamily:
                                                              'ProximaRegular')),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: mediaquery.width / 30,
                                            width: mediaquery.width / 30,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xFF34424e),
                                                  width: 1,
                                                ),
                                                color: onlineStatus == '0'
                                                    ? Colors.grey
                                                    : onlineStatus == 'null'
                                                        ? Colors.grey
                                                        : Colors.green,
                                                shape: BoxShape.circle),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )));

    var shimmerRolecocok = Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.29,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.28,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.28,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
            ],
          ),
        ));

    Widget _rolecocok() {
      if (isLoadRoleCocok == true) {
        return shimmerRolecocok;
      } else {
        if (listCocok.length != 0) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: dataRolecocok,
          );
        } else {
          return Container(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
            height: (mediaquery.width / 20) + (mediaquery.width / 3),
            width: (mediaquery.width / 2.28) * 2,
            decoration: new BoxDecoration(
              color: backgroundSecond,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Tidak ada gamers Yamisok dengan',
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: mediaquery.width / textSize16sp,
                          color: textColor1,
                          fontFamily: 'ProximaRegular')),
                  Text('role yang kamu cari',
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: mediaquery.width / textSize16sp,
                          color: textColor1,
                          fontFamily: 'ProximaRegular'))
                ],
              ),
            ),
          );
        }
      }
    }

    Widget _labelladies(text) {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: backgroundYellow,
                  fontFamily: 'ProximaBold'),
            ),
            // Text(
            //   '_errorname',
            //   style: TextStyle(
            //     fontSize: mediaquery.width/textSize14sp,
            //     color: Colors.red,
            //     fontFamily: 'ProximaRegular'
            //   ),
            // ),
          ],
        ),
      );
    }

    var dataLadies = Align(
        alignment: Alignment.centerLeft,
        child: Container(
            height: mediaquery.width / 1.6,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: listLadies.length,
              itemBuilder: (context, index) {
                // final id = listGammers[index]['player_username'];
                final id = listLadies[index]['id'].toString() ?? '';

                final username = listLadies[index]['username'].toString() ?? '';
                final gameList =
                    listLadies[index]['game_list'].toString() ?? '';
                final gender = listLadies[index]['gender'].toString() ?? '';
                final cityName =
                    listLadies[index]['city_name'].toString() ?? '';
                // final description = listGammers[index]['description'];
                final avatarUrl = listLadies[index]['avatar_url'].toString() ??
                    'https://yamisok.com/img/default.png';
                final mutualFollowing =
                    listLadies[index]['mutual_following'].toString() ?? '';
                final onlineStatus =
                    _counterOnline[id].toString() != 'null' ? '1' : '0';

                String idhero = 'ladies$id';

                // final title = "blabla";
                // final description = "bla bla";
                // final avatarUrlnew = "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/a161727e-91f5-4896-b41b-4d9f1853950a.png";
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new InkWell(
                    onTap: () {
                      analytics.logEvent(name: 'Gamers_Ladies');
                        Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => ProfileOthers(
                          id: id,
                          username: username,
                          images: avatarUrl,
                          idhero: idhero),
                    ));
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  color: backgroundBlackDefault,
                                ),
                                height: mediaquery.width / 2.6,
                                width: mediaquery.width / 2.6,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        child: Center(
                                          child: new Image.asset(
                                            "assets/images/smiley.png",
                                            height: mediaquery.width / 25,
                                          ),
                                        ),
                                        color: Color(0xFF22272b),
                                      ),
                                      Positioned(
                                        child: Center(child: Hero(
                                          tag: idhero,
                                          child: Container(
                                            child: new Image.network(
                                              avatarUrl,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ))
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: mediaquery.width / 2.6,
                                width: mediaquery.width / 2.6,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.0),
                                          Colors.black.withOpacity(0.9),
                                        ],
                                      ),
                                    ),
                                    height: mediaquery.width / 8,
                                    width: mediaquery.width / 2.6,
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(username,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: mediaquery.width /
                                                      textSize16sp,
                                                  color: Colors.white,
                                                  fontFamily: 'ProximaBold')),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(right: 5),
                                              height: mediaquery.width / 25,
                                              width: mediaquery.width / 25,
                                              child: Image.asset(gender == 'P'
                                                  ? 'assets/images/home/male.png'
                                                  : gender == '1'
                                                      ? 'assets/images/home/male.png'
                                                      : 'assets/images/home/female.png'),
                                            ),
                                            Container(
                                              height: mediaquery.width / 22,
                                              width: mediaquery.width / 3.4,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(cityName,
                                                    style: TextStyle(
                                                        fontSize:
                                                            mediaquery.width /
                                                                textSize14sp,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'ProximaRegular')),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: mediaquery.width / 2.6,
                          height: mediaquery.width / 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    10.0), //         <--- border radius here
                                bottomRight: Radius.circular(
                                    10.0) //         <--- border radius here

                                ),
                            color: backgroundSecond,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(gameList,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: mediaquery.width /
                                                  textSize14sp,
                                              color: textColor1,
                                              fontFamily: 'ProximaRegular')),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Text(mutualFollowing ?? '',
                                                    style: TextStyle(
                                                        fontSize:
                                                            mediaquery.width /
                                                                textSize14sp,
                                                        color: textColor2,
                                                        fontFamily:
                                                            'ProximaBold')),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text("friends",
                                                      style: TextStyle(
                                                          fontSize:
                                                              mediaquery.width /
                                                                  textSize14sp,
                                                          color: textColor2,
                                                          fontFamily:
                                                              'ProximaRegular')),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: mediaquery.width / 30,
                                            width: mediaquery.width / 30,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xFF34424e),
                                                  width: 1,
                                                ),
                                                color: onlineStatus == '0'
                                                    ? Colors.grey
                                                    : onlineStatus == 'null'
                                                        ? Colors.grey
                                                        : Colors.green,
                                                shape: BoxShape.circle),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )));

    var shimmerLadies = Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.29,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.28,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                height: (mediaquery.width / 6) + (mediaquery.width / 2.6),
                width: mediaquery.width / 2.28,
                child: Shimmer.fromColors(
                  baseColor: colorShimer,
                  // highlightColor: Colors.grey[300],
                  // baseColor: Colors.grey[100],
                  highlightColor: colorlightShimer,
                  // direction: ,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: backgroundSecond,
                    ),
                    width: mediaquery.width / 2.6,
                    height: mediaquery.width / 1.5,
                  ),
                ),
              ),
            ],
          ),
        ));

    Widget _ladiesgamers() {
      if (isLoadLadies == true) {
        return shimmerLadies;
      } else {
        if (listLadies.length != 0) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: dataLadies,
          );
        } else {
          return Container(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
            height: (mediaquery.width / 20) + (mediaquery.width / 3),
            width: (mediaquery.width / 2.28) * 2,
            decoration: new BoxDecoration(
              color: backgroundSecond,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Tidak ada gamers Yamisok',
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: mediaquery.width / textSize16sp,
                          color: textColor1,
                          fontFamily: 'ProximaRegular')),
                  Text('di daerah kamu',
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: mediaquery.width / textSize16sp,
                          color: textColor1,
                          fontFamily: 'ProximaRegular'))
                ],
              ),
            ),
          );
        }
      }
    }

    Widget _rolebeda() {
      return Container(
        child: Text('dgasjdgjahsgdj'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: _lokasisaatini(),
        actions: <Widget>[],
      ),
      body: Container(
        height: double.infinity,
        color: Color(0xFF1e2326),
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: MaterialClassicHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("pull up load");
              } else if (mode == LoadStatus.loading) {
                body = Container(
                  child: Text(
                    'Load More',
                    style: TextStyle(
                        fontSize: mediaquery.width / textSize18sp,
                        color: backgroundYellow,
                        fontFamily: 'ProximaBold'),
                  ),
                );
              } else if (mode == LoadStatus.failed) {
                body = Text("Load Failed!Click retry!");
              } else {
                body = Container(
                  child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.yellow)),
                );
              }
              // return shimerdt;
              return Container(
                height: 200.0,
                child: Center(child: body),
              );
            },
          ),
          controller: _scrollController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: <Widget>[
                Container(
                  height: mediaquery.width / 2.5,
                  width: double.infinity,
                  child: Image.asset('assets/images/new/backgroundhome_new.png',
                      fit: BoxFit.cover),
                ),
                Column(
                  children: <Widget>[
                    // Container(
                    //   height: MediaQuery.of(context).padding.top,
                    //   color: backgroundPrimary,
                    // ),
                    //  _myusername(),
                    // _lokasisaatini(),

                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    _titleHome(),
                    _subtitleHome(),
                    _onlineUserNew(),
                    // _onlineUser(),

                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    // _labelmygame('Pilih game yang kamu mainkan'),
                    // _showtext(),
                    _menugame(),

                    Container(
                      color: backgroundPrimary,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: UpcomingWidget()
                          ),

                          SizedBox(
                            height: mediaquery.width / 15,
                          ),
                          _labelpopulergame('Gamers terpopuler'),
                          _gamerspopuler(),

                          SizedBox(
                            height: mediaquery.width / 20,
                          ),
                          _labelterdekat('Gamers dekatmu'),
                          _terdekat(),

                          SizedBox(
                            height: mediaquery.width / 20,
                          ),
                          _labelterdekat('Memainkan game yang sama'),
                          _rolesama(),

                          SizedBox(
                            height: mediaquery.width / 20,
                          ),
                          _labelterdekat('Role yang cocok'),
                          _rolecocok(),

                          SizedBox(
                            height: mediaquery.width / 20,
                          ),
                          _labelladies('Ladies gamers'),
                          _ladiesgamers(),
                        ]
                      )
                    )

                    // _rolebeda(),

                    // _sparator("SEPUTAR ESPORTS"),
                    // _esport(),

                    // _profile(),
                    // _profile(),
                    // SizedBox(
                    //   height: paddingwinrate,
                    // ),
                    // _social(),
                    // _sparator("Recent Achievements"),
                    // _achievement(),
                    // _sparator("Upcoming Match"),
                    // _upcomingmatch(),
                    // Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: InkWell(
                    //     onTap: () => _asyncConfirmDialog(context).then((rst) {
                    //       if (rst == ConfirmAction.ACCEPT) logout(context);
                    //     }),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Color(0xFF34424e),
                    //           width: 1,
                    //         ),
                    //         borderRadius: BorderRadius.all(Radius.circular(
                    //                 10.0) //         <--- border radius here
                    //             ),
                    //         gradient: LinearGradient(
                    //           colors: [backgroundPrimary, backgroundPrimary],
                    //           begin: Alignment(-1.0, -2.0),
                    //           end: Alignment(1.0, 2.0),
                    //         ),
                    //       ),
                    //       height: 50.0,
                    //       width: double.infinity,
                    //       child: Center(
                    //           child: Text(
                    //         "Log Out",
                    //         style: TextStyle(
                    //           fontSize: 16.0,
                    //           color: textColor1,
                    //         ),
                    //       )),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
