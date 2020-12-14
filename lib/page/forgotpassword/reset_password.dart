import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yamisok/api/forgotpassword/reset_password_api.dart';
import 'package:yamisok/component/globals.dart';
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/page/forgotpassword/reset_password_success.dart';
import 'package:yamisok/page/login/login.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/page/utilities/style.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

class ResetPasswordPage extends StatefulWidget {
  static String tag = 'reset-password-page';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPasswordPage> {
  bool _obscureText = false;
  bool _obscureTextRepass = false;
  bool _isButtonDisabled;
  int _state = 0;
  String _errorMessage = ' ';
  TextEditingController inputPasswordController = new TextEditingController();
  TextEditingController inputRePasswordController = new TextEditingController();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    analytics.logEvent(name: 'Reset_password_succes');
    _isButtonDisabled = true;

    analytics.logEvent(name: 'Reset_password');
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
      body: _parent(),
    );
  }

  Widget _parent() {
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
                _title(),
                _subTitle(),
                _labelNewPassword(),
                _inputPassword(),
                _labelRePassword(),
                _inputRePassword()
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[_buttonSubmit(), _buttonBack()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return Row(
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.only(left: 16.0, top: 30.0, right: 16.0, bottom: 10.0),
          child: Text('Atur ulang kata sandi',
              style: TextStyle(
                  color: accent, fontSize: 20.0, fontFamily: 'Proxima')),
        )
      ],
    );
  }

  Widget _subTitle() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            'Masukkan kata sandi baru.',
            style: TextStyle(color: textColor1, fontSize: 16),
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
          ),
        )
      ],
    );
  }

  Widget _labelNewPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 0, bottom: 10, top: 10),
          child: Text(
            'Kata sandi',
            style: TextStyle(color: Colors.white, fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 0, right: 16, bottom: 10, top: 10),
          child: Text(
            _errorMessage,
            style: TextStyle(color: textError, fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _inputPassword() {
    var mediaquery = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 6, bottom: 20, left: 16, right: 16),
      decoration: BoxDecoration(
          color: Color(0xFF2f3336),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: TextFormField(
        key: Key('input_email'),
        controller: inputPasswordController,
        maxLines: 1,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontFamily: 'ProximaReguler'),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          hintStyle:
              TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
          hintText: "Kata sandi harus minimal 6 karakter",
          suffixIcon: GestureDetector(
            onTap: _toggle,
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              size: mediaquery.width / textSize16sp,
              color: textGrey,
            ),
          ),
        ),
        obscureText: !_obscureText,
        onChanged: (value) {
          if (value != inputRePasswordController.text) {
            setState(() {
              _isButtonDisabled = true;
              _errorMessage = 'Password tidak sama';
            });
          } else {
            setState(() {
              _isButtonDisabled = false;
              _errorMessage = '';
            });
          }
          return null;
        },
      ),
    );
  }

  Widget _labelRePassword() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            'Ulangi kata sandi',
            style: TextStyle(color: Colors.white, fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
          ),
        )
      ],
    );
  }

  Widget _inputRePassword() {
    var mediaquery = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 6, bottom: 20, left: 16, right: 16),
      decoration: BoxDecoration(
          color: Color(0xFF2f3336),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: TextFormField(
        key: Key('input_email'),
        controller: inputRePasswordController,
        maxLines: 1,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontFamily: 'ProximaReguler'),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          hintStyle:
              TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
          hintText: "Kata sandi harus minimal 6 karakter",
          suffixIcon: GestureDetector(
            onTap: _toggleRePass,
            child: Icon(
              _obscureTextRepass ? Icons.visibility : Icons.visibility_off,
              size: mediaquery.width / textSize16sp,
              color: textGrey,
            ),
          ),
        ),
        obscureText: !_obscureTextRepass,
        onChanged: (value) {
          if (value != inputPasswordController.text) {
            setState(() {
              _isButtonDisabled = true;
              _errorMessage = 'Password tidak sama';
            });
          } else {
            setState(() {
              _isButtonDisabled = false;
              _errorMessage = '';
            });
          }
          return null;
        },
      ),
    );
  }

  Widget _buttonSubmit() {
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
                  _resetPassword();
                },
        ),
      ),
    );
  }

  Widget _buttonBack() {
    return FlatButton(
      onPressed: () {
        Navigator.pushNamed(context, LoginSignUpPage.tag);
      },
      child: Text(
        "Batalkan",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleRePass() {
    setState(() {
      _obscureTextRepass = !_obscureTextRepass;
    });
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

  _resetPassword() async {
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

    keyStore.getEmail().then((email) {
      ApiServiceResetPassword.resetPassword(email, inputPasswordController.text)
          .then((result) {
        var data = json.decode(result);
        var status = data['status'];

        print('ressss $data');

        setState(() {
          _isButtonDisabled = false;
          _state = 0;
        });

        if (status == 200) {
          setLatestPage('null');
          setEmail('');
          setResetPasswordToken('');
          Navigator.pushReplacementNamed(context, ResetPasswordSuccessPage.tag);
        } else {
          var message = data['messages'];
          setState(() {
            _errorMessage = message;
          });
        }
      });
    });
  }
}
