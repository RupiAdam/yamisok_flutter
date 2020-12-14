// import 'dart:ffi';

import 'dart:collection';
import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yamisok/api/profile/profile_aboutme_api.dart';
import 'package:yamisok/api/profile/profile_basicinfo_api.dart';
import 'package:yamisok/api/profile/profile_level_api.dart';
import 'package:yamisok/api/profile/profile_set_endorse_api.dart';
import 'package:yamisok/api/profile/profile_set_follow_api.dart';
import 'package:yamisok/api/profile/profile_sklill_api.dart';
import 'package:share/share.dart';
import 'package:yamisok/api/profile/profile_un_endorse_api.dart';
import 'package:yamisok/api/profile/profile_un_follow_api.dart';
import 'package:yamisok/app/FirebaseDatabaseUtil.dart';
import 'dart:convert';
// import 'package:yamisok/component/globals.dart' as global;
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yamisok/page/chatting/chatting_detail_personal.dart';
import 'package:yamisok/page/game/connect_game.dart';
// import 'package:yamisok/component/styleyami.dart' as prefix0;
import 'package:yamisok/page/login/login.dart';
import 'package:yamisok/model/profile_model.dart';
import 'package:yamisok/api/profile/profile_detail_api.dart';
import 'package:yamisok/api/profile/profile_achievement_api.dart';
import 'package:yamisok/api/profile/profile_upcoming_api.dart';
// import 'package:yamisok/page/redux/action.dart';
import 'package:yamisok/page/redux/action.dart' as AppAction;

import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/page/profile/followers.dart';
import 'package:yamisok/page/profile/following.dart';
import 'package:yamisok/page/profile/update_profile_picture.dart';
import 'package:yamisok/page/utilities/style.dart';
import 'package:yamisok/api/misc/notification.dart';

RefreshController _scrollController =  RefreshController(initialRefresh: false);
RefreshController _refreshController =
RefreshController(initialRefresh: false);

Client client = Client();
List<String> dogImages = new List();
List listData = [];
List listDataProfileDetail=[];
List listDataDetail = [];
List listAchievement = [];
var detailProfile;
FirebaseDatabase database = new FirebaseDatabase();
Map _counterOnline;
StreamSubscription<Event> _counterSubscription;
var _statusOnline=false;


List listSkill=[
];

List listSkillheader=[
];

//images default
String imagesDefault='https://yamisok.com/assets/images/default/default.png';

//profile
String username='';
// String playeridothers='0';
String name='';
String avatarUrl='https://yamisok.com/assets/images/default/default.png';
int levelAchievment=0;
String endorse='0';
String followers='0';
String following='0';
String shortBio='';
bool isFollow=false;
String avatarUrlSm;
double currentLevelPercentage=0;
String gender ='';
String city ='';

String aboutme='';

// poke related variable
bool isPokeActive = true;
int selfId = 0;
String selfUsername = '';
String selfToken = '';
String selfAvatar = '';
int _otherPlayerUnreadChat = 0;
int _selfUnreadChat = 0;

var dataProfileDetail;
const MINUTES_OF_BLOCK_POCKING = 10;
var blockingTime = 0;

FirebaseAnalytics analytics = FirebaseAnalytics();

class ProfileOthers extends StatefulWidget {
  final String id;
  final String idhero;
  final String username;
  final String images;

  const ProfileOthers({Key key, this.id, this.username, this.images, this.idhero}) : super(key: key);
  @override
  _ProfileOthersState createState() => _ProfileOthersState();
}

class _ProfileOthersState extends State<ProfileOthers> {

    FirebaseDatabaseUtil databaseUtil;

  //get api profile
  void apiProfilelevel(){
    ApiServiceProfile.apiprofile(widget.username).then((result) async {
          var resultdt = json.decode(result);
          final messages = resultdt['messages'];
          final status = resultdt['status'];

        if(status==true){
          var resultlist = resultdt['result'];


          print("lihat result detail profile $resultlist");
          if (mounted){
            setState(() {

                username=resultlist['username'];
                levelAchievment=resultlist['level_achievment'];
                endorse=resultlist['endorse'].toString();
                followers=resultlist['followers'].toString();
                following=resultlist['following'].toString();
                shortBio=resultlist['short_bio'].toString();
                avatarUrl=resultlist['avatar_url'];
                avatarUrlSm=resultlist['avatar_url_sm'];
                isFollow=resultlist['is_follow'];
                var datapersen=resultlist['current_level_percentage'];
                currentLevelPercentage=datapersen.toDouble();
                gender =resultlist['gender'];
                city =resultlist['cityName'];

                print('lihat city users $city');

                // _scrollController.refreshCompleted();
            });
          }

          // print("status true");
        }else{
          // print("status false");
        }


      });
  }

  void apiEndorse(){

    print('get api endorse');

    ApiServiceSkill.apiskill(widget.id).then((result) async {
          var resultdt = json.decode(result);
          final messages = resultdt['messages'];
          final status = resultdt['status'];
          listSkillheader.clear();
          listSkill.clear();
          var baseUrlAPI = globals.baseUrlApi;
          List listSkillheaderFirst=[
            {
                  "id": 0,
                  "game_name": "mobile legend",
                  "game_role_id": null,
                  "skill_1": "Skill saya",
                  "skill_2": null,
                  "skill_3": null,
                  "player_id": 0,
                  "game_group_id": null,
                  "image": "$baseUrlAPI/images/20190909172513_5d762889488db.png",
                  "description": null,
                  "total_endorse": 0,
                  "created_at": "2019-09-09 17:25:13",
                  "updated_at": "2019-09-09 17:25:13",
                  "endorse_status": 0
            }
          ];

        if(status==true){
          var resultlist = resultdt['result'];


          // print("lihat result $resultlist");
          if (mounted){
            setState(() {


               listSkill.addAll(resultlist);
              //  listSkillheader.addAll(listSkillheaderFirst);
               listSkillheader.addAll(resultlist);
                // _scrollController.refreshCompleted();
            });
          }

          // print("status true");
        }else{
          setState(() {



            });
        }


      });
  }

  void apiSetEndorse(id,player_id_othersdt){
    var skillid=id;
    var player_id_others=player_id_othersdt;





    print('get api endorse');
    ApiSetEndorse.apisetendorse(skillid,player_id_others).then((result) async {
          var resultdt = json.decode(result);
          final messages = resultdt['messages'];
          final status = resultdt['status'];

        if(status==true){
          var resultlist = resultdt['result'];


          // print("lihat result $resultlist");
          if (mounted){
            setState(() {
              apiEndorse();
              apiProfilelevel();
            });
          }

          // print("status true");
        }else{
            setState(() {



            });
        }


      });
  }

  void apiUnEndorse(id,player_id_othersdt){
    var skillid=id;
    var player_id_others=player_id_othersdt;





    print('get api endorse');
    ApiUnEndorse.apiunendorse(skillid,player_id_others).then((result) async {
          var resultdt = json.decode(result);
          final messages = resultdt['messages'];
          final status = resultdt['status'];

        if(status==true){
          var resultlist = resultdt['result'];


          // print("lihat result $resultlist");
          if (mounted){
            setState(() {
              apiEndorse();
              apiProfilelevel();
            });
          }

          // print("status true");
        }else{
            setState(() {



            });
        }


      });
  }

  void apiFollow(playerIdOthersdt){
   var playerIdOthers=playerIdOthersdt;

   ApiSetFollow.apisetfollow(playerIdOthers).then((result) async {
          var resultdt = json.decode(result);
          final messages = resultdt['messages'];
          final status = resultdt['status'];

        if(status==true){
          // var resultlist = resultdt['result'];


          // print("lihat result $resultlist");
          if (mounted){
            setState(() {

              isFollow=true;
            });
          }

          // print("status true");
        }else{
            setState(() {

             isFollow=false;
             var totalfollow=int.parse(followers) - 1;
              followers=totalfollow.toString();

            });
        }


      });
  }

