import 'dart:async';
import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yamisok/api/online_status/set_status_online_api.dart';
import 'package:yamisok/component/globals.dart';
import 'package:yamisok/component/styleyami.dart' as prefix0;
import 'package:yamisok/page/login/login.dart';
// import 'package:yamisok/page/profile/profile.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:quiver/async.dart';
import 'package:yamisok/component/keyStore.dart';

import 'package:yamisok/api/notification_update/notification_update_api.dart';

import '../utilities/style.dart';
import 'package:yamisok/component/styleyami.dart' as yamiStyle;



FirebaseAnalytics analytics = FirebaseAnalytics();


class NotificationUpdate extends StatefulWidget {
  static String tag = 'notification-update-page';
  final String data;

  const NotificationUpdate({Key key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NotificationUpdateState();
  }
}

class _NotificationUpdateState extends State<NotificationUpdate> {
  ScrollController scrollControllerNotif = ScrollController();
  ScrollController scrollControllerUpdate = ScrollController();

  // var dataNotification = [
  //   {
  //     "type": "tournament-reminder",
  //     "status": "ongoing",
  //     "description1": "Yamisok Mobile Legends",
  //     "description2": "ZenFighter",
  //     "created_at": "1 jam lagi"
  //   },
  //   {
  //     "type": "following-me",
  //     "status": "",
  //     "description1": "Balthazar, Meaw dan 25 lainnya",
  //     "description2": "",
  //     "created_at": "Hari ini 11:27",
  //   },
  //   {
  //     "type": "endorse-me",
  //     "status": "",
  //     "description1": "Deus dan 4 lainnya",
  //     "description2": "Marksman Mobile Legends",
  //     "created_at": "Hari ini 10:30",
  //   },
  //   {
  //     "type": "endorse-me",
  //     "status": "",
  //     "description1": "Lex dan 2 lainnyah",
  //     "description2": "Marksman Mobile Legends",
  //     "created_at": "Kemarin, 9:20",
  //   },
  //   {
  //     "type": "following-me",
  //     "status": "",
  //     "description1": "Rawrzigg",
  //     "description2": "",
  //     "created_at": "14 Dec 2019, 11:27",
  //   },
  //   {
  //     "type": "tournament-reminder",
  //     "status": "done",
  //     "description1": "Yamisok Mobile Legends",
  //     "description2": "ZendayaSquad",
  //     "created_at": "14 Dec 2019"
  //   }
  // ];

  var dataUpdate = [
    {
      "description":
          "Berani lawan Udiil dkk dari Team Onic? Ayo daftar MOBILE LEGENDS Pro Challenge Series x ONIC e-Sport",
      "created_at": "Hari ini, 11:27"
    },
    {
      "description":
          "Ada yang baru di Yamisok! Join Daily Raffle dan dapatkan kesempatan memenangkan hadian harian khusus",
      "created_at": "14 Dec 2019"
    },
    {
      "description":
          "Announcement: Ayo, check weekly tournament Yamisok untuk minggu depan dan ajak teman-temanmu untuk...",
      "created_at": "12 Dec 2019"
    }
  ];

  var dataListNotif = [];
  var dataListUpdate = [];

  int playerId;
  String username = "";
  String token = "";

  int pageNotif = 10;
  int pageUpdate = 10;

  bool isLoadNotif = false;
  bool isLoadUpdate = false;

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
    fetchInitNotification();
    fetchInitUpdate();
    setapistatusonline();
    // analytics.setCurrentScreen(screenName: "/page_notifikasi");
    analytics.logEvent(name: 'Notifikasi');


    scrollControllerNotif.addListener(() {
      if (scrollControllerNotif.offset >=
              scrollControllerNotif.position.maxScrollExtent &&
          !scrollControllerNotif.position.outOfRange) {
        print('reach the bottoms');
        if (isLoadNotif == false) {
          setState(() {
            isLoadNotif = true;
          });
          ApiServiceNotificationUpdate.getNotificationMore(
                  playerId.toString(), pageNotif.toString(), token)
              .then((result) async {
            var data = json.decode(result);
            var status = data['status'];

            print('data $data');

            if (status == 200) {
              setState(() {
                pageNotif = pageNotif + 10;
                isLoadNotif = false;
                dataListNotif.addAll(data['data']);
                print('reach data');
              });
            } else {}
          });
        }
      }

      if (scrollControllerNotif.offset <=
              scrollControllerNotif.position.minScrollExtent &&
          !scrollControllerNotif.position.outOfRange) {
        print('reach the top');
      }
    });

