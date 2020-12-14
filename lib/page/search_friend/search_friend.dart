import 'dart:async';
import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yamisok/api/game/list_role_game_api.dart';
import 'package:yamisok/api/searchfriend/search_friend_api.dart';
import 'package:yamisok/api/searchfriend/search_global_api.dart';
import 'package:yamisok/component/globals.dart';
import 'package:yamisok/page/find_friend/filter_find_friend.dart';
import 'package:yamisok/page/login/login.dart';
// import 'package:yamisok/page/profile/profile.dart';
import 'package:yamisok/page/profile/profile_others.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:quiver/async.dart';
import 'package:yamisok/component/keyStore.dart';

import '../utilities/style.dart';



List listSearch=[];
bool noDataSearch =false;

var listSelected = StringBuffer();
List<int> listSelectedid = List();
List<String> selectedChoices = List();

bool isfist = false;
var newrole = StringBuffer();
var roleparse = StringBuffer();
bool shimmerLoad=false;
bool _isSparator=false;
bool _isNoDataSpesifix=false;
bool _isfirst=false;

List listRole = [];
FirebaseDatabase database = new FirebaseDatabase();
Map _counterOnline;


FirebaseAnalytics analytics = FirebaseAnalytics();
StreamSubscription<Event> _counterSubscription;


RefreshController _scrollController = RefreshController(initialRefresh: false);
RefreshController _refreshController = RefreshController(initialRefresh: false);


class SearchFriend extends StatefulWidget {
  final idGame=17;
  final nameGame="Ml BB";
  @override
  _SearchFriendState createState() => _SearchFriendState();
}

class _SearchFriendState extends State<SearchFriend> {
  String titleStatusBar = "";

  String username = "";
  String token = "";

  final TextEditingController searchController = TextEditingController();

  void _apiListRole() async {
    var idgame = widget.idGame;

    ApiServiceListRole.apilistrole(idgame).then((rst) async {
      setState(() {
        listRole.clear();
      });
      var resultdt = json.decode(rst);
      final messages = resultdt['messages'];
      final status = resultdt['status'];
      if (status == true) {
        final oldrole = resultdt['oldrole'];
        final gamerole = resultdt['gamerole'];
        // print('lihat result role $resultlist');
        setState(() {
          print('lihat oldgame dari api $oldrole');
          // oldgame=oldrole;
          listRole.addAll(gamerole);
        });
      } else {}
    });
  }

