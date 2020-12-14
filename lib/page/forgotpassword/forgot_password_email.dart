import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yamisok/api/forgotpassword/forgot_password_validate_email_api.dart';
import 'package:yamisok/component/globals.dart';
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/page/forgotpassword/forgot_password_cek_email.dart';
import 'package:yamisok/page/utilities/color.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

class ForgotPasswordEmail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordEmailState();
  }
}

class _ForgotPasswordEmailState extends State<ForgotPasswordEmail> {
  bool _isButtonDisabled;
  int _state = 0;
  String _errorMessage = ' ';
  TextEditingController inputEmailController = new TextEditingController();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _isButtonDisabled = true;
    analytics.logEvent(name: 'Forgot_password_email');
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
            title: Text("Kembali ke login"),
            backgroundColor: backgroundPrimary,
            leading: IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: _Parent());
  }

  Widget _Parent() {
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
                _Title(),
                _SubTitle(),
                _Label(),
                _InputEmail(),
              ],
            ),
          ),
          Container(
            child: _ButtonSubmit(),
          ),
        ],
      ),
    );
  }

  Widget _Title() {
    return Row(
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0, bottom: 10.0),
          child: Text('Lupa Kata Sandi',
              style: TextStyle(
                  color: accent, fontSize: 20.0, fontFamily: 'Proxima')),
        )
      ],
    );
  }

  Widget _SubTitle() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 30),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            'Kami akan mengirimkan tautan baru ke email anda untuk mengatur ulang kata sandi.',
            style: TextStyle(color: textColor1, fontSize: 16),
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
          ),
        )
      ],
    );
  }

  Widget _Label() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.only(left: 16.0, top: 6.0, right: 0.0, bottom: 10.0),
          child: Text('Email kamu',
              style: TextStyle(
                  color: Colors.white, fontSize: 20.0, fontFamily: 'Proxima')),
        ),
        Container(
          margin:
              EdgeInsets.only(left: 0.0, top: 6.0, right: 16.0, bottom: 10.0),
          child: Text(_errorMessage,
              style: TextStyle(
                  color: textError, fontSize: 14.0, fontFamily: 'Proxima')),
        )
      ],
    );
  }

  Widget _InputEmail() {
    return Container(
      margin: EdgeInsets.only(top: 6, bottom: 20, left: 16, right: 16),
      decoration: BoxDecoration(
          color: Color(0xFF2f3336),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: TextFormField(
        key: Key('input_email'),
        controller: inputEmailController,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontFamily: 'ProximaReguler'),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          hintStyle:
              TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
          hintText: "Masukan email kamu",
        ),
        onChanged: (value) {
          bool isEmailValid =
              RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);

          if (value.isEmpty) {
            setState(() {
              _errorMessage = 'Email tidak boleh kosong';
              _isButtonDisabled = true;
            });
          } else {
            if (!isEmailValid) {
              _errorMessage = 'Format email salah';
              _isButtonDisabled = true;
            } else {
              setState(() {
                _errorMessage = '';
                _isButtonDisabled = false;
              });
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _ButtonSubmit() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: ButtonTheme(
        key: Key('send_button'),
        minWidth: MediaQuery.of(context).size.width * 0.9,
        height: 50.0,
        child: RaisedButton(
          child: _buttonIndicator(),
          textColor: Colors.black,
          color: accent,
          disabledTextColor: buttonDisabledText,
          disabledColor: buttonDisabledBackgroud,
          onPressed: _isButtonDisabled
              ? null
              : () {
                  _sendEmailValidation();
                },
        ),
      ),
    );
  }

  Widget _buttonIndicator() {
    if (_state == 0) {
      return Text('Kirim');
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  _sendEmailValidation() {
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

    ApiServiceForgotPasswordValidateEmail.validateEmail(
            inputEmailController.text)
        .then((result) async {
      var data = json.decode(result);
      var status = data['status'];

      print('data $data');

      setState(() {
        _isButtonDisabled = false;
        _state = 0;
      });

      if (status == 200) {
        var token = data['token'];
        setResetPasswordToken(token);

        setEmail(inputEmailController.text);
        setLatestPage(ForgotPasswordCekEmailPage.tag);
        Navigator.pushReplacementNamed(context, ForgotPasswordCekEmailPage.tag);
      } else {
        var message = data['messages'];
        setState(() {
          _errorMessage = message;
        });
      }
    });
  }
}
