// import 'dart:ffi';

import 'package:expandable/expandable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' show Client;
import 'package:yamisok/api/online_status/set_status_online_api.dart';
import 'package:yamisok/api/profile/profile_aboutme_api.dart';
import 'package:yamisok/api/profile/profile_basicinfo_api.dart';
import 'package:yamisok/api/profile/profile_level_api.dart';
import 'package:yamisok/api/profile/profile_sklill_api.dart';
import 'package:share/share.dart';
import 'dart:convert';
// import 'package:yamisok/component/globals.dart' as global;
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yamisok/page/game/connect_game.dart';
import 'package:yamisok/page/game/connect_game_manual.dart';
import 'package:yamisok/page/game/connect_game_ocr.dart';
import 'package:yamisok/page/game/connect_game_steam.dart';
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

import 'package:flutter/src/material/refresh_indicator.dart';
import 'package:pull_to_refresh/src/internals/indicator_wrap.dart';

import 'edit_profile.dart';
import 'edit_aboutme.dart';

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

// final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//     new GlobalKey<RefreshIndicatorState>();

List listSkill=[
];

List listSkillheader=[
];

//images default
String imagesDefault='https://yamisok.com/assets/images/default/default.png';

//profile
String username='';
String name='';
String avatarUrl='https://yamisok.com/assets/images/default/default.png';
int levelAchievment=0;
String endorse='0';
String followers='0';
String following='0';
String shortBio='';
String avatarUrlSm;
double currentLevelPercentage=0;
String gender ='';
String cityNameProfile ='';

String aboutme='';

FirebaseAnalytics analytics = FirebaseAnalytics();


class PageProfile extends StatefulWidget {
  @override
  _PageProfileState createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  @override
  
