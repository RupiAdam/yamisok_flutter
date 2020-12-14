import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yamisok/api/game/list_role_game_api.dart';
import 'package:yamisok/api/game/submit_gameid_api.dart';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/redux/action.dart' as AppAction;
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/page/utilities/style.dart';
import '../utilities/style.dart';
import 'connect_game_steam_webview.dart';
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/component/globals.dart' as globals;

List datagame = [];
String _errornickname = '';
String _erroridgame = '';
String _errorMessage = '';
String _errorrole = '';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

final _nicknameController = TextEditingController();
final _gameidController = TextEditingController();
bool _isDisable;
bool _isLoading;
String imagesPic = '';

FirebaseAnalytics analytics = FirebaseAnalytics();

List rolegame = [
  {"name": "Marksman"},
  {"name": "Fighter"},
  {"name": "Assassin"},
  {"name": "Tank"},
  {"name": "Mage"},
  {"name": "Support"}
];

List<String> chipList = [
  "Marksman",
  "Fighter",
  "Assasin",
  "Tank",
  "Mage",
  "Support"
];

var newrole = StringBuffer();

List listRole = [];

String oldgame = '';

int idgamedt;

var listSelected = StringBuffer();
List<int> listSelectedid = List();
List<String> selectedChoices = List();

bool isfist = false;

class GameSteamPage extends StatefulWidget {
  static String tag = 'game-steam';

  final int idgame;
  final String name;
  final String ingameid;
  final bool isjointour;
  final String nicname;

  GameSteamPage(
      {Key key,
      this.idgame,
      this.isjointour,
      this.nicname,
      this.ingameid,
      this.name})
      : super(key: key);
  @override
  _GameSteamPageState createState() => _GameSteamPageState();
}

class _GameSteamPageState extends State<GameSteamPage> {
  // // Perform login or signup
  void _validateAndSubmit() async {
    print("SUBMIT field dikirim : ");
    setState(() {
      _isLoading = true;
    });

    Timer _timer;
    _timer = new Timer(const Duration(milliseconds: 10000), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });

    var nicname = _nicknameController.text;
    var ingameid = _gameidController.text;
    var oldrolegame = oldgame;
    var newrolegame = newrole;
    // var email = "tony@starkindustries.com"

