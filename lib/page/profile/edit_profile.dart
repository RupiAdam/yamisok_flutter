import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yamisok/component/globals.dart';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/page/redux/action.dart' as AppAction;
import 'package:quiver/async.dart';
import 'package:yamisok/component/keyStore.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:yamisok/api/profile/profile_edit_detail_api.dart';

import '../utilities/style.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

var focusNode = new FocusNode();

var varIdGender = "";
var varIdGenderTemp = "";
var varIdProvince = "";
var varProvince = "";
var varIdCity = "";
var varCity = "";

var realNameControllerTemp = "";
var dobControllerTemp = "";
var addressControllerTemp = "";
var telpControllerTemp = "";
var emailControllerTemp = "";
var facebookControllerTemp = "";
var twitterControllerTemp = "";
var instagramControllerTemp = "";
var youtubeControllerTemp = "";

String strStatusBoD = "";
String strGender = "Pria";
String strGenderTemp = "";
String strStatusAddress = "";
String strStatusTelp = "";
String strStatusEmail = "";

bool isShowDoB = true;
bool isShowAddress = false;
bool isShowTelp = false;
bool isShowEmail = false;

bool isShowDoBTemp = true;
bool isShowAddressTemp = false;
bool isShowTelpTemp = false;
bool isShowEmailTemp = false;

bool isLoadCity = false;
bool isDisableCity;
bool isDisableBtn = false;

class EditProfile extends StatefulWidget {
  static String tag = 'edit-profile-page';

  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  String msgError = "";
  String token = "";
  String username = "";

  bool isError = false;
  bool isLoadSave = false;

  ScrollController scrollController = ScrollController();

  final realNameController = TextEditingController();
  final urlProfileController = TextEditingController();
  final countryController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final telpController = TextEditingController();
  final emailController = TextEditingController();
  final facebookController = TextEditingController();
  final twitterController = TextEditingController();
  final instagramController = TextEditingController();
  final youtubeController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    fetchDataInit();

    // if (isShowDoB) {
    //   setState(() {
    //     strStatusBoD = "Tampilkan";
    //   });
    // } else {
    //   setState(() {
    //     strStatusBoD = "Sembunyikan";
    //   });
    // }

    // if (isShowAddress) {
    //   setState(() {
    //     strStatusAddress = "Tampilkan";
    //   });
    // } else {
    //   setState(() {
    //     strStatusAddress = "Sembunyikan";
    //   });
    // }

    // if (isShowTelp) {
    //   setState(() {
    //     strStatusTelp = "Tampilkan";
    //   });
    // } else {
    //   setState(() {
    //     strStatusTelp = "Sembunyikan";
    //   });
    // }

    // if (isShowEmail) {
    //   setState(() {
    //     strStatusEmail = "Tampilkan";
    //   });
    // } else {
    //   setState(() {
    //     strStatusEmail = "Sembunyikan";
    //   });
    // }

