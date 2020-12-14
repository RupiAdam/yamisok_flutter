import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' show Client;
import 'package:yamisok/api/online_status/set_status_online_api.dart';
import 'dart:convert';
// import 'package:yamisok/component/globals.dart' as global;

import 'package:yamisok/component/keyStore.dart';

import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yamisok/component/styleyami.dart';
import 'package:yamisok/model/profile_model.dart';

import 'package:yamisok/api/team/myteam_api.dart';
import 'package:yamisok/api/team/listteam_api.dart';
import 'package:yamisok/api/team/detailteam_api.dart';
import 'package:yamisok/api/team/achievteam_api.dart';
import 'package:yamisok/api/team/recentteam_api.dart';
import 'package:yamisok/page/utilities/style.dart';

Client client = Client();
List<String> dogImages = new List();
List listData = [];
List listDataMembers = [];
List listDataDetail = [];
List listAchievementTeam = [];

// DETAIL ITEM
String teamName = '';
String tagTeam = '';
String statusTeam = '0';
String totalWin = '';
String totallose = '';
String winRates = '';
String totalMatches = '';
List formTeam = [];

// DETAIL RECET
bool statusRecent = false;
bool statusRecentData = false;
String titleRecent = '';
String dateRecent = '';
String timeRecent = '';
String nameTeam1 = '';
String avatarTeam1 = '';
String nameTeam2 = '';
String avatarTeam2 = '';

bool isLoading = true;

FirebaseAnalytics analytics = FirebaseAnalytics();

class ListTeam extends StatefulWidget {
  @override
  _ListTeamState createState() => _ListTeamState();
}

