import 'dart:collection';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yamisok/app/FirebaseDatabaseUtil.dart';
import 'package:yamisok/page/chatting/chatting_detail_group.dart';
import 'package:yamisok/page/chatting/chatting_detail_personal.dart';
import 'package:yamisok/page/chatting/chatting_new.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:intl/intl.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();


class ChatListPage extends StatefulWidget{

    @override
    State<StatefulWidget> createState(){
        return	_ChatListPageState();
    }

}

class _ChatListPageState extends State<ChatListPage>{

    FirebaseDatabaseUtil databaseUtil;

    int _playerId = 0;
    String _token = '';

    bool _isSearchMode = false;
    String _searchKeyword = '';

    bool _chatTeamHasData = true;
    bool _chatPersonalHasData = true;

    @override
    void initState() {
       SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        super.initState();
        getSharedPrefs();
        databaseUtil = FirebaseDatabaseUtil();
        databaseUtil.initState();
        analytics.logEvent(name: 'Chatting');

        

    }


    @override
    void dispose() {
        databaseUtil.dispose();
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        super.dispose();
    }

    Future<Null> getSharedPrefs() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
            _token = prefs.getString("token");
            _playerId = prefs.getInt("id_player");
        });
    }

    var _shimmerFollowing = Padding(
        padding: EdgeInsets.all(16),
        child: Shimmer.fromColors(
                        baseColor: colorShimer,
                        highlightColor: colorlightShimer,
                        child: Column(
                            children: <Widget>[
                                Container(
                                    width: double.infinity,
                                    height: 60,
                                    color: backgroundPrimary,
                                ),
                                SizedBox(height: 10,),
                                Container(
                                    width: double.infinity,
                                    height: 60,
                                    color: backgroundPrimary,
                                ),
                                SizedBox(height: 10,),
                                Container(
                                    width: double.infinity,
                                    height: 60,
                                    color: backgroundPrimary,
                                ),
                                SizedBox(height: 10,),
                                Container(
                                    width: double.infinity,
                                    height: 60,
                                    color: backgroundPrimary,
                                ),
                            ],
                        )
        ),
    );

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                centerTitle: true,
                title: (_isSearchMode) ? _searchMode() : Text("Chat"),
                backgroundColor: backgroundPrimary,
                actions: (_isSearchMode) ? _actionOnSearch() : _actionOffSearch(),
            ),
            body: _parent(),
        );
    }

    Widget _searchMode(){
        return Container(
            child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Container(
                            child: TextField(
                                decoration: InputDecoration(
                                    hintText: 'cari username ...',
                                    hintStyle: TextStyle(
                                                    color: inputHintColor
                                    ),
                                    border: InputBorder.none,
                                ),
                                style: TextStyle(
                                                color: Colors.white
                                ),
                                onChanged: (value){
                                    setState(() {
                                        _searchKeyword = value;
                                    });
                                },
                            ),
                        ),
                    )
                ],
            ),
        );
    }

    List<Widget> _actionOnSearch(){
        return [
            IconButton(
                icon: Icon(Icons.clear, color: Colors.white),
                onPressed: (){
                    setState(() {
                        _isSearchMode = false;
                        _searchKeyword = '';
                    });
                },
            )
        ];
    }

    List<Widget> _actionOffSearch(){
        return [
            IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: Colors.white),
                onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatNewPage()),
                    );
                },
            ),
            IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: (){
                    setState(() {
                        _isSearchMode = true;
                    });
                },
            ),
        ];
    }

    Widget _parent(){
        return Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: backgroundPrimary,
                        child: SingleChildScrollView(
                            child: Column(
                                children: <Widget>[
                                    _labelGroup(),
                                    _streamChatTeam(false),
//							(_playerId == 0) ? _shimmerFollowing : (_chatTeamHasData) ? _parentChatGroup() : _emptyState(),
                                    _labelChats(),
                                    _streamChatTeam(true),
//							(_playerId == 0) ? _shimmerFollowing : (_chatPersonalHasData) ? _parentChatPersonal() : _emptyState(),
                                ],
                            ),
                        )
        );
    }

    Widget _labelGroup(){
        return Container(
            margin: EdgeInsets.only(left: 16, top: 20, bottom: 10),
            width: double.infinity,
            child: Text(
                "MY TEAM",
                style: TextStyle(
                                fontSize: 16,
                                color: accent,
                                fontFamily: 'Proxima',
                                fontWeight: FontWeight.w500
                ),
            ),
        );
    }

    Widget _labelChats(){
        return Container(
            margin: EdgeInsets.only(left: 16, top: 20, bottom: 10),
            width: double.infinity,
            child: Text(
                "CHATS",
                style: TextStyle(
                                fontSize: 16,
                                color: accent,
                                fontFamily: 'Proxima',
                                fontWeight: FontWeight.w500
                ),
            ),
        );
    }


    Widget _parentChatPersonal(){
        return Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: FirebaseAnimatedList(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                reverse: true,
                query: databaseUtil.getPersonalChatHistory(_playerId.toString()).orderByChild('updated_at'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
//					return (_searchKeyword == "" || _searchKeyword == null) ? _chatItem(snapshot) : (snapshot.value['sender_player']['name'].toString().toLowerCase().contains(_searchKeyword.toLowerCase())) ? _chatItem(snapshot) : Container();
                } ,
            ),
        );
    }

    Widget _parentChatGroup(){
        return Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: FirebaseAnimatedList(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                reverse: true,
                query: databaseUtil.getTeamChatHistory(_playerId.toString()).orderByChild('updated_at'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
//					return (_searchKeyword == "" || _searchKeyword == null) ? _chatItemTeam(snapshot) : (snapshot.value['name'].toString().toLowerCase().contains(_searchKeyword.toLowerCase())) ? _chatItemTeam(snapshot) : Container();
                } ,
            ),
        );
    }

    Widget _chatItem(Map dataSnapshot, int index){

        if(dataSnapshot['sender_player'] != null){
            var room_id = dataSnapshot['room_id'] ?? '';
            var last_message = dataSnapshot['last_message'] ?? '....';
            var unread_message = dataSnapshot['unread_message'] ?? 0;
            var sender_id = dataSnapshot['sender_player']['id'].toString() ?? '';
            var sender_name = dataSnapshot['sender_player']['name'] ?? 'Unknown Player';
            var avatar = dataSnapshot['sender_player']['avatar_url_sm'] ?? '';
            var timestamp = dataSnapshot['updated_at'] ?? 946659600000;
            var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
            var formattedDate = DateFormat('dd MMM').format(date);

            return GestureDetector(
                onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatDetailPersonalPage(
                            selfId: _playerId.toString(),
                            otherId: sender_id,
                            playerName: sender_name,
                            avatarUrl: avatar,
                            chatRoomId: room_id,
                        )),
                    );
                },
                child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                            color: badgeBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                        children: <Widget>[
                            Stack(
                                children: <Widget>[
                                    _chatAvatar(avatar),
                                    Positioned(
                                        child: _getIndicator(sender_id),
                                        bottom: 1,
                                        right: 13,
                                    )
                                ],
                            ),

                            Flexible(
                                flex: 1,
                                child: Container(
                                    margin: EdgeInsets.only(right: 8),
                                    child: Column(
                                        children: <Widget>[
                                            Row(
                                                children: <Widget>[
                                                    _chatName(sender_name),
                                                ],
                                            ),
                                            Row(
                                                children: <Widget>[
                                                    _chatDesc(last_message.toString().replaceAll('\n', ' '))
                                                ],
                                            )
                                        ],
                                    ),
                                ),
                            ),
                            Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Column(
                                    children: <Widget>[
                                        Row(
                                            children: <Widget>[
                                                _chatDate(formattedDate)
                                            ],
                                        ),
                                        Row(
                                            children: <Widget>[
                                                _chatCounter(unread_message)
                                            ],
                                        )
                                    ],
                                ),
                            )
                        ],
                    ),
                ),
            );
        }else{
            return SizedBox();
        }
    }

    Widget _chatItemTeam(Map dataSnapshot){
        var room_id = dataSnapshot['room_id'].toString() ?? '';
        var last_message = dataSnapshot['last_message'] ?? '';
        var sender_name = dataSnapshot['name'].toString() ?? '';
        var avatar = dataSnapshot['avatar'] ?? '';
        var groupMembers = dataSnapshot['id_player'] ?? '';
        var timestamp = dataSnapshot['updated_at'] ?? 946659600000;
        var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
        var formattedDate = DateFormat('dd MMM').format(date);

        if(sender_name.contains('1vs1') || sender_name.contains('-solo') || sender_name.toLowerCase() == 'null'){
            return SizedBox();
        }else{
            return GestureDetector(
                onTap: (){
                    Navigator.push(context,
                            MaterialPageRoute(
                                    builder: (context) => ChatDetailTeamPage(
                                        teamName: sender_name,
                                        chatRoomId: room_id,
                                        teamAvatarUrl: avatar,
                                        groupMembers: groupMembers,
                                    )
                            )
                    );
                },
                child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                            color: badgeBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                        children: <Widget>[
                            _chatAvatar(avatar),

                            Flexible(
                                flex: 1,
                                child: Container(
                                    margin: EdgeInsets.only(right: 8),
                                    child: Column(
                                        children: <Widget>[
                                            Row(
                                                children: <Widget>[
                                                    _chatName(sender_name),
                                                ],
                                            ),
                                            Row(
                                                children: <Widget>[
                                                    _chatDesc(last_message.toString().replaceAll('\n', ' '))
                                                ],
                                            )
                                        ],
                                    ),
                                ),
                            ),
                            Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Column(
                                    children: <Widget>[
                                        Row(
                                            children: <Widget>[
                                                _chatDate(formattedDate)
                                            ],
                                        ),
                                        Row(
                                            children: <Widget>[
                                                _chatDate("")
                                            ],
                                        )
                                    ],
                                ),
                            )
                        ],
                    ),
                ),
            );
        }
    }


    Widget _chatAvatar(String avatar){
        return Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.only(left: 10, right: 8),
            decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                            (avatar == '' || avatar == null) ? 'https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/2e830410-63fc-4dfc-9443-3fdec18570c0.png' : avatar
                                            )
                            )
            ),
        );
    }

    Widget _chatName(String name){
        return Flexible(
            flex: 1,
            child: Container(
                child: Text(
                    name,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Proxima',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                ),
            ),
        );
    }

    Widget _chatDate(String date){
        return Container(
            child: Text(
                date,
                style: TextStyle(
                                color: textGrey
                ),
            ),
        );
    }

    Widget _chatDesc(String desc){
        return Flexible(
            flex: 1,
            child: Container(
                child: Text(
                    desc,
                    style: TextStyle(
                                    color: textColor2
                    ),
                    overflow: TextOverflow.ellipsis,
                ),
            ),
        );
    }

    Widget _chatCounter(int total){
        if(total == 0) return SizedBox();

        return Container(
            alignment: Alignment(0, 0),
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.all(4),
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
                    '$total',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white
                    ),
                ),
            )
        );
    }

    Widget _emptyState(){

        return Container(
            child: Text(
                'No data',
                style: TextStyle(
                                color: Colors.white,
                                fontSize: 18
                ),
            ),
        );

    }

    Widget _onlineIndicator(String status){

        var color = (status == 'online') ? Colors.green : (status == 'iddle') ? accent : Colors.grey;

        return Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
                boxShadow: [
                    BoxShadow(
                        blurRadius: .5,
                        spreadRadius: 1.0,
                        color: Colors.black.withOpacity(.12)
                    )
                ],
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(999)),
            ),
            margin: EdgeInsets.only(top: 5),
        );
    }

    Widget _streamChatTeam(bool isPersonal){

        var referencePath = (isPersonal) ? databaseUtil.getPersonalChatHistory(_playerId.toString()) : databaseUtil.getTeamChatHistory(_playerId.toString());

        return Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: StreamBuilder(
                stream: referencePath.onValue,
                builder: (context, snap) {
                    if (snap.hasData && !snap.hasError && snap.data.snapshot.value!=null) {

                        //taking the data snapshot.
                        Map data = snap.data.snapshot.value;
                        List item = [];

                        // map to list
                        data.forEach((index, data) => item.add({"key": index, ...data}));

                        try{
                            // sort data
                            item.sort((a,b){
                                return (b["updated_at"] ?? 0).compareTo(a["updated_at"] ?? 0);
                            });
                        }catch(e){
                            print('data is awesome!!! just skip this steps');
                        }

                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: item.length,
                            itemBuilder: (context, index) {

                                if(isPersonal){

                                    return (_searchKeyword == "" || _searchKeyword == null) ?
                                    _chatItem(item[index], index) :
                                    (item[index]['sender_player']['name'].toString().toLowerCase().contains(_searchKeyword.toLowerCase())) ?
                                    _chatItem(item[index], index) : SizedBox();

                                }else{

                                    return (_searchKeyword == "" || _searchKeyword == null) ?
                                    _chatItemTeam(item[index]) :
                                    (item[index]['name'].toString().toLowerCase().contains(_searchKeyword.toLowerCase())) ?
                                    _chatItemTeam(item[index]) : SizedBox();
                                }

                            },
                        );

                    } else {
                        return    Center(child: _emptyState());
                    }
                },
            ),
        );
    }

    Widget _getIndicator(String id){
        return FutureBuilder(
            // ignore: missing_return
            future: databaseUtil.getOnlineStatus(id).once().then((DataSnapshot snapshot){
                if(snapshot.value == null){
                    databaseUtil.getIdleStatus(id).once().then((DataSnapshot snap){
                        return (snap.value != null) ? 'idle' : 'offline';
                    });
                }else{
                    return 'online';
                }
            }),
//			initialData: "offline",
            builder: (BuildContext context, AsyncSnapshot<String> text) {
                return _onlineIndicator(text.data);
            });
    }

}
