import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:audioplayers/audio_cache.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yamisok/api/misc/firebase_api.dart';
import 'package:yamisok/api/notification_update/notifications.dart';
import 'package:yamisok/api/notification_update/notifications_readall_api.dart';
import 'package:yamisok/api/versions/versions_api.dart';
import 'package:yamisok/app/FirebaseDatabaseUtil.dart';
import 'package:yamisok/page/chatting/chatting_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:yamisok/page/helper/check_connection.dart';
import 'package:yamisok/page/helper/no_connection.dart';
import 'package:yamisok/page/redux/action.dart' as AppAction;


import 'package:yamisok/page/home/home_new.dart' as menuhome;
import 'package:yamisok/page/more.dart' as menumore;
import 'package:yamisok/page/profile/followers.dart';
import 'package:yamisok/page/profile/following.dart';
import 'package:yamisok/page/profile/myprofile.dart';
// import 'package:yamisok/page/profile/profile.dart' as menuprofile;
import 'package:yamisok/page/redux/action.dart';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/team/team.dart' as menuteam;
import 'package:yamisok/component/globals.dart' as globals;
import 'package:yamisok/page/community.dart' as menucommunity;
import 'package:yamisok/page/tournament.dart' as menutournament;
import 'package:yamisok/page/notification_update/notification_update.dart';
import 'package:yamisok/page/setting/setting.dart';
import 'package:yamisok/component/keyStore.dart';


import 'package:yamisok/component/styleyami.dart';
import 'package:yamisok/page/utilities/style.dart';
FirebaseAnalytics analytics = FirebaseAnalytics();

FirebaseDatabase database = new FirebaseDatabase();
DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


bool bedgeNotif = false;
int coundNotif;
bool statusVersion = false;
var versionApps='';
bool pageNoConnections=false;

StreamSubscription<Event> _counterSubscription;


final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


class Bottomnav extends StatefulWidget {
  static String tag = 'main-bottom-page';
  @override
  _BottomnavState createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav>
    with SingleTickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  // AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  TabController controlleratas;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;

  //  TabController2 controller;

  FirebaseDatabaseUtil databaseUtil;
  int totalUnreadChatPersonal = 0;
  int totalUnreadChatTeam = 0;
  int _playerId = 0;

