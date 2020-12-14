import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yamisok/api/game/list_game_api.dart';
import 'package:yamisok/component/styleyami.dart';
import 'package:yamisok/page/game/connect_game_manual.dart';
import 'package:yamisok/page/game/connect_game_ocr.dart';
import 'package:yamisok/page/game/connect_game_steam.dart';
import 'package:yamisok/page/home/home_new.dart';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/redux/action.dart' as AppAction;
import '../utilities/style.dart';
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/page/home/bottom_navigation.dart' as bottomNav;

FirebaseAnalytics analytics = FirebaseAnalytics();

List datagame = [];

bool statusButtonNext = false;

class ConnectGame extends StatefulWidget {
  final String rotefrom;
  static String tag = 'connect-game';

  ConnectGame({Key key, this.rotefrom}) : super(key: key);
  @override
  _ConnectGameState createState() => _ConnectGameState();
}

class _ConnectGameState extends State<ConnectGame> {
  
  void _apiListGame() async {
    ApiServiceListGame.apilistgame().then((rst) async {
      datagame.clear();
      var resultdt = json.decode(rst);
      final messages = resultdt['messages'];
      final status = resultdt['status'];
      if (status == true) {
        final resultlist = resultdt['result'];

        setState(() {
          datagame.addAll(resultlist);
        });
        print('lihat result list game leght ${datagame.length}');

        print('lihat result list game $resultlist');
        for (var i = 0; i < datagame.length; i++) {
          if (datagame[i]['is_connected'] == 1) {
            setState(() {
              statusButtonNext = true;
            });
          }
          // list.add(new Text(strings[i]));
        }
      } else {}
    });
  }

  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    _apiListGame();
    analytics.logEvent(name: 'Connect_game');
    super.initState();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var mediaquery = MediaQuery.of(context).size;

    final double textSize14sp = (size.width) / 25;
    final double textSize16sp = (size.width) / 22;
    final double textSize18sp = (size.width) / 18;
    final double textSize20sp = (size.width) / 15;

