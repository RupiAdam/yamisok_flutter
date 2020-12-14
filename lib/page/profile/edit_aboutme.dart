import 'dart:async';
import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yamisok/component/globals.dart';
import 'package:yamisok/page/login/login.dart';
// import 'package:yamisok/page/profile/profile.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:quiver/async.dart';
import 'package:yamisok/component/keyStore.dart';

import 'package:yamisok/api/profile/profile_edit_aboutme_api.dart';

import '../utilities/style.dart';

bool isDisableBtn = false;
FirebaseAnalytics analytics = FirebaseAnalytics();

class EditAboutMe extends StatefulWidget {
  static String tag = 'edit-aboutme-page';
  final String data;

  const EditAboutMe({Key key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditAboutMeState();
  }
}

class _EditAboutMeState extends State<EditAboutMe> {
  String msgError = "";

  String username = "";
  String token = "";

  static int maxLength = 2000;
  int charCount = 0;

  bool isError = false;
  bool isLoadSave = false;

  final TextEditingController aboutMeController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    fetchStore();
    aboutMeController.text = widget.data;
    analytics.logEvent(name: 'Edit_aboutme');
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
        appBar: AppBar(
            title: Text("Tentang Saya"),
            backgroundColor: backgroundPrimary,
            leading: IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: parent());
  }

  Widget parent() {
    return Container(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      color: backgroundPrimary,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[txtAboutMe(), lblCharCount()],
            ),
          ),
          Container(
              child: Column(
            children: <Widget>[showErrorMessage(), statusButton()],
          )),
        ],
      ),
    );
  }

  Widget txtAboutMe() {
    var mediaquery = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      height: mediaquery.height / 2,
      child: Container(
        child: TextField(
          controller: aboutMeController,
          autofocus: true,
          style: TextStyle(
              color: textColor2,
              fontSize: mediaquery.width / textSize14sp,
              fontFamily: 'ProximaReguler'),
          maxLines: 100,
          keyboardType: TextInputType.multiline,
          decoration: new InputDecoration(
              hintStyle:
                  TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
              hintText: 'Write Description About Yourself',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 0.5, color: textColor1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 0.5, color: textColor1),
              ),
              counterText: ''),
          maxLength: maxLength,
          onChanged: _onChanged,
        ),
      ),
    );
  }

  Widget lblCharCount() {
    var mediaquery = MediaQuery.of(context).size;
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
          width: (MediaQuery.of(context).size.width * 1) - 40,
          child: Text(
              charCount.toString() + ' / ' + maxLength.toString() + ' Karakter',
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: textColor1,
                  fontFamily: 'ProximaRegular')),
        )
      ],
    );
  }

  Widget showErrorMessage() {
    var mediaquery = MediaQuery.of(context).size;

    if (isError) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              msgError,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaRegular',
                  color: Colors.red,
                  height: 1.0,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget btnDone() {
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
            saveAboutMe();
          },
          child: indicatorLoading(),
        ),
      ),
    );
  }

  Widget btnDoneDisabled() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      width: double.infinity,
      height: mediaquery.width / buttonHeight1,
      child: ButtonTheme(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
        ),
        buttonColor: backgroundDisable,
        minWidth: double.infinity,
        height: mediaquery.width / buttonHeight1,
        child: RaisedButton(
          onPressed: () {},
          child: Text('Selesai',
              style: new TextStyle(
                  fontSize: mediaquery.width / textSize17sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ProximaRegular')),
        ),
      ),
    );
  }

  Widget statusButton() {
    if (isDisableBtn == false) {
      return btnDone();
    } else {
      return btnDoneDisabled();
    }
  }

  Widget indicatorLoading() {
    var mediaquery = MediaQuery.of(context).size;
    if (isLoadSave == false) {
      return new Text('Selesai',
          style: new TextStyle(
              fontSize: mediaquery.width / textSize17sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'ProximaRegular'));
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      );
    }
  }

  fetchStore() async {
    username = await keyStore.getUsername();
    token = await keyStore.getToken();
  }

  void saveAboutMe() {
    setState(() {
      isLoadSave = true;
    });

    ApiServiceUpdateAboutme.updateAboutMe(
            username, token, aboutMeController.text)
        .then((result) async {
      var data = json.decode(result);
      var status = data['status'];

      print('data $data');

      if (status == 200) {
        setState(() {
          isLoadSave = false;
          isError = false;
          Navigator.pop(context, "succes");
        });
      } else {
        setState(() {
          msgError = "Maaf, sepertinya terjadi kesalahan jaringan";

          isLoadSave = false;
          isError = true;
        });
      }
    });
  }

  _onChanged(String value) {
    setState(() {
      charCount = value.length;
    });

    if (value.length != 0) {
      setState(() {
        isDisableBtn = false;
      });
    } else {
      setState(() {
        isDisableBtn = true;
      });
    }
  }
}
