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
import 'package:yamisok/api/esport/esport_api.dart';
import 'package:yamisok/page/esports/esport_webview.dart';
import 'package:yamisok/page/helper/check_connection.dart';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/redux/action.dart' as AppAction;

import 'package:yamisok/component/keyStore.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:yamisok/component/styleyami.dart';
import 'package:yamisok/page/login/login.dart';
import 'package:yamisok/api/profile/profile_detail_api.dart';
import 'package:yamisok/api/profile/profile_achievement_api.dart';
import 'package:yamisok/api/profile/profile_upcoming_api.dart';
import 'package:yamisok/page/utilities/color.dart' as prefix0;

Client client = Client();
List<String> dogImages = new List();
List listData = [];
List listDataProfileDetail = [];
List listDataDetail = [];
List listAchievement = [];
List listGammers = [];
List listEsport = [];
List<Container> listnews = new List();

//images default
String imagesDefault = 'https://yamisok.com/assets/images/default/default.png';

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
  void apiAchive() {
    listAchievement.clear();
    ApiServiceProfileAchive.apiProfileAchivel().then((result) async {
      var resultdt = json.decode(result);
      final messages = resultdt['messages'];
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        print('lihat body, $resultlist');
        if (mounted) {
          setState(() {
            listAchievement.addAll(resultlist);
            //  listdiscover.addAll()
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  //get api
  void apiUpcoming() {
    clearUpcoming();
    ApiServiceProfileUpcoming.apiProfileUpcoming().then((result) async {
      var resultdt = json.decode(result);
      final messages = resultdt['messages'];
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        var jmlresult = resultlist.length;
        print('lihat upcoming total data , $jmlresult');

        if (resultlist.length == 0) {
          if (mounted) {
            setState(() {
              statusUpcoming = true;
              statusUpcomingData = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              var stringdate = resultlist['match_start_time'];
              //   stringdate.split(" ");
              var stringdatedt = stringdate.substring(0, 5);
              statusUpcoming = true;
              statusUpcomingData = true;
              titleUpcoming = resultlist['tournament_name'];
              dateUpcoming = resultlist['match_start_date'];
              timeUpcoming = stringdatedt;
              nameTeam1 = resultlist['team_1_name'];
              avatarTeam1 = resultlist['team_1_avatar'];
              nameTeam2 = resultlist['team_2_name'];
              avatarTeam2 = resultlist['team_2_avatar'];
              //  listdiscover.addAll()
            });
          }
        }

        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void apiEsport() {
    listEsport.clear();
    var limit = '5';
    ApiServiceEsport.apiesport(limit).then((result) async {
      var resultdt = json.decode(result);
      final messages = resultdt['messages'];
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        print('lihat body, $resultlist');
        if (mounted) {
          setState(() {
            listEsport.addAll(resultlist);
            //  listdiscover.addAll()
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void apigammers() {
    listEsport.clear();
    var limit = '5';
    ApiServiceEsport.apiesport(limit).then((result) async {
      var resultdt = json.decode(result);
      final messages = resultdt['messages'];
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        print('lihat body, $resultlist');
        if (mounted) {
          setState(() {
            listEsport.addAll(resultlist);
            //  listdiscover.addAll()
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void _modaltap() {
    print("lihat on tap");
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

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    // apiDetail();
    getusername();
    apiAchive();
    apiUpcoming();
    apiEsport();
    // store.dispatch(apigetlocation);

    // storeapp.dispatch(apipopular);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    // listDataMembers.clear();
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    //25sp sample title tournament list /username dilogin
    final double textSize2 =
        (size.width) / 38; //25sp sample list tournament on going
    final double textSize3 =
        (size.width) / 40; //25sp sample list tournament on going
    final double textSize4 =
        (size.width) / 12; //56sp sample 100% winrate detail team
    final double iconSize1 = (size.width) / 15; //25sp sample icon login

    //text size
    final double textSize14sp = (size.width) / 25;
    final double textSize16sp = (size.width) / 22; //sample lokasi kami saat ini
    final double textSize18sp = (size.width) / 18; //jakarta dki jakarta
    final double textSize20sp =
        (size.width) / 15; // final double iconSizeSearch =(size.width) / 25;

    //home
    final double heightbackground = (size.width);
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    //Shimmer
    final double itemWidth = (size.width - 20) / 3;
    final double itemWidth2 = (size.width);
    final double itemHeight = itemWidth;
    final double itemWidthShimer1 = itemWidth - 20;
    // final double itemWidthShimer = itemWidthwinrate;
    final double itemWidthShimer = itemWidthShimer1;

    final double itemWidthCustum = (itemWidth2 / 4) + (itemWidth2 / 2);

    //_myusername
    final double heightusername = (size.width) / 6.5;

    //mylokasi mediaquery
    final double heightsparator = (size.width) / 10;

    //Search mediaquery
    final double searchpadding = (size.width) / 4;
    final double widthsearch = (size.width) - searchpadding;
    final double heightsearch = (size.width) / 8;
    final double widthTextSeach = widthsearch - 40;

    //_menu
    final double widthmenu = (size.width) - 40;
    final double widthmenu2 = (widthmenu / 2) - 10;
    final double heightmenu2 = (size.width) / 5.5;

    //_gamers
    final double widthgamers = (size.width) / 2;
    final double heightgamers = (widthgamers + (widthgamers / 1.5)) + 32;

    //_Tempat
    final double widthtempat1 = (size.width) / 2;
    final double widthtempat = (size.width) / 1.2;
    final double heighttempat = (widthtempat1 + (widthtempat1 / 1.5)) + 32;

    Widget _sparator(String nama) {
      return Container(
        height: 45.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 5.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              nama,
              style: TextStyle(
                  fontSize: 18.0,
                  color: backgroundYellow,
                  fontFamily: 'ProximaRegular'),
              // fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

// new componen ==============================

    _myusername() {
      return Container(
        height: heightusername,
        width: double.infinity,
        // color: backgroundPrimary,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 5.0),
              child: Container(
                height: heightusername / 2,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Container(
                        color: Color(0xFF151a1d),
                        child: new Image.network(
                          avataruser ??
                              'https://yamisok.com/assets/images/default/default.png',
                          fit: BoxFit.fitHeight,
                        ))),
              ),
            ),
            Text("Hi $username",
                style: TextStyle(
                    fontSize: textSize18sp,
                    color: textColor1,
                    fontFamily: 'ProximaRegular')),
          ],
        ),
      );
    }

    var dataMyLokasi = new StoreConnector<AppState, ViewModel>(
      builder: (BuildContext context, ViewModel vm) {
        return new Container(
          child: Column(
            children: <Widget>[
              Text("Lokasi Kamu Saat ini",
                  style: TextStyle(
                      fontSize: textSize14sp,
                      color: textColor1,
                      fontFamily: 'ProximaRegular')),
              GestureDetector(
                // When the child is tapped, show a snackbar.
                onTap: () {
                  // vm.SuccessListPopular('Oh No you Tapped');
                },
                // The custom button
                child: Container(
                  child: Text(vm.state.quote,
                      style: TextStyle(
                          fontSize: textSize18sp,
                          color: textColor1,
                          fontFamily: 'ProximaBold')),
                ),
              ),
            ],
          ),
        );
      },
      converter: (store) {
        return ViewModel(
            state: store.state,
            updateQuote: (quote) =>
                store.dispatch(AppAction.UpdateQuoteAction(quote: quote)));
      },
      onInit: (store) {
        store.dispatch(
            AppAction.UpdateQuoteAction(quote: 'Tangerang, Lengkong kulon'));
      },
    );

    Widget _mylokasi() {
      if (statusUpcoming == true) {
        return dataMyLokasi;
      } else {
        return dataMyLokasi;
      }
    }

    Widget _search() {
      return Center(
        child: Container(
          width: widthsearch,
          height: heightsearch,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFF14fff),
              width: 1,
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(50.0) //         <--- border radius here
                ),
            color: backgroundTrnasparan.withOpacity(0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: TextField(
              // focusNode: myFocusNodeEmailLogin,
              controller: _searchController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                  fontSize: textSize14sp,
                  color: textColor1,
                  fontFamily: 'ProximaRegular'),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Cari teman, role, tempat, dll",
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(textSize2),
                    child: Icon(
                      Icons.search,
                      size: textSize18sp,
                      color: Color(0xFFa2a2a2),
                    ),
                  ),
                  hintStyle: TextStyle(
                      fontSize: textSize14sp,
                      color: prefix0.inputHintColor,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'ProximaRegular')),
            ),
          ),
        ),
      );
    }

    Widget _menu() {
      return Container(
        width: widthmenu,
        child: Row(
          children: <Widget>[
            Container(
              width: widthmenu2,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white12,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0) //         <--- border radius here
                    ),
                color: Colors.white30,
              ),
              height: heightmenu2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: heightmenu2 / 2.7,
                      height: heightmenu2 / 2.7,
                      child: new Image.network(
                        "https://cdn0.iconfinder.com/data/icons/fairytale-basic-lineal-color/512/13_Swords-512.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text("Cari Teman",
                          style: TextStyle(
                              fontSize: textSize16sp,
                              color: Colors.black,
                              fontFamily: 'ProximaBold')),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Container(
              width: widthmenu2,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white12,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0) //         <--- border radius here
                    ),
                color: Colors.white30,
              ),
              height: heightmenu2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: heightmenu2 / 2.7,
                      height: heightmenu2 / 2.7,
                      child: new Image.network(
                        "https://pngimage.net/wp-content/uploads/2018/06/logo-tempat-png-4.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text("Cari Tempat",
                          style: TextStyle(
                              fontSize: textSize16sp,
                              color: Colors.black,
                              fontFamily: 'ProximaBold')),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    var dataGamers = new Container(
        height: heightgamers,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: listAchievement.length,
          itemBuilder: (context, index) {
            final id = listAchievement[index]['player_username'];
            final username = listAchievement[index]['player_username'];
            final description = listAchievement[index]['description'];
            final avatarUrlnew = listAchievement[index]['player_avatar'] ??
                'https://yamisok.com/assets/images/static/logo-yamisok.png';
            // final title = "blabla";
            // final description = "bla bla";
            // final avatarUrlnew = "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/a161727e-91f5-4896-b41b-4d9f1853950a.png";
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: new InkWell(
                onTap: () => _showModalSheet(id, username, avatarUrlnew),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: widthgamers,
                      width: widthgamers,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        child: new Hero(
                          tag: id,
                          child: Container(
                            child: new Image.network(
                              avatarUrlnew,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: widthgamers,
                      height: widthgamers / 1.4,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(username,
                                      style: TextStyle(
                                          fontSize: textSize20sp,
                                          color: textColor1,
                                          fontFamily: 'ProximaBold')),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: widthgamers / 12,
                                        width: widthgamers / 15,
                                        child: Image.network(
                                            "https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Pink_Venus_symbol.svg/768px-Pink_Venus_symbol.svg.png"),
                                      ),
                                      Text("Tangerang Selatan",
                                          style: TextStyle(
                                              fontSize: textSize14sp,
                                              color: textColor2,
                                              fontFamily: 'ProximaRegular')),
                                    ],
                                  ),
                                  Text("PUBG Mobile, DOTA",
                                      style: TextStyle(
                                          fontSize: textSize14sp,
                                          color: textColor1,
                                          fontFamily: 'ProximaRegular')),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text("12 mutual friends",
                                      style: TextStyle(
                                          fontSize: textSize14sp,
                                          color: textColor1,
                                          fontFamily: 'ProximaRegular')),
                                  Container(
                                    height: widthgamers / 15,
                                    width: widthgamers / 15,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFF388e3c),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              20.0) //         <--- border radius here
                                          ),
                                      color: Color(0xFF7ff806),
                                    ),
                                    child: SizedBox(),
                                  )
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
        ));

    var shimmerGamers = new SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
            height: itemHeight,
            width: itemWidthCustum,
            child: new Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF34424e),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0) //         <--- border radius here
                    ),
                gradient: LinearGradient(
                  colors: [fristColor, secondColor],
                  begin: Alignment(-1.0, -2.0),
                  end: Alignment(1.0, 2.0),
                ),
              ),
              child: Shimmer.fromColors(
                baseColor: colorShimer,
                // highlightColor: Colors.grey[300],
                // baseColor: Colors.grey[100],
                highlightColor: colorlightShimer,
                // direction: ,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Container(
                            child: new Image.asset("assets/images/icon.png",
                                fit: BoxFit.cover),
                          )),
                    ),
                    Container(
                      // width: itemWidthAchivement,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: itemWidthShimer,
                            height: 10.0,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.red),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: itemWidthShimer,
                            height: 16.0,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
            height: itemHeight,
            width: itemWidthCustum,
            child: new Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF34424e),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0) //         <--- border radius here
                    ),
                gradient: LinearGradient(
                  colors: [fristColor, secondColor],
                  begin: Alignment(-1.0, -2.0),
                  end: Alignment(1.0, 2.0),
                ),
              ),
              child: Shimmer.fromColors(
                baseColor: colorShimer,
                // highlightColor: Colors.grey[300],
                // baseColor: Colors.grey[100],
                highlightColor: colorlightShimer,
                // direction: ,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Container(
                            child: new Image.asset("assets/images/icon.png",
                                fit: BoxFit.cover),
                          )),
                    ),
                    Container(
                      // width: itemWidthAchivement,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: itemWidthShimer,
                            height: 10.0,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.red),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: itemWidthShimer,
                            height: 16.0,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Widget _gamers() {
      if (listAchievement.length != 0) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: dataGamers,
        );
      } else {
        return shimmerGamers;
      }

      // }
    }

    var dataTempat = new Container(
        height: heighttempat,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: listAchievement.length,
          itemBuilder: (context, index) {
            final title = listAchievement[index]['title'];
            final description = listAchievement[index]['description'];
            final avatarUrlnew = listAchievement[index]['avatar_url'] ??
                'https://yamisok.com/assets/images/static/logo-yamisok.png';
            // final title = "blabla";
            // final description = "bla bla";
            // final avatarUrlnew = "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/a161727e-91f5-4896-b41b-4d9f1853950a.png";
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: widthtempat1,
                    width: widthtempat,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        child: Container(
                          child: new Image.network(
                              "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/fd25105f-08c9-49e4-9a79-2af0d9a3ae7e.png",
                              fit: BoxFit.cover),
                        )),
                  ),
                  Container(
                    width: widthtempat,
                    height: widthtempat1 / 1.4,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Medius",
                                    style: TextStyle(
                                        fontSize: textSize18sp,
                                        color: textColor1,
                                        fontFamily: 'ProximaBold')),
                                Text("Djournal Coffee",
                                    style: TextStyle(
                                        fontSize: textSize20sp,
                                        color: textColor1,
                                        fontFamily: 'ProximaBold')),
                                Text("Pondok Indah",
                                    style: TextStyle(
                                        fontSize: textSize14sp,
                                        color: textColor1,
                                        fontFamily: 'ProximaRegular')),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("32 nearby users",
                                        style: TextStyle(
                                            fontSize: textSize14sp,
                                            color: textColor1,
                                            fontFamily: 'ProximaRegular')),
                                    Text("Open",
                                        style: TextStyle(
                                            fontSize: textSize14sp,
                                            color: Colors.green,
                                            fontFamily: 'ProximaRegular')),
                                  ],
                                ),
                                Icon(
                                  Icons.free_breakfast,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ));
    var shimmerTempat = new SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
            height: itemHeight,
            width: itemWidthCustum,
            child: new Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF34424e),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0) //         <--- border radius here
                    ),
                gradient: LinearGradient(
                  colors: [fristColor, secondColor],
                  begin: Alignment(-1.0, -2.0),
                  end: Alignment(1.0, 2.0),
                ),
              ),
              child: Shimmer.fromColors(
                baseColor: colorShimer,
                // highlightColor: Colors.grey[300],
                // baseColor: Colors.grey[100],
                highlightColor: colorlightShimer,
                // direction: ,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Container(
                            child: new Image.asset("assets/images/icon.png",
                                fit: BoxFit.cover),
                          )),
                    ),
                    Container(
                      // width: itemWidthAchivement,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: itemWidthShimer,
                            height: 10.0,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.red),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: itemWidthShimer,
                            height: 16.0,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
            height: itemHeight,
            width: itemWidthCustum,
            child: new Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF34424e),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0) //         <--- border radius here
                    ),
                gradient: LinearGradient(
                  colors: [fristColor, secondColor],
                  begin: Alignment(-1.0, -2.0),
                  end: Alignment(1.0, 2.0),
                ),
              ),
              child: Shimmer.fromColors(
                baseColor: colorShimer,
                // highlightColor: Colors.grey[300],
                // baseColor: Colors.grey[100],
                highlightColor: colorlightShimer,
                // direction: ,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Container(
                            child: new Image.asset("assets/images/icon.png",
                                fit: BoxFit.cover),
                          )),
                    ),
                    Container(
                      // width: itemWidthAchivement,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: itemWidthShimer,
                            height: 10.0,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.red),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: itemWidthShimer,
                            height: 16.0,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Widget _tempat() {
      if (listAchievement.length != 0) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: dataTempat,
        );
      } else {
        return shimmerTempat;
      }
    }

    var shimmerEsport = new Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: Shimmer.fromColors(
        baseColor: colorShimer,
        // highlightColor: Colors.grey[300],
        // baseColor: Colors.grey[100],
        highlightColor: colorlightShimer,
        // direction: ,

        child: Column(
          children: <Widget>[
            Container(
              height: widthtempat1,
              width: double.infinity,
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  child: Container(
                    color: Colors.grey,
                    height: widthtempat1,
                    width: double.infinity,
                  )),
            ),
            Container(
              width: double.infinity,
              height: widthtempat1 / 2.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                        10.0), //         <--- border radius here
                    bottomRight:
                        Radius.circular(10.0) //         <--- border radius here

                    ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 5.0, top: 10.0, right: 5.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: itemWidthShimer,
                        height: 20.0,
                        child: const DecoratedBox(
                          decoration: const BoxDecoration(color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(),
                        child: SizedBox(
                          width: itemWidthShimer * 3,
                          height: 20.0,
                          child: const DecoratedBox(
                            decoration: const BoxDecoration(color: Colors.grey),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

    Widget _esport() {
      return Container(
          child: StoreConnector<AppState, ViewModel>(
        builder: (BuildContext context, ViewModel vm) {
          var containesEsport = vm.state.news_content;
          if (containesEsport.length != 0) {
            var listEsport = containesEsport;

            return new Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    key: Key('ESPORTS'),
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EsportWebview(
                                  parameter: listEsport[0]['url'])),
                        );
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: widthtempat1,
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                                child: Container(
                                  child: new Image.network(
                                      listEsport[0]['cover_img'] ??
                                          "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/7187d5e3-5cc7-4830-a603-b3a97c46608d.png",
                                      fit: BoxFit.cover),
                                )),
                          ),
                          Container(
                            width: double.infinity,
                            height: widthtempat1 / 2.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      10.0), //         <--- border radius here
                                  bottomRight: Radius.circular(
                                      10.0) //         <--- border radius here

                                  ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, top: 10.0, right: 5.0),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(listEsport[0]['cdate'],
                                        style: TextStyle(
                                            fontSize: textSize18sp,
                                            color: textColor1,
                                            fontFamily: 'ProximaBold')),
                                    Text(listEsport[0]['title'],
                                        style: TextStyle(
                                            fontSize: textSize16sp,
                                            color: textColor1,
                                            fontFamily: 'ProximaReguler')),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EsportWebview(
                                  parameter: listEsport[1]['url'])),
                        );
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: widthtempat1,
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                                child: Container(
                                  child: new Image.network(
                                      listEsport[1]['cover_img'] ??
                                          "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/7187d5e3-5cc7-4830-a603-b3a97c46608d.png",
                                      fit: BoxFit.cover),
                                )),
                          ),
                          Container(
                            width: double.infinity,
                            height: widthtempat1 / 2.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      10.0), //         <--- border radius here
                                  bottomRight: Radius.circular(
                                      10.0) //         <--- border radius here

                                  ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, top: 10.0, right: 5.0),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(listEsport[1]['cdate'],
                                        style: TextStyle(
                                            fontSize: textSize18sp,
                                            color: textColor1,
                                            fontFamily: 'ProximaBold')),
                                    Text(listEsport[1]['title'],
                                        style: TextStyle(
                                            fontSize: textSize16sp,
                                            color: textColor1,
                                            fontFamily: 'ProximaReguler')),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EsportWebview(
                                  parameter: listEsport[2]['url'])),
                        );
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: widthtempat1,
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                                child: Container(
                                  child: new Image.network(
                                      listEsport[2]['cover_img'] ??
                                          "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/7187d5e3-5cc7-4830-a603-b3a97c46608d.png",
                                      fit: BoxFit.cover),
                                )),
                          ),
                          Container(
                            width: double.infinity,
                            height: widthtempat1 / 2.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      10.0), //         <--- border radius here
                                  bottomRight: Radius.circular(
                                      10.0) //         <--- border radius here

                                  ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, top: 10.0, right: 5.0),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(listEsport[2]['cdate'],
                                        style: TextStyle(
                                            fontSize: textSize18sp,
                                            color: textColor1,
                                            fontFamily: 'ProximaBold')),
                                    Text(listEsport[2]['title'],
                                        style: TextStyle(
                                            fontSize: textSize16sp,
                                            color: textColor1,
                                            fontFamily: 'ProximaReguler')),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EsportWebview(
                                  parameter: listEsport[3]['url'])),
                        );
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: widthtempat1,
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                                child: Container(
                                  child: new Image.network(
                                      listEsport[3]['cover_img'] ??
                                          "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/7187d5e3-5cc7-4830-a603-b3a97c46608d.png",
                                      fit: BoxFit.cover),
                                )),
                          ),
                          Container(
                            width: double.infinity,
                            height: widthtempat1 / 2.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      10.0), //         <--- border radius here
                                  bottomRight: Radius.circular(
                                      10.0) //         <--- border radius here

                                  ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, top: 10.0, right: 5.0),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(listEsport[3]['cdate'],
                                        style: TextStyle(
                                            fontSize: textSize18sp,
                                            color: textColor1,
                                            fontFamily: 'ProximaBold')),
                                    Text(listEsport[3]['title'],
                                        style: TextStyle(
                                            fontSize: textSize16sp,
                                            color: textColor1,
                                            fontFamily: 'ProximaReguler')),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EsportWebview(
                                  parameter: listEsport[4]['url'])),
                        );
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: widthtempat1,
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                                child: Container(
                                  child: new Image.network(
                                      listEsport[4]['cover_img'] ??
                                          "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/7187d5e3-5cc7-4830-a603-b3a97c46608d.png",
                                      fit: BoxFit.cover),
                                )),
                          ),
                          Container(
                            width: double.infinity,
                            height: widthtempat1 / 2.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      10.0), //         <--- border radius here
                                  bottomRight: Radius.circular(
                                      10.0) //         <--- border radius here

                                  ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, top: 10.0, right: 5.0),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(listEsport[4]['cdate'],
                                        style: TextStyle(
                                            fontSize: textSize18sp,
                                            color: textColor1,
                                            fontFamily: 'ProximaBold')),
                                    Text(listEsport[4]['title'],
                                        style: TextStyle(
                                            fontSize: textSize16sp,
                                            color: textColor1,
                                            fontFamily: 'ProximaReguler')),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return shimmerEsport;
          }
        },
        converter: (store) {
          return ViewModel(
              state: store.state,
              updateNews: () =>
                  store.dispatch(AppAction.RefreshNews(limit: '5')));
        },
        onInit: (store) {
          store.dispatch(AppAction.UpdateNews(limit: '5'));
        },
      ));
    }

    return Scaffold(
      body: Container(
        height: double.infinity,
        color: backgroundPrimary,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: <Widget>[
              Container(
                height: heightbackground,
                width: double.infinity,
                child: Image.asset('assets/images/new/backgroundhome.png',
                    fit: BoxFit.cover),
              ),
              Column(
                children: <Widget>[
                  Container(
                    height: statusBarHeight,
                    color: backgroundPrimary,
                  ),
                  _myusername(),
                  SizedBox(
                    height: heightsparator * 1.5,
                  ),
                  _mylokasi(),
                  SizedBox(
                    height: heightsparator,
                  ),
                  // _search(),
                  SizedBox(
                    height: heightsparator * 1.5,
                  ),
                  // _showtext(),
                  _menu(),
                  SizedBox(
                    height: heightsparator / 2,
                  ),
                  _sparator("GAMERS TERPOPULER"),
                  _gamers(),

                  _sparator("TEMPAT TERPOPULER"),
                  _tempat(),
                  _sparator("EVENT PALING SERU"),
                  SizedBox(
                    height: heightsparator * 1.5,
                  ),
                  _sparator("SEPUTAR ESPORTS"),
                  _esport(),

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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () => _asyncConfirmDialog(context).then((rst) {
                        if (rst == ConfirmAction.ACCEPT) logout(context);
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF34424e),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          gradient: LinearGradient(
                            colors: [backgroundPrimary, backgroundPrimary],
                            begin: Alignment(-1.0, -2.0),
                            end: Alignment(1.0, 2.0),
                          ),
                        ),
                        height: 50.0,
                        width: double.infinity,
                        child: Center(
                            child: Text(
                          "log Out",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: textColor1,
                          ),
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void logout(context) {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  _googleSignIn.disconnect();
  keyStore.setToken('null').then((val) {
    print("reset token logout sucess");
    // Navigator.pop(context);
    keyStore.getToken().then((rst) {
      print("THEN CEK TOKENNYA : $rst");
      // Navigator.of(context).pushNamed(Home.tag);
      // Navigator.pushNamed(context, '/login');
      Navigator.pushReplacementNamed(context, LoginSignUpPage.tag);
      // Navigator.popUntil(context, ModalRoute.withName('/login'));
      // Navigator.push(context, new MaterialPageRoute(
      //   builder: (context) =>
      //     new LoginSignUpPage())
      // );
    });
  });
}

enum ConfirmAction { CANCEL, ACCEPT }

Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Are you sure want to logout?'),
        actions: <Widget>[
          FlatButton(
            color: Colors.black87,
            textColor: yamiyelowColor,
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            color: Colors.black87,
            textColor: Colors.white54,
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget({
    Key key,

    /// If set, enable the FusedLocationProvider on Android
    @required this.androidFusedLocation,
  }) : super(key: key);

  final bool androidFusedLocation;

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  Position _lastKnownPosition;
  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    print('masuk k init');
    checkConnection().then((isConnected) {
      print('masuk k cek koneksi');
      if (!isConnected) {
        showAlertConnection(context);
      }
    });

    // _initLastKnownLocation();
    // _initCurrentLocation();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _lastKnownPosition = null;
      _currentPosition = null;
    });

    _initLastKnownLocation();
    _initCurrentLocation();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initLastKnownLocation() async {
    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = !widget.androidFusedLocation;
      position = await geolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    } on PlatformException {
      position = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _lastKnownPosition = position;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  _initCurrentLocation() {
    Geolocator()
      ..forceAndroidLocationManager = !widget.androidFusedLocation
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      ).then((position) {
        if (mounted) {
          setState(() => _currentPosition = position);
        }
      }).catchError((e) {
        //
      });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GeolocationStatus>(
        future: Geolocator().checkGeolocationPermissionStatus(),
        builder:
            (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == GeolocationStatus.denied) {
            return const PlaceholderWidget('Access to location denied',
                'Allow access to the location services for this App using the device settings.');
          }

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: Text(
                    _fusedLocationNote(),
                    textAlign: TextAlign.center,
                  ),
                ),
                PlaceholderWidget(
                    'Last known location:', _lastKnownPosition.toString()),
                PlaceholderWidget(
                    'Current location:', _currentPosition.toString()),
              ],
            ),
          );
        });
  }

  String _fusedLocationNote() {
    if (widget.androidFusedLocation) {
      return 'Geolocator is using the Android FusedLocationProvider. This requires Google Play Services to be installed on the target device.';
    }

    return 'Geolocator is using the raw location manager classes shipped with the operating system.';
  }
}

class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget(this.title, this.message);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(title,
              style: const TextStyle(fontSize: 32.0, color: Colors.black54),
              textAlign: TextAlign.center),
          Text(message,
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