    if (nicname == '') {
      setState(() {
        _errornickname = 'Username cant be empty';
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Game Name Empty, Update your id steam'),
          duration: Duration(seconds: 3),
        ));
        // String _erroremail;
        // String _errorconfirmpass;
        _isLoading = false;
      });
    } else if (ingameid == '') {
      setState(() {
        _errorMessage = 'Game ID cant be empty';
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(_errorMessage),
          duration: Duration(seconds: 3),
        ));
        _isLoading = false;
      });
    } else if (newrolegame.length == 0) {
      setState(() {
        _errorMessage = "Silahkan pilih role minimal satu";
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(_errorMessage),
          duration: Duration(seconds: 3),
        ));
        _isLoading = false;
      });
    } else {
      var idgame = widget.idgame;
      print("lihat field dikirim : ");
      ApiServiceSubmitGame.apisubmitgame(
              idgame, nicname, ingameid, oldrolegame, newrolegame)
          .then((rst) async {
        // var jsn = json.decode(response.bodyname);
        print("THEN RESULT LOGIN 1: ,$rst");
        var resultdt = json.decode(rst);
        // print(' lihat pesan ku penuh dengan error ada yg putih dan ada yg $resultdt');
        final messages = resultdt['messages'];
        final status = resultdt['status'];
        // print(' lihat pesan ku penuh dengan error ada yg putih dan ada yg merah $messages');
        if (status == true) {
          print('masuk k true');
          setState(() {
            _errorMessage = resultdt['messages'];
            // _showDialog();
            _isLoading = false;
            Navigator.pop(context, "succes");
            // _usernameController.text='';
            // _emailController.text='';
            // _passwordController.text='';
            // _confirmpasswordController.text='';
            //  Navigator.pushReplacementNamed(context, log.Bottomnav.tag);
          });
        } else {
          setState(() {
            _errorMessage = resultdt['messages'];
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(_errorMessage),
              duration: Duration(seconds: 3),
            ));

            _isLoading = false;
          });
        }
      });
    }
  }

  void _apiListRole() async {
    var idgame = widget.idgame;

    ApiServiceListRole.apilistrole(idgame).then((rst) async {
      listRole.clear();
      var resultdt = json.decode(rst);
      final messages = resultdt['messages'];
      final status = resultdt['status'];
      if (status == true) {
        final oldrole = resultdt['oldrole'];
        final gamerole = resultdt['gamerole'];
        // print('lihat result role $resultlist');
        setState(() {
          print('lihat oldgame dari api $oldrole');
          oldgame = oldrole;
          listRole.addAll(gamerole);
        });
      } else {}
    });
  }

  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    _errorMessage = '';
    _isLoading = false;
    _apiListRole();
    selectedChoices = List();
    listSelectedid = List();
    isfist = true;
    listRole.clear();
    _isDisable = true;
    print('lihat id steam ${widget.ingameid} ${widget.nicname}');
    _gameidController.text = widget.ingameid ?? '';
    _nicknameController.text = widget.nicname ?? '';

    analytics.logEvent(name: 'Connect_game_steam');
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
    var size = MediaQuery.of(context).size;
    var mediaquery = MediaQuery.of(context).size;

    Widget _deskripsi() {
      return Container(
        margin: EdgeInsets.only(left: 20.0),
        child: Text(
          'Untuk melakukan verifikasi ID, silahkan upload screenshot profile Mobile Legends kamu seperti contoh di bawah ini.',
          style: TextStyle(
              fontSize: mediaquery.width / textSize12sp, color: textColor2),
          textAlign: TextAlign.left,
        ),
      );
    }

    Widget _deskripsi2() {
      return Container(
        margin: EdgeInsets.only(left: 20.0),
        child: Text(
          'Untuk melakukan verifikasi ID, silahkan upload screenshot profile Mobile Legends kamu seperti contoh di bawah ini.',
          style: TextStyle(
              fontSize: mediaquery.width / textSize12sp, color: textColor2),
          textAlign: TextAlign.left,
        ),
      );
    }

    Widget _showScreenshotButton() {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: mediaquery.width / 1.5,
        height: mediaquery.width / buttonHeight1,
        child: ButtonTheme(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
          buttonColor: backgroundYellow,
          minWidth: double.infinity,
          height: mediaquery.width / buttonHeight1,
          child: Container(
            color: backgroundPrimary,
            child: RaisedButton(
              color: backgroundGreen,
              onPressed: () async {
                final bool statusApi = globals.statusApi;
                final String baseUrl = globals.baseUrlApi;
                final String baseUrlPro = globals.urlApiPro;
                final userToken = await keyStore.getToken();
                var url = "$baseUrl/v1/steam/steam-login-new?token=$userToken";

                if (statusApi == false) {
                  url = "$baseUrl/v1/steam/steam-login-new?token=$userToken";
                } else {
                  url = "$baseUrlPro/v1/steam/steam-login-new?token=$userToken";
                }
                String result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SteamWebview(
                            parameter: url,
                          )),
                );

                setState(() {
                  String status = result.split("/").first;

                  if (status == 'succes') {
                    String idsteam2 = result.split("/").last;
                    String idsteam = idsteam2.split("#-#").first;
                    String nicknamesteam = result.split("#-#").last;
                    _gameidController.text = idsteam;
                    _nicknameController.text = nicknamesteam;
                  } else {}
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text('Connect/ganti ID via Steam',
                      style: new TextStyle(
                          fontSize: mediaquery.width / textSize14sp,
                          color: Colors.white,
                          fontFamily: 'Proximaregular')),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _imagespic() {
      if (imagesPic != '') {
        return Container(
          height: mediaquery.width / 2,
          child: Image.network(
              'https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/540A637E-971E-428A-A28A-F7BCCA9D08C9.png'),
        );
      } else {
        return Container(
          height: mediaquery.width / 2,
          child: Image.network(
              'https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/540A637E-971E-428A-A28A-F7BCCA9D08C9.png'),
        );
      }
    }

    Widget _labelnickname(text) {
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
              _errornickname ?? '',
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: Colors.red,
                  fontFamily: 'ProximaRegular'),
            ),
          ],
        ),
      );
    }

    Widget _nicknameInput() {
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
              controller: _nicknameController,
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
                hintText: "Nickname dalam game",
                labelStyle: new TextStyle(
                    color: textColor2,
                    fontSize: mediaquery.width / textSize14sp,
                    fontFamily: 'ProximaReguler'),

                // icon:
              ),
              maxLength: 30,

              onChanged: (value) {
                if (listRole.length != 0 &&
                    value.length != 0 &&
                    _gameidController.text != '') {
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

    Widget _labelrole(text) {
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
              '',
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: Colors.red,
                  fontFamily: 'ProximaRegular'),
            ),
          ],
        ),
      );
    }

    Widget _labelgame(text) {
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
              _erroridgame ?? '',
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: Colors.red,
                  fontFamily: 'ProximaRegular'),
            ),
          ],
        ),
      );
    }

    Widget _showErrorMessage() {
      var size = MediaQuery.of(context).size;
      final double itemWidthpading = (size.width) / 8;
      final double itemWidth = (size.width) - itemWidthpading;
      final double itemHeightEmail = (size.width) / 8;
      final double textSize1 = (size.width) /
          25; //25sp sample title tournament list /username dilogin
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

    Widget _gameidInput() {
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
              enabled: false,
              controller: _gameidController,
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
                hintText: "Game ID",
                labelStyle: new TextStyle(
                    color: textColor2,
                    fontSize: mediaquery.width / textSize14sp,
                    fontFamily: 'ProximaReguler'),

                // icon:
              ),
              maxLength: 30,

              onChanged: (value) {
                if (listRole.length != 0 &&
                    value.length != 0 &&
                    _nicknameController.text != '') {
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

    // Widget _choiceChip(){
    //   return Container(
    //     padding: EdgeInsets.only(left: 20.0, right: 20.0),
    //     child: Align(
    //       alignment: Alignment.centerLeft,
    //                     child: Wrap(
    //       alignment: WrapAlignment.start,
    //       spacing: 5.0,
    //       runSpacing: 5.0,
    //       children: <Widget>[
    //         choiceChipWidget(chipList),
    //       ],
    //       ),
    //     )
    //   );
    // }

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
            child: new Text('Lanjut',
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
            child: new Text('Lanjut',
                style: new TextStyle(
                    fontSize: mediaquery.width / textSize17sp,
                    color: Colors.black,
                    fontFamily: 'ProximaBold')),
          ),
        ),
      );
    }

    Widget _labeltnctr() {
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
                  'Kamu tidak sedang ikut turnamen.',
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

    Widget _labeltnc() {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Stack(
            children: <Widget>[
              Icon(Icons.report, color: Colors.red),
              Container(
                padding: EdgeInsets.only(left: 30.0),
                child: Text(
                  'Perhatian: Jika kamu menggunakan nickname atau game ID yang tidak sama dengan yang ada di dalam game, kamu akan di diskualifikasi dari kompetisi / turnamen.',
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

    var shimmerChoosechip = Container(
      // padding: const EdgeInsets.all(5.0),
      // padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Shimmer.fromColors(
        baseColor: colorShimer,
        // highlightColor: Colors.grey[300],
        // baseColor: Colors.grey[100],
        highlightColor: colorlightShimer,
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.all(Radius.circular(
                              50.0) //         <--- border radius here
                          ),
                      color: colorShimer,
                    ),
                    height: mediaquery.width / 12,
                    width: mediaquery.width / 4,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.all(Radius.circular(
                              50.0) //         <--- border radius here
                          ),
                      color: colorShimer,
                    ),
                    margin: EdgeInsets.only(
                        left: mediaquery.width / 50,
                        right: mediaquery.width / 50),
                    height: mediaquery.width / 12,
                    width: mediaquery.width / 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.all(Radius.circular(
                              50.0) //         <--- border radius here
                          ),
                      color: colorShimer,
                    ),
                    height: mediaquery.width / 12,
                    width: mediaquery.width / 4.5,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: mediaquery.width / 50),
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.all(Radius.circular(
                              50.0) //         <--- border radius here
                          ),
                      color: colorShimer,
                    ),
                    height: mediaquery.width / 12,
                    width: mediaquery.width / 7,
                  )
                  // Container(
                  //   margin: EdgeInsets.only(left:mediaquery.width/20,right: mediaquery.width/20),

                  //   height: mediaquery.width/14,
                  //   width: mediaquery.width/5,
                  //   color: colorShimer,
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(left:mediaquery.width/20,right: mediaquery.width/20),
                  //   height: mediaquery.width/14,
                  //   width: mediaquery.width/4,
                  //   color: colorShimer,
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.all(Radius.circular(
                              50.0) //         <--- border radius here
                          ),
                      color: colorShimer,
                    ),
                    height: mediaquery.width / 12,
                    width: mediaquery.width / 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.all(Radius.circular(
                              50.0) //         <--- border radius here
                          ),
                      color: colorShimer,
                    ),
                    margin: EdgeInsets.only(
                        left: mediaquery.width / 50,
                        right: mediaquery.width / 50),
                    height: mediaquery.width / 12,
                    width: mediaquery.width / 6,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.all(Radius.circular(
                              50.0) //         <--- border radius here
                          ),
                      color: colorShimer,
                    ),
                    margin: EdgeInsets.only(right: mediaquery.width / 50),
                    height: mediaquery.width / 12,
                    width: mediaquery.width / 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.all(Radius.circular(
                              50.0) //         <--- border radius here
                          ),
                      color: colorShimer,
                    ),
                    height: mediaquery.width / 12,
                    width: mediaquery.width / 5,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    List<String> selectedReportList = List();

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0XFF22272B),

          title: Text(widget.name ?? ''),

          actions: <Widget>[],

          // title: Text('Tabs Demo'),
        ),
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: mediaquery.width / 20,
                ),
                SizedBox(
                  height: mediaquery.width / 20,
                ),
                _labelgame('Game ID kamu'),
                _gameidInput(),
                SizedBox(
                  height: mediaquery.width / 20,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: _showScreenshotButton()),
                SizedBox(
                  height: mediaquery.width / 20,
                ),
                _labelrole('Role kamu dalam permainan'),
                // _choiceChip(),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: listRole.length == 0
                      ? shimmerChoosechip
                      : MultiSelectChip(
                          listRole,
                          onSelectionChanged: (selectedList) {
                            setState(() {
                              selectedReportList = selectedList;
                              print('lihat listnya $listSelectedid');
                              print('lihat lis $selectedChoices');

                              if (listSelectedid.length != 0 &&
                                  _gameidController.text != '') {
                                _isDisable = false;
                              } else {
                                _isDisable = true;
                              }
                            });
                          },
                        ),
                ),

                SizedBox(
                  height: mediaquery.width / 20,
                ),
                _labeltnctr(),
                _labeltnc(),
                SizedBox(
                  height: mediaquery.width / 20,
                ),
                _showErrorMessage(),
                SizedBox(
                  height: mediaquery.width / 20,
                ),
                _statusButton(),
                SizedBox(
                  height: mediaquery.width / 20,
                ),
              ],
            ),
          ),
        ));
  }
}

