import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
// import 'package:yamisok/api/basic_info/basic_info_api.dart';
import 'package:yamisok/api/basic_info/basic_info_new_api.dart';
import 'package:yamisok/api/basic_info/basic_info_sosial_api.dart';
import 'package:yamisok/api/basic_info/basic_info_update_api.dart';
import 'package:yamisok/api/profile/profile_achievement_api.dart';
import 'package:yamisok/api/profile/profile_upcoming_api.dart';
// import 'package:yamisok/component/styleyami.dart';
import 'package:yamisok/page/game/connect_game.dart';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/redux/action.dart' as AppAction;
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/page/utilities/style.dart';
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/page/verification_email/verification_email.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

List listProvinsi = [];
List listKota = [];
var idprovinsi = "";
var txprovinsi = "";
var idkota = "";
var txkota = "";
String gender = "Laki-laki";
int idgender = 1;
bool loadkota;
bool _isLoading;
bool _isDisable;
String _errorprovinsi = "";
String _errorkota = "";
String _erroremail = "";
String _errorname = "";
String _errorusername = "";

class BasicInfo extends StatefulWidget {
  static String tag = 'basic-page';
  final String idsocial;
  final String socialtoken;
  final String signature;
  final String provider;
  final String name;
  final String email;
  final String username;
  final String password;
  final String verify;
  final String statusPlayer;
  final String token;
  final String playerid;

  BasicInfo(
      {Key key,
      this.email,
      this.username,
      this.password,
      this.verify,
      this.statusPlayer,
      this.token,
      this.playerid,
      this.name,
      this.idsocial,
      this.socialtoken,
      this.signature,
      this.provider})
      : super(key: key);
  @override
  _BasicInfoState createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    //  apiAchive();
    loadkota = false;
    _emailController.text = widget.email;
    _usernameController.text = widget.username;
    _nameController.text = widget.name;
    _isLoading = false;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    analytics.logEvent(name: 'Basic_info');
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