  void apiUnFollow(playerIdOthersdt){
   var playerIdOthers=playerIdOthersdt;

   ApiUnFollow.apiunfollow(playerIdOthers).then((result) async {
          var resultdt = json.decode(result);
          final messages = resultdt['messages'];
          final status = resultdt['status'];

        if(status==true){
          // var resultlist = resultdt['result'];


          // print("lihat result $resultlist");
          if (mounted){
            setState(() {
              isFollow=false;
            });
          }

          // print("status true");
        }else{
            setState(() {

             isFollow=true;
            var totalfollow=int.parse(followers) + 1;
            followers=totalfollow.toString();

            });
        }


      });
  }

  void apiAboutMe(){

    // print('get api endorse');
    ApiServiceAboutMe.apiaboutme(widget.username).then((result) async {
          var resultdt = json.decode(result);
          final messages = resultdt['messages'];
          final status = resultdt['status'];

        if(status==true){


          var resultlist = resultdt['result'];

          // print('lihat respon aboutme $resultlist');
            setState(() {
               aboutme=resultlist['about_me'];
                // _scrollController.refreshCompleted();
            });



          // print("status true");
        }else{

        }


      });
  }

  //get api achieve
  void apiAchive(){
     listAchievement.clear();
    ApiServiceProfileAchive.apiProfileAchivel().then((result) async {
        var resultdt = json.decode(result);
        final messages = resultdt['messages'];
        final status = resultdt['status'];
      if(status==true){
        // print('masuk k satstus 200');
            var resultlist = resultdt['result'];
          // print('lihat body, $resultlist');
          if (mounted){
            setState(() {
            listAchievement.addAll(resultlist);
            //  listdiscover.addAll()
            });
          }
        print("status true");
      }else{
        print("status false");
      }
    });

  }

  void _onLoading(){
    print('on load');
  }

	void fetchSelfId() async {
        var block = await keyStore.getLatestPokedTIme(widget.id) ?? 0;
        var now = DateTime.now().toUtc().millisecondsSinceEpoch;

		SharedPreferences prefs = await SharedPreferences.getInstance();
		setState(() {
			selfId = prefs.getInt("id_player");
			selfUsername = prefs.getString("username");
			selfToken = prefs.getString("token");
			selfAvatar = prefs.getString("avatar_url");
			blockingTime = block;
			isPokeActive = (now < block) ? false : true;
		});
        getOtherPlayerCounterChat();
	}

    Future<Null> getOtherPlayerCounterChat() async {
        var roomId = (selfId < int.parse(widget.id)) ? "$selfId-${int.parse(widget.id)}" : "${int.parse(widget.id)}-$selfId";
        _otherPlayerUnreadChat = (await databaseUtil.getCounterChatPersonal(widget.id, roomId).once()).value ?? 0;
        _selfUnreadChat = (await databaseUtil.getCounterChatPersonal(selfId.toString(), roomId).once()).value ?? 0;
    }

  @override
  void initState() {
    databaseUtil = FirebaseDatabaseUtil();
    databaseUtil.initState();

    listData.clear();
    listDataProfileDetail.clear();
    listDataDetail.clear();
    listAchievement.clear();
    _statusOnline=false;
     username='';
    // String playeridothers='0';
     name='';
     avatarUrl='https://yamisok.com/assets/images/default/default.png';
     levelAchievment=0;
     endorse='0';
     followers='0';
     following='0';
     shortBio='';
     isFollow=false;
     avatarUrlSm;
     currentLevelPercentage=0;
     gender ='';
     city ='';

    aboutme='';
    print('lihat id ${widget.id}');
    var _firebaseRef = database.reference().child('onlinestat/players/online/${widget.id}');

    // totalOnline = '';

    _firebaseRef.keepSynced(true);
    // var _firebaseRef = FirebaseDatabase().reference().child('onlinestat');
    // Demonstrates configuring to the database using a file
    // _counterRef = FirebaseDatabase.instance.reference().child('counter');
    // Demonstrates configuring the database directly

    //  var _counterRef = database.reference().child('onlinestat/players/online');
    //   database.reference().child('onlinestat/players/online').once().then((DataSnapshot snapshot) {
    //     print('Connected to second database and read ${snapshot.value.length}');
    //   });
    // var _firebaseRef = FirebaseDatabase().reference().child('onlinestat/players/online');
    // // database.setPersistenceEnabled(true);
    // // database.setPersistenceCacheSizeBytes(10000000);

    _counterSubscription = _firebaseRef.onValue.listen((Event event) {
      // error = null;
      
       setState(() {
        if (mounted) {
          _counterOnline = event.snapshot.value ?? '0';
         print('online player total ${_counterOnline.length}');
         if(_counterOnline.length==0){
            _statusOnline=false;
          }else{
            _statusOnline=true;
         }
        }
      });

      // print('----- > lihat total data online ${_counterOnline.length}');
    }, onError: (Object o) {
      print('----- > lihat total data online  error $o');
    });

    fetchSelfId();
    // playeridothers='0';
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    listSkill.clear();
    listSkillheader.clear();
    isFollow=false;
    apiProfilelevel();
    apiEndorse();
    apiAboutMe();

    analytics.setCurrentScreen(screenName: "/page_profile_others");
    analytics.logEvent(name: 'Profile_others');


    // getReduxDetailprofile();


  }