class MultiSelectChip extends StatefulWidget {
  final List listRole;
  final Function(List<String>) onSelectionChanged;
  final Function(List<int>) onSelectionChangedint;

  MultiSelectChip(this.listRole,
      {this.onSelectionChanged, this.onSelectionChangedint});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";

  _buildChoiceList() {
    var mediaquery = MediaQuery.of(context).size;
    List<Widget> choices = List();
    newrole = StringBuffer();
    if (isfist == true && listRole.length != 0) {
      print('is first');
      widget.listRole.forEach((itemd) {
        var item = itemd['role'];
        int itemid = itemd['role_id'];
        bool isselect = itemd['is_select'];
        print('is first lihat list dt $itemd');
        if (isselect) {
          setState(() {
            selectedChoices.add(item);
            listSelectedid.add(itemid);
            // widget.onSelectionChanged(selectedChoices);
          });
        }

        // print('LIHAT FOREACH ITEM $itemd');
        choices.add(Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            backgroundColor: Color(0xFF38424a),
            selectedColor: backgroundYellow,
            selectedShadowColor: Colors.red,
            label: Text(item,
                style: TextStyle(
                    fontSize: mediaquery.width / textSize14sp,
                    color: isselect
                        ? Colors.black
                        : selectedChoices.contains(item)
                            ? Colors.black
                            : textColor2,
                    fontFamily: 'ProximaRegular')),
            selected: isselect ?? selectedChoices.contains(item),
            onSelected: (selected) {
              setState(() {
                print('lihat data fist $selectedChoices');
                widget.onSelectionChanged(selectedChoices);
              });
            },
          ),
        ));
      });
      listSelectedid.forEach((item) async {
        newrole.write('$item,');
        print('lihat newrole $newrole');
      });
      isfist = false;

