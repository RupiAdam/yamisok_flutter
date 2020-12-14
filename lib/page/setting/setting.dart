import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yamisok/api/online_status/set_status_online_api.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:quiver/async.dart';
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/page/utilities/style.dart';

import 'package:yamisok/page/privacy-policy/privacy_and_policy_setting.dart';
import 'package:yamisok/page/term_and_condition/term_and_condition_setting.dart';
import 'package:yamisok/page/faq/faq_webview.dart';
import 'package:yamisok/page/report/report_webview.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yamisok/page/login/login.dart';
import 'package:yamisok/component/globals.dart' as globals;


FirebaseAnalytics analytics = FirebaseAnalytics();

class SettingPage extends StatefulWidget {
  static String tag = 'notification-update-page';
  final String data;

  const SettingPage({Key key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  int playerId;
  String username = "";
  String token = "";
  var versionApps='';


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
    //  apiAchive();

    analytics.logEvent(name: 'Setting');

    var majorAndroid = globals.majorAndroid;
    var minorAndroid = globals.minorAndroid;
    var patchAndroid = globals.patchAndroid;
    var buildAndroid=globals.buildAndroid;
    var incrementAndroid = globals.incrementAndroid;


    var majorIOS = globals.majorIOS;
    var minorIOS = globals.minorIOS;
    var patchIOS = globals.patchIOS;
    var buildIOS=globals.buildIOS;
    var incrementIOS = globals.incrementIOS;


     if (Platform.isAndroid) {
       versionApps='$majorAndroid.$minorAndroid.$patchAndroid-$buildAndroid.$incrementAndroid';
     }else{
       versionApps='$majorIOS.$minorIOS.$patchIOS-$buildIOS.$incrementIOS';
      
     }
    
   
    setapistatusonline();
  }

  @override
  dispose() {
     SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: backgroundPrimary,
          title: Center(
            child: new Text(
              "Settings",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        body: Container(
          height: mediaquery.height,
          color: backgroundPrimary,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical, child: parent()),
        ));
  }

  parent() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(16.0),
      color: backgroundPrimary,
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          divReport(),
          Container(
            width: mediaquery.width,
            margin: EdgeInsets.only(bottom: 10.0, top: 20.0),
            child: Text(
              "Bantuan",
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: mediaquery.width / textSize16sp,
                  fontFamily: "ProximaBold"),
            ),
          ),
          divButton(),
          btnLogout(),
          SizedBox(
            height: mediaquery.width / 40,
          ),
          Container(
            width: mediaquery.width,
            child: Text(
              versionApps,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: textColor2,
                fontSize: mediaquery.width / textSize12sp,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget divReport() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      width: mediaquery.width,
      // height: mediaquery.height / 3.5,
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: mediaquery.width / 2,
              child: new Image.asset("assets/images/settings/emoticon.png")),
          SizedBox(
            height: mediaquery.width / 30,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Kirimkan pendapat kamu mengenai versi',
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: mediaquery.width / textSize14sp,
                        fontFamily: 'ProximaRegular')),
                Text('uji coba mobile apps Yamisok',
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: mediaquery.width / textSize14sp,
                        fontFamily: 'ProximaRegular'))
              ],
            ),
          ),
          SizedBox(
            height: mediaquery.width / 30,
          ),
          btnSuggest()
        ],
      ),
    );
  }

  Widget btnSuggest() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportWebview()),
              );
            },
            child: Text('Beri masukan',
                style: new TextStyle(
                    fontSize: mediaquery.width / textSize16sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ProximaRegular'))),
      ),
    );
  }

  Widget divButton() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
        width: mediaquery.width,
        // height: mediaquery.height / 4.4,
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 0),
        decoration: BoxDecoration(
            color: backgroundAbu,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrivacyAndPolicySettingPage()),
                );
              },
              child: Container(
                width: mediaquery.width,
                height: mediaquery.height / 20,
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(width: 0.5, color: textColor1)),
                ),
                child: Text(
                  "Aturan dan privasi",
                  style: TextStyle(
                    fontSize: mediaquery.width / textSize16sp,
                    fontFamily: "ProximaRegular",
                    color: textColor2,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: mediaquery.width / 30,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TermAndConditionSettingPage()),
                );
              },
              child: Container(
                width: mediaquery.width,
                height: mediaquery.height / 20,
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(width: 0.5, color: textColor1)),
                ),
                child: Text(
                  "Syarat dan ketentuan",
                  style: TextStyle(
                    fontSize: mediaquery.width / textSize16sp,
                    fontFamily: "ProximaRegular",
                    color: textColor2,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: mediaquery.width / 30,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQWebview()),
                );
              },
              child: Container(
                width: mediaquery.width,
                height: mediaquery.height / 20,
                child: Text(
                  "F.A.Q ",
                  style: TextStyle(
                    fontSize: mediaquery.width / textSize16sp,
                    fontFamily: "ProximaRegular",
                    color: textColor2,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget btnLogout() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      width: mediaquery.width,
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
          color: backgroundAbu,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: InkWell(
        onTap: () => _asyncConfirmDialog(context).then((rst) {
          if (rst == ConfirmAction.ACCEPT) logout(context);
        }),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(10.0) //         <--- border radius here
                ),
          ),
          child: Text(
            "Keluar",
            style: TextStyle(
              fontSize: mediaquery.width / textSize16sp,
              color: textColor2,
            ),
          ),
        ),
      ),
    );
  }

  fetchStore() async {
    playerId = await keyStore.getPlayerId();
    username = await keyStore.getUsername();
    token = await keyStore.getToken();
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
  setLogout().then((val) {
    print("reset token logout sucess");
    // Navigator.pop(context);
    keyStore.getToken().then((rst) {
      print("THEN CEK TOKENNYA : $rst");
      disableLandingPage();
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
            textColor: backgroundYellow,
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