  void getapisearchfriend(offset, limit, statusActions, skillid, keyUsername) {
    print('masuk k api search');
    setState(() {
      noDataSearch =false;
    });
   
    var usernameparse = '';
    ApiSearchGlobal.apisearchglobal(offset, limit, widget.idGame, skillid, keyUsername).then((result) async {
      var resultdt = json.decode(result);
      final messages = resultdt['messages'];
      final status = resultdt['status'];
      if (status == true) {
        // print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        
        print('lihat body api getapisearchfriend length, $resultlist');
        if (mounted) {
          
          
          setState(() {
            _scrollController.refreshCompleted();
            _scrollController.loadComplete();
            if (statusActions == 'reLoad') {
              listSearch.clear();
              _isSparator=false;
              _isNoDataSpesifix=false;
              _isfirst=false;
              

            }
            

            // List listGameConnectdt=[];
            // listGameConnectdt.clear();
            shimmerLoad=false;
            // listSearch.addAll(resultlist);
            
            

            if(resultlist!=null){
              for(var i = 0; i < resultlist.length; i++){
              print('object ${resultlist[i]['name']}');
              print('kriteria 1 $i');
              print('kriteria 2 ${resultlist[i]['fitness']}');
              print('kriteria 3 $_isNoDataSpesifix');
              var isSparator=0;
              var isNoDataSpesifix=0;
              
              if(_isfirst==false && resultlist[i]['fitness']!=0 && _isNoDataSpesifix==false){
                print('masuk kriteria ');
                isNoDataSpesifix=1;
                setState(() {
                _isNoDataSpesifix=true;
                  
                });
              }
              if(_isfirst==false && i==0){
                 setState(() {
                  _isfirst=true;
                 });
              }

              if(_isSparator==false && resultlist[i]['fitness']!=0){
                isSparator=1;
                _isSparator=true;
              }
              listSearch.add(
                {
                  "id": resultlist[i]['id'],
                  "username": resultlist[i]['username'],
                  "avatar_url": resultlist[i]['avatar_url'],
                  "gender": resultlist[i]['gender'],
                  "city_name": resultlist[i]['city_name'],
                  "self_city": resultlist[i]['self_city'],
                  "isSparator":resultlist[i]['isSparator'],
                  "mutual_following": resultlist[i]['mutual_following'],
                  "game_list": resultlist[i]['game_list'],
                  "featured": resultlist[i]['featured'],
                  "fitness": resultlist[i]['fitness']
                }
              );
            }
            }

            if(listSearch.length==0){
                  noDataSearch =true;
              }
            // listSearch.clear();
            //
          });

        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

  void _onLoading() {
    print('on load');

    Timer _timer;
    _timer = new Timer(const Duration(milliseconds: 8000), () {
      if (mounted) {
        setState(() {
          _scrollController.loadComplete();

        });
      }
    });
    
    getapisearchfriend(
        listSearch.length, 5, 'onLoad', roleparse, searchController.text);
    
  }

  void _onRefresh() {
    Timer _timer;
    _timer = new Timer(const Duration(milliseconds: 8000), () {
      if (mounted) {
        setState(() {
          _scrollController.refreshCompleted();
        });
      }
    });
    getapisearchfriend(0, 10, 'reLoad', roleparse, searchController.text);

    print('on refresh');
  }

  fetchStore() async {
    username = await keyStore.getUsername();
    token = await keyStore.getToken();
  }

  @override
  void initState() {
    searchController.text = '';
    titleStatusBar = "Mobile Legend";
    listSearch.clear();

    noDataSearch =false;
    _isSparator=false;
    _isNoDataSpesifix=false;
    _isfirst=false;

    listSelected=StringBuffer();
    listSelectedid = List();
    selectedChoices = List();
    shimmerLoad=true;

    bool isfist=false;
    var newrole = StringBuffer();
    var roleparse = StringBuffer();

    List listRole = [];
    var _firebaseRef = database.reference().child('onlinestat/players/online');

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
      
       
        if (mounted) {
          setState(() {
          _counterOnline = event.snapshot.value ?? '0';
         print('online player total ${_counterOnline.length}');
            });
        }
    

      // print('----- > lihat total data online ${_counterOnline.length}');
    }, onError: (Object o) {
      print('----- > lihat total data online  error $o');
    });

    fetchStore();
    _apiListRole();
    getapisearchfriend(0, 10, 'reLoad', roleparse, searchController.text);

    print('lihat game name ${widget.nameGame}');
    

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    analytics.logEvent(name: 'Find_friend');

    // fetchStore();
  }

  

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    // listDataMembers.clear();
    // _scrollController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    AppBar appBar = AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text('Cari Player'),
          ),
          backgroundColor: backgroundPrimary,
          leading: IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ));
    var appbarsize =appBar.preferredSize.height;
    var paddingtop =MediaQuery.of(context).padding.top;


    print('lihat data height ${mediaquery.height}');  
    print('lihat data height appbar $appbarsize'); 
    print('lihat data height search ${mediaquery.height*0.12}');  
    print('lihat data height search ${mediaquery.height*0.88-appbarsize}');  


    