  //get api profile
  void apiProfilelevel(){
    var usernameParse='';
    ApiServiceProfile.apiprofile(usernameParse).then((result) async {
          var resultdt = json.decode(result);
          final messages = resultdt['messages'];
          final status = resultdt['status'];

        if(status==true){
          var resultlist = resultdt['result'];


          print("lihat result apiprofile  $resultlist");
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
                var datapersen=resultlist['current_level_percentage'];
                currentLevelPercentage=datapersen.toDouble();
                gender =resultlist['gender'];
                cityNameProfile =resultlist['cityName'].toString() ?? '';
                // _scrollController.refreshCompleted();
            });
          }

          print("lihat apiprofile cityNameProfile $cityNameProfile");
        }else{
          // print("status false");
        }


      });
  }

  void apiEndorse(){

    print('get api endorse');
    var playerIdparse=0;
    ApiServiceSkill.apiskill(playerIdparse).then((result) async {
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
               listSkillheader.addAll(listSkillheaderFirst);
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

  void apiAboutMe(){

    // print('get api endorse');
    var parseUsername='';
    ApiServiceAboutMe.apiaboutme(parseUsername).then((result) async {
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

  void setapistatusonline() {
    ApiSetOnline.apisetonline().then((result) async {
      var resultdt = json.decode(result);
      final status = resultdt['status'];
      if (status == true) {
        
        print("status online true");
      } else {
        print("status online false");
      }
    });
  }


  @override
  void initState() {
    print('lihat init profile 1');
    // listData.clear();
    // listDataProfileDetail.clear();
    // listDataDetail.clear();
    // listAchievement.clear();
    // listSkill.clear();
    // listSkillheader.clear();
    // detailProfile='';
    // //images default
    // imagesDefault='https://yamisok.com/assets/images/default/default.png';

    // //profile
    //  username='';
    //  name='';
    //  avatarUrl='https://yamisok.com/assets/images/default/default.png';
    //  levelAchievment=0;
    //  endorse='0';
    //  followers='0';
    //  following='0';
    //  shortBio='';
    //  currentLevelPercentage=0;
    //  gender ='';
    //  cityNameProfile ='';


    super.initState();
    aboutme='';
    // apiEndorse();
    // apiAboutMe();
    // setapistatusonline();
    // apiProfilelevel();
   

    analytics.logEvent(name: 'Profile');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    
  }

  @override
  void dispose() {
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    super.dispose();
  }

  //  @override
  // void initState() {
  //   super.initState();
  //   print('lihat data tab k profile');   
  //   print('jalan profile load data baru');

  //   super.initState();
  //   aboutme='';
  //   apiEndorse();
  //   apiAboutMe();
  //   setapistatusonline(); 
  //   apiProfilelevel();

  //   analytics.logEvent(name: 'Profile');
  //   // setapistatusonline();
  // }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

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
        var usernameParse='';
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
                        child: Center(child: Container(
                            child: new Image.network(
                              avatarUrl ?? '',
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
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
                              height: mediaquery.width/textSize18sp,),
                              Container(
                                width: mediaquery.width/2.2,
                                padding: EdgeInsets.only(left: 5),
                                child: Text(username ?? '',
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
                                color: Colors.green,
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
                      child: Text(cityNameProfile ?? '',
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
      if(username.length==0){
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileFollowersPage()),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileFollowingPage()),
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
          onTap: ()async{
            String result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => 
                    UpdateProfilePicturePage(
                      dataAvatarUrl:avatarUrl,
                      dataShortbio:shortBio
                    )
                  ),
            );
            setState((){
              if(result=='succes'){
                print('masuk k status true');
                  apiProfilelevel();
              }else{
                  print('masuk k status false');
                  apiProfilelevel();
              }
            });

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

    Widget _buttonBagikan() {
      var mediaquery = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.only(right: mediaquery.width/80),
        width: mediaquery.width/4,
        height: mediaquery.width/buttonHeight1,
        child: ButtonTheme(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(50.0),
        ),
        buttonColor: backgroundYellow,
        minWidth: double.infinity,
        height: mediaquery.width/buttonHeight1,
        child: RaisedButton(
          onPressed: (){
              keyStore.getUsername().then((uname){
                Share.share('https://yamisok.com/profile/$uname');
              });
          },
          child: new Text('Bagikan',
            style: new TextStyle(
            fontSize: mediaquery.width/textSize14sp,
            color: Colors.black,
            fontFamily: 'ProximaBold')
          ),
        ),
      ),
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
                width: mediaquery.width/3.5,

              ),


      ),
    );

    Widget _buttonAction(){
      return Container(
        margin: EdgeInsets.only( left: mediaquery.width/25, right: mediaquery.width/25),
        height: mediaquery.width/buttonHeight1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              username.length==0 ? shimmerbuttonaction : _buttonUbah(),
             username.length==0 ? shimmerbuttonaction : Container(),
              username.length==0 ? shimmerbuttonaction : _buttonBagikan(),

            ],
        ),
      );
    }

    //widget skill
    var dataSkill = new Container(
        height: mediaquery.width/4.2,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: listSkillheader.length,
          itemBuilder: (context, index) {
            final id = listSkillheader[index]['id'];
            final name = listSkillheader[index]['skill_1'];
            // final name = 'test data';

             final avatarUrlnew = listSkillheader[index]['avatar_url'] !=null ? listSkillheader[index]['avatar_url'] : "null";

            // print('lihat skill headers ${listSkillheader[index]['avatar_url'] }'); // final title = "blabla";
            // final description = "bla bla";
            // final avatarUrlnew = "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/a161727e-91f5-4896-b41b-4d9f1853950a.png";
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child:InkWell(
                onTap: () async {
                  if(id==0){
                    String result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>
                              ConnectGame(
                                rotefrom:'profile'
                              )
                            ),
                          );
                          setState((){
                            if(result=='succes'){
                              print('masuk k status true');
                                apiEndorse();
                            }else{
                               print('masuk k status false');
                               apiEndorse();
                            }
                          });
                  }else{

                  }

              },
                              child: Column(
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
                              child: avatarUrlnew != "null" ? Image.network(avatarUrlnew) : Image.asset("assets/images/profile/defaultskill.png",
                                scale: 10),
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
              ),
            );
          },
        ));

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
        child: username.length==0 ? shimmerSkill : dataSkill,
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
            GestureDetector(

              onTap: () async {
                String result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>
                              EditAboutMe(
                                data:aboutme
                              )
                            ),
                          );
                          setState((){
                            if(result=='succes'){
                              print('-->Profile return trus');
                                apiAboutMe();
                            }else{
                               print('-->Profile return false');
                              //  apiAboutMe();
                            }
                          });
              },
                          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Ubah',
                    style: TextStyle(
                      fontSize: mediaquery.width/textSize14sp,
                      color:textColorDisable,
                      fontFamily: 'ProximaBold'
                    ),
                  ),
                  Icon(Icons.chevron_right,
                  size:mediaquery.width/textSize20sp,
                  color: Colors.white,)
                ],
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
              height: (mediaquery.width/textSize14sp) * 6,
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
        final tp = TextPainter(text: span, maxLines: 5, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
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
                  10.0)
              ),
          color: backgroundAbu
        ),
        margin: EdgeInsets.only(left: 10,right: 10),
        padding: EdgeInsets.all(20.0),
        child: ExpandableNotifier(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: ScrollOnExpand(
              child: conditionTentangSaya()
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

            GestureDetector(

              onTap: () async {
                String result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>
                              ConnectGame(
                                rotefrom:'profile'
                              )
                            ),
                          );
                          setState((){
                            if(result=='succes'){
                              print('masuk k status true');
                                apiEndorse();
                            }else{
                               print('masuk k status false');
                               apiEndorse();
                            }
                          });
              },
                          child: Row(
                            key: Key('tambahendorse'),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Tambah',
                    style: TextStyle(
                      fontSize: mediaquery.width/textSize14sp,
                      color:textColorDisable,
                      fontFamily: 'ProximaBold'
                    ),
                  ),
                  Icon(Icons.chevron_right,
                  size:mediaquery.width/textSize20sp,
                  color: Colors.white,)
                ],
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
                  child: SelectableText('youtube.com/channel/$youtubeUrl',
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

      if(detailProfile != '' || detailProfile != null){
        // print("detailProfile");
        // print(detailProfile);
        var fullname = detailProfile[0]['real_name'].toString() == 'null' || detailProfile[0]['real_name'].toString() == '' ? '-' : detailProfile[0]['real_name'];
        var urlname = detailProfile[0]['url'].toString() ?? '';
        var dateofborn = detailProfile[0]['date_of_born'].toString() == 'null' || detailProfile[0]['date_of_born'].toString() == '' ? '-' : detailProfile[0]['date_of_born'];
        var gender = detailProfile[0]['gender'].toString() == 'P' ? 'Pria' : 'Wanita';
        var phoneNumber = detailProfile[0]['phone_number'].toString() ?? '';
        var address = detailProfile[0]['player_address'].toString() == 'null' || detailProfile[0]['player_address'].toString() == '' ? '-' : detailProfile[0]['player_address'].toString();
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
                  child: Text('URL profile',
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
        var usernameParse='';
        // store.dispatch(AppAction.UpdateDetailPlayer(usernameParse));
        store.dispatch(AppAction.UpdateDetailPlayer(usernameParse:usernameParse));

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
            GestureDetector(
              onTap: () async {
                String result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>
                              EditProfile(
                              )
                            ),
                          );
                          setState((){
                            if(result=='succes'){

                              // Container(
                              //       child: StoreConnector<AppState, ViewModel>(
                              //       builder: (BuildContext context, ViewModel vm) {
                              //       detailProfile = vm.state.detailuser_content;

                              //         if(detailProfile!='' || detailProfile!=null){
                              //         return Container();

                              //         }else{
                              //           return shimmerContainer;
                              //         }


                              //       }, converter: (store) {
                              //           return ViewModel(
                              //             state: store.state,
                              //               // updatekota : (String provinsi) => store.dispatch(AppAction.UpdateKota(provinsi:provinsi))

                              //             );
                              //       }, onInit: (store) {
                              //         var usernameParse='';
                              //         // store.dispatch(AppAction.UpdateDetailPlayer(usernameParse));
                              //         store.dispatch(AppAction.UpdateDetailPlayer(usernameParse:usernameParse));

                              //       },
                              //       ),
                              //       );
                              var store = StoreProvider.of<AppState>(context);
                              var usernameParse='';
                              store.dispatch(AppAction.UpdateDetailPlayer(usernameParse:usernameParse));
                              
                              print('-->Profile return trus');
                                // apiAboutMe();
                            }else{
                              // Container(
                              //       child: StoreConnector<AppState, ViewModel>(
                              //       builder: (BuildContext context, ViewModel vm) {
                              //       detailProfile = vm.state.detailuser_content;

                              //         if(detailProfile!='' || detailProfile!=null){
                              //         return Container();

                              //         }else{
                              //           return shimmerContainer;
                              //         }


                              //       }, converter: (store) {
                              //           return ViewModel(
                              //             state: store.state,
                              //               // updatekota : (String provinsi) => store.dispatch(AppAction.UpdateKota(provinsi:provinsi))

                              //             );
                              //       }, onInit: (store) {
                              //         var usernameParse='';
                              //         // store.dispatch(AppAction.UpdateDetailPlayer(usernameParse));
                              //         store.dispatch(AppAction.UpdateDetailPlayer(usernameParse:usernameParse));

                              //       },
                              //       ),
                              //       );
                               print('-->Profile return false');
                              //  apiAboutMe();
                            }
                          });
              },
                          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Ubah',
                    style: TextStyle(
                      fontSize: mediaquery.width/textSize14sp,
                      color:textColorDisable,
                      fontFamily: 'ProximaBold'
                    ),
                  ),
                  Icon(Icons.chevron_right,
                  size:mediaquery.width/textSize20sp,
                  color: Colors.white,)
                ],
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

            title: Center(child: const Text('Profil Saya')),
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
                  child: Text(
              '',
              style: TextStyle(
                fontSize: mediaquery.width/textSize18sp,
                color: backgroundYellow,
                fontFamily: 'ProximaBold'
              ),
            ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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

                    var skill= listSkill[index]['skill_1'];
                    var totalEndorse= listSkill[index]['total_endorse'].toString();
                    var gameName= listSkill[index]['game_name'].toString();
                    var nickName= listSkill[index]['nickname'];
                    var inGameId= listSkill[index]['in_game_id'].toString();
                    var idgame = listSkill[index]['game_group_id'];
                    int idGameGrup=0;
                    if(idgame!=null){
                      idGameGrup=idgame;

                    }else{
                      idGameGrup=0;
                    }
                    var imageGame = listSkill[index]['image'].toString()!='' ?  listSkill[index]['image'].toString() !='null' ?  listSkill[index]['image'].toString() :  "https://yamisok.com/assets/images/profile-v2/default-skill.png" :  "https://yamisok.com/assets/images/profile-v2/default-skill.png";
                    bool statusGameOcr = listSkill[index]['is_mobile_legend'];
                    bool statusGameSteam = listSkill[index]['is_steam_game'];
                    bool statusGameOthers = listSkill[index]['is_other_game'] ?? false;
                    bool statusUbahButton = true;

                    if(statusGameOcr==false && statusGameSteam==false &&  statusGameOthers==false){
                      statusUbahButton=false;
                    }
                    return Container(

                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.all(Radius.circular(
                                10.0) //         <--- border radius here
                            ),
                        color: backgroundAbu
                      ),

                      // color: Colors.white,
                      margin:EdgeInsets.only(left: 8.0, right: 8.0, bottom:8.0, top:8.0),
                      child: GestureDetector(
                        onTap:() async {},

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
                                        buttonColor: backgroundGreyDark,
                                        minWidth: double.infinity,
                                        height: mediaquery.width/buttonHeight1,
                                        child: statusUbahButton ? RaisedButton(
                                          onPressed: () async {
                                            if(statusGameSteam==true){
                                                String result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context)=>
                                                    GameSteamPage(
                                                      idgame:idGameGrup,
                                                      ingameid:inGameId,
                                                      isjointour:false,
                                                      nicname:nickName,
                                                      name:gameName
                                                      )
                                                  ),
                                                );
                                                setState((){
                                                  if(result=='succes'){
                                                      apiEndorse();
                                                  }else{
                                                  }
                                                });
                                            }else if(statusGameOcr==true){
                                                String result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context)=>
                                                    GameOcrPage(
                                                      idgame:idGameGrup,
                                                      ingameid:inGameId,
                                                      isjointour:false,
                                                      nicname:nickName,
                                                      name:gameName
                                                    )
                                                  ),
                                                );
                                                setState((){
                                                  if(result=='succes'){
                                                      apiEndorse();
                                                  }else{
                                                  }
                                                });
                                            }else if(statusGameOthers==true){
                                                String result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context)=>
                                                    GameManualPage(
                                                      idgame:idGameGrup,
                                                      ingameid:inGameId,
                                                      isjointour:false,
                                                      nicname:nickName,
                                                      name:gameName
                                                      )
                                                  ),
                                                );
                                                setState((){
                                                  if(result=='succes'){
                                                      apiEndorse();
                                                  }else{
                                                  }
                                                });
                                            }else{
                                              String result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context)=>
                                                    GameManualPage(
                                                      idgame:idGameGrup,
                                                      ingameid:inGameId,
                                                      isjointour:false,
                                                      nicname:nickName,
                                                      name:gameName
                                                      )
                                                  ),
                                                );
                                                setState((){
                                                  if(result=='succes'){
                                                    apiEndorse();
                                                  }else{
                                                  }
                                                });

                                            }



                                          },
                                          child: new Text('Ubah',
                                            style: new TextStyle(
                                            fontSize: mediaquery.width/textSize14sp,
                                            color: textColor2,
                                            fontFamily: 'ProximaBold')
                                          ),
                                        ):Container(),
                                      ),
                                      )
                                    )

                                  ],
                                ),
                              )

                            ]
                          ),
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