class _ListTeamState extends State<ListTeam> {
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];

  RefreshController _scrollController =
      RefreshController(initialRefresh: false);
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch

    // if failed,use refreshFailed()
    int offset = 0;
    ApiService.apimyteam(offset).then((result) async {
      var resultdt = json.decode(result);
      final messages = resultdt['messages'];
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        print('lihat body, $resultlist');

        setState(() {
          emptyListData();
          listData.addAll(resultlist);
        });
        print("status true");
      } else {
        print("status false");
      }
    });

    _scrollController.refreshCompleted();
  }

  void _onLoading() async {
    print("jlan onload");
    int offset = listData.length;
    ApiService.apimyteam(offset).then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        print('lihat body, $resultlist');

        setState(() {
          listData.addAll(resultlist);
        });
        print("status true");
      } else {
        print("status false");
      }
    });

    _scrollController.loadComplete();
  }

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

  @override
  void initState() {
     SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
    super.initState();

    setState(() {
      isLoading = true;
    });

    listData.clear();
    int offset = listData.length;
    ApiService.apimyteam(offset).then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        print('lihat body, $resultlist');
        setState(() {
          listData.addAll(resultlist);
          isLoading = false;
        });
        print("status true");
      } else {
        print("status false");
      }
    });

    analytics.setCurrentScreen(screenName: "/page_team");
    analytics.logEvent(name: 'Team');
    setapistatusonline();
  }

  @override
  void dispose() {
     SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
    _scrollController.dispose();
    super.dispose();
  }

  fetchAPiLoad() async {
    final response = await client.get(
        'http://www.mocky.io/v2/5d7497f33300004f6c081980',
        headers: {"content-type": "application/json"});
    final statuscodeprint = response.statusCode;
    print('lihat status code $statuscodeprint');
    if (response.statusCode == 200) {
      Map<String, dynamic> user = jsonDecode(response.body);
      var bodylog = json.decode(response.body);
      var resultlist = bodylog['result'];
      var newtes2 = resultlist[1];
      print('Howdy, $bodylog[1].');
      print('Howdy2, $resultlist');
      print('Howdy3, $newtes2');

      setState(() {
        listData.addAll(resultlist);
      });

      var newprint = listData[0]['avatar_sm'];

      print("errorlihat $newprint");

      // listdiscover.add(newtes);
      //  listdiscover=newtes;
      // });
    } else {
      throw Exception('failed to load images');
    }
  }

  fetchAPi() async {
    setState(() {
      isLoading = true;
    });
    print("Fetch");
    print(isLoading);
    final String baseUrl = globals.baseUrlApi;
    final userPlayerId = await keyStore.getPlayerId();
    final playerId = userPlayerId.toString();
    final userToken = await keyStore.getToken();
    final response = await client.get(
        '$baseUrl/v1/teams/my-team?offset=0&limit=5',
        headers: {"token": userToken, "playerid": playerId});
    final statuscodeprint = response.statusCode;
    final String status = statuscodeprint.toString();
    if (status == "200") {
      setState(() {
        isLoading = false;
      });

      // Map<String, dynamic> user = jsonDecode(response.body);
      var bodylog = json.decode(response.body);
      var resultlist = bodylog['result'];

      setState(() {
        listData.addAll(resultlist);
      });

      var newprint = listData[0]['avatar_sm'];

      print("errorlihat $newprint");
    } else {
      setState(() {
        isLoading = false;
      });

      throw Exception('failed to load images');
    }
  }

  emptyListData() {
    listData.clear();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemWidth = (size.width - 10) / 3;
    final double itemHeight1 = (size.width) / 4;

    final double itemHeight = ((size.width - 10) / 4) - 10;
    final double itemHeightTeam = ((size.width) / 2);
    final double itemWhithTeam = itemHeightTeam - 10;
    final double itemHeightText = itemHeightTeam / 4;
    final double itemHeightfix = (itemHeightTeam - itemHeightText) - 15;

    final double itemWidthComunity = (size.width - 20) / 2;
    final double itemWidthComunitytext1 = (size.width - 80) / 2;
    final double itemWidthComunitytext2 = (size.width - 200) / 2;
    final double itemHeightComunity = (size.width - 100) / 2;

    final double textSize1 =
        (size.width) / 25; //25sp sample title tournament list /username dilogin
    final double textSize2 =
        (size.width) / 38; //25sp sample list tournament on going
    final double textSize3 =
        (size.width) / 40; //25sp sample list tournament on going
    final double iconSize1 = (size.width) / 15; //25sp sample icon login

    var shimerdt = MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundPrimary,
          title: Center(child: Text('Team')),
          actions: <Widget>[],
        ),
        body: Container(
          height: double.infinity,
          color: backgroundPrimary,
          child: new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Shimmer.fromColors(
                baseColor: colorShimer,
                highlightColor: colorlightShimer,
                child: Column(
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: itemWidthComunity,
                                height: itemHeightComunity,
                                child: const DecoratedBox(
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext1,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFE0E0E0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext2,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFE0E0E0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: itemWidthComunity,
                                height: itemHeightComunity,
                                child: const DecoratedBox(
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext1,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFE0E0E0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext2,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFE0E0E0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: itemWidthComunity,
                                height: itemHeightComunity,
                                child: const DecoratedBox(
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext1,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFE0E0E0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext2,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFE0E0E0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: itemWidthComunity,
                                height: itemHeightComunity,
                                child: const DecoratedBox(
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext1,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFE0E0E0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext2,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFE0E0E0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: itemWidthComunity,
                                height: itemHeightComunity,
                                child: const DecoratedBox(
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext1,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFE0E0E0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext2,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFE0E0E0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: itemWidthComunity,
                                height: itemHeightComunity,
                                child: const DecoratedBox(
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext1,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFE0E0E0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext2,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFE0E0E0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    var dataUi = new Container(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = Container(
                child: Text("Load More"),
              );
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else {
              body = CircularProgressIndicator();
            }
            return Container(
              height: 200.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _scrollController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: GridView.builder(
          itemCount: listData.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            var imagesteam = listData[index]['avatar_sm'].toString() ?? '';
            var namateam = listData[index]['team_name'].toString() ?? '';
            var idteam = listData[index]['team_id'].toString() ?? '';
            var gamename = listData[index]['game_name'].toString() ?? '';

            print('lihat print  $imagesteam');
            return Container(
              padding: const EdgeInsets.all(5.0),
              child: new Material(
                color: backgroundPrimary,
                child: new InkWell(
                    onTap: () =>
                        Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new DeytailTeam(
                              id: idteam, nama: namateam, images: imagesteam),
                        )),
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          child: new Hero(
                            tag: idteam,
                            child: Container(
                              color: Colors.black,
                              width: itemWhithTeam,
                              height: itemHeightfix,
                              child: new Image.network(
                                imagesteam,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: backgroundSecond,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                          ),
                          width: itemWhithTeam,
                          height: itemHeightText,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                namateam,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: textSize1,
                                    fontFamily: 'ProximaBold'),
                              ),
                              Text(
                                gamename,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white, fontSize: textSize1),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            );
          },
        ),
      ),
    );

    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: backgroundPrimary,
          title: Center(child: Text('Team')),
          actions: <Widget>[],
        ),
        body: parent());


    // if (isLoading == true) {
    //   return shimerdt;
    // } else {
    //   if (listData.length == 0) {
    //     return Scaffold(
    //         appBar: AppBar(
    //           backgroundColor: backgroundPrimary,
    //           title: Center(child: Text('Team')),
    //           actions: <Widget>[],
    //         ),
    //         body: Container(
    //           color: backgroundPrimary,
    //           width: size.width,
    //           height: size.height,
    //           child: Center(
    //             child: Container(
    //               child: Text(
    //                 "Kamu belum memiliki team :(",
    //                 style: TextStyle(
    //                     color: textColor1, fontSize: (size.width) / 25),
    //               ),
    //             ),
    //           ),
    //         ));
    //   } else {
    //     return Scaffold(
    //         appBar: AppBar(
    //           backgroundColor: backgroundPrimary,
    //           title: Center(child: Text('Team')),
    //           actions: <Widget>[],
    //         ),
    //         body: Container(
    //           color: backgroundPrimary,
    //           padding: const EdgeInsets.all(5.0),
    //           child: dataUi,
    //         ));
    //   }
    // }
  }

  Widget parent() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      color: Color(0xFF151a1e),
      width: mediaquery.width,
      height: mediaquery.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            logoImage(),
            Text('Fitur ini sedang dalam',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: mediaquery.width / textSize18sp,
                    fontFamily: 'ProximaRegular')),
            Text('tahap optimalisasi fitur.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: mediaquery.width / textSize18sp,
                    fontFamily: 'ProximaRegular'))
          ],
        ),
      ),
    );
  }

  Widget logoImage() {
    var size = MediaQuery.of(context).size;

    final double itemWidthpadding = (size.width) / 4;
    final double itemWidthpadding2 = itemWidthpadding / 4;
    final double itemWidth = (size.width) / 1.5;
    return Column(
      children: <Widget>[
        SizedBox(
          height: itemWidthpadding2,
        ),
        Container(
            width: itemWidth,
            child: new Image.asset("assets/images/comingsoon/team.jpg")),
        SizedBox(
          height: itemWidthpadding2,
        )
      ],
    );
  }

}