    scrollControllerUpdate.addListener(() {
      if (scrollControllerUpdate.offset >=
              scrollControllerUpdate.position.maxScrollExtent &&
          !scrollControllerUpdate.position.outOfRange) {
        print('reach the bottoms');
        if (isLoadNotif == false) {
          setState(() {
            isLoadNotif = true;
          });
          ApiServiceNotificationUpdate.getUpdateMore(
                  playerId.toString(), pageUpdate.toString(), token)
              .then((result) async {
            var data = json.decode(result);
            var status = data['status'];

            print('data $data');

            if (status == 200) {
              setState(() {
                pageUpdate = pageUpdate + 10;
                isLoadNotif = false;
                dataListNotif.addAll(data['data']);
                print('reach data');
              });
            } else {}
          });
        }
      }

      if (scrollControllerUpdate.offset <=
              scrollControllerUpdate.position.minScrollExtent &&
          !scrollControllerUpdate.position.outOfRange) {
        print('reach the top');
      }
    });
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
    var mediaquery = MediaQuery.of(context).size;

    // return new MaterialApp(
    //   home: DefaultTabController(
    //     length: 2,
    //     child: Scaffold(
    //         appBar: AppBar(
    //           elevation: 0,
    //           bottom: TabBar(
    //             indicatorSize: TabBarIndicatorSize.label,
    //             labelColor: Colors.white,
    //             indicatorColor: Colors.white,
    //             unselectedLabelColor: textColor1,
    //             tabs: [Tab(text: "Notifikasi"), Tab(text: "Update")],
    //           ),
    //           title: Center(
    //             child: new Text(
    //               "Notifications",
    //               textAlign: TextAlign.center,
    //             ),
    //           ),
    //           backgroundColor: backgroundPrimary,
    //         ),
    //         body: parent()),
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundPrimary,
        title: Center(
          child: new Text(
            "Notifications",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              bottom: PreferredSize(
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.white,
                  indicatorColor: Colors.white,
                  unselectedLabelColor: textColor1,
                  tabs: <Widget>[
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 15.0,
                        ),
                        child: new Text(
                          "Notifikasi",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: mediaquery.width / textSize14sp,
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 15.0,
                        ),
                        child: new Text(
                          "Update",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: mediaquery.width / textSize14sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                preferredSize: Size.fromHeight(-8.0),
              ),
              backgroundColor: backgroundPrimary,
            ),
            body: parent(),
          ),
        ),
      ),
    );
  }

  parent() {
    var mediaquery = MediaQuery.of(context).size;

    return TabBarView(
      children: [
        Container(
            width: mediaquery.width,
            padding: EdgeInsets.only(right: 16.0, left: 16.0),
            color: backgroundPrimary,
            child: listingNotif(dataListNotif)),
        Container(
            width: mediaquery.width,
            padding: EdgeInsets.only(right: 16.0, left: 16.0),
            color: backgroundPrimary,
            child: listingUpdate(dataListUpdate)),
      ],
    );
  }

  Widget listingNotif(List<dynamic> dataNotification) {
    if (dataNotification.length > 0) {
      return ListView.builder(
        padding: EdgeInsets.only(top: 20.0),
        controller: scrollControllerNotif,
        itemBuilder: (context, index) {
          return statusRowNotif(
              // dataNotification[index]['type'],
              // dataNotification[index]['status'],
              // dataNotification[index]['description1'],
              // dataNotification[index]['description2'],
              // dataNotification[index]['created_at']);
              dataNotification[index]['type'],
              dataNotification[index]['message'],
              dataNotification[index]['created_at']);
        },
        itemCount: dataNotification.length,
      );
    } else {
      return shimmerNotification;
    }
  }

  Widget listingUpdate(List<dynamic> dataUpdate) {
    if (dataUpdate.length > 0) {
      return ListView.builder(
        padding: EdgeInsets.only(top: 20.0),
        controller: scrollControllerUpdate,
        itemBuilder: (context, index) {
          return statusRowUpdate(
              // dataUpdate[index]['type'],
              // dataUpdate[index]['status'],
              // dataUpdate[index]['description1'],
              // dataUpdate[index]['description2'],
              // dataUpdate[index]['created_at']);
              dataUpdate[index]['text_announcement'],
              dataUpdate[index]['created_at']);
        },
        itemCount: dataUpdate.length,
      );
    } else {
      return shimmerUpdate;
    }
  }

  var shimmerNotification = Padding(
    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
    child: Shimmer.fromColors(
        baseColor: yamiStyle.colorShimer,
        highlightColor: yamiStyle.colorlightShimer,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 60,
              color: backgroundPrimary,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 60,
              color: backgroundPrimary,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 60,
              color: backgroundPrimary,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 60,
              color: backgroundPrimary,
            ),
          ],
        )),
  );

  var shimmerUpdate = Padding(
    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
    child: Shimmer.fromColors(
        baseColor: yamiStyle.colorShimer,
        highlightColor: yamiStyle.colorlightShimer,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 60,
              color: backgroundPrimary,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 60,
              color: backgroundPrimary,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 60,
              color: backgroundPrimary,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 60,
              color: backgroundPrimary,
            ),
          ],
        )),
  );

  Widget reminderText() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: mediaquery.width / 30,
            width: mediaquery.width / 30,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF34424e),
                  width: 1,
                ),
                color: Colors.red,
                shape: BoxShape.circle),
          ),
          Text(
            " Pengingat Turnamen",
            style: TextStyle(
                fontSize: mediaquery.width / textSize12sp,
                color: textColor2,
                fontFamily: 'ProximaRegular'),
          ),
        ],
      ),
    );
  }

  Widget dateTimeLabelOngoing(valueText) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            valueText,
            style: TextStyle(
                fontSize: mediaquery.width / textSize12sp,
                color: prefix0.yamiyelowColor,
                fontFamily: 'ProximaRegular'),
          ),
        ],
      ),
    );
  }

  Widget dateTimeLabel(valueText) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            valueText,
            style: TextStyle(
                fontSize: mediaquery.width / textSize12sp,
                color: textColor2,
                fontFamily: 'ProximaRegular'),
          ),
        ],
      ),
    );
  }

  Widget statusRowNotif(type, message, dateTime) {
    // if (type == "tournament-reminder") {
    //   if (status == "ongoing") {
    //     return rowNotifTournamentOngoing(
    //         description1, description2, createdAt, status);
    //   } else {
    //     return rowNotifTournamentDone(
    //         description1, description2, createdAt, status);
    //   }
    // } else if (type == "following-me") {
    //   return rowNotifFollowers(description1, createdAt);
    // } else if (type == "endorse-me") {
    //   return rowNotifEndorse(description1, description2, createdAt);
    // }
    return rowNotifSimple(message, dateTime.toString());
  }

  Widget statusRowUpdate(message, dateTime) {
    return rowUpdateDescInformation(message, dateTime.toString());
  }

  // NOTIF TOURNAMENT
  Widget notifDescTournament(myTeam, myEnemy) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: RichText(
              text: TextSpan(
                style: new TextStyle(
                  fontSize: mediaquery.width / textSize20sp,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Tim kamu ',
                      style: new TextStyle(color: textColor2)),
                  TextSpan(
                    text: myTeam,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text: ' bertanding melawan ',
                      style: new TextStyle(color: textColor2)),
                  TextSpan(
                    text: myEnemy,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowNotifTournamentOngoing(myTeam, myEnemy, dateTime, status) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: <Widget>[
          reminderText(),
          SizedBox(
            height: mediaquery.width / 50,
          ),
          notifDescTournament(myTeam, myEnemy),
          SizedBox(
            height: mediaquery.width / 50,
          ),
          dateTimeLabelOngoing(dateTime),
          Divider(
            thickness: 0.2,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  Widget rowNotifTournamentDone(myTeam, myEnemy, dateTime, status) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: <Widget>[
          reminderText(),
          SizedBox(
            height: mediaquery.width / 50,
          ),
          notifDescTournament(myTeam, myEnemy),
          SizedBox(
            height: mediaquery.width / 50,
          ),
          dateTimeLabel("Pertandingan telah selesai pada " + dateTime),
          Divider(
            thickness: 0.2,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  Widget statusRowNotifTournament(myTeam, myEnemy, dateTime, status) {
    if (status == "ongoing") {
      return rowNotifTournamentOngoing(myTeam, myEnemy, dateTime, status);
    } else {
      return rowNotifTournamentDone(myTeam, myEnemy, dateTime, status);
    }
  }

  // NOTIF FOLLOWERS
  Widget notifDescFollowers(personFollow) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: RichText(
              text: TextSpan(
                style: new TextStyle(
                  fontSize: mediaquery.width / textSize20sp,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: personFollow,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text: ' telah mengikuti kamu.',
                      style: new TextStyle(color: textColor2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowNotifFollowers(personFollow, dateTime) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: <Widget>[
          notifDescFollowers(personFollow),
          SizedBox(
            height: mediaquery.width / 50,
          ),
          dateTimeLabel(dateTime),
          Divider(
            thickness: 0.2,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  // NOTIF ENDORSE
  Widget notifDescEndorse(personEndorse, roleGame) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: RichText(
              text: TextSpan(
                style: new TextStyle(
                  fontSize: mediaquery.width / textSize20sp,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: personEndorse,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text: ' telah menambah endorse skill ',
                      style: new TextStyle(color: textColor2)),
                  TextSpan(
                    text: roleGame,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text: ' kamu.', style: new TextStyle(color: textColor2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowNotifEndorse(personEndorse, roleGame, dateTime) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: <Widget>[
          notifDescEndorse(personEndorse, roleGame),
          SizedBox(
            height: mediaquery.width / 50,
          ),
          dateTimeLabel(dateTime),
          Divider(
            thickness: 0.2,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  // NOTIF SIMPLE
  Widget notifDescSimple(descInformation) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: RichText(
              text: TextSpan(
                style: new TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: descInformation,
                      style: new TextStyle(color: textColor2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowNotifSimple(descInformation, dateTime) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: <Widget>[
          notifDescSimple(descInformation),
          SizedBox(
            height: mediaquery.width / 50,
          ),
          dateTimeLabel(dateTime),
          Divider(
            thickness: 0.2,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  // UPDATE INFORMATION
  Widget updateDescInformation(descInformation) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: RichText(
              text: TextSpan(
                style: new TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: descInformation,
                      style: new TextStyle(color: textColor2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowUpdateDescInformation(descInformation, dateTime) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: <Widget>[
          updateDescInformation(descInformation),
          SizedBox(
            height: mediaquery.width / 50,
          ),
          dateTimeLabel(dateTime),
          Divider(
            thickness: 0.2,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  fetchInitNotification() async {
    setState(() {
      isLoadNotif = true;
    });

    playerId = await keyStore.getPlayerId();
    username = await keyStore.getUsername();
    token = await keyStore.getToken();

    ApiServiceNotificationUpdate.getNotificationFirst(
            playerId.toString(), username, token)
        .then((result) async {
      var data = json.decode(result);
      var status = data['status'];

      print('data $data');

      if (status == 200) {
        setState(() {
          dataListNotif.addAll(data['data']);
          isLoadNotif = false;
        });
      } else {}
    });
  }

  fetchInitUpdate() async {
    setState(() {
      isLoadUpdate = true;
    });

    playerId = await keyStore.getPlayerId();
    username = await keyStore.getUsername();
    token = await keyStore.getToken();

    ApiServiceNotificationUpdate.getUpdateFirst(
            playerId.toString(), username, token)
        .then((result) async {
      var data = json.decode(result);
      var status = data['status'];

      if (status == 200) {
        setState(() {
          dataListUpdate.addAll(data['data']);
          isLoadUpdate = false;
        });
        print("dataListUpdate");
        print(dataListUpdate);
      } else {}
    });
  }
}