    analytics.logEvent(name: 'Edit_profile');
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Widget labelInput(valueText) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            valueText,
            style: TextStyle(
                fontSize: mediaquery.width / textSize14sp,
                color: textColor2,
                fontFamily: 'ProximaRegular'),
          ),
        ],
      ),
    );
  }

  Widget textRealName() {
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
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: TextField(
            focusNode: focusNode,
            controller: realNameController,
            style: TextStyle(
                color: textColor2,
                fontSize: mediaquery.width / textSize14sp,
                fontFamily: 'ProximaReguler'),
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              border: InputBorder.none,
              hintStyle:
                  TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
              prefixStyle: TextStyle(color: Colors.white),
              counterText: "",
              hintText: "Nama Asli Kamu",
              labelStyle: new TextStyle(
                  color: textColor2,
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaReguler'),
            ),
            maxLength: 50,
          ),
        ),
      ),
    );
  }

  Widget textURLProfile() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      height: mediaquery.width / buttonHeight1,
      width: double.infinity,
      decoration: new BoxDecoration(
        color: Color(0xFF1e2427),
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(5.0),
            bottomLeft: const Radius.circular(5.0),
            topRight: const Radius.circular(5.0),
            bottomRight: const Radius.circular(5.0)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: TextField(
            enabled: false,
            controller: urlProfileController,
            style: TextStyle(
                color: textColor1,
                fontSize: mediaquery.width / textSize14sp,
                fontFamily: 'ProximaReguler'),
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              border: InputBorder.none,
              hintStyle:
                  TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
              counterText: "",
              labelStyle: new TextStyle(
                  color: textColor2,
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaReguler'),
            ),
            maxLength: 50,
          ),
        ),
      ),
    );
  }

  Widget textCountry() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      height: mediaquery.width / buttonHeight1,
      width: double.infinity,
      decoration: new BoxDecoration(
        color: Color(0xFF1e2427),
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
            enabled: false,
            controller: countryController,
            style: TextStyle(
                color: textColor1,
                fontSize: mediaquery.width / textSize14sp,
                fontFamily: 'ProximaReguler'),
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              border: InputBorder.none,
              hintStyle:
                  TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
              counterText: "",
              labelStyle: new TextStyle(
                  color: textColor2,
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaReguler'),
            ),
            maxLength: 30,
          ),
        ),
      ),
    );
  }

  Widget labelDoB(valueText) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            valueText,
            style: TextStyle(
                fontSize: mediaquery.width / textSize14sp,
                color: textColor2,
                fontFamily: 'ProximaRegular'),
          ),
          Row(children: <Widget>[
            Container(
                child: Text(
              strStatusBoD,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize12sp,
                  color: textColor1,
                  fontFamily: 'ProximaRegular'),
            )),
            Container(
              // color: textColor2,
              child: Transform.scale(
                  scale: 1,
                  child: new Switch(
                    value: isShowDoB,
                    onChanged: switchChangeDoB,
                    activeColor: accent,
                    activeTrackColor: Color(0xFF2f3336),
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.white,
                  )),
            )
          ])
        ],
      ),
    );
  }

  Widget datepickerBirth() {
    var mediaquery = MediaQuery.of(context).size;

    var component = new Container(
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
            enabled: false,
            controller: dobController,
            style: TextStyle(
                color: textColor2,
                fontSize: mediaquery.width / textSize14sp,
                fontFamily: 'ProximaReguler'),
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              border: InputBorder.none,
              hintStyle:
                  TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
              counterText: "",
              hintText: "yyyy-MM-dd",
              labelStyle: new TextStyle(
                  color: textColor2,
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaReguler'),
            ),
            onChanged: (value) {
              if (value.length != 0 &&
                  dobController.text.length != 0 &&
                  varIdGender.length != 0 &&
                  varIdProvince.length != 0 &&
                  varIdCity.length != 0 &&
                  telpController.text.length != 0) {
                setState(() {
                  isDisableBtn = false;
                });
              } else {
                setState(() {
                  isDisableBtn = true;
                });
              }
            },
            maxLength: 15,
          ),
        ),
      ),
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              selectDoB(context);
            },
            child: component,
          ),
        ],
      ),
    );
  }

  Widget selectGender() {
    var mediaquery = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: GestureDetector(
        onTap: () {
          showDialogGender();
        },
        child: Container(
          height: mediaquery.width / buttonHeight1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: Color(0xFF2f3336),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    strGender,
                    style: TextStyle(
                        fontSize: mediaquery.width / textSize14sp,
                        color: textColor2),
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

  Widget selectProvince() {
    var mediaquery = MediaQuery.of(context).size;

    return StoreConnector<AppState, ViewModel>(
      builder: (BuildContext context, ViewModel vm) {
        return GestureDetector(
          onTap: () {
            showDialogProvince();
          },
          child: Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            height: mediaquery.width / buttonHeight1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Color(0xFF2f3336),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      varProvince != "" ? varProvince : 'Pilih Provinsi',
                      style: TextStyle(
                          fontSize: mediaquery.width / textSize14sp,
                          color: textColor2),
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

  Widget selectCity() {
    var mediaquery = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (varProvince == "") {
        } else {
          if (!isLoadCity) {
            showDialogCity();
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        height: mediaquery.width / buttonHeight1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Color(0xFF2f3336),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  varCity != "" ? varCity : 'Pilih Kota',
                  style: TextStyle(
                      fontSize: mediaquery.width / textSize14sp,
                      color: textColor2),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: isLoadCity
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

  Widget labelAddress(valueText) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            valueText,
            style: TextStyle(
                fontSize: mediaquery.width / textSize14sp,
                color: textColor2,
                fontFamily: 'ProximaRegular'),
          ),
          Row(children: <Widget>[
            Text(
              strStatusAddress,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize12sp,
                  color: textColor1,
                  fontFamily: 'ProximaRegular'),
            ),
            Transform.scale(
                scale: 1,
                child: new Switch(
                  value: isShowAddress,
                  onChanged: switchChangeAddress,
                  activeColor: accent,
                  activeTrackColor: Color(0xFF2f3336),
                  inactiveThumbColor: Colors.black,
                  inactiveTrackColor: Colors.white,
                )),
          ])
        ],
      ),
    );
  }

  Widget textAddress() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
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
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: TextField(
            controller: addressController,
            style: TextStyle(
                color: textColor2,
                fontSize: mediaquery.width / textSize14sp,
                fontFamily: 'ProximaReguler'),
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintStyle:
                  TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
              prefixStyle: TextStyle(color: Colors.white),
              counterText: "",
              hintText: "Alamat tinggal kamu",
              labelStyle: new TextStyle(
                  color: textColor2,
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaReguler'),
            ),
            maxLength: 100,
          ),
        ),
      ),
    );
  }

  Widget labelTelp(valueText) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            valueText,
            style: TextStyle(
                fontSize: mediaquery.width / textSize14sp,
                color: textColor2,
                fontFamily: 'ProximaRegular'),
          ),
          Row(children: <Widget>[
            Text(
              strStatusTelp,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize12sp,
                  color: textColor1,
                  fontFamily: 'ProximaRegular'),
            ),
            Transform.scale(
                scale: 1,
                child: new Switch(
                  value: isShowTelp,
                  onChanged: switchChangeTelp,
                  activeColor: accent,
                  activeTrackColor: Color(0xFF2f3336),
                  inactiveThumbColor: Colors.black,
                  inactiveTrackColor: Colors.white,
                )),
          ])
        ],
      ),
    );
  }

  Widget textTelp() {
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
            controller: telpController,
            style: TextStyle(
                color: textColor2,
                fontSize: mediaquery.width / textSize14sp,
                fontFamily: 'ProximaReguler'),
            maxLines: 1,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              border: InputBorder.none,
              hintStyle:
                  TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
              prefixStyle: TextStyle(color: Colors.white),
              counterText: "",
              hintText: "Nomor handphone kamu",
              labelStyle: new TextStyle(
                  color: textColor2,
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaReguler'),
            ),
            onChanged: (value) {
              if (value.length != 0 &&
                  dobController.text.length != 0 &&
                  varIdGender.length != 0 &&
                  varIdProvince != "" &&
                  varIdCity != "" &&
                  telpController.text.length != 0) {
                setState(() {
                  isDisableBtn = false;
                });
              } else {
                setState(() {
                  isDisableBtn = true;
                });
              }
            },
            maxLength: 15,
          ),
        ),
      ),
    );
  }

  Widget labelEmail(valueText) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            valueText,
            style: TextStyle(
                fontSize: mediaquery.width / textSize14sp,
                color: textColor2,
                fontFamily: 'ProximaRegular'),
          ),
          Row(children: <Widget>[
            Text(
              strStatusEmail,
              style: TextStyle(
                  fontSize: mediaquery.width / textSize12sp,
                  color: textColor1,
                  fontFamily: 'ProximaRegular'),
            ),
            Transform.scale(
                scale: 1,
                child: new Switch(
                  value: isShowEmail,
                  onChanged: switchChangeEmail,
                  activeColor: accent,
                  activeTrackColor: Color(0xFF2f3336),
                  inactiveThumbColor: Colors.black,
                  inactiveTrackColor: Colors.white,
                )),
          ])
        ],
      ),
    );
  }

  Widget textEmail() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      height: mediaquery.width / buttonHeight1,
      width: double.infinity,
      decoration: new BoxDecoration(
        color: Color(0xFF1e2427),
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(5.0),
            bottomLeft: const Radius.circular(5.0),
            topRight: const Radius.circular(5.0),
            bottomRight: const Radius.circular(5.0)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: TextField(
            enabled: false,
            controller: emailController,
            style: TextStyle(
                color: textColor1,
                fontSize: mediaquery.width / textSize14sp,
                fontFamily: 'ProximaReguler'),
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              border: InputBorder.none,
              hintStyle:
                  TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
              counterText: "",
              labelStyle: new TextStyle(
                  color: textColor2,
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaReguler'),
            ),
            maxLength: 50,
          ),
        ),
      ),
    );
  }

  Widget textFacebook() {
    var mediaquery = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Container(
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
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Center(
              child: TextField(
                controller: facebookController,
                style: TextStyle(
                    color: textColor2,
                    fontSize: mediaquery.width / textSize14sp,
                    fontFamily: 'ProximaReguler'),
                maxLines: 1,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                  prefixText: "facebook.com/",
                  prefixStyle: TextStyle(color: Colors.transparent),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  border: InputBorder.none,
                  hintText: "username",
                  hintStyle: TextStyle(
                      color: inputHintColor,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  counterText: "",
                  labelStyle: new TextStyle(
                      color: textColor2,
                      fontSize: mediaquery.width / textSize14sp,
                      fontFamily: 'ProximaReguler'),
                ),
                maxLength: 50,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30.0, right: 20.0),
          child: Builder(builder: (context) {
            return Text(
              'facebook.com/',
              style: TextStyle(color: textColor2),
            );
          }),
        )
      ],
    );
  }

  Widget textTwitter() {
    var mediaquery = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Container(
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
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Center(
              child: TextField(
                controller: twitterController,
                style: TextStyle(
                    color: textColor2,
                    fontSize: mediaquery.width / textSize14sp,
                    fontFamily: 'ProximaReguler'),
                maxLines: 1,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                  prefixText: "twitter.com/",
                  prefixStyle: TextStyle(color: Colors.transparent),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  border: InputBorder.none,
                  hintText: "username",
                  hintStyle: TextStyle(
                      color: inputHintColor,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  counterText: "",
                  labelStyle: new TextStyle(
                      color: textColor2,
                      fontSize: mediaquery.width / textSize14sp,
                      fontFamily: 'ProximaReguler'),
                ),
                maxLength: 50,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30.0, right: 20.0),
          child: Builder(builder: (context) {
            return Text(
              'twitter.com/',
              style: TextStyle(color: textColor2),
            );
          }),
        )
      ],
    );
  }

  Widget textInstagram() {
    var mediaquery = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Container(
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
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Center(
              child: TextField(
                controller: instagramController,
                style: TextStyle(
                    color: textColor2,
                    fontSize: mediaquery.width / textSize14sp,
                    fontFamily: 'ProximaReguler'),
                maxLines: 1,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                  prefixText: "instagram.com/",
                  prefixStyle: TextStyle(color: Colors.transparent),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  border: InputBorder.none,
                  hintText: "username",
                  hintStyle: TextStyle(
                      color: inputHintColor,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  counterText: "",
                  labelStyle: new TextStyle(
                      color: textColor2,
                      fontSize: mediaquery.width / textSize14sp,
                      fontFamily: 'ProximaReguler'),
                ),
                maxLength: 50,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30.0, right: 20.0),
          child: Builder(builder: (context) {
            return Text(
              'instagram.com/',
              style: TextStyle(color: textColor2),
            );
          }),
        )
      ],
    );
  }

  Widget textYoutube() {
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
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: TextField(
            controller: youtubeController,
            style: TextStyle(
                color: textColor2,
                fontSize: mediaquery.width / textSize14sp,
                fontFamily: 'ProximaReguler'),
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              border: InputBorder.none,
              hintStyle:
                  TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
              prefixStyle: TextStyle(color: Colors.white),
              counterText: "",
              hintText: "URL Youtube Channel",
              labelStyle: new TextStyle(
                  color: textColor2,
                  fontSize: mediaquery.width / textSize14sp,
                  fontFamily: 'ProximaReguler'),
            ),
            maxLength: 100,
          ),
        ),
      ),
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
          onPressed: () {
            saveEditProfile();
          },
          child: indicatorLoading(),
        ),
      ),
    );
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
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  Widget buttonDisableVerification() {
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
      return buttonVerification();
    } else {
      return buttonDisableVerification();
    }
  }

  void switchChangeDoB(bool value) {
    setState(() {
      isShowDoB = value;
    });
    print(isShowDoB);

    if (isShowDoB == true) {
      setState(() {
        strStatusBoD = "Tampilkan";
      });
    } else {
      setState(() {
        strStatusBoD = "Sembunyikan";
      });
    }
  }

  void switchChangeAddress(bool value) {
    setState(() {
      isShowAddress = value;
    });
    print(isShowAddress);

    if (isShowAddress == true) {
      setState(() {
        strStatusAddress = "Tampilkan";
      });
    } else {
      setState(() {
        strStatusAddress = "Sembunyikan";
      });
    }
  }

  void switchChangeTelp(bool value) {
    setState(() {
      isShowTelp = value;
    });
    print(isShowTelp);

    if (isShowTelp == true) {
      setState(() {
        strStatusTelp = "Tampilkan";
      });
    } else {
      setState(() {
        strStatusTelp = "Sembunyikan";
      });
    }
  }

  void switchChangeEmail(bool value) {
    setState(() {
      isShowEmail = value;
    });

    if (isShowEmail) {
      setState(() {
        strStatusEmail = "Tampilkan";
      });
    } else {
      setState(() {
        strStatusEmail = "Sembunyikan";
      });
    }
  }

  void selectDoB(BuildContext context) async {
    if(dobController.text == ""){
      final DateTime datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime(2000, 1, 1),
        firstDate: DateTime(1975),
        lastDate: DateTime(DateTime.now().year - 1));
      if (datePicked != null) {
        setState(() {
          dobController.text = new DateFormat('yyyy-MM-dd').format(datePicked);
        });
      }
    } else {
      var dateDOB = DateTime.parse(dobController.text);

      final DateTime datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime(dateDOB.year, dateDOB.month, dateDOB.day),
        firstDate: DateTime(1975),
        lastDate: DateTime(DateTime.now().year - 1));
      if (datePicked != null) {
        setState(() {
          dobController.text = new DateFormat('yyyy-MM-dd').format(datePicked);
        });
      }
    }
  }

  void showDialogGender() {
    var mediaquery = MediaQuery.of(context).size;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                          strGender = "Pria";
                          varIdGender = "P";
                        });
                        print(strGender);

                        if (dobController.text.length != 0 &&
                            varIdGender.length != 0 &&
                            varIdProvince != "" &&
                            varIdCity != "" &&
                            telpController.text.length != 0) {
                          setState(() {
                            isDisableBtn = false;
                          });
                        } else {
                          setState(() {
                            isDisableBtn = true;
                          });
                        }
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        height: mediaquery.width / buttonHeight1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Pria",
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
                        print("WANITA AJA");
                        setState(() {
                          strGender = "Wanita";
                          varIdGender = "W";
                        });
                        print(strGender);

                        if (dobController.text.length != 0 &&
                            varIdGender.length != 0 &&
                            varIdProvince != "" &&
                            varIdCity != "" &&
                            telpController.text.length != 0) {
                          setState(() {
                            isDisableBtn = false;
                          });
                        } else {
                          setState(() {
                            isDisableBtn = true;
                          });
                        }
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        height: mediaquery.width / buttonHeight1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Wanita",
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

  void showDialogProvince() {
    var mediaquery = MediaQuery.of(context).size;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                    child: listProvince(),
                  )),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showDialogCity() {
    var mediaquery = MediaQuery.of(context).size;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                    child: listCity(),
                  )),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget listProvince() {
    var mediaquery = MediaQuery.of(context).size;

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
                            vm.updatekota(provinsi);
                            new Timer(const Duration(milliseconds: 5000), () {
                              if (mounted) {
                                setState(() {
                                  isLoadCity = false;
                                });
                              }
                            });

                            setState(() {
                              isLoadCity = true;
                              varProvince = nameprovinsi;
                              varIdProvince = provinsi;
                              varCity = "";
                              varIdCity = "";
                            });

                            if (dobController.text.length != 0 &&
                                varIdGender.length != 0 &&
                                varIdProvince != "" &&
                                varIdCity != "" &&
                                telpController.text.length != 0) {
                              setState(() {
                                isDisableBtn = false;
                              });
                            } else {
                              setState(() {
                                isDisableBtn = true;
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
  }

  Widget listCity() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      child: StoreConnector<AppState, ViewModel>(
        builder: (BuildContext context, ViewModel vm) {
          var contain = vm.state.kota_content;
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
                            if (varIdProvince != "") {
                              setState(() {
                                isDisableCity = false;
                                varCity = name;
                                varIdCity = id;
                              });
                            } else {
                              setState(() {
                                isDisableCity = true;
                                varCity = name;
                                varIdCity = id;
                              });
                            }

                            if (dobController.text.length != 0 &&
                                varIdGender.length != 0 &&
                                varIdProvince != "" &&
                                varIdCity != "" &&
                                telpController.text.length != 0) {
                              setState(() {
                                isDisableBtn = false;
                              });
                            } else {
                              setState(() {
                                isDisableBtn = true;
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

  fetchDataInit() async {
    token = await keyStore.getToken();
    username = await keyStore.getUsername();
    realNameController.text = realNameControllerTemp;
    urlProfileController.text = "https://yamisok.com/player/" + username;
    countryController.text = "Indonesia";
    dobController.text = dobControllerTemp;
    strGender = strGenderTemp;
    varIdGender = varIdGenderTemp;
    // PROVINCE
    // CITY
    addressController.text = addressControllerTemp;
    telpController.text = telpControllerTemp;
    emailController.text = emailControllerTemp;
    facebookController.text = facebookControllerTemp;
    twitterController.text = twitterControllerTemp;
    instagramController.text = instagramControllerTemp;
    youtubeController.text = youtubeControllerTemp;

    isShowDoB = isShowDoBTemp;
    isShowEmail = isShowEmailTemp;
    isShowTelp = isShowTelpTemp;

    if (isShowDoB) {
      setState(() {
        strStatusBoD = "Tampilkan";
      });
    } else {
      setState(() {
        strStatusBoD = "Sembunyikan";
      });
    }

    if (isShowAddress) {
      setState(() {
        strStatusAddress = "Tampilkan";
      });
    } else {
      setState(() {
        strStatusAddress = "Sembunyikan";
      });
    }

    if (isShowTelp) {
      setState(() {
        strStatusTelp = "Tampilkan";
      });
    } else {
      setState(() {
        strStatusTelp = "Sembunyikan";
      });
    }

    if (isShowEmail) {
      setState(() {
        strStatusEmail = "Tampilkan";
      });
    } else {
      setState(() {
        strStatusEmail = "Sembunyikan";
      });
    }

    if (dobController.text.length != 0 &&
        varIdGender.length != 0 &&
        varIdProvince.length != 0 &&
        varIdCity.length != 0 &&
        telpController.text.length != 0) {
      setState(() {
        isDisableBtn = false;
      });
    } else {
      setState(() {
        isDisableBtn = true;
      });
    }

    FocusScope.of(context).requestFocus(focusNode);
    Timer(Duration(milliseconds: 500), () => scrollController.jumpTo(0));
  }

  void saveEditProfile() {
    setState(() {
      isLoadSave = true;
    });
    print(isShowDoB);
    print(isShowDoB);
    print(isShowDoB);
    ApiServiceUpdateProfile.updateProfile(
            username,
            token,
            realNameController.text,
            !isShowEmail,
            !isShowDoB,
            !isShowTelp,
            dobController.text,
            varIdGender,
            varIdCity,
            addressController.text,
            telpController.text,
            facebookController.text,
            twitterController.text,
            instagramController.text,
            youtubeController.text)
        .then((result) async {
      var data = json.decode(result);
      var status = data['status'];

      print('data $data');

      if (status == 200) {
        print("BERHASIL");
        setState(() {
          isLoadSave = false;
          isError = false;
        });
        // Navigator.pop(context : );
        Navigator.pop(context, "succes");
      } else {
        setState(() {
          msgError = "Maaf, sepertinya terjadi kesalahan jaringan";

          isLoadSave = false;
          isError = true;
        });
      }
    });
  }

  Widget parent() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      color: backgroundPrimary,
      child: StoreConnector<AppState, ViewModel>(
        builder: (BuildContext context, ViewModel vm) {
          var detailProfile = vm.state.detailuser_content;

          print("WOY");
          realNameControllerTemp = detailProfile[0]['real_name'] ?? '';
          dobControllerTemp = detailProfile[0]['date_of_born'] ?? '';
          strGenderTemp = detailProfile[0]['gender'] != 'P' ? 'Wanita' : 'Pria';
          varIdGenderTemp = detailProfile[0]['gender'] != 'P' ? 'W' : 'P';
          addressControllerTemp = detailProfile[0]['player_address'] ?? '';
          telpControllerTemp = detailProfile[0]['phone_number'] ?? '';
          emailControllerTemp = detailProfile[0]['email'] ?? '';
          facebookControllerTemp =
              detailProfile[0]['facebook_url'].toString() != 'null' ||
                      detailProfile[0]['facebook_url'].toString() != ''
                  ? detailProfile[0]['facebook_url']
                  : '';
          twitterControllerTemp =
              detailProfile[0]['instagram_url'].toString() != 'null' ||
                      detailProfile[0]['instagram_url'].toString() != ''
                  ? detailProfile[0]['instagram_url']
                  : '';
          instagramControllerTemp =
              detailProfile[0]['twitter_url'].toString() != 'null' ||
                      detailProfile[0]['twitter_url'].toString() != ''
                  ? detailProfile[0]['twitter_url']
                  : '';
          youtubeControllerTemp =
              detailProfile[0]['youtube_url'].toString() != 'null' ||
                      detailProfile[0]['youtube_url'].toString() != ''
                  ? detailProfile[0]['youtube_url']
                  : '';

          isShowDoBTemp = detailProfile[0]['hidden_date_of_birth'] == 1 ? false : true;
          isShowEmailTemp = detailProfile[0]['hidden_email'] == 1 ? false : true;
          isShowTelpTemp = detailProfile[0]['hidden_phone'] == 1 ? false : true;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    labelInput('Nama Lengkap'),
                    textRealName(),
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    labelInput('URL Profil'),
                    textURLProfile(),
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    labelInput('Negara'),
                    textCountry(),
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    labelDoB('Tanggal Lahir *'),
                    datepickerBirth(),
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    labelInput('Jenis Kelamin *'),
                    selectGender(),
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    labelInput('Provinsi *'),
                    selectProvince(),
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    labelInput('Kota *'),
                    selectCity(),
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    labelInput('Alamat'),
                    textAddress(),
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    labelTelp('No. Kontak *'),
                    textTelp(),
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    labelEmail('Email'),
                    textEmail(),
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    labelInput('Facebook'),
                    textFacebook(),
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    labelInput('Twitter'),
                    textTwitter(),
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    labelInput('Instagram'),
                    textInstagram(),
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                    labelInput('Youtube'),
                    textYoutube(),
                    SizedBox(
                      height: mediaquery.width / 20,
                    ),
                  ],
                ),
              ),
              Container(
                  child: Column(
                children: <Widget>[
                  showErrorMessage(),
                  statusButton(),
                  SizedBox(
                    height: mediaquery.width / 20,
                  )
                ],
              )),
            ],
          );
        },
        converter: (store) {
          return ViewModel(
            state: store.state,
            // updatekota : (String provinsi) => store.dispatch(AppAction.UpdateKota(provinsi:provinsi))
          );
        },
        onInit: (store) {
          // store.dispatch(AppAction.UpdateDetailPlayer());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: Text("Informasi"),
            backgroundColor: backgroundPrimary,
            leading: IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: parent()));
  }
}
