import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yamisok/component/globals.dart';
import 'package:yamisok/page/login/login.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:quiver/async.dart';
import 'package:yamisok/component/keyStore.dart';

import 'package:yamisok/page/verification_email/verification_email_success.dart';

import 'package:yamisok/api/verification_email/send_verification_email_api.dart';

import '../utilities/style.dart';

class VerificationEmail extends StatefulWidget {
  static String tag = 'verification-email-page';

  @override
  State<StatefulWidget> createState() {
    return _VerificationEmailState();
  }
}

class _VerificationEmailState extends State<VerificationEmail> {
  String email = '';
  String msgError = '';

  static int countdownTimer = 30;
  int _current = countdownTimer;

  bool isError = false;
  bool ableToResend = false;
  bool _isButtonDisabled = false;
  int _state = 0;

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
    sendVerificationEmail();
    startCountDown();
    stream.receiveBroadcastStream().listen((appLink) => _onRedirected());
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
            title: Text("Kembali ke login"),
            backgroundColor: backgroundPrimary,
            leading: IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () {
                setLatestPage('null');
                Navigator.pushNamed(context, LoginSignUpPage.tag);
              },
            )),
        body: parent());
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
            child: Column(
              children: <Widget>[
                logoImage(),
                labelDesc(),
                labelEmail(email),
                showErrorMessage()
              ],
            ),
          ),
          Container(
              child: Column(
            children: <Widget>[
              buttonVerification(),
              SizedBox(
                height: 10,
              ),
              ableToResend ? labelResend() : labelCountdown(),
            ],
          )),
        ],
      ),
    );
  }

  Widget logoImage() {
    var size = MediaQuery.of(context).size;

    final double itemWidthpadding = (size.width) / 4;
    final double itemWidthpadding2 = itemWidthpadding / 4;
    final double itemWidth = (size.width) / 3;
    return Column(
      children: <Widget>[
        SizedBox(
          height: itemWidthpadding2,
        ),
        Container(
            width: itemWidth,
            child: new Image.asset(
                "assets/images/verification/verification-email.png")),
        SizedBox(
          height: itemWidthpadding2,
        )
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
              'Kami telah mengirimkan link untuk verifikasi akun Yamisok anda ke email.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize16sp,
                  color: textColor1,
                  fontFamily: 'ProximaRegular')),
        )
      ],
    );
  }

  Widget labelEmail(text) {
    var mediaquery = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.only(left: 16.0, top: 6.0, right: 0.0, bottom: 10.0),
          child: Text(text,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: mediaquery.width / textSize20sp,
                  fontFamily: 'ProximaRegular')),
        ),
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

  Widget buttonVerification() {
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
          onPressed: _isButtonDisabled
              ? null
              : () {
                  checkVerificationEmail();
                  // Navigator.pushNamed(context, VerificationEmailSuccess.tag);
                },
          child: _buttonIndicator(),
        ),
      ),
    );
  }

  Widget _buttonIndicator() {
    var mediaquery = MediaQuery.of(context).size;
    if (_state == 0) {
      return new Text('Cek status verifikasi',
          style: new TextStyle(
              fontSize: mediaquery.width / textSize17sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'ProximaRegular'));
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  Widget labelCountdown() {
    var mediaquery = MediaQuery.of(context).size;
    var textTimer = new RichText(
      textAlign: TextAlign.center,
      text: new TextSpan(
        text: 'Kirim ulang email dalam ',
        style: new TextStyle(
          fontSize: mediaquery.width / textSize16sp,
          color: Colors.white,
        ),
        children: <TextSpan>[
          new TextSpan(
            text: "$_current detik",
            style: new TextStyle(
              fontWeight: FontWeight.bold,
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

  Widget labelResend() {
    var mediaquery = MediaQuery.of(context).size;
    var textResend = new RichText(
      text: new TextSpan(
        text: 'Belum menerima email? Kirim ulang',
        style: new TextStyle(
          fontSize: mediaquery.width / textSize16sp,
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
              setState(() {
                isError = false;
                ableToResend = false;
                _current = countdownTimer;
                startCountDown();
                sendVerificationEmail();
              });
            },
            child: textResend,
          ),
        ],
      ),
    );
  }

  fetchEmail() async {
    email = await keyStore.getEmail();
    // email = "arigo1602@gmail.com";
  }

  sendVerificationEmail() {
    setState(() {
      ableToResend = false;
      _current = countdownTimer;
      startCountDown();
    });

    ApiServiceVerificationEmail.sendVerificationEmail(email)
        .then((result) async {
      var data = json.decode(result);
      var status = data['status'];

      print('data $data');

      if (status != 200) {
        msgError = data['messages'];
        isError = true;
      }
    });
  }

  checkVerificationEmail() {
    Timer(Duration(seconds: DEFAULT_TIMEOUT), () {
      if (mounted) {
        setState(() {
          _isButtonDisabled = false;
          _state = 0;
        });
      }
    });

    setState(() {
      _isButtonDisabled = true;
      _state = 1;
    });

    ApiServiceVerificationEmail.checkStatusEmail(email).then((result) async {
      var data = json.decode(result);
      var status = data['status'];

      print('data $data');

      setState(() {
        _isButtonDisabled = false;
        _state = 0;
      });

      if (status == 200) {
        setLatestPage('null');
        Navigator.pushNamed(context, VerificationEmailSuccess.tag);
      } else {
        setState(() {
          msgError = data['messages'];
          isError = true;
        });
      }
    });
  }

  void startCountDown() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: countdownTimer),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = countdownTimer - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      setState(() {
        ableToResend = true;
      });
      sub.cancel();
    });
  }

  _onRedirected() {
    checkVerificationEmail();
  }
}
