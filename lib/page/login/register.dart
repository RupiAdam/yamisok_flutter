import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:yamisok/component/all_library.dart' as prefix0;
// import 'package:yamisok/component/all_library.dart' as prefix0;
// import 'package:yamisok/component/styleyami.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/page/home/bottom_navigation.dart' as bottomNav;
import 'package:flutter/services.dart';
import 'package:yamisok/page/login/basic_info.dart';
import 'package:yamisok/page/login/login.dart';
import 'package:yamisok/api/login/register_api.dart';
import 'package:yamisok/model/profile_model.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/page/utilities/style.dart';

final String baseUrl23 = "https://api.yamisok.com";
final String baseUrl2 = globals.urlAPI;

FirebaseAnalytics analytics = FirebaseAnalytics();

//model
class Response {
  final String status;
  final String message;
  final result;

  Response({this.status, this.message, this.result});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      status: json['status'],
      message: json['message'],
      result: json["result"],
    );
  }
}

class RegisterPage extends StatefulWidget {
  static String tag = 'login-page';
  RegisterPage({this.onSignedIn});
  final VoidCallback onSignedIn;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;
  String _mytoken;
  double height_device; //device size
  double width_device;

  String _errorusername;
  String _erroremail;
  String _errorpass;
  String _errorconfirmpass;

  //device size
  // Client client = Client();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  // Initial form is login form
  // FormMode _formMode = FormMode.LOGIN;
  // bool _isIos;
  bool _isLoading;
  bool _isDisable;

  bool _obscureTextpass = false;
  bool _obscureTextpassConfirm = false;

  //buat visibility password
  // void _togglepas() {
  //   setState(() {
  //     _obscureTextpass = !_obscureTextpass;
  //   });
  // }
  void _togglepass() {
    setState(() {
      _obscureTextpass = !_obscureTextpass;
    });
  }

  void _togglepassconfirm() {
    setState(() {
      _obscureTextpassConfirm = !_obscureTextpassConfirm;
    });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: backgroundPrimary,
          // title: new Text("Alert Dialog title"),
          title: new Text(
            "Registrasi",
            style: TextStyle(color: Colors.white),
          ),
          content: new Text(
            "Sukses Registrasi",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorusername = "";
      _erroremail = "";
      _errorpass = "";
      _errorconfirmpass = "";
      _isLoading = true;
    });

    var username = _usernameController.text;
    var email = _emailController.text;
    var pass = _passwordController.text;
    var confirmpass = _confirmpasswordController.text;
    // var email = "tony@starkindustries.com"
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

    if (username == '') {
      setState(() {
        _errorusername = 'Username cant be empty';
        // String _erroremail;
        // String _errorconfirmpass;
        _isLoading = false;
      });
    } else if (email == '') {
      setState(() {
        _erroremail = 'Email cant be empty';
        _isLoading = false;
      });
    } else if (emailValid == false) {
      setState(() {
        _erroremail = "Please check your email";
        _isLoading = false;
      });
    } else if (pass == '') {
      setState(() {
        _errorpass = "Password can't be empty";
        _isLoading = false;
      });
    } else if (confirmpass == '') {
      setState(() {
        _errorconfirmpass = "Confirm can't be empty";
        _isLoading = false;
      });
    } else if (pass != confirmpass) {
      setState(() {
        _errorconfirmpass = "Confirm password not match";
        _isLoading = false;
      });
    } else {
      print("lihat field dikirim : ");
      ApiService2.apiregister(username, email, pass).then((rst) async {
        // var jsn = json.decode(response.body);
        print("THEN RESULT LOGIN 1: ,$rst");
        var resultdt = json.decode(rst);
        // print(' lihat pesan ku penuh dengan error ada yg putih dan ada yg $resultdt');
        final messages = resultdt['messages'];
        final status = resultdt['status'];
        // print(' lihat pesan ku penuh dengan error ada yg putih dan ada yg merah $messages');
        if (status == true) {
          setState(() {
            // _showDialog();
            _isLoading = false;
            // _usernameController.text='';
            // _emailController.text='';
            // _passwordController.text='';
            // _confirmpasswordController.text='';
            //  Navigator.pushReplacementNamed(context, log.Bottomnav.tag);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BasicInfo(
                      token: '',
                      playerid: '',
                      email: email,
                      username: username,
                      password: pass,
                      statusPlayer: '0',
                      verify: '0')),
            );
          });
        } else {
          setState(() {
            _errorusername = "";
            _erroremail = "";
            _errorpass = "";
            _errorconfirmpass = "";
            var string = messages;

            if (string.contains('username')) {
              _errorusername = messages;
            }
            if (string.contains('password')) {
              _errorpass = messages;
            }
            if (string.contains('email')) {
              _erroremail = messages;
            }

            _isLoading = false;
          });
        }
      });
    }
  }