    final double margin1 = (size.width) / 30;
    final double whithimg = ((size.width) / 3);
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    void _validateAndSubmit() async {
      if (widget.rotefrom == 'profile') {
        Navigator.pop(context, "succes");
      } else {
        setLatestPage('Home').then((val) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, bottomNav.Bottomnav.tag);
        });
      }
    }

    Widget _showPrimaryButton() {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: double.infinity,
        height: mediaquery.width / buttonHeight1,
        child: ButtonTheme(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
          buttonColor: backgroundYellow,
          minWidth: double.infinity,
          height: mediaquery.width / buttonHeight1,
          child: RaisedButton(
            onPressed: _validateAndSubmit,
            child: new Text(widget.rotefrom == 'profile' ? 'Selesai' : 'Lanjut',
                style: new TextStyle(
                    fontSize: mediaquery.width / textSize17sp,
                    color: Colors.black,
                    fontFamily: 'ProximaBold')),
          ),
        ),
      );
    }

    Widget _showDisableButton() {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: double.infinity,
        height: mediaquery.width / buttonHeight1,
        child: ButtonTheme(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
          buttonColor: Colors.grey,
          minWidth: double.infinity,
          height: mediaquery.width / buttonHeight1,
          child: RaisedButton(
            onPressed: () {},
            child: new Text('Lanjut',
                style: new TextStyle(
                    fontSize: mediaquery.width / textSize17sp,
                    color: Colors.grey[800],
                    fontFamily: 'ProximaBold')),
          ),
        ),
      );
    }

    Widget _showLoadingButton() {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: double.infinity,
        height: mediaquery.width / buttonHeight1,
        child: ButtonTheme(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
          buttonColor: backgroundYellow,
          minWidth: double.infinity,
          height: mediaquery.width / buttonHeight1,
          child: RaisedButton(
              onPressed: () {},
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black))),
        ),
      );
    }

    Widget _statusButton() {
      if (statusButtonNext == true) {
        return _showPrimaryButton();
      } else {
        return _showDisableButton();
      }
    }

    Widget listGame() {
      return Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: statusBarHeight,
                      ),
                      SizedBox(
                        height: margin1,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Bind games untuk bisa terhubung',
                          style: TextStyle(
                              fontSize: textSize18sp, color: backgroundYellow),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: margin1,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          'Bind game yang kamu mainkan untuk dapat mencari teman yang sesuai.',
                          style: TextStyle(
                              fontSize: textSize14sp, color: textColor2),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: margin1 * 4,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          'Game yang kamu mainkan',
                          style: TextStyle(
                              fontSize: textSize16sp, color: textColor2),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: margin1,
                      ),
                    ],
                  ),
                )
              ]),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: whithimg,
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 0.0,
                childAspectRatio: 0.80,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var dtimages = Container();
                  if (datagame[index]['is_connected'] == 1) {
                    dtimages = Container(
                      child: Image.asset("assets/images/game/frameconnect.png"),
                    );
                  } else {
                    dtimages = Container();
                  }

                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: GestureDetector(
                      onTap: () async {
                        var idgame = datagame[index]['id'];
                        var ingameid = datagame[index]['in_game_id'];
                        var isjointour =
                            datagame[index]['is_joined_tournament'];
                        var nicname = datagame[index]['nickname'];
                        var name = datagame[index]['name'];
                        print('liat ingame id $ingameid');
                        if (datagame[index]['is_steam_game'] == 1) {
                          String result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GameSteamPage(
                                    idgame: idgame,
                                    ingameid: ingameid,
                                    isjointour: isjointour,
                                    nicname: nicname,
                                    name: name)),
                          );
                          setState(() {
                            if (result == 'succes') {
                              _apiListGame();
                            } else {}
                          });
                        } else if (datagame[index]['is_mobile_legend'] == 1) {
                          String result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GameOcrPage(
                                    idgame: idgame,
                                    ingameid: ingameid,
                                    isjointour: isjointour,
                                    nicname: nicname,
                                    name: name)),
                          );
                          setState(() {
                            if (result == 'succes') {
                              _apiListGame();
                            } else {}
                          });
                        } else {
                          String result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GameManualPage(
                                    idgame: idgame,
                                    ingameid: ingameid,
                                    isjointour: isjointour,
                                    nicname: nicname,
                                    name: name)),
                          );
                          setState(() {
                            if (result == 'succes') {
                              _apiListGame();
                            } else {}
                          });
                        }
                      },
                      child: Container(
                        child: Stack(children: <Widget>[
                          Image.network(datagame[index]["avatar_banner_mobile"],
                              fit: BoxFit.cover),
                          dtimages
                        ]),
                      ),
                    ),
                  );
                },
                childCount: datagame.length,
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                height: mediaquery.height / 11,
              )
            ]))
          ],
        ),
      );
    }

    Widget _shimmerlist() {
      return Container(
        child: Shimmer.fromColors(
          baseColor: colorShimer,
          // highlightColor: Colors.grey[300],
          // baseColor: Colors.grey[100],
          highlightColor: colorlightShimer,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Container(
                  height: statusBarHeight,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    height: mediaquery.width / 20,
                    width: mediaquery.width / 1.5,
                    color: colorShimer,
                  ),
                ),
                SizedBox(
                  height: margin1,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    height: mediaquery.width / 35,
                    width: mediaquery.width / 1.2,
                    color: colorShimer,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    height: mediaquery.width / 35,
                    width: mediaquery.width / 1.6,
                    color: colorShimer,
                  ),
                ),
                SizedBox(
                  height: margin1 * 4,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    height: mediaquery.width / 30,
                    width: mediaquery.width / 2,
                    color: colorShimer,
                  ),
                ),
                SizedBox(
                  height: margin1,
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: colorShimer,
                        ),
                        height: mediaquery.width / 2.6,
                        width: mediaquery.width / 3.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: colorShimer,
                        ),
                        height: mediaquery.width / 2.6,
                        width: mediaquery.width / 3.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: colorShimer,
                        ),
                        height: mediaquery.width / 2.6,
                        width: mediaquery.width / 3.5,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: colorShimer,
                        ),
                        height: mediaquery.width / 2.6,
                        width: mediaquery.width / 3.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: colorShimer,
                        ),
                        height: mediaquery.width / 2.6,
                        width: mediaquery.width / 3.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: colorShimer,
                        ),
                        height: mediaquery.width / 2.6,
                        width: mediaquery.width / 3.5,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: colorShimer,
                        ),
                        height: mediaquery.width / 2.6,
                        width: mediaquery.width / 3.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: colorShimer,
                        ),
                        height: mediaquery.width / 2.6,
                        width: mediaquery.width / 3.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: colorShimer,
                        ),
                        height: mediaquery.width / 2.6,
                        width: mediaquery.width / 3.5,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: colorShimer,
                        ),
                        height: mediaquery.width / 2.6,
                        width: mediaquery.width / 3.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: colorShimer,
                        ),
                        height: mediaquery.width / 2.6,
                        width: mediaquery.width / 3.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: colorShimer,
                        ),
                        height: mediaquery.width / 2.6,
                        width: mediaquery.width / 3.5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: datagame.length != 0 ? listGame() : _shimmerlist()),
      floatingActionButton: _statusButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