  @override
  void dispose() {
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();

    //onrefresh
    _onRefresh() async {
      Timer _timer;
      _timer = new Timer(const Duration(milliseconds: 10000), () {
        if(mounted){
          setState(() {
          _scrollController.refreshCompleted();
        });
        }

      });
       apiProfilelevel();
       apiEndorse();
       apiAboutMe();

       var store = StoreProvider.of<AppState>(context);
        var usernameParse=widget.username;
        store.dispatch(AppAction.UpdateDetailPlayer(usernameParse:usernameParse));

      print('on refresh');


    }

    void _onLoading(){
      print('on load');
      Timer _timer;
      _timer = new Timer(const Duration(milliseconds: 20000), () {
        if(mounted){
          setState(() {
          _scrollController.loadComplete();
        });
        }

      });
    }

    void _sendPoke(){

        setState(() {
            isPokeActive = false;
        });

        var roomId = (selfId < int.parse(widget.id)) ? "$selfId-${int.parse(widget.id)}" : "${int.parse(widget.id)}-$selfId";
        var _timestamp = ServerValue.timestamp;

        var blockTime = DateTime.now().toUtc().millisecondsSinceEpoch + (MINUTES_OF_BLOCK_POCKING * 60000);
        keyStore.setPokedTime(widget.id, blockTime);

        databaseUtil.getPersonalChatDetail(roomId).push().set({
            'avatar': selfAvatar,
            'badge_url': '',
            'date': _timestamp,
            'id': selfId,
            'is_subscribe': 0,
            'name': selfUsername,
            'text': 'poked',
            'type': 2, // 1: text, 2: poke
            'poke_back': false,
            'platform': Platform.operatingSystem,
            'url': '',
            'file_name': '',
        });

        var otherPlayerInfo = HashMap();
        otherPlayerInfo['avatar_url'] = widget.images;
        otherPlayerInfo['avatar_url_sm'] = widget.images;
        otherPlayerInfo['name'] = widget.username;
        otherPlayerInfo['username'] = widget.username;
        otherPlayerInfo['id'] = widget.id;

        var selfPlayerInfo = HashMap();
        selfPlayerInfo['avatar_url'] = selfAvatar;
        selfPlayerInfo['avatar_url_sm'] = selfAvatar;
        selfPlayerInfo['name'] = selfUsername;
        selfPlayerInfo['username'] = selfUsername;
        selfPlayerInfo['id'] = selfId;

        // update other history
        databaseUtil.getPersonalChatHistoryDetail(widget.id, roomId).update({
            'last_message': 'Kamu telah dicolek $selfUsername',
            'unread_message': _otherPlayerUnreadChat+1,
            'last_seen': 0,
            'read_message': false,
            'room_id': roomId,
            'sender_player': selfPlayerInfo,
            'updated_at': _timestamp,
        });

        // update self history
        databaseUtil.getPersonalChatHistoryDetail(selfId.toString(), roomId).update({
            'last_message': 'Kamu telah mencolek ${widget.username}',
            'last_seen': 0,
            'unread_message': 0,
            'read_message': false,
            'room_id': roomId,
            'sender_player': otherPlayerInfo,
            'updated_at': _timestamp,
        });

        ApiNotification.sendNotification(selfToken, selfId.toString(), widget.id, selfUsername, "Mencolek kamu!", "CHAT");
    }

    //widget profile
    var imageslevel=Container(
        padding: EdgeInsets.only(left: 10),
        child: Stack(
          children: <Widget>[
            Container(
               width: mediaquery.width/3,
                height:  mediaquery.width/3,
                padding: EdgeInsets.all(20),

              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),

                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: Center(
                          child: new Image.asset(
                            "assets/images/smiley.png",
                            height: mediaquery.width / 25,
                          ),
                        ),
                        color: Color(0xFF141A1D),
                      ),
                      Positioned(
                        child: Center(child: Hero(
                          tag: widget.idhero,
                          child: Container(
                            child: new Image.network(
                              widget.images ?? '',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ))
                      )
                    ],
                  ),
              ),
            ),
            Transform.rotate(
              angle: 3.1,
                child: AnimatedCircularChart(
                key: _chartKey,
                size: Size(mediaquery.width/3, mediaquery.width/3),
                initialChartData: <CircularStackEntry>[
                  new CircularStackEntry(
                    <CircularSegmentEntry>[
                      new CircularSegmentEntry(
                        currentLevelPercentage,
                        backgroundYellow,
                        rankKey: 'completed',
                      ),
                      new CircularSegmentEntry(
                        100.00,
                        backgroundGreyDark,
                        rankKey: 'remaining',
                      ),
                    ],
                    rankKey: 'progress',
                  ),
                ],
                chartType: CircularChartType.Radial,
                edgeStyle: SegmentEdgeStyle.round,
                percentageValues: true,
              ),
            ),
            Container(
              height: mediaquery.width/3,
              width: mediaquery.width/3,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(

                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(50.0))
                      ),
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                      decoration: BoxDecoration(
                        color: backgroundYellow,
                        borderRadius: BorderRadius.all(Radius.circular(50.0))
                      ),
                      height: mediaquery.width/15,
                      width: mediaquery.width/15,
                      child: Center(
                        child: Text('$levelAchievment' ?? '1', style: TextStyle(
                        fontSize: mediaquery.width/textSize14sp,
                        color: Colors.black,
                        fontFamily: 'ProximaBold'
                ),),
                      ),
                ),
                    ),
                  ),
            ),

          ],
        ),

    );

    var dataProfile=Container(
          color: backgroundTrnasparan,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              imageslevel,
              Container(

                padding: const EdgeInsets.only(
                    left: 5.0, right: 20.0, top: 10.0, bottom: 5.0),
                // color: Colors.amber,
                width: mediaquery.width-(mediaquery.width/3)-10,
                child: new Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                           Row(
                            children: <Widget>[
                              Image.asset(gender=='P' ? 'assets/images/home/male.png' : gender=='1' ? 'assets/images/home/male.png' : 'assets/images/home/female.png',
                              height: mediaquery.width/textSize14sp,),
                              Container(
                                width: mediaquery.width/2.2,
                                padding: EdgeInsets.only(left: 5),
                                child: Text(widget.username ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                  fontSize: mediaquery.width/textSize18sp,
                                  color: textColor2,
                                  fontFamily: 'ProximaBold')
                                ),
                              ),
                            ],
                          ),

                          Container(
                            margin: EdgeInsets.only(left: 5),
                            height: mediaquery.width / 30,
                            width: mediaquery.width / 30,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFF34424e),
                                  width: 1,
                                ),
                                color: _statusOnline==true ? Colors.green : Colors.grey,
                                shape: BoxShape.circle),
                          )


                        ],
                      ),
                    ),
                    Container(
                      child: Text('Lv. $levelAchievment Newbie',
                        style: TextStyle(
                        fontSize: mediaquery.width/textSize14sp,
                        color: textColor2,
                        fontFamily: 'ProximaBold')
                      ),
                    ),
                    Container(
                      child: Text(city ?? '',
                        style: TextStyle(
                        fontSize: mediaquery.width/textSize14sp,
                        color: textColor2,
                        fontFamily: 'ProximaRegular')
                      ),
                    ),
                    Container(
                      child: Text(shortBio == "null" ? 'Tidak ada status.' : shortBio,
                        style: TextStyle(
                        fontSize: mediaquery.width/textSize14sp,
                        color: textColor2,
                        fontFamily: 'ProximaRegular')
                      ),
                    ),
                   ],
                ),
              ),
            ],
          ),
        );

    var shimmerProfile= Container(
          padding: const EdgeInsets.all(5.0),
          // padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          color: backgroundTrnasparan,
          child: Row(
            children: <Widget>[
            Shimmer.fromColors(
                    baseColor: colorShimer,
                    // highlightColor: Colors.grey[300],
                    // baseColor: Colors.grey[100],
                    highlightColor: colorlightShimer,
                          child: Container(
                 width: mediaquery.width/3,
                  height:  mediaquery.width/3,
                  padding: EdgeInsets.all(20),

                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),

                    child: Container(
                      color: Colors.black87,

                      child: new Image.network(avatarUrl ?? '',
                      // fit: BoxFit.cover
                      fit: BoxFit.contain,
                      ),

                  )
                ),
              ),
            ),
               Shimmer.fromColors(
                    baseColor: colorShimer,
                    // highlightColor: Colors.grey[300],
                    // baseColor: Colors.grey[100],
                    highlightColor: colorlightShimer,
                 child: Container(

                  padding: const EdgeInsets.only(
                      left: 5.0, right: 20.0, top: 10.0, bottom: 5.0),
                  // color: Colors.amber,
                  width: mediaquery.width-(mediaquery.width/3)-10,
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //         <--- border radius here
                          ),
                           color: colorShimer,
                        ),

                        height:mediaquery.width/20,
                        width: mediaquery.width/3,

                      ),
                      Container(
                        margin: EdgeInsets.only(top:mediaquery.width/40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //         <--- border radius here
                          ),
                           color: colorShimer,
                        ),

                        height:mediaquery.width/35,
                        width: mediaquery.width/5,

                      ),

                      Container(
                        margin: EdgeInsets.only(top:mediaquery.width/20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //         <--- border radius here
                          ),
                           color: colorShimer,
                        ),

                        height:mediaquery.width/28,
                        width: mediaquery.width/2,

                      ),
                      Container(
                        margin: EdgeInsets.only(top:mediaquery.width/40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //         <--- border radius here
                          ),
                           color: colorShimer,
                        ),

                        height:mediaquery.width/28,
                        width: mediaquery.width/3.5,

                      ),


                     ],
                  ),
                ),
              ),



            ],
          ),
        );

    Widget _profile() {
      final lihatdt=username.length;
      // print("lihat leght username $username $lihatdt");
      if(widget.username.length==0){
        return shimmerProfile;
      }else{
        return dataProfile;
      }
    }

    //widget endorse
    var dataEndore=Container(
      height: mediaquery.width/5,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('$endorse' ?? '0',
                    style: TextStyle(
                          fontSize: mediaquery.width/textSize18sp,
                          color: textColor2,
                          fontFamily: 'ProximaBold')
                  ),
                  Text('Endorse',
                    style: TextStyle(
                          fontSize: mediaquery.width/textSize14sp,
                          color: textColor2,
                          fontFamily: 'ProximaRegular')
                  )
                ],
              ),
            ),
            Container(
              height: mediaquery.width/8,
              width: 1.0,
              color: Color(0xFF2a3337),
            ),
            GestureDetector(
                onTap: (){
                 analytics.logEvent(name: 'Followers');

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileFollowersPage.otherPlayer(otherPlayerId: int.parse(widget.id))),
                    );
                },
                child: Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Text('$followers' ?? '0',
                                    style: TextStyle(
                                            fontSize: mediaquery.width/textSize18sp,
                                            color: textColor2,
                                            fontFamily: 'ProximaBold')
                            ),
                            Text('Followers',
                                    style: TextStyle(
                                            fontSize: mediaquery.width/textSize14sp,
                                            color: textColor2,
                                            fontFamily: 'ProximaRegular')
                            )
                        ],
                    ),
                ),
            ),
            Container(
              height: mediaquery.width/8,
              width: 1.0,
              color: Color(0xFF2a3337),
            ),
            GestureDetector(
                onTap: (){
                 analytics.logEvent(name: 'Following');

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileFollowingPage.otherPlayer(otherPlayerId: int.parse(widget.id))),
                    );
                },
                child: Container(
                    child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                Text('$following' ?? '0',
                                        style: TextStyle(
                                                fontSize: mediaquery.width/textSize18sp,
                                                color: textColor2,
                                                fontFamily: 'ProximaBold')
                                ),
                                Text('Following',
                                        style: TextStyle(
                                                fontSize: mediaquery.width/textSize14sp,
                                                color: textColor2,
                                                fontFamily: 'ProximaRegular')
                                )
                            ]
                    ),
                ),
            )
          ],
        ),
      ),
    );

    var shimmerEndore=Container(
       child: Shimmer.fromColors(
                    baseColor: colorShimer,
                    // highlightColor: Colors.grey[300],
                    // baseColor: Colors.grey[100],
                    highlightColor: colorlightShimer,
                child: Container(
            height: mediaquery.width/5,
            color: colorShimer,

         ),
       ),
    );

    Widget _edorse(){
      final lihatdt=username.length;
      // print("lihat leght username $username $lihatdt");
      if(username.length==0){
        return shimmerEndore ;
      }else{
        return dataEndore;
      }
    }

    //widget buttonAction
    Widget _buttonUbah(){
      return GestureDetector(
          onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateProfilePicturePage()),
              );
          },
          child: Container(
              margin: EdgeInsets.only(right:mediaquery.width/80),
              decoration: BoxDecoration(
                  border: Border.all(
                      color:backgroundYellow,
                      width: 1,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(
                          50.0) //         <--- border radius here
                  ),
                  gradient: LinearGradient(
                      colors: [Color(0xFF43411e), Color(0xFF43411e)],
                      begin: Alignment(-1.0, -2.0),
                      end: Alignment(1.0, 2.0),
                  ),
              ),
              height: 50.0,
              width: (mediaquery.width/4)*2.5,
              child: Center(child: Text("Ubah",style: new TextStyle(
                      fontSize: mediaquery.width/textSize14sp,
                      color: Colors.white,
                      fontFamily: 'ProximaBold'),)),
          ),
      );
    }

    Widget _buttonChat() {
	    var roomId = (selfId < int.parse(widget.id)) ? "$selfId-${int.parse(widget.id)}" : "${int.parse(widget.id)}-$selfId";
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        width: mediaquery.width/4,
        height: mediaquery.width/buttonHeight1,
        decoration: BoxDecoration(
          boxShadow: [
              BoxShadow(
                      blurRadius: .5,
                      spreadRadius: 1.0,
                      color: Colors.black.withOpacity(.12)
              )
          ],
          color: backgroundYellow,
          borderRadius: BorderRadius.all(Radius.circular(99)),
        ),
        child: ButtonTheme(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(50.0),
        ),
        buttonColor: backgroundYellow,
        minWidth: double.infinity,
        height: mediaquery.width/buttonHeight1,
        child: RaisedButton(
          onPressed: (){
            analytics.logEvent(name: 'Chat');

	          Navigator.push(
		          context,
		          MaterialPageRoute(builder: (context) => ChatDetailPersonalPage(
                      selfId: selfId.toString(),
                      otherId: widget.id,
			          playerName: widget.username,
			          avatarUrl: widget.images,
			          chatRoomId: roomId
                    )
                  )
	          );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset("assets/images/profile/comment.png", scale: 4,),
              Text('Chat',
                style: new TextStyle(
                fontSize: mediaquery.width/textSize14sp,
                color: Colors.black,
                fontFamily: 'ProximaBold')
              ),
            ],
          ),
        ),
      ),
      );
    }

    Widget _pokeButton() {
        var mediaquery = MediaQuery.of(context).size;
        return Container(
            width: mediaquery.width/4,
            height: mediaquery.width/buttonHeight1,
            decoration: BoxDecoration(
                boxShadow: [
                    BoxShadow(
                            blurRadius: .5,
                            spreadRadius: 1.0,
                            color: Colors.black.withOpacity(.12)
                    )
                ],
                color: Color(0xFF1ac5bf),
                borderRadius: BorderRadius.all(Radius.circular(99)),
            ),
            child: ButtonTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(50.0),
                ),
                buttonColor: (isPokeActive) ? Color(0xFF1ac5bf) : Color(0xff38424a),
                minWidth: double.infinity,
                height: mediaquery.width/buttonHeight1,
                child: RaisedButton(
                    onPressed: (){
                        if(isPokeActive){
                            _sendPoke();
                        }else{
                            Fluttertoast.showToast(
                                    msg: "Tunggu hingga dapat kembali mencolek",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 2,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 14.0
                            );

                        }
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                            (isPokeActive) ? Image.asset("assets/images/profile/poke_active.png", scale: 4) : Image.asset("assets/images/profile/poke_inactive.png", scale: 4),
                            Text('Colek',
                                    style: new TextStyle(
                                            fontSize: mediaquery.width/textSize14sp,
                                            color: (isPokeActive) ? Colors.white : Color(0xff616b74),
                                            fontFamily: 'ProximaBold')
                            ),
                        ],
                    ),
                ),
            ),
        );
    }

    Widget _shareButton(){
        var mediaquery = MediaQuery.of(context).size;
        return GestureDetector(
            onTap: (){
                analytics.logEvent(name: 'Bagikan');
                Share.share('https://yamisok.com/profile/${widget.username}');
            },
            child: Container(
                height: mediaquery.width/buttonHeight1,
                width: mediaquery.width/6,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: .5,
                          spreadRadius: 1.0,
                          color: Colors.black.withOpacity(.12)
                      )
                    ],
                    color: backgroundSecond,
                    borderRadius: BorderRadius.all(Radius.circular(99)),
                ),
              child: Icon(Icons.share, color: Colors.white),
            ),
        );
    }

    Widget _followButton(){
        var mediaquery = MediaQuery.of(context).size;
        return GestureDetector(
            child: Container(
                height: mediaquery.width/buttonHeight1,
                width: mediaquery.width/6,
                decoration: BoxDecoration(
                    boxShadow: [
                        BoxShadow(
                            blurRadius: .5,
                            spreadRadius: 1.0,
                            color: Colors.black.withOpacity(.12)
                        )
                    ],
                    color: (!isFollow) ? backgroundSecond : Color(0xFF38424a),
                    borderRadius: BorderRadius.all(Radius.circular(99)),
                ),
                child: Image.asset(
                (!isFollow) ? "assets/images/profile/followers_active.png" : "assets/images/profile/followers_inactive.png",
                    scale: 4,
                ),
            ),
            onTap: (){
                analytics.logEvent(name: 'Follow');

                if(isFollow==false){
                    setState(() {
                        var totalfollow=int.parse(followers) + 1;
                        followers=totalfollow.toString();
                        isFollow=true;
                    });
                    apiFollow(widget.id);

                }else{
                    setState(() {
                        var totalfollow=int.parse(followers) - 1;
                        followers=totalfollow.toString();
                        isFollow=false;
                    });
                    apiUnFollow(widget.id);
                }
            },
        );
    }

    var shimmerbuttonaction=Container(
      child: Shimmer.fromColors(
                    baseColor: colorShimer,
                    // highlightColor: Colors.grey[300],
                    // baseColor: Colors.grey[100],
                    highlightColor: colorlightShimer,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(
                  50.0) //         <--- border radius here
                  ),
                    color: colorShimer,
                ),

                height:mediaquery.width/buttonHeight1,
                width: mediaquery.width/4,

              ),


      ),
    );

    var shimmerIconButton = Container(
        child: Shimmer.fromColors(
            baseColor: colorShimer,
            highlightColor: colorlightShimer,
            child: Container(
                height: mediaquery.width/buttonHeight1,
                width: mediaquery.width/6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(99)),
                    color: colorShimer
                ),
            ),
        ),
    );

    Widget _buttonAction(){
      return Container(
        margin: EdgeInsets.only(left: mediaquery.width/25, right: mediaquery.width/25),
        height: mediaquery.width/buttonHeight1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              username.length==0 ? shimmerbuttonaction : _buttonChat(),
              username.length==0 ? shimmerbuttonaction : _pokeButton(),
              username.length==0 ? shimmerIconButton : _followButton(),
              username.length==0 ? shimmerIconButton: _shareButton(),
            ],
        ),
      );
    }

    //widget skill
    Widget dataSkill(){
      if(listSkillheader.length > 0){
        return Container(
        height: mediaquery.width/4.2,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: listSkillheader.length,
          itemBuilder: (context, index) {
            final id = listSkillheader[index]['id'];
            final name = listSkillheader[index]['skill_1'].toString();
            final avatarUrlnew = listSkillheader[index]['avatar_url'] !=null ? listSkillheader[index]['avatar_url'] : 'https://yamisok.com/assets/images/static/logo-yamisok.png';
            // final title = "blabla";
            // final description = "bla bla";
            // final avatarUrlnew = "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/a161727e-91f5-4896-b41b-4d9f1853950a.png";
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   id==0? Container(
                       height: mediaquery.width/7,
                       width: mediaquery.width/7,
                       decoration: BoxDecoration(
                            // border: Border.all(
                            //   color:backgroundYellow,
                            //   width: 1,
                            // ),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    10.0) //         <--- border radius here
                                ),
                           color: Color(0xFF383e41),

                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:Icon(Icons.add,
                              size: (mediaquery.width/textSize14sp)*2,
                              color: Colors.white,
                              )
                              ),

                  ):
                  Container(
                       height: mediaquery.width/7,
                       width: mediaquery.width/3,
                       decoration: BoxDecoration(
                            // border: Border.all(
                            //   color:backgroundYellow,
                            //   width: 1,
                            // ),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    10.0) //         <--- border radius here
                                ),
                           color: Color(0xFF383e41),

                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child:Image.network(avatarUrlnew),
                          ),

                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(name,
                    style: TextStyle(
                    fontSize: mediaquery.width/textSize14sp,
                    color: textColor2,
                    fontFamily: 'ProximaRegular')
                    ),
                  )
                ],
              ),
            );
          },
        ));
      } else {
        return Container(
          height: mediaquery.width/4.2,
          child: Center(
            child: Text(
              "Tidak ada skill",
              style: TextStyle(
              fontSize: mediaquery.width/textSize14sp,
              color: Color(0xFF95989a),
              fontWeight: FontWeight.bold),
            ),
          ));
      }
    }

    var shimmerSkill=Container(
       child: Shimmer.fromColors(
                    baseColor: colorShimer,
                    // highlightColor: Colors.grey[300],
                    // baseColor: Colors.grey[100],
                    highlightColor: colorlightShimer,
                child: Container(
            height: mediaquery.width/4.2,
            color: colorShimer,

         ),
       ),
    );

    Widget _skill(){
      return Container(
        color: Color(0xFF23292c),
        width: mediaquery.width,
        height: mediaquery.width/3.2,
        child: username.length==0 ? shimmerSkill : dataSkill(),
      );
    }

    var shimmertabview=Container(
      child: Shimmer.fromColors(
                    baseColor: colorShimer,
                    // highlightColor: Colors.grey[300],
                    // baseColor: Colors.grey[100],
                    highlightColor: colorlightShimer,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(
                  5.0) //         <--- border radius here
                  ),
                    color: colorShimer,
                ),

                height:(mediaquery.width/buttonHeight1)-(mediaquery.width/20),
                width: mediaquery.width/3.5,

              ),


      ),
    );

    //widget tabview menu
    Widget _tabview(){
      return Container(
        padding: EdgeInsets.only(left:20, right:20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            username.length==0 ?  shimmertabview : Container(
              child: Column(
                children: <Widget>[
                  Text('Overview',
                   style: TextStyle(
                              fontSize: mediaquery.width/textSize18sp,
                              color: textColor2,
                              fontFamily: 'ProximaBold')
                  ),
                  Container(
                    height: 2.0,
                    color: textColor2,
                    width: mediaquery.width/6,
                  )
                ],
              ),
            ),
             username.length==0 ?  shimmertabview : Container(
              child: Column(
                children: <Widget>[
                  Text('Statistics',
                   style: TextStyle(
                              fontSize: mediaquery.width/textSize18sp,
                              color: textColorDisable,
                              fontFamily: 'ProximaRegular')
                  ),
                  // Container(
                  //   height: 2.0,
                  //   color: textColor2,
                  //   width: mediaquery.width/6,
                  // )
                ],
              ),
            ),
             username.length==0 ?  shimmertabview : Container(
              child: Column(
                children: <Widget>[
                  Text('Activity',
                   style: TextStyle(
                              fontSize: mediaquery.width/textSize18sp,
                              color: textColorDisable,
                              fontFamily: 'ProximaRegular')
                  ),
                  // Container(
                  //   height: 2.0,
                  //   color: textColor2,
                  //   width: mediaquery.width/6,
                  // )
                ],
              ),
            )
          ],
        ),
      );

    }

    //widget tabcontainer
    Widget _labelTentangSaya(){
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
            Text(
              'Tentang saya',
              style: TextStyle(
                fontSize: mediaquery.width/textSize18sp,
                color: backgroundYellow,
                fontFamily: 'ProximaBold'
              ),
            ),

          ],
        ),
      );
    }

    Widget tentangSayaShort() {
      return Container(
        width: mediaquery.width,
        child: Text(
          aboutme,
          style: TextStyle(
            fontSize: mediaquery.width/textSize14sp,
            color: Color(0xFF95989a),
            fontWeight: FontWeight.bold),
        ),
      );
    }

    Widget tentangSayaLong(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expandable(
            collapsed:Container(
              height: ((mediaquery.width/textSize14sp) * 3) + (mediaquery.height / 80),
              child: Text(
              aboutme ?? '',
              // 'xxxxxx sutidaba dakdg ashsvd djsks hgdshga ahjgdajd \n ajsdgad ',
              // overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: mediaquery.width/textSize14sp,
                  color: Color(0xFF95989a),
                  fontWeight: FontWeight.bold),
              )
            ),
            expanded:Container(
              child: Text(
              aboutme ?? '',
              // 'adabg sutidaba dakdg ashsvd djsks asjdhaud asjdhaj',
              //  overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: mediaquery.width/textSize14sp,
                  color: Color(0xFF95989a),
                  fontWeight: FontWeight.bold),
              )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Builder(
                builder: (context) {
                  var controller = ExpandableController.of(context);
                  return GestureDetector(
                    onTap: (){
                      controller.toggle();
                    },
                    child: Container(
                      width: mediaquery.width / 1.5,
                      child: Text(controller.expanded ? "Hide": "Read More",
                        style: TextStyle(
                        fontSize: mediaquery.width/textSize14sp,
                        color: backgroundYellow,
                        fontWeight: FontWeight.bold),
                      )
                    ));
                },
              ),
            ],
          ),
        ],
      );
    }

    Widget validasiLine(){
      return LayoutBuilder(builder: (context, size) {
        final span = TextSpan(text: aboutme, 
          style: TextStyle(
          fontSize: mediaquery.width/textSize14sp,
          color: Color(0xFF95989a),
          fontWeight: FontWeight.bold));
        final tp = TextPainter(text: span, maxLines: 3, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
        tp.layout(maxWidth: size.maxWidth);

        if (tp.didExceedMaxLines) {
          return tentangSayaLong();
        } else {
          return tentangSayaShort();
        }
      });
    }
    
    Widget conditionTentangSaya(){
      if(aboutme != null){
        if(aboutme == ''){
          setState(() {
            aboutme = 'Tidak ada deskripsi';
          });
          return validasiLine();
        } else {
          return validasiLine();
        }
      } else {
        setState(() {
          aboutme = 'Tidak ada deskripsi';
        });
        return validasiLine();
      }
    }

    Widget _dataTentangSaya(){
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(
                  10.0) //         <--- border radius here
              ),
          color: backgroundAbu
        ),
        margin: EdgeInsets.only(left: 10,right: 10),
        padding: EdgeInsets.all(20.0),
        child: ExpandableNotifier(
          child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: ScrollOnExpand(
            child: conditionTentangSaya(),
            // child: LayoutBuilder(builder: (context, size) {
            //   final span = TextSpan(text: aboutme, 
            //     style: TextStyle(
            //     fontSize: mediaquery.width/textSize14sp,
            //     color: Color(0xFF95989a),
            //     fontWeight: FontWeight.bold));
            //   final tp = TextPainter(text: span, maxLines: 5, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
            //   tp.layout(maxWidth: size.maxWidth);

            //   if (tp.didExceedMaxLines) {
            //     return tentangSayaLong();
            //   } else {
            //     return tentangSayaShort();
            //   }
            // }),
        ),
      ),
      )
      );
    }

    Widget _labelEndorse(){
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
            Text(
              'Skill dan Endorsement',
              style: TextStyle(
                fontSize: mediaquery.width/textSize18sp,
                color: backgroundYellow,
                fontFamily: 'ProximaBold'
              ),
            ),


          ],
        ),
      );
    }

    var dataEndorse = new Container(
      height: mediaquery.width,
        child:

        SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: mediaquery.width/3,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              childAspectRatio: 0.80,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {


                return Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(
                          10.0) //         <--- border radius here
                      ),
                  color: backgroundAbu
                  ),
                  alignment: Alignment.center,
                  padding:EdgeInsets.only(left: 5.0, right: 5.0),
                  child: GestureDetector(
                    onTap:() async {

                    },
                      child: Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: mediaquery.width/2,
                            child: Text('data new'),
                          )

                        ]
                      ),
                    ),
                  ),
                );
              },
              childCount: 9,
            ),
          ),


        );

    Widget _endorsement(){
      return
      Container(
        child: Column(
          children:[dataEndorse],
        ),
      );

    }

    var shimmerlabel=Container(
      child: Shimmer.fromColors(
                    baseColor: colorShimer,
                    // highlightColor: Colors.grey[300],
                    // baseColor: Colors.grey[100],
                    highlightColor: colorlightShimer,
              child: Align(
                  alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(
                    5.0) //         <--- border radius here
                    ),
                      color: colorShimer,
                  ),

                  height:(mediaquery.width/20),
                  width: mediaquery.width/3.5,

                ),
              ),


      ),
    );

    var shimmerContainer=Container(
      child: Shimmer.fromColors(
                    baseColor: colorShimer,
                    // highlightColor: Colors.grey[300],
                    // baseColor: Colors.grey[100],
                    highlightColor: colorlightShimer,
              child: Align(
                  alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(
                    10.0) //         <--- border radius here
                    ),
                      color: colorShimer,
                  ),

                  height:(mediaquery.width/2.5),
                  width: double.infinity,

                ),
              ),


      ),
    );

    Widget _infoRealname(fullname){
      if(fullname == '' || fullname == 'null' || fullname == null){
        return Column(
          children: <Widget>[

          ],
        );
      } else {
        return Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
                child: Text('Name',
                style: TextStyle(
                  fontSize: mediaquery.width/textSize14sp,
                  color:textColorDisable,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
                child: SelectableText(fullname,
                style: TextStyle(
                  fontSize: mediaquery.width/textSize16sp,
                  color:textColor2,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
            SizedBox(
                height: mediaquery.width/30,
            ),
          ],
        );
      }
    }

    Widget _infoAddress(address){
      if (address == "" || address == 'null' || address == null){
        return Column(
          children: <Widget>[

          ],
        );
      } else {
        return Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
                          child: Text('Alamat',
                style: TextStyle(
                  fontSize: mediaquery.width/textSize14sp,
                  color:textColorDisable,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
                          child: SelectableText(address,
                style: TextStyle(
                  fontSize: mediaquery.width/textSize16sp,
                  color:textColor2,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
            SizedBox(
                height: mediaquery.width/30,
            ),
          ]
        );
      }
    }

    Widget _infoFacebook(facebookUrl){
      if(facebookUrl == '' || facebookUrl == 'null' || facebookUrl == null){
        return Column(
          children: <Widget>[

          ],
        );
      } else {
        return Column(
          children: <Widget>[
            SizedBox(
              height: mediaquery.width/30,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Facebook',
                style: TextStyle(
                  fontSize: mediaquery.width/textSize14sp,
                  color:textColorDisable,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SelectableText('Facebook.com/$facebookUrl',
                style: TextStyle(
                  fontSize: mediaquery.width/textSize16sp,
                  color:textColor2,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
          ],
        );
      }
    }

    Widget _infoTwitter(twitterUrl){
      if(twitterUrl == '' || twitterUrl == 'null' || twitterUrl == null){
        return Column(
          children: <Widget>[

          ],
        );
      }else{
        return Column(
          children: <Widget>[
            SizedBox(
                height: mediaquery.width/30,
            ),
            Align(
              alignment: Alignment.centerLeft,
                  child: Text('Twitter',
                style: TextStyle(
                  fontSize: mediaquery.width/textSize14sp,
                  color:textColorDisable,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
                  child: SelectableText('twitter.com/$twitterUrl',
                style: TextStyle(
                  fontSize: mediaquery.width/textSize16sp,
                  color:textColor2,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
          ],
        );
      }
    }

    Widget _infoInstagram(instagramUrl){
      if(instagramUrl == '' || instagramUrl == 'null' || instagramUrl == null){
        return Column(
          children: <Widget>[

          ],
        );
      } else {
        return Column(
          children: <Widget>[
            SizedBox(
                height: mediaquery.width/30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                    child: Text('Instagram',
                  style: TextStyle(
                    fontSize: mediaquery.width/textSize14sp,
                    color:textColorDisable,
                    fontFamily: 'ProximaRegular'
                  )
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                    child: SelectableText('instagram.com/$instagramUrl',
                  style: TextStyle(
                    fontSize: mediaquery.width/textSize16sp,
                    color:textColor2,
                    fontFamily: 'ProximaRegular'
                  )
                ),
              ),
          ],
        );
      }
    }

    Widget _infoYoutube(youtubeUrl){
      if(youtubeUrl == '' || youtubeUrl == 'null' || youtubeUrl == null){
        return Column(
          children: <Widget>[

          ],
        );
      } else {
        return Column(
          children: <Widget>[
            SizedBox(
                  height: mediaquery.width/30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                  child: Text('YouTube',
                  style: TextStyle(
                    fontSize: mediaquery.width/textSize14sp,
                    color:textColorDisable,
                    fontFamily: 'ProximaRegular'
                  )
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                  child: Text('youtube.com/channel/$youtubeUrl',
                  style: TextStyle(
                    fontSize: mediaquery.width/textSize16sp,
                    color:textColor2,
                    fontFamily: 'ProximaRegular'
                  )
                ),
              ),
          ],
        );
      }
    }

    Widget _dataInformasi(){
      return Container(
      child: StoreConnector<AppState, ViewModel>(
      builder: (BuildContext context, ViewModel vm) {
      detailProfile = vm.state.detailuser_content;

        if(detailProfile!='' || detailProfile!=null){
          var fullname = detailProfile[0]['real_name'].toString() == 'null' || detailProfile[0]['real_name'].toString() == '' ? '-' : detailProfile[0]['real_name'];
          var urlname = detailProfile[0]['url'].toString() ?? '';
          var dateofborn = detailProfile[0]['date_of_born'].toString() == 'null' || detailProfile[0]['date_of_born'].toString() == '' ? '-' : detailProfile[0]['date_of_born'];
          var gender = detailProfile[0]['gender'].toString() == 'P' ? 'Pria' : 'Wanita';
          var phoneNumber = detailProfile[0]['phone_number'].toString() ?? '';
          var address = detailProfile[0]['player_address'].toString() == 'null' || detailProfile[0]['player_address'].toString() == '' ? '' : detailProfile[0]['player_address'].toString();
          var city = detailProfile[0]['cityName'].toString() == 'null' || detailProfile[0]['cityName'].toString() == '' ? '-' : detailProfile[0]['cityName'];
          var provinceName = detailProfile[0]['province_name'].toString() == 'null' || detailProfile[0]['province_name'].toString() == '' ? '-' : detailProfile[0]['province_name'];
          var countryName = detailProfile[0]['country_name'].toString() == 'null' || detailProfile[0]['country_name'].toString() == '' ? '-' : detailProfile[0]['country_name'];
          var email = detailProfile[0]['email'].toString() ?? '';
          var facebookUrl = detailProfile[0]['facebook_url'].toString() == 'null' ? '' : detailProfile[0]['facebook_url'];
          var twitterUrl = detailProfile[0]['twitter_url'].toString() == 'null' ? '' : detailProfile[0]['twitter_url'];
          var instagramUrl = detailProfile[0]['instagram_url'].toString() == 'null' ? '' : detailProfile[0]['instagram_url'];
          var youtubeUrl = detailProfile[0]['youtube_url'].toString() == 'null' ? '' : detailProfile[0]['youtube_url'];
          var hiddenEmail = detailProfile[0]['hidden_email'] == 0 ? true : false;
          var hiddenDateOfBirth = detailProfile[0]['hidden_date_of_birth'] == 0 ? true : false;
          var hiddenPhone = detailProfile[0]['hidden_phone'] == 0 ? true : false;
          return Container(
        decoration: BoxDecoration(

          borderRadius: BorderRadius.all(Radius.circular(
                  10.0) //         <--- border radius here
              ),
          color: backgroundAbu
        ),
        margin: EdgeInsets.only(left: 10,right: 10),
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _infoRealname(fullname),

            Align(
              alignment: Alignment.centerLeft,
                          child: SelectableText('URL profile',
                style: TextStyle(
                  fontSize: mediaquery.width/textSize14sp,
                  color:textColorDisable,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
                          child: SelectableText('https://yamisok.com/profile/$urlname',
                style: TextStyle(
                  fontSize: mediaquery.width/textSize16sp,
                  color:textColor2,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
            
            hiddenDateOfBirth? SizedBox(
                height: mediaquery.width/30,
            ):Container(),
            hiddenDateOfBirth ? Align(
              alignment: Alignment.centerLeft,
                          child: Text('Tanggal lahir',
                style: TextStyle(
                  fontSize: mediaquery.width/textSize14sp,
                  color:textColorDisable,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ):Container(),
            hiddenDateOfBirth ? Align(
              alignment: Alignment.centerLeft,
                          child: Text(dateofborn,
                style: TextStyle(
                  fontSize: mediaquery.width/textSize16sp,
                  color:textColor2,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ): Container(),

            SizedBox(
                height: mediaquery.width/30,
            ),
            Align(
              alignment: Alignment.centerLeft,
                          child: Text('Jenis Kelamin',
                style: TextStyle(
                  fontSize: mediaquery.width/textSize14sp,
                  color:textColorDisable,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
                          child: Text(gender,
                style: TextStyle(
                  fontSize: mediaquery.width/textSize16sp,
                  color:textColor2,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
            
            hiddenPhone ? SizedBox(
                height: mediaquery.width/30,
            ):Container(),
            hiddenPhone ?  Align(
              alignment: Alignment.centerLeft,
                          child: Text('No. kontak',
                style: TextStyle(
                  fontSize: mediaquery.width/textSize14sp,
                  color:textColorDisable,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ) : Container(),
            hiddenPhone ? Align(
              alignment: Alignment.centerLeft,
                          child: SelectableText(phoneNumber,
                style: TextStyle(
                  fontSize: mediaquery.width/textSize16sp,
                  color:textColor2,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ): Container(),
            
            SizedBox(
                height: mediaquery.width/30,
            ),
            
            _infoAddress(address),
            
            Align(
              alignment: Alignment.centerLeft,
                          child: Text('Kota',
                style: TextStyle(
                  fontSize: mediaquery.width/textSize14sp,
                  color:textColorDisable,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
                          child: Text(city,
                style: TextStyle(
                  fontSize: mediaquery.width/textSize16sp,
                  color:textColor2,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
            
            SizedBox(
                height: mediaquery.width/30,
            ),
            Align(
              alignment: Alignment.centerLeft,
                          child: Text('Provinsi',
                style: TextStyle(
                  fontSize: mediaquery.width/textSize14sp,
                  color:textColorDisable,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
                          child: Text(provinceName,
                style: TextStyle(
                  fontSize: mediaquery.width/textSize16sp,
                  color:textColor2,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ),
            
            hiddenEmail ? SizedBox(
                height: mediaquery.width/30,
            ):Container(),
            hiddenEmail ? Align(
              alignment: Alignment.centerLeft,
                          child: Text('Email',
                style: TextStyle(
                  fontSize: mediaquery.width/textSize14sp,
                  color:textColorDisable,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ):Container(),
            hiddenEmail ? Align(
              alignment: Alignment.centerLeft,
                          child: SelectableText(email,
                style: TextStyle(
                  fontSize: mediaquery.width/textSize16sp,
                  color:textColor2,
                  fontFamily: 'ProximaRegular'
                )
              ),
            ):Container(),
            
            _infoFacebook(facebookUrl),
            _infoTwitter(twitterUrl),
            _infoInstagram(instagramUrl),
            _infoYoutube(youtubeUrl),
            SizedBox(
                height: mediaquery.width/30,
            ),
          ],
        ),
      );
        }else{
          return shimmerContainer;
        }

      }, converter: (store) {
          return ViewModel(
            state: store.state,
              // updatekota : (String provinsi) => store.dispatch(AppAction.UpdateKota(provinsi:provinsi))

            );
      }, onInit: (store) {
        store.dispatch(AppAction.UpdateDetailPlayer(usernameParse:widget.username));
      },
      ),
      );
    }

    Widget _labelInformasi(){
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
            Text(
              'Informasi',
              style: TextStyle(
                fontSize: mediaquery.width/textSize18sp,
                color: backgroundYellow,
                fontFamily: 'ProximaBold'
              ),
            ),

          ],
        ),
      );
    }

    Widget _overView(){
      // print('lihat $detailProfile');
      return Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
                  child: Column(
            children: <Widget>[
              username.length==0 ?  shimmerlabel : _labelTentangSaya(),
              username.length==0 ?  shimmerContainer : _dataTentangSaya(),
              SizedBox(
                  height: mediaquery.width/20,
              ),
              username.length==0 ?  shimmerlabel :_labelInformasi(),
              _dataInformasi(),
              SizedBox(
                  height: mediaquery.width/20,
              ),
               username.length==0 ?  shimmerlabel : _labelEndorse(),
                // username.length==0 ?  shimmerlabel : _detailinfo(),
              // _endorsement()
            ],
          ),
        ),
      );
    }

    Widget _tabContainer(){
      return Container(
        child: Column(
          children: <Widget>[
            _overView(),

          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(

            backgroundColor: backgroundTrnasparan,

            title:Text('Profil Detail'),
           actions: <Widget>[


          ],

          ),
      body:Container(
        color: backgroundTrnasparan,
        child:

        SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(

        ),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("pull up load");
            }
            else if(mode==LoadStatus.loading){
              body = Container(

              );
            }
            else if(mode == LoadStatus.failed){
              body = Text("Load Failed!Click retry!");
            }
            else{
              body = Container(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellow)),
              );
            }
            // return shimerdt;
            return Container(
              height: 200.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _scrollController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child:CustomScrollView(
            slivers: <Widget>[

              SliverList(
              delegate: SliverChildListDelegate(

                [

                   Container(
                     color: backgroundTrnasparan,
                    child: Column(

                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // _provinsilist(),



                          SizedBox(
                            height: mediaquery.width/20,
                          ),
                           _profile(),
                          SizedBox(
                            height: mediaquery.width/20,
                          ),
                          _edorse(),
                          SizedBox(
                            height: mediaquery.width/20,
                          ),
                          _buttonAction(),
                          SizedBox(
                            height: mediaquery.width/20,
                          ),
                          _skill(),
                          // SizedBox(
                          //   height: mediaquery.width/20,
                          // ),
                          // _tabview(),
                          // SizedBox(
                          //   height: mediaquery.width/20,
                          // ),
                          SizedBox(
                            height: mediaquery.width/20,
                          ),
                          _tabContainer()

                        ],
                      ),
                  )
                ]

              ),
            ),
            SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: (mediaquery.width) / 2,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                  childAspectRatio: 0.80,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    var id= listSkill[index]['id'];
                    var skill= listSkill[index]['skill_1'].toString();
                    var player_id_others= listSkill[index]['player_id'];
                    var totalEndorse= listSkill[index]['total_endorse'].toString();
                    var gameName= listSkill[index]['game_name'].toString();
                    var endorseStatus= listSkill[index]['endorse_status'];

                    var imageGame = listSkill[index]['image']!=null ? listSkill[index]['image'] : "https://yamisok.com/assets/images/profile-v2/default-skill.png";
                    // print('see edorse  $skill $endorseStatus');
                    return Container(

                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.all(Radius.circular(
                                10.0) //         <--- border radius here
                            ),
                        color: backgroundAbu
                      ),

                      // color: Colors.white,
                      margin:EdgeInsets.only(left: 8.0, right: 8.0, bottom:8.0, top:8.0),
                      child: Container(

                          child: Stack(
                            children: <Widget>[

                              Container(
                                decoration: BoxDecoration(

                                  borderRadius: BorderRadius.only(
                                      topLeft:Radius.circular(10.0),
                                      topRight:Radius.circular(10.0)) //         <--- border radius here
                                      ,
                                  color: backgroundGreyDark,
                                ),

                                height: mediaquery.width/4.5,
                                width: double.infinity,

                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height: mediaquery.width/3.5,
                                            child: Image.network(imageGame)
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top:mediaquery.width/30),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Color(0xFF34424e),
                                                width: 2,
                                              ),
                                            ),
                                            height: mediaquery.width/7,
                                            width: mediaquery.width/7,
                                            child: Center(
                                              child: Text(
                                                totalEndorse ?? '',
                                                style: TextStyle(
                                                  fontSize: mediaquery.width/textSize14sp,
                                                  color: backgroundYellow,
                                                  fontFamily: 'ProximaBold'
                                                ),
                                              ),
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: mediaquery.width/30, right: mediaquery.width/30),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                  gameName ?? '',
                                                  style: TextStyle(
                                                    fontSize: mediaquery.width/textSize16sp,
                                                    color: Colors.white,
                                                    fontFamily: 'ProximaBold'
                                                  ),
                                                ),
                                          ),
                                          Align(
                                          alignment: Alignment.centerLeft,
                                                child: Text(
                                                  skill ?? '',
                                                  style: TextStyle(
                                                    fontSize: mediaquery.width/textSize14sp,
                                                    color: Colors.white,
                                                    fontFamily: 'ProximaRegular'
                                                  ),
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child:  Container(
                                      padding: EdgeInsets.only(left: mediaquery.width/30, right: mediaquery.width/30),
                                      width: double.infinity,
                                        height: (mediaquery.width/buttonHeight1)-(mediaquery.width/30),
                                        child: ButtonTheme(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(5.0),
                                        ),
                                        buttonColor: endorseStatus==0 ? backgroundYellow : backgroundBlackDefault,
                                        minWidth: double.infinity,
                                        height: mediaquery.width/buttonHeight1,
                                        child: RaisedButton(
                                          onPressed: (){

                                            if(endorseStatus==0){
                                                analytics.logEvent(name: 'Endorse');

                                              print('profile others see indexs $index');
                                            
                                            var dataparse= [
                                              {
                                                  "id": listSkill[index]['id'],
                                                  "game_name": listSkill[index]['game_name'],
                                                  "game_role_id": listSkill[index]['game_role_id'],
                                                  "skill_1": listSkill[index]['skill_1'],
                                                  "player_id": listSkill[index]['player_id'],
                                                  "game_group_id": listSkill[index]['game_group_id'],
                                                  "image": listSkill[index]['image'],
                                                  "description": listSkill[index]['description'],
                                                  "total_endorse": listSkill[index]['total_endorse'] +1,
                                                  "endorse_status": 1,
                                                  "avatar_url": listSkill[index]['avatar_url'],
                                                  "nickname": listSkill[index]['nickname'],
                                                  "in_game_id": listSkill[index]['in_game_id'],
                                                  "is_steam_game": listSkill[index]['is_steam_game'],
                                                  "is_mobile_legend": listSkill[index]['is_mobile_legend']
                                              }];

                                               setState(() {
                                                 listSkill.replaceRange(index, index+1, dataparse);
                                              });
                                               apiSetEndorse(id,player_id_others);
                                            }else{
                                               var dataparse= [
                                              {
                                                  "id": listSkill[index]['id'],
                                                  "game_name": listSkill[index]['game_name'],
                                                  "game_role_id": listSkill[index]['game_role_id'],
                                                  "skill_1": listSkill[index]['skill_1'],
                                                  "player_id": listSkill[index]['player_id'],
                                                  "game_group_id": listSkill[index]['game_group_id'],
                                                  "image": listSkill[index]['image'],
                                                  "description": listSkill[index]['description'],
                                                  "total_endorse": listSkill[index]['total_endorse'] -1,
                                                  "endorse_status": 0,
                                                  "avatar_url": listSkill[index]['avatar_url'],
                                                  "nickname": listSkill[index]['nickname'],
                                                  "in_game_id": listSkill[index]['in_game_id'],
                                                  "is_steam_game": listSkill[index]['is_steam_game'],
                                                  "is_mobile_legend": listSkill[index]['is_mobile_legend']
                                              }];
                                              setState(() {
                                                 listSkill.replaceRange(index, index+1, dataparse);
                                              });


                                              apiUnEndorse(id,player_id_others);
                                            }

                                          },
                                          child: new Text(endorseStatus==0 ? 'Endorse' : 'UnEndorse',
                                            style: new TextStyle(
                                            fontSize: mediaquery.width/textSize14sp,
                                            color: endorseStatus==0 ? Colors.black : Colors.white,
                                            fontFamily: 'ProximaBold')
                                          ),
                                        ),
                                      ),
                                      )
                                    )

                                  ],
                                ),
                              )

                            ]
                          ),
                        ),

                    );

                  },
                  childCount: listSkill.length,
                ),
              ),

            ],
          ),
        ),
      )

    );
  }
}

void logout(context){
  keyStore.setToken('null').then((val){
    print("reset token logout sucess");
    // Navigator.pop(context);
    keyStore.getToken().then((rst){
      print("THEN CEK TOKENNYA : $rst");
      // Navigator.of(context).pushNamed(Home.tag);
      // Navigator.pushNamed(context, '/login');
      Navigator.pushReplacementNamed(context, LoginSignUpPage.tag);
      // Navigator.popUntil(context, ModalRoute.withName('/login'));
      // Navigator.push(context, new MaterialPageRoute(
      //   builder: (context) =>
      //     new LoginSignUpPage())
      // );
    });
  });
}
enum ConfirmAction { CANCEL, ACCEPT }

Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text(
            'Are you sure want to logout?'),
        actions: <Widget>[
          FlatButton(
            color: Colors.black87,
            textColor: backgroundYellow,
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            color: Colors.black87,
            textColor: Colors.white54,
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}
