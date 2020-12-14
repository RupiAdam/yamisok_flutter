import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yamisok/component/handle_error.dart';
// import 'package:yamisok/component/styleyami.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'package:http/http.dart' as Client;
// import 'package:http/http.dart' as http;
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/page/forgotpassword/forgot_password_email.dart';
import 'package:yamisok/page/game/connect_game.dart';
import 'package:yamisok/page/home/bottom_navigation.dart' as bottomNav;
import 'package:yamisok/page/home/home_new.dart' as homev2;
import 'package:yamisok/page/game/connect_game.dart' as connectgame;
import 'package:yamisok/page/login/basic_info.dart' as basic;

import 'package:flutter/services.dart';
import 'package:yamisok/page/login/basic_info.dart';

// import 'package:yamisok/component/all_library.dart';
import 'package:yamisok/page/login/register.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:yamisok/api/login/login_api.dart';
import 'package:yamisok/api/login/login_social_api.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:yamisok/page/term_and_condition/term_and_condition.dart';
import 'package:yamisok/page/verification_email/verification_email.dart';

//utilities
import '../utilities/color.dart';
import '../utilities/style.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

// SharedPreferences sharedPreferences;

// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

//redux

//redux
// import 'package:redux_thunk/redux_thunk.dart';
// import 'package:yamisok/redux/action.dart';
// import 'package:yamisok/redux/appstate.dart';
// import 'package:redux/redux.dart';

// import 'package:yamisok/page/redux/reducer.dart'

// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

// final FirebaseAuth _auth = FirebaseAuth.instance;
// // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// GoogleSignIn _googleSignIn = GoogleSignIn(
//  scopes: [
//    'email',
//    'https://www.googleapis.com/auth/contacts.readonly',
//  ],
// );

var loggedIn = false;
var firebaseAuth = FirebaseAuth.instance;

final String baseUrl2 = globals.baseUrlApi;

// ThunkAction<AppState> getRandomQuote = (Store<AppState> store) async {
//   http.Response response = await http.get(
//     Uri.encodeFull(
//         'https://baconipsum.com/api/?type=all-meat&paras=2&start-with-lorem=1'),
//   );
//   List<dynamic> result = json.decode(response.body);

//   // This is to remove the <p></p> html tag received. This code is not crucial.
//   // String quote = result[0]['content']
//   //     .replaceAll(new RegExp('[(<p>)(</p>)]'), '')
//   //     .replaceAll(new RegExp('&#8217;'), '\'');
//   String quote = result[0]
//       .replaceAll(new RegExp('[(<p>)(</p>)]'), '')
//       .replaceAll(new RegExp('&#8217;'), '\'');
//   String author = 'adang';

//   store.dispatch(new UpdateQuoteAction(quote, author));
// };

class LoginSignUpPage extends StatefulWidget {
  static String tag = 'login-page';
  LoginSignUpPage({this.onSignedIn});

  // final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

//model
// class Response {
//   final String status;
//   final String message;
//   final result;

//   Response({this.status, this.message, this.result});

//   factory Response.fromJson(Map<String, dynamic> json) {
//     return Response(
//       status: json['status'],
//       message: json['message'],
//       result: json["result"],
//     );
//   }
// }

// enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  bool isLoggedIn = false;
  var profileData;

//  var facebookLogin = FacebookLogin();
//  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
//     setState(() {
//       this.isLoggedIn = isLoggedIn;
//       this.profileData = profileData;
//     });
//   }
  // ScaffoldState scaffold;
  // final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;
  String _mytoken;
  // double height_device; //device size
  // double width_device; //device size
  // Client client = Client();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Initial form is login form
  // FormMode _formMode = FormMode.LOGIN;
  // bool _isIos;
  bool _isLoading;

  bool _obscureText = false;

