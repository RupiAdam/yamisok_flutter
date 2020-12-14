import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yamisok/page/home/filter_lokasi.dart';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/page/redux/action.dart' as AppAction;
import 'package:yamisok/component/keyStore.dart';

import '../utilities/style.dart';

var varIdGender = "";
var varIdProvince = "";
var varProvince = "";
var varIdCity = "";
var varCity = "";
var nameKota = "";
var nameProvinsi = "";
var isFirst=true;


String strGender = "Laki-laki";

bool isLoadCity = false;
bool isDisableCity;
FirebaseAnalytics analytics = FirebaseAnalytics();


class FilterFindFriend extends StatefulWidget {
  static String tag = 'filter-find-friend';

  @override
  State<StatefulWidget> createState() {
    return _FilterFindFriendState();
  }
}

class _FilterFindFriendState extends State<FilterFindFriend> {
  String token = "";
  String username = "";

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    analytics.logEvent(name: 'Filter_find_friend');
    varCity =  ''; 
    varProvince='';
    isFirst=true;
    fetchDataInit();

    print('lihat masuk init state');
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
    return new Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: Text("Filter"),
            backgroundColor: backgroundPrimary,
            leading: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                // setLatestPage('null');
                // GO TO WHEN PRESSBACK
                // Navigator.pushNamed(context, LoginSignUpPage.tag);
              },
            )),
        body: parent());
  }

  Widget parent() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      color: backgroundPrimary,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: mediaquery.width / 20,
                ),
                labelInput('Provinsi'),
                selectProvince(),
                SizedBox(
                  height: mediaquery.width / 20,
                ),
                labelInput('Kota'),
                selectCity(),
                SizedBox(
                  height: mediaquery.width / 20,
                ),
                labelInput('Jenis Kelamin'),
                selectGender(),
              ],
            ),
          ),
          Container(
              child: Column(
            children: <Widget>[
              buttonFilter(),
              SizedBox(
                height: mediaquery.width / 20,
              )
            ],
          )),
        ],
      ),
    );
  }

  void validateAndSubmit(){
    // Timer _timer;
    // _timer = new Timer(const Duration(milliseconds: 10000), () {
    //   if(mounted){
    //     setState(() {
    //     _isLoading = false;
    //   });
    //   }
      
    // });
    // setState(() {
    //   _errorMessage = "";
    //   _isLoading = true;
    // });

    // var username = _usernameController.text;
    // var pass = _passwordController.text;
    print('see data kota $varIdCity dan $varCity dan $varProvince' );
    setKotaForSearchMabar(varIdCity.toString(), varCity.toString(), varProvince.toString()).then((val) {
        setGenderForSearch(varIdGender.toString()).then((val) {
            print('succes save  $varIdCity dan $varCity dan $varIdGender');

          Navigator.pop(context, "succes");
        });
    });
            
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
        print('lihat is first $isFirst');
        if(isFirst==true){

        }else{
          if (varProvince == "") {
          } else {
            if (!isLoadCity) {
              if(!isDisableCity){
                showDialogCity();
              }
            
            }
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

  Widget buttonFilter() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      width: double.infinity,
      height: mediaquery.width / buttonHeight1,
      child: ButtonTheme(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
        ),
        buttonColor: varCity !='' ? backgroundYellow : backgroundDisable,
        minWidth: double.infinity,
        height: mediaquery.width / buttonHeight1,
        child: RaisedButton(
          onPressed: (){ if(varCity!=''){
              validateAndSubmit();

            }
            },
          child: Text('Tampilkan hasil pencarian',
              style: new TextStyle(
                  fontSize: mediaquery.width / textSize17sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ProximaRegular')),
        ),
      ),
    );
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
                          strGender = "Semua Gener";
                          varIdGender = "";
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
                            "Semua Gender",
                            style: TextStyle(fontSize: textSize18sp),
                          ),
                        ),
                      ),
                    ),
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
                          strGender = "Laki-laki";
                          varIdGender = "P";
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
                          strGender = "Perempuan";
                          varIdGender = "W";
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
           List contain=[];
          contain.add(
            {
              "province_id": 0,
              "country_id": 0,
              "province_name": "Semua Provinsi",
              "province_name_abbr": "NAD",
              "province_name_id": "Nanggroe Aceh Darussalam",
              "province_name_en": "Nanggroe Aceh Darussalam",
              "province_capital_city_id": 1171,
              "iso_code": "ID-AC",
              "iso_name": "Aceh",
              "iso_type": "autonomous province",
              "iso_geounit": "SM",
              "timezone": 7,
              "province_lat": "4.695135",
              "province_lon": "96.749397",
              "created_at": "2017-10-19 17:36:59",
              "updated_at": "2017-10-19 17:36:59"
            },
          );
          contain.addAll(vm.state.provinsi_content);
          
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

                            if(provinsi=='0'){
                             
                              Navigator.pop(context);
                              if (mounted) {
                                setState(() {
                                  isDisableCity=true;
                                  isLoadCity = false;
                                  varProvince = nameprovinsi;
                                  varIdProvince = provinsi;
                                  varCity = "Semua Kota";
                                  varIdCity = "";
                                });
                              }
                            }else{

                            
                            Navigator.pop(context);
                            vm.updatekota(provinsi);
                            isFirst=false;
                                  
                            new Timer(const Duration(milliseconds: 5000), () {
                              if (mounted) {
                                setState(() {
                                  isLoadCity = false;
                                });
                              }
                            });

                            setState(() {
                               isDisableCity=false;
                              isLoadCity = true;
                              varProvince = nameprovinsi;
                              varIdProvince = provinsi;
                              varCity = "";
                              varIdCity = "";
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

    var idkotadt = await keyStore.getidKotaForSearchMabar(); 
    var namekotadt = await keyStore.getNameKotaForSearchMabar(); 
    var nameprovinsidt = await keyStore.getNameProvinsiForSearchMabar(); 

    setState(() {
    varIdCity = idkotadt != null ? idkotadt : '';
    varCity = namekotadt != null ? namekotadt : ''; 
    varProvince = nameprovinsidt != null ? nameprovinsidt : ''; 

    });
   
    print('lihat data kota $varCity $varProvince');
    token = await keyStore.getToken();
    username = await keyStore.getUsername();

    strGender = "Semua Gender";
    varIdGender = "";
    
  }
}
