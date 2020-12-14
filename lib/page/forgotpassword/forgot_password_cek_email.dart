import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yamisok/api/forgotpassword/forgot_password_validate_email_api.dart';
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/page/forgotpassword/reset_password.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:quiver/async.dart';
FirebaseAnalytics analytics = FirebaseAnalytics();

class ForgotPasswordCekEmailPage extends StatefulWidget{

  static String tag = 'forgot-password-cek-email-page';

  @override
  _ForgotPasswordCekEmailPageState createState() => _ForgotPasswordCekEmailPageState();

}

class _ForgotPasswordCekEmailPageState extends State<ForgotPasswordCekEmailPage>{

  static int COUNTDOWN_TIMER = 30;
  String email = '';
  int _current = COUNTDOWN_TIMER;
  bool ableToResend = false;

  //Event Channel creation
  static const stream = const EventChannel('https.yamisok.com/events');

  StreamController<String> _stateController = StreamController();
  Stream<String> get state => _stateController.stream;
  Sink<String> get stateSink => _stateController.sink;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    fetchEmail();
    startCountDown();
    stream.receiveBroadcastStream().listen((appLink) => _onRedirected(appLink));
    analytics.logEvent(name: 'Forgot_passwors_email');

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
    return Scaffold(
        appBar: AppBar(
            title: Text("Kembali ke login"),
            backgroundColor: backgroundPrimary,
            leading: IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.white),
              onPressed: (){
                Navigator.pop(context);
              },
            )
        ),
        body: _Parent()
    );

  }

  Widget _Parent(){
    return Container(
      padding: EdgeInsets.all(16.0),
      color: backgroundPrimary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                _Description()
              ],
            ),
          ),
          Container(
            child: ableToResend ? _ResendButton() : _Countdown(),
          ),
        ],
      ),
    );
  }

  Widget _Description(){
    var description = new RichText(
      textAlign: TextAlign.center,
      text: new TextSpan(
        text: 'Silahkan cek email kamu. Kami telah mengirimkan tautan untuk mengatur ulang kata sandi ke ',
        style: new TextStyle(
          fontSize: 16,
          color: textColor1,
        ),
        children: <TextSpan>[
          new TextSpan(
            text: email,
            style: new TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 30, top: 50),
      width: MediaQuery.of(context).size.width * 0.8,
      child: description,
    );

  }

  Widget _Countdown(){

    var textTimer = new RichText(
      textAlign: TextAlign.center,
      text: new TextSpan(
        text: 'Kirim ulang email dalam ',
        style: new TextStyle(
          fontSize: 16,
          color: textColor1,
        ),
        children: <TextSpan>[
          new TextSpan(
            text: "$_current detik",
            style: new TextStyle(
              color: accent,
            ),
          ),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
      width: MediaQuery.of(context).size.width * 0.9,
      child: textTimer,
    );

  }

  Widget _ResendButton(){
    var textResend = new RichText(
      text: new TextSpan(
        text: 'Belum menerima email? Kirim ulang',
        style: new TextStyle(
          fontSize: 16,
          color: accent,
        ),
      ),
    );

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _resendEmailValidation();
            },
            child: textResend,
          ),
        ],
      ),
    );
  }

  fetchEmail() async {
    email = await keyStore.getEmail();
  }

  void startCountDown(){
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: COUNTDOWN_TIMER),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      if(mounted){
        setState(() {
          _current = COUNTDOWN_TIMER - duration.elapsed.inSeconds;
        });
      }
    });

    sub.onDone(() {
      if(mounted){
        setState(() {
          ableToResend = true;
        });
      }
      sub.cancel();
    });
  }

  _resendEmailValidation() {

    setState(() {
      ableToResend = false;
      _current = COUNTDOWN_TIMER;
      startCountDown();
    });

    ApiServiceForgotPasswordValidateEmail.resendValidation(email).then((result) async{

      var data = json.decode(result);
      var status = data['status'];

      print('data $data');

      if(status == 200){

        var token = data['token'];
        setResetPasswordToken(token);
//        _showToast(context, "Email sent");

      }else{

        var message = data['messages'];
//       _showToast(context, message);
      }
    });
  }

  _onRedirected(String appLink) {
    try {
      var uri = Uri.parse(appLink);
      var path = uri.path.substring(1);

      if (path == "reset_password") {
        var email = uri.queryParameters['email'];
        var token = uri.queryParameters['token'];

        _validateResetPassword(email, token);
      }
    } on PlatformException catch (e) {
      // return error, pretend nothing happen LMAO
      print('method channel error: $e');
    }
  }

  _validateResetPassword(String email, String token) async {
    keyStore.getResetPasswordToken().then((savedToken) {
      print("saved_token: $savedToken token: $token email: $email ");

      if (savedToken == token)
        Navigator.pushReplacementNamed(context, ResetPasswordPage.tag);

    });
  }
}