      print('after is first lihat status $isfist');
    } else {
      print('masuk k else first');
      widget.listRole.forEach((itemd) {
        var item = itemd['role'];
        int itemid = itemd['role_id'];

        // print('LIHAT FOREACH ITEM $itemd');
        choices.add(Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            backgroundColor: Color(0xFF38424a),
            selectedColor: backgroundYellow,
            selectedShadowColor: Colors.red,
            label: Text(item,
                style: TextStyle(
                    fontSize: mediaquery.width / textSize14sp,
                    color: selectedChoices.contains(item)
                        ? Colors.black
                        : textColor2,
                    fontFamily: 'ProximaRegular')),
            selected: selectedChoices.contains(item),
            onSelected: (selected) {
              setState(() {
                print('--> lihat 1 $listSelectedid');
                selectedChoices.contains(item)
                    ? selectedChoices.remove(item)
                    : selectedChoices.add(item);

                listSelectedid.contains(itemid)
                    ? listSelectedid.remove(itemid)
                    : listSelectedid.add(itemid);

                print('--> lihat 2 $listSelectedid');

                widget.onSelectionChanged(selectedChoices);
                //  widget.onSelectionChangedint(listSelectedid);
              });
            },
          ),
        ));
      });

      listSelectedid.forEach((item) async {
        newrole.write('$item,');
        print('lihat newrole $newrole');
      });
    }

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