    Widget txtSearch() {
    var keyTemp = '';
    var keyTemp2 = '';
   
    return Container(
      // color:Colors.red,
      height: mediaquery.width / buttonHeight1+ mediaquery.height*0.02,
      child: Align(
        alignment: Alignment.center,
        child: Container(
        height: mediaquery.width / buttonHeight1,
        margin: EdgeInsets.only(left:mediaquery.width/25, right: mediaquery.width/25),
        
          decoration: BoxDecoration(
            color: inputBackground,
            borderRadius: BorderRadius.all(const Radius.circular(50.0))
          ),
          child: Stack(
           children: <Widget>[
            Container(
              padding: EdgeInsets.only(left:mediaquery.width/25,right: mediaquery.width/25),
              child: Center(
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  onChanged: (text) {
                    setState(() {
                       shimmerLoad=true;
                        noDataSearch=false;
                    });
                    
    
                    keyTemp = text;
                    Timer _timer;
                    _timer = new Timer(const Duration(milliseconds: 2000), () {
                      if (mounted) {
                        setState(() {
                          if (keyTemp == text) {
                           
                            // getapisearchfriend(0,10,roleparse,searchController.text);
                            getapisearchfriend(
                                0, 10, 'reLoad', roleparse, searchController.text);
                          }
                        });
                      }
                    });
                  },
                  onEditingComplete: () {
                    // setState(() {
                    //       getapisearchfriend(roleparse,searchController.text);
                    //   });
                  },
                  onSubmitted: (text) {
                    // setState(() {
                    //       getapisearchfriend(roleparse,searchController.text);
                    //   });
                  },
                  style: TextStyle(
                      color: textColor2,
                      fontSize: mediaquery.width / textSize14sp,
                      fontFamily: 'ProximaReguler'),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle:
                          TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
                      hintText: 'Cari pemain disini',
                      
                      ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child:GestureDetector(
                      onTap: () {
                       
                        getapisearchfriend(
                            0, 10, 'reLoad', roleparse, searchController.text);
                      },
                  child: Container(
                  padding: EdgeInsets.only(right:mediaquery.width/25),
                   decoration: BoxDecoration(
                    color: inputBackground,
                    borderRadius: BorderRadius.all(const Radius.circular(50.0))),
                  child: Icon(Icons.search,size: mediaquery.width/textSize20sp,color: Colors.white,)),
              )
            )
           ],
          ),
        ),
      ),
    );
  }

    List<String> selectedReportList = List();

  
    Widget listdata() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = Container(
              child: Text(
                '',
                style: TextStyle(
                    fontSize: mediaquery.width / textSize18sp,
                    color: backgroundYellow,
                    fontFamily: 'ProximaBold'),
              ),
            );
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else {
            body = Container(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellow)),
            );
          }
          // return shimerdt;
          return Container(
            height: 200.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _scrollController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
               noDataSearch==true ? Container(
                  margin: EdgeInsets.only(left:mediaquery.width/25, right: mediaquery.width/25, top: mediaquery.width/25),
                  padding: EdgeInsets.only(left: mediaquery.width/25, right: mediaquery.width/25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(
                              10.0) //         <--- border radius here
                          ),
                      color: backgroundSecond),
                  height: mediaquery.width / 4,
                  child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Tidak ada hasil yang sesuai',
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: mediaquery.width / textSize16sp,
                          color: textColor1,
                          fontFamily: 'ProximaRegular')),
                  Text('dengan pencarian kamu',
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: mediaquery.width / textSize16sp,
                          color: textColor1,
                          fontFamily: 'ProximaRegular'))
                ],
              ),
            ),
                ):Container()
              ],
            ),
          ),
          shimmerLoad ==false ? SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                print(listSearch[index]);
                var imagesUrl = listSearch[index]['avatar_url'] ??
                    'https://yamisok.com/assets/images/default/default.png';
                var gameList = listSearch[index]['game_list'].toString() == 'null' || listSearch[index]['game_list'].toString()=='' || listSearch[index]['game_list'].toString()=='-' ? 'Game belum ditentukan' : listSearch[index]['game_list'].toString();
                var  id = listSearch[index]['id'].toString() ?? '';
                final onlineStatus =  _counterOnline[id].toString() !='null' ? '1' : '0';
                
               
                
                var username = listSearch[index]['username'].toString() ?? '';
                var gender = listSearch[index]['gender'].toString() ?? '';
                var cityname = listSearch[index]['city_name'].toString() == '' || listSearch[index]['city_name'].toString() == 'null' || listSearch[index]['city_name'].toString() == '-' ? 'Lokasi belum ditentukan' : listSearch[index]['city_name'].toString();
                var selfCity = listSearch[index]['self_city'].toString() ?? '0';
                
                var roleList = listSearch[index]['role_list'].toString() == 'null' || listSearch[index]['role_list'].toString()=='' || listSearch[index]['role_list'].toString()=='-' ? 'Role belum ditentukan' : listSearch[index]['role_list'].toString();
                var isSparator= listSearch[index]['is_sparator'].toString() ?? '0';
                var isNoDataSpesifix= listSearch[index]['is_no_data_spesifix'].toString() ?? '0';
                
                // var onlineStatus=listSearch[index]['online_status'].toString() ?? '0';
                // print('cityname $cityname');
                // print(listSearch[index]['city_name'].toString());

                String idhero = 'Search$id';
                var lableSparator=Container();
                var nodataspesifik=Container();

                 if(isSparator=='1'){
                    lableSparator=Container(
                       margin: EdgeInsets.only(left:mediaquery.width/25, right: mediaquery.width/25, top: mediaquery.width/25),
                       
                      child: Align(
                        alignment: Alignment.centerLeft,
                          child: Text('Hasil Pencarian lain',
                          style: TextStyle(
                          fontSize: mediaquery.width /
                              textSize18sp,
                          color: textColor2,
                          fontFamily: 'ProximaBold')
                        ),
                      ),
                    );
                  }


                  if(isNoDataSpesifix=='1'){
                    nodataspesifik=Container(
                        margin: EdgeInsets.only(left:mediaquery.width/25, right: mediaquery.width/25, top: mediaquery.width/25),
                        padding: EdgeInsets.only(left:mediaquery.width/25, right: mediaquery.width/25),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                    10.0) //         <--- border radius here
                                ),
                            color: backgroundSecond),
                        height: mediaquery.width / 4,
                        child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Tidak ada hasil yang sesuai',
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontSize: mediaquery.width / textSize16sp,
                                color: textColor1,
                                fontFamily: 'ProximaRegular')),
                        Text('dengan kategori pencarian kamu',
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontSize: mediaquery.width / textSize16sp,
                                color: textColor1,
                                fontFamily: 'ProximaRegular'))
                      ],
                    ),
                  ),
                );
                 
                  }
                  
                 

                  

                return Column(
                  children: <Widget>[
                    nodataspesifik,
                    lableSparator,
                    Container(
                      margin: EdgeInsets.only(left: mediaquery.width / 30, right: mediaquery.width / 30, top: mediaquery.width / 30),
                      padding: EdgeInsets.only(left: mediaquery.width / 30, right: mediaquery.width / 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: backgroundAbu),
                      height: mediaquery.width / 4,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => ProfileOthers(
                                id: id,
                                username: username,
                                images: imagesUrl,
                                idhero: idhero),
                          ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: mediaquery.width / 6,
                                    height: mediaquery.width / 6,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(20.0)),
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
                                                tag: idhero,
                                                child: Container(
                                                  child: new Image.network(
                                                    imagesUrl,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ))
                                            )
                                          ],
                                        )),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 20.0,
                                        // top: 10.0,
                                        // bottom: 5.0
                                    ),
                                    // color: Colors.amber,
                                    width: mediaquery.width - (mediaquery.width / 3) - 10,
                                    child: new Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Container(
                                          child: Text(username,
                                              style: TextStyle(
                                                  fontSize: mediaquery.width /
                                                      textSize18sp,
                                                  color: textColor2,
                                                  fontFamily: 'ProximaBold')),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                  margin: EdgeInsets.only(right: 5),
                                                  height: mediaquery.width / 40,
                                                  width: mediaquery.width / 40,
                                                  child: Image.asset(
                                                    gender == 'P'
                                                        ? 'assets/images/home/male.png'
                                                        : gender == '1'
                                                            ? 'assets/images/home/male.png'
                                                            : 'assets/images/home/female.png',
                                                  )),
                                              Text(cityname,
                                                  style: TextStyle(
                                                      fontSize: mediaquery.width /
                                                          textSize20sp /
                                                          2,
                                                      color: textColor2,
                                                      fontFamily:
                                                          'ProximaRegular')),
                                            ],
                                          ),
                                        ),
                                        Container(
                                                  height: mediaquery.width / textSize18sp,
                                                  width: mediaquery.width / 6,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Text(gameList,
                                                        style: TextStyle(
                                                            fontSize:
                                                                mediaquery.width /
                                                                    textSize14sp,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'ProximaRegular')),
                                          ),
                                        )
                                        ,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                             padding: EdgeInsets.only(top: 10, bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                       width: mediaquery.width / 30,
                                      child: selfCity=='2' ? 
                                      Text('',
                                        style: TextStyle(
                                            color: textColor2,
                                            fontSize:  (mediaquery.width / textSize20sp)/2,
                                            fontFamily: 'ProximaRegular'),
                                      ): 
                                      selfCity=='1' ? 
                                     Text('',
                                        style: TextStyle(
                                            color: textColor2,
                                            fontSize: (mediaquery.width / textSize20sp)/2,
                                            fontFamily: 'ProximaRegular'),
                                      ):  
                                      Text('',
                                        style: TextStyle(
                                            color: textColor2,
                                            fontSize:  (mediaquery.width / textSize20sp)/2,
                                            fontFamily: 'ProximaRegular'),
                                      )
                                      ) ,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      height: mediaquery.width / 30,
                                      width: mediaquery.width / 30,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xFF34424e),
                                            width: 1,
                                          ),
                                          color: onlineStatus == '0'
                                              ? Colors.grey
                                              : onlineStatus == 'null'
                                                  ? Colors.grey
                                                  : Colors.green,
                                          shape: BoxShape.circle),
                                    ),
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },

              /// Set childCount to limit no.of items
              childCount: listSearch.length,
            ),
          ) : 
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left:mediaquery.width/25, right: mediaquery.width/25),

                      padding: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: backgroundSecond),
                      height: mediaquery.width / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Shimmer.fromColors(
                                baseColor: colorShimer,
                                // highlightColor: Colors.grey[300],
                                // baseColor: Colors.grey[100],
                                highlightColor: colorlightShimer,
                                // direction: ,
                                  child: Container(
                                    width: mediaquery.width / 6,
                                    height: mediaquery.width / 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      color: backgroundTrnasparan,
                                    )
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 5.0),
                                  // color: Colors.amber,
                                  width: mediaquery.width -
                                      (mediaquery.width / 3) -
                                      10,
                                  child: new Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    
                                    children: <Widget>[
                                    Shimmer.fromColors(
                                      baseColor: colorShimer,
                                      // highlightColor: Colors.grey[300],
                                      // baseColor: Colors.grey[100],
                                      highlightColor: colorlightShimer,
                                // direction: ,
                                  
                                    child: Container(
                                          width: mediaquery.width / 3,
                                          height: mediaquery.width / 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                            color: backgroundTrnasparan,
                                          )
                                        ),
                                      ),
                                      SizedBox(
                                        height: mediaquery.width/45,
                                        width: mediaquery.width/10,
                                      ),
                                    
                                      Shimmer.fromColors(
                                      baseColor: colorShimer,
                                      // highlightColor: Colors.grey[300],
                                      // baseColor: Colors.grey[100],
                                      highlightColor: colorlightShimer,
                                // direction: ,
                                  
                                                                          child: Container(
                                          width: mediaquery.width / 4,
                                          height: mediaquery.width / 35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                            color: backgroundTrnasparan,
                                          )
                                        ),
                                      ),
                                      SizedBox(
                                        height: mediaquery.width/45,
                                        width: mediaquery.width/10,
                                      ),
                                      Shimmer.fromColors(
                                      baseColor: colorShimer,
                                      // highlightColor: Colors.grey[300],
                                      // baseColor: Colors.grey[100],
                                      highlightColor: colorlightShimer,
                                // direction: ,
                                  
                                                                          child: Container(
                                          width: mediaquery.width / 2.2,
                                          height: mediaquery.width / 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                            color: backgroundTrnasparan,
                                          )
                                        ),
                                      )
                                      ,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                        ]
                      ),
                    ),
                    SizedBox(
                      height: mediaquery.width/40,
                    ),
                    Container(
                       margin: EdgeInsets.only(left:mediaquery.width/25, right: mediaquery.width/25, top: mediaquery.width/25),

                      padding: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //         <--- border radius here
                              ),
                          color: backgroundSecond),
                      height: mediaquery.width / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Shimmer.fromColors(
                                baseColor: colorShimer,
                                // highlightColor: Colors.grey[300],
                                // baseColor: Colors.grey[100],
                                highlightColor: colorlightShimer,
                                // direction: ,
                                  child: Container(
                                    width: mediaquery.width / 6,
                                    height: mediaquery.width / 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      color: backgroundTrnasparan,
                                    )
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 5.0),
                                  // color: Colors.amber,
                                  width: mediaquery.width -
                                      (mediaquery.width / 3) -
                                      10,
                                  child: new Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    
                                    children: <Widget>[
                                    Shimmer.fromColors(
                                      baseColor: colorShimer,
                                      // highlightColor: Colors.grey[300],
                                      // baseColor: Colors.grey[100],
                                      highlightColor: colorlightShimer,
                                // direction: ,
                                  
                                    child: Container(
                                          width: mediaquery.width / 3,
                                          height: mediaquery.width / 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                            color: backgroundTrnasparan,
                                          )
                                        ),
                                      ),
                                      SizedBox(
                                        height: mediaquery.width/45,
                                        width: mediaquery.width/10,
                                      ),
                                    
                                      Shimmer.fromColors(
                                      baseColor: colorShimer,
                                      // highlightColor: Colors.grey[300],
                                      // baseColor: Colors.grey[100],
                                      highlightColor: colorlightShimer,
                                // direction: ,
                                  
                                                                          child: Container(
                                          width: mediaquery.width / 4,
                                          height: mediaquery.width / 35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                            color: backgroundTrnasparan,
                                          )
                                        ),
                                      ),
                                      SizedBox(
                                        height: mediaquery.width/45,
                                        width: mediaquery.width/10,
                                      ),
                                      Shimmer.fromColors(
                                      baseColor: colorShimer,
                                      // highlightColor: Colors.grey[300],
                                      // baseColor: Colors.grey[100],
                                      highlightColor: colorlightShimer,
                                // direction: ,
                                  
                                                                          child: Container(
                                          width: mediaquery.width / 2.2,
                                          height: mediaquery.width / 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                            color: backgroundTrnasparan,
                                          )
                                        ),
                                      )
                                      ,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                        ]
                      ),
                    )
                  
                  ],
                ) 
                 
                   


                
              

              ],
            )
          ),
        ]
    ),
    );
  }


    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: Container(
         
          color: backgroundPrimary,
          child: Column(
            children: <Widget>[
              Container(
                height:  mediaquery.width / buttonHeight1+ mediaquery.height*0.02,
                child:  txtSearch(),
              ),
              Container(
                height:( ((mediaquery.height)-appbarsize)-paddingtop)- (mediaquery.width / buttonHeight1+ mediaquery.height*0.02),
                child: listdata(),
              )
            ],
          )),
      // floatingActionButton: btnFloatFilter(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
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

    //  print('masuk k else first $listRole');
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

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
