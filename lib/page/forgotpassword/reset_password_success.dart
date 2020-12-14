import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/page/login/login.dart';
import 'package:yamisok/page/utilities/color.dart';
FirebaseAnalytics analytics = FirebaseAnalytics();


class ResetPasswordSuccessPage extends StatefulWidget{

  static String tag = 'reset-password-success-page';

  @override
  _ResetPasswordSuccessState createState() => _ResetPasswordSuccessState();

}

class _ResetPasswordSuccessState extends State<ResetPasswordSuccessPage>{

  @override
  void initState() {
    // fetchDataInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    analytics.logEvent(name: 'Reset_password_succes');
    super.initState();

  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // listDataMembers.clear();
    // _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _parent(),
    );
  }

  Widget _parent(){
    return Container(
      padding: EdgeInsets.all(16.0),
      color: backgroundPrimary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: _description(),
          ),
          Container(
            child: _buttonLogin(),
          ),
        ],
      ),
    );
  }

  Widget _description(){
    var height = MediaQuery.of(context).size.height;
    var description = new RichText(
      textAlign: TextAlign.center,
      text: new TextSpan(
        text: 'Kata sandi berhasil diubah. Silahkan masuk kembali dengan kata sandi yang baru.',
        style: new TextStyle(
          fontSize: 16,
          color: textColor1,
        ),
      ),
    );

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 30, top: height * 0.33),
      width: MediaQuery.of(context).size.width * 0.8,
      child: description,
    );

  }

  Widget _buttonLogin(){

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width * 0.9,
        height: 50.0,
        child: RaisedButton(
          child: Text('Masuk kembali'),
          textColor: Colors.black,
          color: accent,
          disabledTextColor: buttonDisabledText,
          disabledColor: buttonDisabledBackgroud,
          onPressed: (){
            setLatestPage('null');
            Navigator.of(context).pushNamedAndRemoveUntil(LoginSignUpPage.tag, (Route<dynamic> route) => false);
          },

        ),
      ),
    );

  }

}