    void _showDialogGender() {
      // flutter defined function
      showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            // title: new Text("Alert Dialog title"),
            content: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Pilih Jenis Kelamin",
                        style: TextStyle(fontSize: textSize18sp),
                      ),
                      GestureDetector(
                          onTap: Navigator.of(context).pop,
                          child: Icon(Icons.close))
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
                      height: 1.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(
                                10.0) //         <--- border radius here
                            ),
                        gradient: LinearGradient(
                          colors: [Colors.black26, Colors.black26],
                          begin: Alignment(-1.0, -2.0),
                          end: Alignment(1.0, 2.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            gender = "Laki-laki";
                            idgender = 1;
                          });
                          Navigator.of(context).pop();
                          // Navigator.of().pop();
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          height: mediaquery.width / buttonHeight1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Laki-laki",
                              style: TextStyle(fontSize: textSize18sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      height: 1.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            gender = "Perempuan";
                            idgender = 0;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          height: mediaquery.width / buttonHeight1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Perempuan",
                              style: TextStyle(fontSize: textSize18sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    Widget _provinsilist() {
      return Container(
        child: StoreConnector<AppState, ViewModel>(
          builder: (BuildContext context, ViewModel vm) {
            var contain = vm.state.provinsi_content;
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: contain.length,
                itemBuilder: (BuildContext context, index) {
                  var nameprovinsi = contain[index]["province_name"];
                  String provinsi = contain[index]["province_id"].toString();
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              print('jalan tap');
                              vm.updatekota(provinsi);
                              Timer _timer;
                              _timer = new Timer(
                                  const Duration(milliseconds: 5000), () {
                                if (mounted) {
                                  setState(() {
                                    loadkota = false;
                                  });
                                }
                              });

                              setState(() {
                                loadkota = true;
                                txprovinsi = nameprovinsi;
                                idprovinsi = provinsi;
                                txkota = "";
                                idkota = "";
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              height: mediaquery.width / 8,
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text(nameprovinsi),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.black12,
                          height: 1.0,
                        )
                      ],
                    ),
                  );
                });

            // print('lihat isi contain provinsi $contain');
          },
          converter: (store) {
            return ViewModel(
                state: store.state,
                updatekota: (String provinsi) =>
                    store.dispatch(AppAction.UpdateKota(provinsi: provinsi)));
          },
          onInit: (store) {
            // store.dispatch(AppAction.UpdateProvinsi());
          },
        ),
      );

      // }
    }

    void _showDialogProvinsi() {
      // flutter defined function
      showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            // title: new Text("Alert Dialog title"),
            content: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Pilih Provinsi",
                        style: TextStyle(fontSize: textSize18sp),
                      ),
                      GestureDetector(
                          onTap: Navigator.of(context).pop,
                          child: Icon(Icons.close))
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
                      height: 1.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(
                                10.0) //         <--- border radius here
                            ),
                        gradient: LinearGradient(
                          colors: [Colors.black26, Colors.black26],
                          begin: Alignment(-1.0, -2.0),
                          end: Alignment(1.0, 2.0),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                        child: new Container(
                      height: mediaquery.height / 2,
                      child: _provinsilist(),
                    )),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    Widget _kotalist() {
      return Container(
        child: StoreConnector<AppState, ViewModel>(
          builder: (BuildContext context, ViewModel vm) {
            var contain = vm.state.kota_content;
            // print('lihat isi contain provinsi $contain');
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: contain.length,
                itemBuilder: (BuildContext context, index) {
                  var name = contain[index]["city_name_full"];
                  String id = contain[index]["city_id"].toString();

                  return Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              // vm.updatekota(provinsi);
                              //  vm.updatekota(provinsi);
                              if (_usernameController.text.length != 0 &&
                                  _nameController.text.length != 0 &&
                                  idprovinsi != "") {
                                setState(() {
                                  _isDisable = false;
                                  txkota = name;
                                  idkota = id;
                                });
                              } else {
                                setState(() {
                                  _isDisable = true;
                                  txkota = name;
                                  idkota = id;
                                });
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              height: mediaquery.width / 8,
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text(name),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.black12,
                          height: 1.0,
                        )
                      ],
                    ),
                  );
                });
          },
          converter: (store) {
            return ViewModel(
              state: store.state,
              // updatekota : (String provinsi) => store.dispatch(AppAction.UpdateKota(provinsi:provinsi))
            );
          },
          onInit: (store) {
            // store.dispatch(AppAction.UpdateProvinsi());
          },
        ),
      );

      // }
    }

    void _showDialogkota() {
      // flutter defined function
      showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            // title: new Text("Alert Dialog title"),
            content: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Pilih Kota",
                        style: TextStyle(fontSize: textSize18sp),
                      ),
                      GestureDetector(
                          onTap: Navigator.of(context).pop,
                          child: Icon(Icons.close))
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
                      height: 1.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(
                                10.0) //         <--- border radius here
                            ),
                        gradient: LinearGradient(
                          colors: [Colors.black26, Colors.black26],
                          begin: Alignment(-1.0, -2.0),
                          end: Alignment(1.0, 2.0),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                        child: new Container(
                      height: mediaquery.height / 2,
                      child: _kotalist(),
                    )),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    Widget _labelname(text) {
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
              _errorname,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: Colors.red,
                  fontFamily: 'ProximaRegular'),
            ),
          ],
        ),
      );
    }

    Widget _nameInput() {
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
              controller: _nameController,
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
                hintText: "Your Name here",
                labelStyle: new TextStyle(
                    color: textColor2,
                    fontSize: mediaquery.width / textSize14sp,
                    fontFamily: 'ProximaReguler'),

                // icon:
              ),
              onChanged: (value) {
                if (value.length != 0 &&
                    _usernameController.text.length != 0 &&
                    _emailController.text.length != 0 &&
                    idkota != "" &&
                    idprovinsi != "") {
                  setState(() {
                    _isDisable = false;
                  });
                } else {
                  setState(() {
                    _isDisable = true;
                  });
                }
              },
              maxLength: 30,

              // onChanged: (value){
              //   if(value.length!=0 &&
              //       _emailController.text.length!=0 &&
              //       _confirmpasswordController.text.length!=0 &&
              //       _passwordController.text.length!=0){
              //       setState(() {
              //        _isDisable =false;
              //       });
              //   }else{
              //       setState(() {
              //        _isDisable =true;
              //       });
              //   }
              // },
            ),
          ),
        ),
      );
    }

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
              _errorusername,
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
                    _nameController.text.length != 0 &&
                    idkota != "" &&
                    idprovinsi != "") {
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
              _erroremail,
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
              controller: _emailController,
              enabled: false,
              style: TextStyle(
                  color: textColorDisable,
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
                // labelText: widget.email,
                hintText: widget.email,
                labelStyle: new TextStyle(
                    color: textColorDisable,
                    fontSize: mediaquery.width / textSize14sp,
                    fontFamily: 'ProximaReguler'),

                // icon:
              ),
              maxLength: 30,
              onChanged: (value) {
                if (value.length != 0 &&
                    _usernameController.text.length != 0 &&
                    _nameController.text.length != 0 &&
                    idkota != "" &&
                    idprovinsi != "") {
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

    Widget _labeljeniskelamin(text) {
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

    Widget _dropDownGender() {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: GestureDetector(
          onTap: () {
            _showDialogGender();
          },
          child: Container(
            height: mediaquery.width / buttonHeight1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0) //         <--- border radius here
                  ),
              color: backgroundBlackDefault,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      gender,
                      style: TextStyle(
                          fontSize: mediaquery.width / textSize14sp,
                          // fontFamily: 'ProximaBold',
                          color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.expand_more,
                      size: textSize20sp,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _labelprovinsi(text) {
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
              _errorprovinsi,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: Colors.red,
                  fontFamily: 'ProximaRegular'),
            ),
          ],
        ),
      );
    }

    Widget _dropDownProvinsi() {
      return StoreConnector<AppState, ViewModel>(
        builder: (BuildContext context, ViewModel vm) {
          var contain = vm.state.provinsi_content;

          return GestureDetector(
            onTap: () {
              _showDialogProvinsi();
            },
            child: Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              height: mediaquery.width / buttonHeight1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //         <--- border radius here
                    ),
                color: backgroundBlackDefault,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        txprovinsi != "" ? txprovinsi : 'Pilih Provinsi',
                        style: TextStyle(
                            fontSize: mediaquery.width / textSize14sp,
                            // fontFamily: 'ProximaBold',
                            color: Colors.white),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.expand_more,
                        size: textSize20sp,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        converter: (store) {
          return ViewModel(
              state: store.state,
              updateprovinsi: () => store.dispatch(AppAction.UpdateProvinsi()));
        },
        onInit: (store) {
          store.dispatch(AppAction.UpdateProvinsi());
        },
      );
    }

    Widget _labelkota(text) {
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
              _errorkota,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize14sp,
                  color: Colors.red,
                  fontFamily: 'ProximaRegular'),
            ),
          ],
        ),
      );
    }

    Widget _dropDownKota() {
      return GestureDetector(
        onTap: () {
          if (txprovinsi == "") {
          } else {
            if (!loadkota) {
              _showDialogkota();
            }
          }
        },
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          height: mediaquery.width / buttonHeight1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(5.0) //         <--- border radius here
                ),
            color: backgroundBlackDefault,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    txkota != "" ? txkota : 'Pilih Kota',
                    style: TextStyle(
                        fontSize: mediaquery.width / textSize14sp,
                        // fontFamily: 'ProximaBold',
                        color: Colors.white),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: loadkota
                      ? Container(
                          height: (mediaquery.width / buttonHeight1) / 2,
                          width: (mediaquery.width / buttonHeight1) / 2,
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  backgroundYellow)))
                      : Icon(Icons.expand_more,
                          size: textSize20sp, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      );
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
        _isLoading = true;
        _errorprovinsi = "";
        _errorkota = "";
        _erroremail = "";
        _errorname = "";
      });
      var name = _nameController.text;
      var username = _usernameController.text;
      var email = _emailController.text;
      var password = widget.password;
      var verify = widget.verify;

      bool emailValid =
          RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

      if (name == '') {
        setState(() {
          _errorname = 'Name cant be empty';
          _isLoading = false;
        });
      } else if (email == '') {
        setState(() {
          _erroremail = 'Email cant be empty';
          _isLoading = false;
        });
      } 
      else if (emailValid == false) {
        setState(() {
          _erroremail = "Please check your email";
          _isLoading = false;
        });
      } 
      else if (idprovinsi == '') {
        setState(() {
          _errorprovinsi = "Please pick province";
          _isLoading = false;
        });
      } else if (idkota == '') {
        setState(() {
          _errorkota = "Please pick city";
          _isLoading = false;
        });
      } else {
        if (widget.statusPlayer == '0') {
          print("statusPlayer : new user for register");
           ApiServiceBasicNew.apibasicinfonew(
                  name, username, email, password, idgender, idkota)
              .then((rst) async {
            // var jsn = json.decode(response.body);
            var resultdt = json.decode(rst);
            final messages = resultdt['messages'];
            final status = resultdt['status'];
            if (status == true) {
              setState(() {
                _errorprovinsi = "";
                _errorkota = "";
                _erroremail = "";
                _errorname = "";
                _errorusername = "";
                _isLoading = false;
              });
              final token = resultdt['token'];
              final playerID = resultdt['player_id'];
              final avatar_url = resultdt['avatar_url'].toString();
              final username = resultdt['username'].toString();
              final email = resultdt['email'].toString();

              saveLocallogin(token, playerID, avatar_url, username).then((val) {
                if (widget.verify == '0') {
                  setLatestPage('VerificationEmail').then((val) {
                    setEmail(email).then((val) {
                      Navigator.pushReplacementNamed(
                          context, VerificationEmail.tag);
                    });
                  });
                } else {
                  setLatestPage('ConnectGame').then((lates) {
                    keyStore.getLatestPage().then((resultLates) {
                      print('lihat set lates page $resultLates');
                      setEmail(email).then((val) {
                        Navigator.pushReplacementNamed(
                            context, ConnectGame.tag);
                      });
                    });
                  });
                }
              });
            } else {
              setState(() {
                _errorprovinsi = "";
                _errorkota = "";
                _erroremail = "";
                _errorname = "";
                _errorusername = "";
                _isLoading = false;
              });
              var string = messages;
              if (string.contains('username')) {
                setState(() {
                  _errorusername = messages;
                });
              }
              if (string.contains('email')) {
                setState(() {
                  _erroremail = messages;
                });
              }
            }
          });
        } else if (widget.statusPlayer == '1') {
          print("statusPlayer :  new user for register social");
          var idsocial = widget.idsocial ?? '';
          var socialtoken = widget.socialtoken ?? '';
          var signature = widget.signature ?? '';
          var provider = widget.provider ?? '';
          ApiServiceBasicSocial.apibasicinfosocial(
                  idsocial,
                  socialtoken,
                  signature,
                  provider,
                  name,
                  username,
                  email,
                  password,
                  idgender,
                  idkota)
              .then((rst) async {
            // var jsn = json.decode(response.body);
            var resultdt = json.decode(rst);
            final messages = resultdt['messages'];
            final status = resultdt['status'];
            if (status == true) {
              setState(() {
                _errorprovinsi = "";
                _errorkota = "";
                _erroremail = "";
                _errorname = "";
                _errorusername = "";
                _isLoading = false;
              });
              final token = resultdt['token'];
              final playerID = resultdt['player_id'];
              final avatar_url = resultdt['avatar_url'].toString();
              final username = resultdt['username'].toString();
              final email = resultdt['email'].toString();

              saveLocallogin(token, playerID, avatar_url, username).then((val) {
                if (widget.verify == '0') {
                  setLatestPage('VerificationEmail').then((val) {
                    setEmail(email).then((val) {
                      Navigator.pushReplacementNamed(
                          context, VerificationEmail.tag);
                    });
                  });
                } else {
                  setLatestPage('ConnectGame').then((lates) {
                    keyStore.getLatestPage().then((resultLates) {
                      print('lihat set lates page $resultLates');
                      setEmail(email).then((val) {
                        Navigator.pushReplacementNamed(
                            context, ConnectGame.tag);
                      });
                    });
                  });
                }
              });
            } else {
              setState(() {
                _errorprovinsi = "";
                _errorkota = "";
                _erroremail = "";
                _errorname = "";
                _errorusername = "";
                _isLoading = false;
              });
              var string = messages;
              if (string.contains('username')) {
                setState(() {
                  _errorusername = messages;
                });
              }
              if (string.contains('email')) {
                setState(() {
                  _erroremail = messages;
                });
              }
            }
          });
        } else {
          print("statusPlayer : new user for existing");
          var playerid = widget.playerid;
          var token = widget.token;

          ApiServiceBasicUpdate.apibasicinfoupdate(token, playerid, name,
                  username, email, password, idgender, idkota)
              .then((rst) async {
            // var jsn = json.decode(response.body);
            var resultdt = json.decode(rst);
            final messages = resultdt['messages'];
            final status = resultdt['status'];
            if (status == true) {
              print("statusPlayer : dtatus true");
              setState(() {
                _errorprovinsi = "";
                _errorkota = "";
                _erroremail = "";
                _errorname = "";
                _errorusername = "";
                _isLoading = false;
              });
              final token = resultdt['token'];
              final playerID = resultdt['player_id'];
              final avatar_url = resultdt['avatar_url'].toString();
              final username = resultdt['username'].toString();
              final email = resultdt['email'].toString();
              print('masuk k status save sukses');

              saveLocallogin(token, playerID, avatar_url, username).then((val) {
                if (widget.verify == '0') {
                  setLatestPage('VerificationEmail').then((val) {
                    setEmail(email).then((val) {
                      Navigator.pushReplacementNamed(
                          context, VerificationEmail.tag);
                    });
                  });
                } else {
                  setLatestPage('ConnectGame').then((lates) {
                    keyStore.getLatestPage().then((resultLates) {
                      print('lihat set lates page $resultLates');
                      setEmail(email).then((val) {
                        Navigator.pushReplacementNamed(
                            context, ConnectGame.tag);
                      });
                    });
                  });
                }
              });
            } else {
              setState(() {
                _errorprovinsi = "";
                _errorkota = "";
                _erroremail = "";
                _errorname = "";
                _errorusername = "";
                _isLoading = false;
              });
              var string = messages;
              if (string.contains('username')) {
                setState(() {
                  _errorusername = messages;
                });
              }
              if (string.contains('email')) {
                setState(() {
                  _erroremail = messages;
                });
              }
            }
          });
        }
      }
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
          buttonColor: backgroundDisable,
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

    var columusername = Container();
    if (widget.username == '') {
      columusername = Container(
        child: Column(
          children: <Widget>[
            _labelusername('Username'),
            _usernameInput(),
            SizedBox(
              height: mediaquery.width / 20,
            ),
          ],
        ),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).padding.top,
            ),
            SizedBox(
              height: mediaquery.width / 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                'Profile untuk mencari teman',
                style: TextStyle(
                    fontSize: mediaquery.width / textSize18sp,
                    color: backgroundYellow,
                    fontFamily: 'ProximaBold'),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: mediaquery.width / 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                'Akun kamu hampir selesai. Lengkapi data dibawah ini untuk pencarian teman yang lebih akurat.',
                // username ${widget.username} || email ${widget.email} ||
                // nama ${widget.name} || verify ${widget.verify} || statusPlayer ${widget.statusPlayer}
                // || playerid ${widget.playerid} || token  ${widget.token}',
                style: TextStyle(
                    fontSize: mediaquery.width / textSize14sp,
                    color: textColor2),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: mediaquery.width / 20,
            ),
            _labelname('Nama'),
            _nameInput(),
            SizedBox(
              height: mediaquery.width / 20,
            ),
            Container(
              child: columusername,
            ),
            _labelemail('Email'),
            _showEmailInput(),
            SizedBox(
              height: mediaquery.width / 20,
            ),
            _labeljeniskelamin('Jenis Kelamin'),
            _dropDownGender(),
            SizedBox(
              height: mediaquery.width / 20,
            ),
            _labelprovinsi('Pilih Provinsi'),
            _dropDownProvinsi(),
            SizedBox(
              height: mediaquery.width / 20,
            ),
            _labelkota('Pilih Kota'),
            _dropDownKota(),
            // _provinsi(),
            SizedBox(
              height: mediaquery.width / 20,
            ),
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
    );
  }
}