  getDevice() async { 
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Android Id : ${androidInfo.androidId}');
      print('Device Info : ${androidInfo.device}');
      print('brand : ${androidInfo.brand}');
      // print('brand : ${androidInfo.name}');

      print('model : ${androidInfo.model}');
      print('version baseOS : ${androidInfo.version.baseOS}');
      print('version name : ${androidInfo.version.codename}');
      print('sdkInt : ${androidInfo.version.sdkInt}');
      print('id : ${androidInfo.id}');
      print('isPhysicalDevice : ${androidInfo.isPhysicalDevice}');
      print('manufacturer : ${androidInfo.manufacturer}');
      print('release : ${androidInfo.version.release}');
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      var deviceId = '${androidInfo.androidId}';
      var osName = '${androidInfo.model} Android $release (SDK $sdkInt)';
      var typeHp = '$sdkInt';
      var merkHp = '${androidInfo.brand}';

      // deviceId,osName,merkHp,typeHp
      // device_id, Android 9 (SDK 28), Xiaomi, Redmi Note 7
      // Android Id : f8a519934ba8d21e                                                                   
      // I/flutter ( 9514): Device Info : generic_x86                                                                       
      // I/flutter ( 9514): brand : google                                                                                  
      // I/flutter ( 9514): model : Android SDK built for x86                                                               
      // I/flutter ( 9514): version baseOS :                                                                                
      // I/flutter ( 9514): version name : REL                                                                              
      // I/flutter ( 9514): sdkInt : 28                                                                                     
      // I/flutter ( 9514): id : PSR1.180720.075                                                                            
      // I/flutter ( 9514): isPhysicalDevice : false                                                                        
      // I/flutter ( 9514): manufacturer : Google                                                                           
      // I/flutter ( 9514): release : 9 

      // Android Id : f241a6da24984a87                                                                   
      // I/flutter (22589): Device Info : santoni                                                                           
      // I/flutter (22589): brand : Xiaomi                                                                                  
      // I/flutter (22589): model : Redmi 4X                                                                                
      // I/flutter (22589): version baseOS :                                                                                
      // I/flutter (22589): version name : REL                                                                              
      // I/flutter (22589): sdkInt : 25                                                                                     
      // I/flutter (22589): id : N2G47H                                                                                     
      // I/flutter (22589): isPhysicalDevice : true                                                                         
      // I/flutter (22589): manufacturer : Xiaomi   

        _firebaseMessaging.getToken().then((String token) {
          if (token != null) {
             keyStore.getToken().then((userToken) {
              if (userToken != 'null') {
                 print(' --> set device info & fcm $token $deviceId, $osName $typeHp, $merkHp ');
               
                ApiServiceFirebase.saveToken(token,deviceId,osName,typeHp,merkHp);
                //  print(' --> set device info & fcm $deviceId, Android $release (SDK $sdkInt), $manufacturer, $model');
     
              }
            });
          }
        });

    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Device Info : ${iosInfo.utsname.nodename}'); 
      print('machine ${iosInfo.utsname.machine}');
      print('version ${iosInfo.utsname.version}');
      print('model ${iosInfo.model}');
      print('name ${iosInfo.name}');
      print('identifierForVendor ${iosInfo.identifierForVendor}');
      print('isPhysicalDevice ${iosInfo.isPhysicalDevice}');
      print('systemVersion ${iosInfo.systemVersion}');
      print('systemName ${iosInfo.systemName}');
      // Device Info : Yamisoks-MacBook-Pro.local                                                                  
      // flutter: machine x86_64                                                                                            
      // flutter: version Darwin Kernel Version 19.0.0: Wed Sep 25 20:18:50 PDT 2019; root:xnu-6153.11.26~2/RELEASE_X86_64  
      // flutter: model iPhone                                                                                              
      // flutter: name iPhone 11 Pro Max                                                                                    
      // flutter: identifierForVendor 6B090C65-BF56-44C2-93CA-FA6AA6FC08AB                                                  
      // flutter: isPhysicalDevice false                                                                                    
      // flutter: systemVersion 13.3                                                                                        
      // flutter: systemName iOS 
       // var osName = '$systemName $version';

      var deviceId = '${iosInfo.identifierForVendor}';
      var osName = '${iosInfo.name}';
      var typeHp = '${iosInfo.systemVersion}';
      var merkHp = '${iosInfo.model}';

      _firebaseMessaging.getToken().then((String token) {
          if (token != null) {
            print("Token fcm: $token");
            keyStore.getToken().then((userToken) {
              if (userToken != 'null') {
                ApiServiceFirebase.saveToken(token,deviceId,osName,typeHp,merkHp);

                // ApiServiceFirebase.saveToken(token);
                 print(' --> set device info & fcm $token $deviceId, $osName $typeHp, $merkHp ');
              }
            });
          }
        });
     
      // device_id, iOS 13.1, iPhone 11 Pro Max, iPhone

    }
  }
  
  // void _showDialogupdate(alert,url) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: new Text(alert ?? ''),
  //         actions: <Widget>[
  //             new FlatButton(
  //               child: new Text("Updates"),
  //               onPressed: () async {
  //                 if (await canLaunch(url)) {
  //                   await launch(url);
  //                 } else {
  //                   throw 'Could not launch $url';
  //                 } 
  //               },
  //             ),
  //           ],
  //         );
  //     },
  //   );
  // }

  void _showDialogupdate(alert,url,download_size) {
    var mediaquery = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Row(
            children: <Widget> [
              ClipRRect(
                // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Container(
                  child: new Image.asset(
                    "assets/images/icon.png",
                    width: mediaquery.width / 11),
                )
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Update Yamisok App",
                      style: TextStyle(
                        color: Colors.black, 
                        fontSize: mediaquery.width / textSize16sp,
                        fontFamily: 'ProximaBold'
                      ),
                    ),
                    Text(
                      "Downloaded size: " + download_size,
                      style: TextStyle(
                        color: Color(0xFF727573),
                        fontSize: (mediaquery.width / textSize18sp) / 2,
                        fontFamily: 'ProximaRegular'
                      ),
                    )
                  ],
                ),
              )
            ]
          ),
          content: new Text(alert ?? ''),
          actions: <Widget>[
              Container(
                child: GestureDetector(
                    onTap: () async {
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      } 
                    },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                    padding: EdgeInsets.all(10),
                    color: backgroundYellow,
                    width: mediaquery.width / 1.3,
                    child: Center(
                        child: Text(
                          "Update Sekarang",
                          style: new TextStyle(
                            fontSize: mediaquery.width / textSize12sp,
                            color: Colors.black,
                            fontFamily: 'ProximaBold'
                          )
                        )
                      ),
                  )
                )
              )
            ],
          );
      },
    );
  }


   void getapiversion() {
     var parsedata='';
     if (Platform.isAndroid) {
       parsedata='ANDROID';
     }else{
       parsedata='IOS';

     }
    
    ApiVersions.apiversions(parsedata).then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      Timer _timer;
      _timer = new Timer(const Duration(hours: 3), () {
        if(mounted){
          setState(() {
          getapiversion();
        });
        }
        
      });
      if (status == true) {
        
        

        var resultlist = resultdt['result'];
        print("VERSION");
        print(resultlist);
        


        if(resultlist.length==0){
           if (mounted) {
            setState(() {
              _showDialogupdate('opps version api error','','');
              
            });
           }
        }else{
           if (Platform.isAndroid) {
          var majorAndroid = globals.majorAndroid;
          var minorAndroid = globals.minorAndroid;
          var patchAndroid = globals.patchAndroid;
          var buildAndroid=globals.buildAndroid;
          var incrementAndroid = globals.incrementAndroid;
          versionApps='$majorAndroid.$minorAndroid.$patchAndroid-$buildAndroid.$incrementAndroid';
          // print('lihat data url ');
          if (mounted) {
            setState(() {
              if(resultlist['name']!=versionApps){
                _showDialogupdate(resultlist['notes'] ?? '',resultlist['download_link']??'',resultlist['download_size:'] ?? '');
              }
            });
          }
        }else{
          var majorIOS = globals.majorIOS;
          var minorIOS = globals.minorIOS;
          var patchIOS = globals.patchIOS;
          var buildIOS=globals.buildIOS;
          var incrementIOS = globals.incrementIOS;
          versionApps='$majorIOS.$minorIOS.$patchIOS-$buildIOS.$incrementIOS';
          if (mounted) {
            setState(() {
              if(resultlist['name']!=versionApps){
                _showDialogupdate(resultlist['notes'] ?? '',resultlist['download_link']??'',resultlist['download_size:'] ?? '');
                
              }
            });
          }
        }

        }


       
       

        print("status true");
      } else {
        print("status false");
      }
    });
  }


  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    advancedPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
  }
  // Future bgMsgHdl(Map<String, dynamic> message) async {
  //   print("onbgMessage: $message");
  //   audioCache.play('alert.mp3');
  // }

    void getapinotif() {
    // listPopular.clear();
    ApiNotif.apinotif(0,20).then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        var unread = resultdt['unread'];

        
        print('Lihat status true list,$unread $resultlist');
        if (mounted) {
          setState(() {
            // listPopular.addAll(resultlist);
            //  listdiscover.addAll()
            if(unread==0){
              
                bedgeNotif=false;

            }else{
                coundNotif=unread;
                bedgeNotif=true;

            }
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void getapireadallnotif() {
    // listPopular.clear();
    ApiNotifReadAll.apinotifreadall().then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        print('sukses read all notif');
        var resultlist = resultdt['result'];
        // var unread = resultdt['unread'];

        
        print('Lihat status true list, $resultlist');
        
      } else {
        print("status false");
      }
    });
  }
   void getinfoconnections() {
     checkConnection().then((statusInternet) async {
      Timer _timer;
      _timer = new Timer(const Duration(milliseconds: 10000), () {
        if (mounted) {
          setState(() {
           getinfoconnections();
          });
        }
      });

      if(statusInternet==false){
         if (mounted) {

          if(pageNoConnections==false){
            pageNoConnections=true;
            String result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoConnection()),
            );
            setState(() {
              if (result == 'succes') {
                pageNoConnections=false;
              } else {
                pageNoConnections=false;
              }
            });
            
          }
          
         }
      }
      //  print('lihat data connections $statusInternet');

      

    });
   }



  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    pageNoConnections=false;
    getinfoconnections();

    
    getSharedPrefs();
    databaseUtil = FirebaseDatabaseUtil();
    databaseUtil.initState();
    getDevice();
    initPlayer();
    getapinotif();
    getapiversion();

    
     bedgeNotif=false;
    coundNotif=0;

   
   
   
      
        
      _firebaseMessaging.configure(
    //     onBackgroundMessage: (Map<String, dynamic> message) async {
    //      audioCache.play('alert.mp3');

    //       // print("onLaunch: $message");
    // //              _navigateToItemDetail(message);
    //     },
        onMessage: (Map<String, dynamic> message) async {
          // int result = await audioPlayer.resume();
          print("onMessage bottom bar: $message");
          // var type=message['notification']['type'];
          var type=message['data']['type'];
          var pesanbody=message['notification']['body'];
          var pesantitle=message['notification']['title'];
         if(type=='CHAT'){

         }else{
           setState(() {
              bedgeNotif=true;
             
           });
           
         }
         audioCache.play('alert.mp3');
                Flushbar(
                  flushbarPosition: FlushbarPosition.TOP,
                  margin: EdgeInsets.all(8),
                  borderRadius: 8,
                  icon:type=='CHAT' ? Icon(
                    Icons.message,
                    color: backgroundYellow,
                  ): type=='UPCOMING_MATCH' ? Icon(Icons.gamepad,color: backgroundYellow) : Icon(
                    Icons.notifications_active,
                    color: backgroundYellow,
                  ),
                  title: pesantitle,
                  message:  pesanbody,
                  duration:  Duration(seconds: 3),              
                )..show(context);

         
        },
        
        onLaunch: (Map<String, dynamic> message) async {
          // print("onLaunch: $message");
    //              _navigateToItemDetail(message);
        },
        onResume: (Map<String, dynamic> message) async {
          // print("onResume: $message");
    //              _navigateToItemDetail(message);
        },
      );



    // var _firebaseRef = database.reference().child('players/17698/chat_histories');

   

    // _firebaseRef.keepSynced(true);
 
    // _counterSubscription = _firebaseRef.onValue.listen((Event event) {
    //   // error = null;
    //   var _counterbadge = event.snapshot.value ?? '0';
    //   setState(() {
    //     if (mounted) {
    //       print('counter badge ${_counterbadge.lenght}');
    //       for(var i = 0; i < _counterbadge.length; i++){
    //            print('counter badge ${_counterbadge[i]}');
    //       }
    //     }
    //   });

    //   // print('----- > lihat total data online ${_counterOnline.length}');
    // }, onError: (Object o) {
    //   print('----- > lihat total data online  error $o');
    // });
    controlleratas = new TabController(vsync: this, length: 6);
    // controller = new TabController2(vsync: this, length: 2);
    controlleratas.addListener(_handleTabSelection);

   
    
    super.initState();
  }

  _handleTabSelection() {
        setState(() {
          var lihatindextab = controlleratas.index;
          print('lihat index tab $lihatindextab');

        if(lihatindextab==2){
          analytics.logEvent(name: 'Profile');
          var store = StoreProvider.of<AppState>(context);
          var usernameParse='';
          store.dispatch(AppAction.UpdateDetailPlayer(usernameParse:usernameParse));
        }
        
         
        if(lihatindextab==4){
          getapireadallnotif();
              bedgeNotif=false;

        }

      });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    controlleratas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    
    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          key: _scaffoldKey,
          body: new TabBarView(
            
             physics: NeverScrollableScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            
            controller: controlleratas,
            children: <Widget>[
              new menuhome.HomeNew(),
              ChatListPage(),
              // new menuprofile.PageProfile(),
              MyProfilePage(),
              new menuteam.ListTeam(),
              NotificationUpdate(),
              SettingPage(),
            ],
          ),
          bottomNavigationBar: new Material(
            color: Color(0XFF22272B),
            child: new TabBar(
              controller: controlleratas,
              unselectedLabelColor: Colors.white,
              labelColor: Colors.yellowAccent[700],
              tabs: <Widget>[
                new Container(
                  height: mediaquery.width / 8,
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(top: mediaquery.width / 70),
                        child: new Text(
                          '',
                          style: TextStyle(
                            fontFamily: 'YamiFont',
                            fontSize: mediaquery.width / 15,
                          ),
                        ),
                      ),
                      new Container(
                        // margin: const EdgeInsets.only(top: 2.0),
                        child: new Text(
                          'Home',
                          style: TextStyle(
                            fontFamily: 'YamiFont',
                            fontSize: mediaquery.width / 40,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                new Container(
                  height: mediaquery.width / 8,
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(top: mediaquery.width / 70),
                            child: Text(
                              '',
                              style: TextStyle(
                                fontFamily: 'YamiFont',
                                fontSize: mediaquery.width / 15,
                              ),
                            ),
                          ),
                          new Container(
                            child: new Text(
                              'Chat',
                              style: TextStyle(
                                fontFamily: 'YamiFont',
                                fontSize: mediaquery.width / 40,
                              ),
                            ),
                          )
                        ],
                      ),
                      StreamBuilder(
                        stream: databaseUtil.getPersonalChatHistory(_playerId.toString()).onValue,
                        builder: (context, snap){

                          if (snap.hasData && !snap.hasError && snap.data.snapshot.value!=null) {
                            totalUnreadChatPersonal = 0;
                            Map dataPersonal = snap.data.snapshot.value;
                            dataPersonal.forEach((index, data){
                              totalUnreadChatPersonal+=data['unread_message'] ?? 0;
                            });

                            return _chatCounter(totalUnreadChatPersonal);
                          }else{
                            return Container();
                          }

                        },
                      ),
                    ],
                  ),
                ),
                new Container(
                  height: mediaquery.width / 8,
                  child: new Column(
                    key: Key('tabprofile'),
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(top: mediaquery.width / 70),
                        child: new Text(
                          '',
                          style: TextStyle(
                            fontFamily: 'YamiFont',
                            fontSize: mediaquery.width / 15,
                          ),
                        ),
                      ),
                      new Container(
                        child: new Text(
                          'Profile',
                          style: TextStyle(
                            fontFamily: 'YamiFont',
                            fontSize: mediaquery.width / 40,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                new Container(
                  height: mediaquery.width / 8,
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(top: mediaquery.width / 70),
                        child: new Text(
                          '',
                          style: TextStyle(
                            fontFamily: 'YamiFont',
                            fontSize: mediaquery.width / 15,
                          ),
                        ),
                      ),
                      new Container(
                        child: new Text(
                          'Team',
                          style: TextStyle(
                            fontFamily: 'YamiFont',
                            fontSize: mediaquery.width / 40,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                new Container(
                  height: mediaquery.width / 8,
                  child: new Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: mediaquery.width / 70),
                        child: Stack(
                          alignment:  bedgeNotif==true ?AlignmentDirectional.topEnd : AlignmentDirectional.center,
                          children: <Widget>[
                            Text(
                                '',
                                style: TextStyle(
                                  fontFamily: 'YamiFont',
                                  fontSize: mediaquery.width / 15,
                                ),
                              ),
                              bedgeNotif==true ? _notifCounter(coundNotif):Container(),
                            ],
                          ),
                      ),
                      new Container(
                        child: new Text(
                          'Notif',
                          style: TextStyle(
                            fontFamily: 'YamiFont',
                            fontSize: mediaquery.width / 40,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                new Container(
                  height: mediaquery.width / 8,
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(top: mediaquery.width / 70),
                        child: new Text(
                          '',
                          style: TextStyle(
                            fontFamily: 'YamiFont',
                            fontSize: mediaquery.width / 15,
                          ),
                        ),
                      ),
                      new Container(
                        child: new Text(
                          'Setting',
                          style: TextStyle(
                            fontFamily: 'YamiFont',
                            fontSize: mediaquery.width / 40,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // #BackButtonONPRESS
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            content: new Text('Are you sure want to Exit?'),
            actions: <Widget>[
              FlatButton(
                color: Colors.black87,
                textColor: yamiyelowColor,
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                color: Colors.black87,
                textColor: Colors.white54,
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ),
        ) ??
        false;
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _playerId = prefs.getInt("id_player");
    });
  }

  Widget _chatCounter(int total){
    if(total == 0)
      return SizedBox();

    return Container(
      width: (total > 99) ? 25 : (total < 10) ? 15 : 18,
      height: 15,
      alignment: Alignment(0, 0),
      margin: EdgeInsets.only(top: 3),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(999))
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
                minWidth: 12,
                minHeight: 12
        ),
        child: Text(
          (total>99) ? '99+' : '$total',
          textAlign: TextAlign.center,
          style: TextStyle(
                  fontSize: 10,
                  color: Colors.white
          ),
        ),
      )
    );
  }

  Widget _notifCounter(int total){
    if(total == 0)
    return SizedBox();

    return Container(
      width: (total > 99) ? 25 : (total < 10) ? 15 : 18,
      height: 15,
      alignment: Alignment(0, 0),
      margin: EdgeInsets.only(top: 3),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(999))
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
                minWidth: 12,
                minHeight: 12
        ),
        child: Text(
          (total>99) ? '99+' : '$total',
          textAlign: TextAlign.center,
          style: TextStyle(
                  fontSize:10,
                  color: Colors.white
          ),
        ),
      )
    );
  }
}