  //buat visibility password
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void showSnackBar() {
    final snackBar = SnackBar(
      content: Text('Yay! A SnackBar!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: backgroundPrimary,
          // title: new Text("Alert Dialog title"),
          title: new Image.network(
              'https://techcrunch.com/wp-content/uploads/2015/08/safe_image.gif'),

          content: new Text("Alert Dialog body"),
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

  void initiateSignIn(String type) {
    _handleSignIn(type).then((result) {
      if (result == 1) {
        setState(() {
          loggedIn = true;
        });
      } else {
        setState(() {
          loggedIn = false;
        });
      }
    });
  }

  Future<int> _handleSignIn(String type) async {
    //  print('login ');
    switch (type) {
      case "FB":
        final facebookLogin = FacebookLogin();
        final result = await facebookLogin.logIn(['email']);
        switch (result.status) {
          case FacebookLoginStatus.loggedIn:
            final token = result.accessToken.token;
            final graphResponse = await Client.get(
                'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
            final profile = json.decode(graphResponse.body);
            print(profile);
            print("get data from facebook");
            print("id: : " + profile['id']);
            print("name : " + profile['name']);
            print("email : " + profile['email'] ?? '');
            // print("lihat token " + token ?? '');
            var id = profile['id'] ?? '';
            var email = profile['email'] ?? '';
            var name = profile['name'] ?? '';
            final String provider = "facebook";
            var enkripdt = email + provider;
            var md5 = crypto.md5;
            var bytes = utf8.encode(enkripdt); // data being hashed
            var digest = md5.convert(bytes);
            var socialtoken = profile['id'] ?? '';
            final String signature = digest.toString();
            if (id == '' || name == '' || email == '') {
              if (id == '') {
                _errorMessage = '#12001 Your Facebook invalid id';
              } else if (email == '') {
                _errorMessage = '#12002 Your Facebook invalid email';
              } else if (name == '') {
                _errorMessage = '#12003 Your Facebook invalid name';
              } else {
                _errorMessage = 'Your Facebook invalid';
              }
            } else {
              ApiServiceLoginSocial.apiloginSocial(
                      id, name, socialtoken, email, signature, provider)
                  .then((rst) async {
                var resultdt = json.decode(rst);
                final messages = resultdt['messages'];
                final status = resultdt['status'];
                final statusCode = resultdt['statusCode'];
                if (status == true) {
                  if (statusCode == 200) {
                    setState(() {
                      // _errorMessage = messages;
                      // _showDialog();
                      _isLoading = false;
                      _usernameController.text = '';
                      _passwordController.text = '';
                    });
                    final token = resultdt['token'];
                    final playerID = resultdt['player_id'].toString();
                    final avatar_url = resultdt['avatar_url'].toString();
                    final username = resultdt['username'].toString();
                    final basic_info = resultdt['basic_info'].toString();
                    final game_connect = resultdt['game_connect'].toString();
                    final verifikasi = '1';

                    if (basic_info == "0") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BasicInfo(
                                idsocial: id,
                                socialtoken: socialtoken,
                                signature: signature,
                                provider: provider,
                                email: email,
                                token: token,
                                name: name,
                                playerid: playerID,
                                username: username,
                                password: '',
                                statusPlayer: '2',
                                verify: verifikasi)),
                      );
                    } else if (verifikasi == "0") {
                      var parseplayerID = int.parse(playerID);
                      saveLocallogin(token, parseplayerID, avatar_url, username)
                          .then((val) {
                        setLatestPage('VerificationEmail').then((val) {
                          setEmail(email).then((val) {
                            Navigator.pushReplacementNamed(
                                context, VerificationEmail.tag);
                          });
                        });
                      });
                    } else if (game_connect == "0") {
                      var parseplayerID = int.parse(playerID);
                      saveLocallogin(token, parseplayerID, avatar_url, username)
                          .then((val) {
                        setLatestPage('ConnectGame').then((lates) {
                          setEmail(email).then((val) {
                            Navigator.pushReplacementNamed(
                                context, ConnectGame.tag);
                          });
                        });
                      });
                    } else {
                      var parseplayerID = int.parse(playerID);
                      saveLocallogin(token, parseplayerID, avatar_url, username)
                          .then((val) {
                        setEmail(email).then((val) {
                          Navigator.pushReplacementNamed(
                              context, bottomNav.Bottomnav.tag);
                        });
                      });
                    }
                  } else if (statusCode == 202) {
                    setState(() {
                      _errorMessage = messages;
                      // _showDialog();
                      _isLoading = false;
                      _usernameController.text = '';
                      _passwordController.text = '';
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BasicInfo(
                              idsocial: id,
                              socialtoken: socialtoken,
                              signature: signature,
                              provider: provider,
                              email: email,
                              token: '',
                              name: name,
                              playerid: '',
                              username: '',
                              password: '',
                              statusPlayer: '1',
                              verify: '1')),
                    );
                  } else {}
                } else {
                  //  print("status false dari api");

                  setState(() {
                    _errorMessage = messages;
                    _isLoading = false;
                  });
                }
              });
            }
            break;
          case FacebookLoginStatus.cancelledByUser:
            setState(() => loggedIn);
            print('login.dart-User-fb => cancel by user');
            break;
          case FacebookLoginStatus.error:
            setState(() => loggedIn);
            print('login.dart-User-fb => error by user');
            break;
        }

        return 1;
      case "G":
        print("masuk ke google");
        try {
          final GoogleSignIn googleSignIn = GoogleSignIn();
          await googleSignIn.signOut();
          print("masuk ke google try catch");
          GoogleSignInAccount googleSignInAccount = await _handleGoogleSignIn();

          final googleAuth = await googleSignInAccount.authentication;
          final googleAuthCred = GoogleAuthProvider.getCredential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
          final user = await firebaseAuth.signInWithCredential(googleAuthCred);
          print("get data from google ${user.user.displayName}");
          print("User : " + user.user.displayName);
          print("User : " + user.user.email);
          print("lihat token " + googleAuth.idToken);
          var id = user.user.uid ?? '';
          var name = user.user.displayName ?? '';
          var email = user.user.email ?? '';
          final String provider = "google";
          var enkripdt = email + provider;
          var socialtoken = googleAuth.idToken;
          print("enkripdt : $enkripdt");
          var md5 = crypto.md5;
          var bytes = utf8.encode(enkripdt); // data being hashed
          var digest = md5.convert(bytes);
          final String signature = digest.toString();

          if (id == '' || name == '' || email == '') {
            if (id == '') {
              _errorMessage = '#12001 Your Gmail invalid id';
            } else if (email == '') {
              _errorMessage = '#12002 Your Gmail invalid email';
            } else if (name == '') {
              _errorMessage = '#12003 Your Gmail invalid name';
            } else {
              _errorMessage = 'Your Gmail invalid';
            }
          } else {
            ApiServiceLoginSocial.apiloginSocial(
                    id, name, socialtoken, email, signature, provider)
                .then((rst) async {
              // var jsn = json.decode(response.body);
              print("THEN RESULT LOGIN 1: ,$rst");
              var resultdt = json.decode(rst);
              // print(' lihat pesan ku penuh dengan error ada yg putih dan ada yg $resultdt');
              final messages = resultdt['messages'];
              final status = resultdt['status'];
              final statusCode = resultdt['statusCode'];

              // print( ' lihat pesan ku penuh dengan error ada yg putih dan ada yg merah $messages');
              if (status == true) {
                if (statusCode == 200) {
                  print('masuk k 200');

                  setState(() {
                    // _errorMessage = messages;
                    // _showDialog();
                    _isLoading = false;
                    _usernameController.text = '';
                    _passwordController.text = '';
                  });
                  final token = resultdt['token'];
                  final playerID = resultdt['player_id'].toString();
                  final name = resultdt['name'].toString();
                  print('lihat name $name');
                  final avatar_url = resultdt['avatar_url'].toString();
                  final username = resultdt['username'].toString();
                  final basic_info = resultdt['basic_info'].toString();
                  final game_connect = resultdt['game_connect'].toString();
                  final verifikasi = '1';
                  // saveLocallogin(token, playerID, avatar_url, username).then((val) {
                  // // Navigator.pushReplacementNamed(context, bottomNav.Bottomnav.tag);
                  //   Navigator.pushReplacementNamed(context, homev2.HomeNew.tag);
                  //  });
                  if (basic_info == "0") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BasicInfo(
                              idsocial: id,
                              socialtoken: socialtoken,
                              signature: signature,
                              provider: provider,
                              token: token,
                              name: name,
                              playerid: playerID,
                              email: email,
                              username: username,
                              password: '',
                              statusPlayer: '2',
                              verify: verifikasi)),
                    );
                  } else if (verifikasi == "0") {
                    var parseplayerID = int.parse(playerID);
                    saveLocallogin(token, parseplayerID, avatar_url, username)
                        .then((val) {
                      setLatestPage('VerificationEmail').then((val) {
                        setEmail(email).then((val) {
                          Navigator.pushReplacementNamed(
                              context, VerificationEmail.tag);
                        });
                      });
                    });
                  } else if (game_connect == "0") {
                    var parseplayerID = int.parse(playerID);
                    saveLocallogin(token, parseplayerID, avatar_url, username)
                        .then((val) {
                      setLatestPage('ConnectGame').then((lates) {
                        setEmail(email).then((val) {
                          Navigator.pushReplacementNamed(
                              context, ConnectGame.tag);
                        });
                      });
                    });
                  } else {
                    var parseplayerID = int.parse(playerID);
                    saveLocallogin(token, parseplayerID, avatar_url, username)
                        .then((val) {
                      setEmail(email).then((val) {
                        Navigator.pushReplacementNamed(
                            context, bottomNav.Bottomnav.tag);
                      });
                    });
                  }
                } else if (statusCode == 202) {
                  print('masuk k 202');
                  setState(() {
                    // _errorMessage = messages;
                    // _showDialog();
                    _isLoading = false;
                    _usernameController.text = '';
                    _passwordController.text = '';
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BasicInfo(
                            idsocial: id,
                            socialtoken: socialtoken,
                            signature: signature,
                            provider: provider,
                            token: '',
                            name: name,
                            playerid: '',
                            email: email,
                            username: '',
                            password: '',
                            statusPlayer: '1',
                            verify: '1')),
                  );
                } else {}
              } else {
                //  print("status false dari api");

                setState(() {
                  _errorMessage = messages;
                  _isLoading = false;
                });
              }
            });
          }

          return 1;
        } catch (error) {
          HandlerError('Login_POST_THEN : ', error);
          return 0;
        }
    }
    return 0;
  }

  Future<GoogleSignInAccount> _handleGoogleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email']);
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    return googleSignInAccount;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    
   

    
    Timer _timer;
    _timer = new Timer(const Duration(milliseconds: 10000), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    var username = _usernameController.text;
    var pass = _passwordController.text;

    print("CEK FIELD : $username,$pass");
    if (username == '') {
      setState(() {
        _errorMessage = "Username/email tidak boleh kosong";
        _isLoading = false;
      });
      print("USERNAME EMPTY : $_errorMessage");
    } else {
      if (pass == '') {
        setState(() {
          _errorMessage = "password tidak boleh kosong";
          _isLoading = false;
        });
        print("PASSWORD EMPTY : $_errorMessage");
      } else {
        // print("LOGIN body : $body");

        try {
          analytics.logEvent(name: 'LoginButton');
          ApiServiceLogin.apilogin(username, pass).then((rst) async {
            var resultdt = json.decode(rst);
            // print(' lihat pesan ku penuh dengan error ada yg putih dan ada yg $resultdt');
            final messages = resultdt['messages'];
            final status = resultdt['status'];

            // print(' lihat pesan ku penuh dengan error ada yg putih dan ada yg merah $messages');
            if (status == true) {
              final token = resultdt['token'];
              final playerID = resultdt['player_id'].toString();
              final avatar_url = resultdt['avatar_url'].toString();
              final username = resultdt['username'].toString();
              final email = resultdt['email'].toString();
              final namedt = resultdt['name'].toString();
              print('lihat namedt $namedt');
              // final email = 'adangfirman12@gmail.com';
              final password = pass;
              // final basicInfo = resultdt['basic_info'];
              // final gameConnect = resultdt['player_game_connect'];
              final basicInfo = resultdt['basic_info'].toString();
              final gameConnect = resultdt['game_connect'].toString();
              // final gameConnect = "0";

              final verifikasi = resultdt['verified'].toString();

              print(
                  'lihat dari api basicInfo $basicInfo  gameConnect $gameConnect verifikasi $verifikasi');

              setState(() {
                _isLoading = false;
                _usernameController.text = '';
                _passwordController.text = '';
              });
              if (basicInfo == "0") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BasicInfo(
                          name: namedt,
                          token: token,
                          playerid: playerID,
                          email: email,
                          username: username,
                          password: pass,
                          statusPlayer: '2', //esixting user
                          verify: verifikasi)),
                );
              } else if (verifikasi == "0") {
                var parseplayerID = int.parse(playerID);
                saveLocallogin(token, parseplayerID, avatar_url, username)
                    .then((val) {
                  setLatestPage('VerificationEmail').then((val) {
                    setEmail(email).then((val) {
                      Navigator.pushReplacementNamed(
                          context, VerificationEmail.tag);
                    });
                  });
                });
              } else if (gameConnect == "0") {
                var parseplayerID = int.parse(playerID);
                saveLocallogin(token, parseplayerID, avatar_url, username)
                    .then((val) {
                  setLatestPage('ConnectGame').then((lates) {
                    setEmail(email).then((val) {
                      Navigator.pushReplacementNamed(context, ConnectGame.tag);
                    });
                  });
                });
              } else {
                var parseplayerID = int.parse(playerID);
                saveLocallogin(token, parseplayerID, avatar_url, username)
                    .then((val) {
                  setEmail(email).then((val) {
                    Navigator.pushReplacementNamed(
                        context, bottomNav.Bottomnav.tag);
                  });
                });
              }

              // Navigator.pushReplacementNamed(context, connectgame.ConnectGame.tag);

              // keyStore.setTokenId(token,playerID,avatarurl,username).then((val){
              //   print("SAVE TOKEN SUCESS");
              //   keyStore.getToken().then((rst){
              //     print("THEN TOKENNYA : $rst");
              //     Navigator.pushReplacementNamed(context, bottomNav.Bottomnav.tag);
              //     print("#EOF Login.dart ----------------------------------------------");
              //   });
              // });
            } else {
              //  print("status false dari api");

              setState(() {
                if (messages == '#500 oops please try again later') {
                  _errorMessage = messages;
                } else {
                  _errorMessage = "Cek username dan password kamu";
                }

                _isLoading = false;
              });
            }
          }).catchError((e) {
            HandlerError('Login_POST_THEN', e);
          });
        } catch (e) {
          HandlerError('REGISTER_API_ERR : ', e);
        }
      }
    }
  }

  @override
  void initState() {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    _errorMessage = "";
    _isLoading = false;
    super.initState();
   
    analytics.logEvent(name: 'Login');
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
    // _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    // height_device = MediaQuery.of(context).size.height;
    // width_device = MediaQuery.of(context).size.height;

    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: backgroundPrimary,
        child: _showBody(),
      ),
    );
  }

  Widget _showCircularProgress() {
    var size = MediaQuery.of(context).size;
    final double itemHeightEmail = (size.width) / 8;
    final borderRadius = BorderRadius.circular(10.0);
    final startColor = Color(0xFFfb8402);
    final endColor = Color(0xFFffca00);
    if (_isLoading) {
      return Container(
        // width: (double.infinity - 10) / 3,
        width: itemHeightEmail,
        height: itemHeightEmail,
        decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(colors: [startColor, endColor]),
            boxShadow: [
              // BoxShadow(
              //   color: Colors.grey[500],
              //   offset: Offset(0.0, 1.5),
              //   blurRadius: 1.5,
              // ),
            ]),
        child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black)),
            )),
      );
      // return Container(
      //   color: Colors.black,
      //   child: Center(

      //       // child:CircularProgressIndicator(
      //       //   valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),

      //       // ),
      //     // child: CircularProgressIndicator()
      //     )
      // );
      // return Center(child: CircularProgressIndicator());
    }
  }

  Widget _showBody() {
    //  var size = globals.varMediaQuery;
    var size = MediaQuery.of(context).size;

    // final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemHeight = (size.height);
    final double itemWidth = (size.width);
    final double itemWidthpadding = (size.width) / 40;
    // final double itemWidthpadding = (size.width)/3.5;
    // final double itemWidthpadding2 = itemWidth/5;
    final double itemWidthpaddingLOGIN = (size.width) / 3.5;
    final double itemWidthpaddingLOGIN2 = (itemWidthpaddingLOGIN / 2) / 2;
    // final double itemWidth = (size.width)-itemWidthpadding;

    return new Column(
      // shrinkWrap: true,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          color: backgroundPrimary,
          child: Column(
            children: <Widget>[
              _showLogo(),
              _labelinfo('Username atau email'),
              _showEmailInput(),
              SizedBox(
                height: size.width / 20,
              ),
              _labelinfo('Kata sandi'),
              _passLayout(),
              SizedBox(
                height: itemWidthpadding,
              ),
              _labelupapass('Lupa kata sandi ?'),
            ],
          ),
        ),
        Container(
          color: backgroundPrimary,
          child: Column(
            children: <Widget>[
              _showErrorMessage(),
              // _showtext(),
              _statusButton(),
              _showSosmedButton(),
              _showSecondaryButton(),
              SizedBox(
                height: itemWidthpaddingLOGIN2,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _statusButton() {
    if (_isLoading == false) {
      return _showPrimaryButton();
    } else {
      return _showLoadingButton();
    }
  }

  Widget _showErrorMessage() {
    var size = MediaQuery.of(context).size;
    final double itemWidthpading = (size.width) / 8;
    final double itemWidth = (size.width) - itemWidthpading;
    final double itemHeightEmail = (size.width) / 8;
    final double textSize1 =
        (size.width) / 25; //25sp sample title tournament list /username dilogin
    final double textSize2 =
        (size.width) / 38; //25sp sample list tournament on going
    final double textSize3 =
        (size.width) / 40; //25sp sample list tournament on going
    final double iconSize1 = (size.width) / 15; //25sp sample icon login
    final int itemHeightEmail2 = 10;
    if (_errorMessage != null && _errorMessage.length > 0) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              _errorMessage,
              style: TextStyle(
                  fontSize: textSize1,
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

  Widget _showLogo() {
    var size = MediaQuery.of(context).size;

    // final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidthpadding = (size.width) / 3.5;
    final double itemWidthpadding2 = itemWidthpadding / 2;
    final double itemWidth = (size.width) - itemWidthpadding;
    final double itemHeightLogo = (size.width) / 3;
    return Column(
      children: <Widget>[
        SizedBox(
          height: itemWidthpadding2 - 10,
        ),
        Container(
            width: itemWidth,
            // height: itemHeightLogo,
            child: new Image.asset("assets/images/logo.png")),
        SizedBox(
          height: itemWidthpadding2 - 10,
        )
      ],
    );
  }

  Widget _showEmailInput() {
    var mediaquery = MediaQuery.of(context).size;
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
            key: Key('field_username'),
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
              hintStyle:
                  TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
              prefixStyle: TextStyle(color: Colors.white),
              // fillColor: Color(0xFFFFFFFF), filled: true,

              counterText: "",
              hintText: "yamisok@gmail.com",
              labelStyle: new TextStyle(
                  color: textColor2,
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaReguler'),

              // icon:
            ),
            maxLength: 30,
            onChanged: (value) {},
          ),
        ),
      ),
    );
  }

  Widget _labelinfo(text) {
    var mediaquery = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
              fontSize: mediaquery.width / textSize14sp,
              color: textColor2,
              fontFamily: 'ProximaRegular'),
        ),
      ),
    );
  }

  Widget _labelupapass(text) {
    var mediaquery = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordEmail()),
          );
        },
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            text,
            style: TextStyle(
                fontSize: mediaquery.width / textSize14sp,
                color: textColor2,
                fontFamily: 'ProximaRegular'),
          ),
        ),
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
            key: Key('field_password'),
            style: TextStyle(
                color: textColor2,
                fontSize: mediaquery.width / textSize14sp,
                fontFamily: 'ProximaReguler'),
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintStyle:
                  TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
              prefixStyle: TextStyle(color: Colors.white),
              counterText: "",
              hintText: "Kata Sandi",
              labelStyle: new TextStyle(
                  color: textColor2,
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaReguler'),
              suffixIcon: GestureDetector(
                onTap: _toggle,
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  size: mediaquery.width / textSize14sp,
                  color: Color(0xFFa2a2a2),
                ),
              ),

              // icon:
            ),
            obscureText: !_obscureText,
            maxLength: 30,
            onChanged: (value) {},
          ),
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
          child: new Text('Login',
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

  Widget _showLogoFb() {
    var size = MediaQuery.of(context).size;
    final double itemWidthpading = (size.width) / 11;
    final double textSize1 =
        (size.width) / 25; //25sp sample title tournament list /username dilogin
    final double textSize2 =
        (size.width) / 38; //25sp sample list tournament on going
    final double iconSize1 = (size.width) / 15; //25sp sample icon login

    return GestureDetector(
      // When the child is tapped, show a snackbar.
      onTap: () {
        analytics.logEvent(name: 'Login_Facebook');
        _handleSignIn("FB");
        //  initiateFacebookLogin();
        // Scaffold.of(context).showSnackBar(snackBar);
      },
      // The custom button
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            width: itemWidthpading,
            height: itemWidthpading,
            child: new Image.asset("assets/images/fb_icon.png")),
      ),
    );
  }

  Widget _showLogoGgl() {
    var size = MediaQuery.of(context).size;
    final double itemWidthpading = (size.width) / 11;
    //  _handleSignIn
    return GestureDetector(
      // When the child is tapped, show a snackbar.
      onTap: () {
        analytics.logEvent(name: 'Login_Google');
        _handleSignIn("G");

        // Scaffold.of(context).showSnackBar(snackBar);
      },
      // The custom button
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            height: itemWidthpading,
            width: itemWidthpading,
            child: new Image.asset("assets/images/g_icon.png")),
      ),
    );
  }

  Widget _showSosmedButton() {
    var mediaquery = MediaQuery.of(context).size;
    var textSignInfo = new RichText(
      text: new TextSpan(
          text: 'atau login dengan',
          style: new TextStyle(
            fontSize: mediaquery.width / textSize12sp,
            color: Color(0xFFCCCCCC),
          )),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            textSignInfo,
            _showLogoFb(),
            // _showLogoGgl(),
          ],
        ),
      ),
    );
  }

  Widget _showSecondaryButton() {
    var size = MediaQuery.of(context).size;
    final double itemWidthpading = (size.width) / 11;
    final double textSize1 =
        (size.width) / 25; //25sp sample title tournament list /username dilogin
    final double textSize2 =
        (size.width) / 38; //25sp sample list tournament on going
    final double iconSize1 = (size.width) / 15; //25sp sample icon login

    int charCode = 0x1F431; // 🐱 (cat emoji)
    String s5 = String.fromCharCode(charCode);

    var textSignInfo = new RichText(
      text: new TextSpan(
        text: 'Belum terdaftar ? ',
        style: new TextStyle(
          fontSize: textSize1,
          color: Color(0xFFCCCCCC),
        ),
        children: <TextSpan>[
          new TextSpan(
            text: 'Buat baru',
            style: new TextStyle(
              color: backgroundYellow,
              fontWeight: FontWeight.bold,
            ),
            recognizer: new TapGestureRecognizer()
              ..onTap = () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermAndConditionPage()),
                  ),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermAndConditionPage()),
              );
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

    // return new FlatButton(
    //   child: _formMode == FormMode.LOGIN
    //       ? new Text('Create account now.',
    //           style: new TextStyle(color: yamiyelowColor,fontSize: 12.0, fontWeight: FontWeight.w300))
    //       : new Text('Have an account? Sign in',
    //           style:
    //               new TextStyle(color: yamiyelowColor,fontSize: 12.0, fontWeight: FontWeight.w300)),
    //   onPressed: _formMode == FormMode.LOGIN
    //       ? _changeFormToSignUp
    //       : _changeFormToLogin,
    // );
  }
}

//redux
// typedef void GenerateQuote();