//  ApiService apiService;
  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _usernameController.text = '';
    _emailController.text = '';
    _passwordController.text = '';
    _confirmpasswordController.text = '';
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    //  apiService = ApiService();
    analytics.logEvent(name: 'Register');
    super.initState();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    var paddingtop = MediaQuery.of(context).padding.top;

    Widget _labelusername(text) {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: textColor2,
                  fontFamily: 'ProximaRegular'),
            ),
            Text(
              _errorusername ?? '',
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: Colors.red,
                  fontFamily: 'ProximaRegular'),
            ),
          ],
        ),
      );
    }

    Widget _usernameInput() {
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        height: mediaquery.width / buttonHeight1,
        width: double.infinity,
        decoration: new BoxDecoration(
          color: Color(0xFF2f3336),
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(5.0),
              bottomLeft: const Radius.circular(5.0),
              topRight: const Radius.circular(5.0),
              bottomRight: const Radius.circular(5.0)),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Center(
            child: TextField(
              autofocus: true,
              key: Key('fieldusername'),
              controller: _usernameController,
              style: TextStyle(
                  color: textColor2,
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaReguler'),
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              // autofocus: false,
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                border: InputBorder.none,
                hintStyle: TextStyle(
                    color: inputHintColor, fontStyle: FontStyle.italic),
                prefixStyle: TextStyle(color: Colors.white),
                // fillColor: Color(0xFFFFFFFF), filled: true,

                counterText: "",
                hintText: "Username",
                labelStyle: new TextStyle(
                    color: textColor2,
                    fontSize: mediaquery.width / textSize14sp,
                    fontFamily: 'ProximaReguler'),

                // icon:
              ),
              maxLength: 30,

              onChanged: (value) {
                if (value.length != 0 &&
                    _emailController.text.length != 0 &&
                    _confirmpasswordController.text.length != 0 &&
                    _passwordController.text.length != 0) {
                  setState(() {
                    _isDisable = false;
                  });
                } else {
                  setState(() {
                    _isDisable = true;
                  });
                }
              },
            ),
          ),
        ),
      );
    }

    Widget _labelemail(text) {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: textColor2,
                  fontFamily: 'ProximaRegular'),
            ),
            Text(
              _erroremail ?? '',
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: Colors.red,
                  fontFamily: 'ProximaRegular'),
            ),
          ],
        ),
      );
    }

    Widget _showEmailInput() {
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        height: mediaquery.width / buttonHeight1,
        width: double.infinity,
        decoration: new BoxDecoration(
          color: Color(0xFF2f3336),
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(5.0),
              bottomLeft: const Radius.circular(5.0),
              topRight: const Radius.circular(5.0),
              bottomRight: const Radius.circular(5.0)),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Center(
            child: TextField(
              key: Key('fieldusername'),
              controller: _emailController,
              style: TextStyle(
                  color: textColor2,
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaReguler'),
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              // autofocus: false,
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                border: InputBorder.none,
                hintStyle: TextStyle(
                    color: inputHintColor, fontStyle: FontStyle.italic),
                prefixStyle: TextStyle(color: Colors.white),
                // fillColor: Color(0xFFFFFFFF), filled: true,

                counterText: "",
                hintText: "Email",
                labelStyle: new TextStyle(
                    color: textColor2,
                    fontSize: mediaquery.width / textSize14sp,
                    fontFamily: 'ProximaReguler'),

                // icon:
              ),
              maxLength: 30,
              onChanged: (value) {
                if (value.length != 0 &&
                    _usernameController.text.length != 0 &&
                    _confirmpasswordController.text.length != 0 &&
                    _passwordController.text.length != 0) {
                  setState(() {
                    _isDisable = false;
                  });
                } else {
                  setState(() {
                    _isDisable = true;
                  });
                }
              },
            ),
          ),
        ),
      );
    }

    Widget _labelpassword(text) {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: textColor2,
                  fontFamily: 'ProximaRegular'),
            ),
            Text(
              _errorpass ?? '',
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: Colors.red,
                  fontFamily: 'ProximaRegular'),
            ),
          ],
        ),
      );
    }

    Widget _passLayout() {
      var mediaquery = MediaQuery.of(context).size;

      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        height: mediaquery.width / buttonHeight1,
        width: double.infinity,
        decoration: new BoxDecoration(
          color: Color(0xFF2f3336),
          // color: Colors.red,

          // color: Color(0xFF3c4144),
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(5.0),
              bottomLeft: const Radius.circular(5.0),
              topRight: const Radius.circular(5.0),
              bottomRight: const Radius.circular(5.0)),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Center(
            child: TextField(
              controller: _passwordController,
              key: Key('fieldpassword'),
              style: TextStyle(
                  color: textColor2,
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaReguler'),
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                    color: inputHintColor, fontStyle: FontStyle.italic),
                prefixStyle: TextStyle(color: Colors.white),
                counterText: "",
                hintText: "Password",
                labelStyle: new TextStyle(
                    color: textColor2,
                    fontSize: mediaquery.width / textSize14sp,
                    fontFamily: 'ProximaReguler'),
                suffixIcon: GestureDetector(
                  onTap: _togglepass,
                  child: Icon(
                    _obscureTextpass ? Icons.visibility : Icons.visibility_off,
                    size: mediaquery.width / textSize14sp,
                    color: Color(0xFFa2a2a2),
                  ),
                ),

                // icon:
              ),
              obscureText: !_obscureTextpass,
              maxLength: 30,
              onChanged: (value) {
                if (value.length != 0 &&
                    _usernameController.text.length != 0 &&
                    _confirmpasswordController.text.length != 0 &&
                    _emailController.text.length != 0) {
                  setState(() {
                    _isDisable = false;
                  });
                } else {
                  setState(() {
                    _isDisable = true;
                  });
                }
              },
            ),
          ),
        ),
      );
    }

    Widget _labelpasswordconfirm(text) {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: textColor2,
                  fontFamily: 'ProximaRegular'),
            ),
            Text(
              _errorconfirmpass ?? '',
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: Colors.red,
                  fontFamily: 'ProximaRegular'),
            ),
          ],
        ),
      );
    }

    Widget _passLayoutConfirm() {
      var mediaquery = MediaQuery.of(context).size;

      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        height: mediaquery.width / buttonHeight1,
        width: double.infinity,
        decoration: new BoxDecoration(
          color: Color(0xFF2f3336),
          // color: Colors.red,

          // color: Color(0xFF3c4144),
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(5.0),
              bottomLeft: const Radius.circular(5.0),
              topRight: const Radius.circular(5.0),
              bottomRight: const Radius.circular(5.0)),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Center(
            child: TextField(
              controller: _confirmpasswordController,
              key: Key('fieldpassword'),
              style: TextStyle(
                  color: textColor2,
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaReguler'),
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                    color: inputHintColor, fontStyle: FontStyle.italic),
                prefixStyle: TextStyle(color: Colors.white),
                counterText: "",
                hintText: "Password",
                labelStyle: new TextStyle(
                    color: textColor2,
                    fontSize: mediaquery.width / textSize14sp,
                    fontFamily: 'ProximaReguler'),
                suffixIcon: GestureDetector(
                  onTap: _togglepass,
                  child: Icon(
                    _obscureTextpass ? Icons.visibility : Icons.visibility_off,
                    size: mediaquery.width / textSize14sp,
                    color: Color(0xFFa2a2a2),
                  ),
                ),

                // icon:
              ),
              obscureText: !_obscureTextpass,
              maxLength: 30,
              onChanged: (value) {
                if (value.length != 0 &&
                    _usernameController.text.length != 0 &&
                    _passwordController.text.length != 0 &&
                    _emailController.text.length != 0) {
                  setState(() {
                    _isDisable = false;
                  });
                } else {
                  setState(() {
                    _isDisable = true;
                  });
                }
              },
            ),
          ),
        ),
      );
    }

    Widget _labeltnc() {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Stack(
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.green[700],
              ),
              Container(
                padding: EdgeInsets.only(left: 30.0),
                child: Text(
                  'Saya telah menyetujui Syarat dan Ketentuan yang berlaku.',
                  style: TextStyle(
                      fontSize: mediaquery.width / textSize14sp,
                      color: textColor2,
                      fontFamily: 'ProximaRegular'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _showPrimaryButton() {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
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
            onPressed: _validateAndSubmit,
            child: new Text('Register',
                style: new TextStyle(
                    fontSize: mediaquery.width / textSize17sp,
                    color: Colors.black,
                    fontFamily: 'ProximaBold')),
          ),
        ),
      );
    }

    Widget _showDisableButton() {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: double.infinity,
        height: mediaquery.width / buttonHeight1,
        child: ButtonTheme(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
          buttonColor: Colors.grey,
          minWidth: double.infinity,
          height: mediaquery.width / buttonHeight1,
          child: RaisedButton(
            onPressed: () {},
            child: new Text('Register',
                style: new TextStyle(
                    fontSize: mediaquery.width / textSize17sp,
                    color: Colors.black,
                    fontFamily: 'ProximaBold')),
          ),
        ),
      );
    }

    Widget _showLoadingButton() {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
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
              onPressed: () {},
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black))),
        ),
      );
    }

    Widget _showSecondaryButton() {
      var size = MediaQuery.of(context).size;
      final double itemWidthpading = (size.width) / 11;
      final double textSize1 = (size.width) /
          25; //25sp sample title tournament list /username dilogin
      final double textSize2 =
          (size.width) / 38; //25sp sample list tournament on going
      final double iconSize1 = (size.width) / 15; //25sp sample icon login

      int charCode = 0x1F431; // 🐱 (cat emoji)
      String s5 = String.fromCharCode(charCode);

      var textSignInfo = new RichText(
        text: new TextSpan(
          text: 'Sudah memiliki akun ? ',
          style: new TextStyle(
            fontSize: textSize1,
            color: Color(0xFFCCCCCC),
          ),
          children: <TextSpan>[
            new TextSpan(
              text: 'Login disini',
              style: new TextStyle(
                color: backgroundYellow,
                fontWeight: FontWeight.bold,
              ),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pop();
                },
            ),
          ],
        ),
      );

      return Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              // When the child is tapped, show a snackbar.
              onTap: () {
                // _showDialog();
                // final snackBar = SnackBar(content: Text("Tap"));

                // Scaffold.of(context).showSnackBar(snackBar);
              },
              // The custom button
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 1.0, 1.0),
                child: textSignInfo,
              ),
            ),
          ],
        ),
      );
    }

    Widget _statusButton() {
      if (_isLoading == false) {
        if (_isDisable == false) {
          return _showPrimaryButton();
        } else {
          return _showDisableButton();
        }
      } else {
        return _showLoadingButton();
      }
    }

    return new Scaffold(
      // resizeToAvoidBottomInset : false,
      body: Container(
        color: backgroundPrimary,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: mediaquery.height,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: backgroundPrimary,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: paddingtop,
                      ),
                      SizedBox(
                        height: (mediaquery.width / 20) - 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Buat akun baru",
                            style: TextStyle(
                                color: backgroundYellow,
                                fontSize: textSize18sp,
                                fontFamily: 'ProximaBold'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mediaquery.width / 20,
                      ),
                      _labelusername('Username'),
                      _usernameInput(),
                      SizedBox(
                        height: mediaquery.width / 20,
                      ),
                      _labelemail('Email'),
                      _showEmailInput(),
                      SizedBox(
                        height: mediaquery.width / 20,
                      ),
                      _labelpassword('Password'),
                      _passLayout(),
                      SizedBox(
                        height: mediaquery.width / 20,
                      ),
                      _labelpasswordconfirm('Confirm Password'),
                      _passLayoutConfirm(),
                    ],
                  ),
                ),
                Container(
                  color: backgroundPrimary,
                  child: Column(
                    children: <Widget>[
                      // _showtext(),
                      // _labeltnc(),
                      _statusButton(),

                      _showSecondaryButton(),
                      SizedBox(
                        height: mediaquery.width / 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