class DeytailTeam extends StatefulWidget {
  DeytailTeam({this.id, this.nama, this.images});
  final String id;
  final String nama;
  final String images;
  @override
  _DeytailTeamState createState() => _DeytailTeamState();
}

class _DeytailTeamState extends State<DeytailTeam> {
  void clearDetailTeam() {
    teamName = '';
    tagTeam = '';
    statusTeam = '0';
    totalWin = '';
    totallose = '';
    winRates = '';
    totalMatches = '';
    formTeam = [];
  }

  void apiTeam() {
    final idteam = widget.id;
    listDataMembers.clear();
    ApiServiceteam.apilistteam(idteam).then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        var resultlist = resultdt['result'];
        setState(() {
          listDataMembers.addAll(resultlist);
          final lihatusername_members =
              listDataMembers[0]['username_members'].toString() ?? '';
          print("status true lihat array members $lihatusername_members");
        });
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void apiDetailTeam() {
    clearDetailTeam();
    final idteam = widget.id;
    ApiServicedetailteam.apidetailteam(idteam).then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        print('lihat body, $resultlist');
        if (mounted) {
          setState(() {
            teamName = resultlist['team_name'].toString() ?? '';
            tagTeam = resultlist['tag_team'].toString() ?? '';
            statusTeam = resultlist['status'].toString() ?? '';
            totalWin = resultlist['total_win'].toString() ?? '';
            totallose = resultlist['total_lose'].toString() ?? '';
            winRates = resultlist['winrates'].toString() ?? '';
            totalMatches = resultlist['total_matches'].toString() ?? '';
            formTeam = resultlist['form'];
            //  listdiscover.addAll()
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void apiAchieveTeam() {
    listAchievementTeam.clear();
    final idteam = widget.id;
    ApiServiceachieveteam.apiachieveteam(idteam).then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        print('lihat body, $resultlist');
        if (mounted) {
          setState(() {
            listAchievementTeam.addAll(resultlist);
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void apiRecentMatchTeam() {
    clearDetailTeam();
    final idteam = widget.id;
    ApiServiceachieveteam.apiachieveteam(idteam).then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        print('lihat body, $resultlist');
        if (mounted) {
          setState(() {
            listAchievementTeam.addAll(resultlist);
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.initState();

    apiTeam();
    apiDetailTeam();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemWidth = (size.width - 20) / 3;
    final double itemWidth2 = (size.width);

    final double itemWidthCustum = (itemWidth2 / 4) + (itemWidth2 / 2);

    final double itemWidthAchivement =
        ((size.width - 10) / 3) + (itemWidth / 2) - 5;
    final double itemHeight = itemWidth;
    final double itemHeightwinrate = itemHeight - 20;

    //winrate
    final double itemWidthCustumwinrate = (size.width) - 20;
    final double itemWidthwinrate = itemWidth - 20;
    final double itemWidthwinrate2 = itemWidthCustumwinrate - itemWidthwinrate;

    //team members
    final double itemWidthteammembers = (size.width) - 20;
    final double itemWidthteammemberslist = (size.width) / 15;
    final double itemWidthteammemberslistname = itemWidthwinrate;
    final datates = widget.id;

    // final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    //  final double itemWidth = (size.width - 10) / 3;
    final double itemWidthCustom = ((size.width - 10) / 3) * 2;
    final double paddingwinrate = (size.width) / 10;
    final double itemWidthCustomStatusXp = (((size.width - 10) / 3) * 2) - 70;

    //upcoming match
    final double itemWidthupcoming = (size.width - 10) / 3;
    final double itemWidthDailyupcoming = itemWidthupcoming / 2.5;

    final double textSize1 =
        (size.width) / 25; //25sp sample title tournament list /username dilogin
    final double textSize2 =
        (size.width) / 38; //25sp sample list tournament on going
    final double textSize3 =
        (size.width) / 40; //25sp sample list tournament on going
    final double textSize4 =
        (size.width) / 12; //56sp sample 100% winrate detail team
    final double iconSize1 = (size.width) / 15; //25sp sample icon login

    var dataAchievement = new Container(
        height: itemHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: listDataMembers.length,
          itemBuilder: (context, index) {
            final title = "Lorem Ipsum";
            final description = "Lorem ipsum dolor";
            final avatarUrlnew =
                "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/a161727e-91f5-4896-b41b-4d9f1853950a.png";

            return Container(
              padding:
                  const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Container(
                            child: new Image.network(avatarUrlnew,
                                fit: BoxFit.cover),
                          )),
                    ),
                    Container(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: textColor2,
                            ),
                            // fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          new Text(
                            description,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: backgroundYellow,
                                fontWeight: FontWeight.bold),
                            // fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));

    var shimmerAchievement = new Container(
      child: Text(
        "shimmer data",
        style: TextStyle(
            fontSize: 18.0, color: textColor2, fontWeight: FontWeight.bold),
        // fontWeight: FontWeight.bold),
      ),
    );

    Widget _achievementnew() {
      if (listDataMembers.length != 0) {
        return new Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: dataAchievement,
        );
      } else {
        return shimmerAchievement;
      }
    }

    var dataTeamMembers = new Container(
        child: ListView.builder(
      // scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listDataMembers.length,
      itemBuilder: (context, index) {
        // final title = listDataDetail[index].team_name;
        // final description = listDataDetail[index].team_name;

        final username = listDataMembers[index]['username_members'];
        final statuscap = listDataMembers[index]['is_captain'];
        final avatarmembers = listDataMembers[index]['avatar_sm_member'];
        var datalihat = Container();
        print("lihat username $avatarmembers");
        var statuscaptain = new Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
              width: 1,
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(10.0) //         <--- border radius here
                ),
            gradient: LinearGradient(
              colors: [backgroundPrimary, backgroundPrimary],
              begin: Alignment(-1.0, -2.0),
              end: Alignment(1.0, 2.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              "Captain",
              style: TextStyle(fontSize: textSize2, color: Colors.green),
            ),
          ),
        );
        if (statuscap == true) {
          datalihat = statuscaptain;
        } else {
          datalihat = Container();
        }
        // final avatarUrlnew = "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/a161727e-91f5-4896-b41b-4d9f1853950a.png";
        return Padding(
          padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: itemWidthteammemberslist,
                child: Row(
                  children: <Widget>[
                    Container(
                        width: itemWidthteammemberslist,
                        height: itemWidthteammemberslist,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(avatarmembers)))),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      username,
                      style: TextStyle(
                          fontSize: textSize1,
                          color: textColor2,
                          fontWeight: FontWeight.bold),
                      // fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              datalihat
            ],
          ),
        );
      },
    ));

    var shimmerTeamMembers = Shimmer.fromColors(
      baseColor: colorShimer,
      // highlightColor: Colors.grey[300],
      // baseColor: Colors.grey[100],
      highlightColor: colorlightShimer,
      // direction: ,

      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: itemWidthteammemberslist,
              child: Row(
                children: <Widget>[
                  Container(
                      width: itemWidthteammemberslist,
                      height: itemWidthteammemberslist,
                      decoration: new BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(
                                20.0) //         <--- border radius here
                            ),
                      )),
                  SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                    width: itemWidthteammemberslistname,
                    height: 10.0,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(color: Colors.red),
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0) //         <--- border radius here
                    ),
                gradient: LinearGradient(
                  colors: [backgroundPrimary, backgroundPrimary],
                  begin: Alignment(-1.0, -2.0),
                  end: Alignment(1.0, 2.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "captain",
                  style: TextStyle(fontSize: textSize2, color: Colors.green),
                ),
              ),
            )
          ],
        ),
      ),
    );

    Widget _teammembers() {
      if (listDataMembers.length != 0) {
        return Container(
          // height: itemHeight,
          width: itemWidthteammembers,
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
            child: Container(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[dataTeamMembers],
              ),
            ),
          ),
        );
      } else {
        return Container(
          // height: itemHeight,
          width: itemWidthteammembers,
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
            child: Container(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[shimmerTeamMembers, shimmerTeamMembers],
              ),
            ),
          ),
        );
      }
    }

    Widget _profile() {
      return Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(5.0),
              // padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              color: backgroundSecond,
              child: Row(
                children: <Widget>[
                  new Container(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                    height: itemWidth,
                    width: itemWidth,
                    child: new Container(
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: new Hero(
                          tag: widget.id,
                          // child: new InkWell(
                          child: Container(
                            color: Color(0xFF151a1d),
                            child: new Image.network(widget.images),
                          ),
                          // ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 10.0, bottom: 5.0),
                    // color: Colors.amber,
                    width: itemWidthCustom,
                    height: itemWidth,
                    child: new Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.nama,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: textColor2,
                                    fontWeight: FontWeight.bold),
                                // fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.nama,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: textColor1,
                                    fontWeight: FontWeight.bold),
                                // fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  RaisedButton(
                                    child: new Text("Share Profile"),
                                    color: backgroundYellow,
                                    // elevation: 10.0,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(8.0)),
                                    onPressed: () {
                                      // Navigator.of(context).pop();
                                    },
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  RaisedButton(
                                    child: new Text(
                                      "Leave",
                                      style: TextStyle(
                                          color: textColor2,
                                          fontWeight: FontWeight.bold),
                                      // fontWeight: FontWeight.bold),
                                    ),
                                    color: colorButtonAbu,
                                    // elevation: 10.0,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(8.0)),
                                    onPressed: () {
                                      // Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    var dataTeamDetail = Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: backgroundSecond),

        width: itemWidthCustumwinrate,
        height: itemWidthwinrate,
        // color: backgroundSecond,
        child: Row(
          children: <Widget>[
            new Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0),
                  ),
                  // boxShadow: [
                  //   new BoxShadow(
                  //       color: Color(0xffffd500),
                  //       offset: new Offset(0.0, 0.0),
                  //       blurRadius: 2.0,
                  //       spreadRadius: 0.5)
                  // ],
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange, backgroundYellow],
                    begin: Alignment(1.0, 2.0),
                    end: Alignment(-1.0, -1.0),
                  ),
                ),
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                height: itemWidthwinrate,
                width: itemHeightwinrate,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "WIN RATE",
                      style: TextStyle(
                          fontSize: textSize2,
                          color: Colors.black,
                          fontFamily: 'ProximaBold',
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "-",
                      style: TextStyle(
                          fontSize: textSize4,
                          color: Colors.black,
                          fontFamily: 'ProximaBold',
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Container(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
              // color: Colors.amber,
              height: itemWidthwinrate,
              width: itemWidthwinrate2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                // crossAxisAlignment: CrossAxisAlignment.,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "TOTAL MATCHES",
                        style: TextStyle(
                            fontSize: textSize3,
                            color: textColor1,
                            fontWeight: FontWeight.bold),
                        // fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "-",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: textColor1,
                            fontWeight: FontWeight.bold),
                        // fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "FORM",
                        style: TextStyle(
                            fontSize: textSize3,
                            color: textColor1,
                            fontWeight: FontWeight.bold),
                        // fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "-",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: textColor1,
                            fontWeight: FontWeight.bold),
                        // fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      // );

      //   },
      // )
    );

    var shimmerTeamDetail = Shimmer.fromColors(
      baseColor: colorShimer,
      // highlightColor: Colors.grey[300],
      // baseColor: Colors.grey[100],
      highlightColor: colorlightShimer,
      // direction: ,

      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: itemWidthteammemberslist,
              child: Row(
                children: <Widget>[
                  Container(
                      width: itemWidthteammemberslist,
                      height: itemWidthteammemberslist,
                      decoration: new BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(
                                20.0) //         <--- border radius here
                            ),
                      )),
                  SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                    width: itemWidthteammemberslistname,
                    height: 10.0,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(color: Colors.red),
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0) //         <--- border radius here
                    ),
                gradient: LinearGradient(
                  colors: [backgroundPrimary, backgroundPrimary],
                  begin: Alignment(-1.0, -2.0),
                  end: Alignment(1.0, 2.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "captain",
                  style: TextStyle(fontSize: textSize2, color: Colors.green),
                ),
              ),
            )
          ],
        ),
      ),
    );

    Widget _winrate() {
      if (listDataMembers.length != 0) {
        return Container(
          child: dataTeamDetail,
        );
      } else {
        return Container(
          child: shimmerTeamDetail,
        );
      }
    }

    var dataRecentMatch = new Container(
      // padding: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: new Container(
        padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
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
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0)),
                  color: Color(0xFF192024),
                ),
                height: 60.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Lorem Ipsum Dolor",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: textColor1,
                                ),
                                // fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "20 Mar 18",
                            style: TextStyle(fontSize: 14.0, color: textColor1),
                            // fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "07:00",
                            style: TextStyle(fontSize: 14.0, color: textColor1),
                            // fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  new Image.asset("assets/images/categori_GameConnect.png",
                      fit: BoxFit.cover, width: itemWidthDailyupcoming),
                  Expanded(
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Daily Mission Number 1",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: textColor1,
                                  fontWeight: FontWeight.bold),
                              // fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "0",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: textColor1,
                          fontWeight: FontWeight.bold),
                      // fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  new Image.asset("assets/images/categori_GameConnect.png",
                      fit: BoxFit.cover, width: itemWidthDailyupcoming),
                  Expanded(
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Daily Mission Number 1",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: textColor1,
                                  fontWeight: FontWeight.bold),
                              // fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "2",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: textColor1,
                          fontWeight: FontWeight.bold),
                      // fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    var shimmerUpcomingmatch = Container(
      padding:
          const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
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
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0)),
                color: Color(0xFF192024),
              ),
              height: 60.0,
              child: Shimmer.fromColors(
                baseColor: colorShimer,
                // highlightColor: Colors.grey[300],
                // baseColor: Colors.grey[100],
                highlightColor: colorlightShimer,
                // direction: ,

                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: itemWidthteammemberslistname + 40,
                                height: 20.0,
                                child: const DecoratedBox(
                                  decoration:
                                      const BoxDecoration(color: Colors.red),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: itemWidthteammemberslistname - 20,
                            height: 10.0,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.red),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          SizedBox(
                            width: itemWidthteammemberslistname - 40,
                            height: 10.0,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: colorShimer,
              // highlightColor: Colors.grey[300],
              // baseColor: Colors.grey[100],
              highlightColor: colorlightShimer,
              // direction: ,

              child: Row(
                children: <Widget>[
                  new Image.asset("assets/images/icon.png",
                      fit: BoxFit.cover, width: itemWidthDailyupcoming),
                  Expanded(
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: itemWidthteammemberslistname,
                              height: 10.0,
                              child: const DecoratedBox(
                                decoration:
                                    const BoxDecoration(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 20.0,
                      height: 10.0,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Shimmer.fromColors(
              baseColor: colorShimer,
              // highlightColor: Colors.grey[300],
              // baseColor: Colors.grey[100],
              highlightColor: colorlightShimer,
              // direction: ,

              child: Row(
                children: <Widget>[
                  new Image.asset("assets/images/icon.png",
                      fit: BoxFit.cover, width: itemWidthDailyupcoming),
                  Expanded(
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: itemWidthteammemberslistname,
                              height: 10.0,
                              child: const DecoratedBox(
                                decoration:
                                    const BoxDecoration(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 20.0,
                      height: 10.0,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    Widget _recentmatch() {
      if (listDataMembers.length != 0) {
        return dataRecentMatch;
      } else {
        return shimmerUpcomingmatch;
      }
    }

    Widget _sparator(String nama) {
      return Container(
        height: 45.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              nama,
              style: TextStyle(
                fontSize: 16.0,
                color: textColor1,
              ),
              // fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF22272B),
        title: const Text('Team profile'),
        actions: <Widget>[],
      ),
      body: Container(
        height: double.infinity,
        color: backgroundPrimary,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              _profile(),
              SizedBox(
                height: paddingwinrate,
              ),
              _winrate(),
              // _sparator("Recent Achievements"),
              // _achievementnew(),
              _sparator("Team Members"),
              _teammembers(),
              // _sparator("Recent Match"),
              // _recentmatch()
            ],
          ),
        ),
      ),
    );
  }
}
