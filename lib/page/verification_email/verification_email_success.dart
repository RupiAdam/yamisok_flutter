import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yamisok/page/game/connect_game.dart';
import 'package:yamisok/page/utilities/color.dart';

import '../utilities/style.dart';

class VerificationEmailSuccess extends StatefulWidget {
  static String tag = 'verification-email-success';

  @override
  State<StatefulWidget> createState() {
    return _VerificationEmailSuccessState();
  }
}

class _VerificationEmailSuccessState extends State<VerificationEmailSuccess> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
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
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: backgroundPrimary,
        child: parent(),
      ),
    );
  }

  Widget parent() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: backgroundPrimary,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 1.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[labelTitle(), labelDesc()],
            ),
          ),
          Container(
              child: Column(
            children: <Widget>[buttonFindFriend()],
          )),
        ],
      ),
    );
  }

  Widget labelTitle() {
    var mediaquery = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.only(left: 16.0, top: 6.0, right: 0.0, bottom: 10.0),
          child: Text('Selamat !',
              style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.bold,
                  fontSize: mediaquery.width / textSize20sp,
                  fontFamily: 'ProximaRegular')),
        ),
      ],
    );
  }

  Widget labelDesc() {
    var mediaquery = MediaQuery.of(context).size;
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 10),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
              'Email kamu telah terverifikasi dan silahkan menggunakan fitur Yamisok untuk mendapatkan pengalaman baru dalam bermain game bareng teman baru.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize16sp,
                  color: textColor1,
                  fontFamily: 'ProximaRegular')),
        )
      ],
    );
  }

  Widget buttonFindFriend() {
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
            Navigator.pushReplacementNamed(context, ConnectGame.tag);
          },
          child: new Text('Mulai cari teman',
              style: new TextStyle(
                  fontSize: mediaquery.width / textSize17sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ProximaRegular')),
        ),
      ),
    );
  }
}
