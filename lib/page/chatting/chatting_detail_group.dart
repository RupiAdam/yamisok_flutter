import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yamisok/api/misc/notification.dart';
import 'package:yamisok/app/FirebaseDatabaseUtil.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:intl/intl.dart';
import 'package:yamisok/widget/chatting/chat_bubble_widget.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

class ChatDetailTeamPage extends StatefulWidget {
    String teamName = "";
    String teamAvatarUrl = "";
    String chatRoomId = "";
    List groupMembers = [];

    ChatDetailTeamPage(
            {this.teamName, this.teamAvatarUrl, this.chatRoomId, this.groupMembers});

    @override
    State<StatefulWidget> createState() => _ChatDetailTeamState(
            teamName: teamName,
            teamAvatarUrl: teamAvatarUrl,
            chatRoomId: chatRoomId,
            groupMembers: groupMembers);
}

class _ChatDetailTeamState extends State<ChatDetailTeamPage> {
    FirebaseDatabaseUtil databaseUtil;

    String teamName = "";
    String teamAvatarUrl = "";
    String chatRoomId = "";
    List groupMembers = [];

    int _selfPlayerId = 0;
    String _selfToken = "";
    String _selfUsername = "";
    String _selfAvatar = "";

    List _itemChat = [];
    List<Color> listColors = [
        Color(0xFF55C276),
        Color(0xFF4C8AD1),
        Color(0xFFBF61A9),
        Color(0xFFF95252),
        Color(0xFFAF8663),
        Color(0xFF55C276),
        Color(0xFF4C8AD1),
        Color(0xFFBF61A9),
        Color(0xFFF95252),
        Color(0xFFAF8663)
    ];

    ScrollController _scrollController = ScrollController();
    final TextEditingController _textController = TextEditingController();
    bool _isComposing = false;
    bool _isAtBottomScroll = true;

    var _blockTimeInMillis = 1000;
    var _maxSendInSameTime = 3;

    List<int> _listCounter = [];

    _ChatDetailTeamState({this.teamName, this.teamAvatarUrl, this.chatRoomId, this.groupMembers});

    Future<Null> getSharedPrefs() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
            _selfToken = prefs.getString("token");
            _selfPlayerId = prefs.getInt("id_player");
            _selfUsername = prefs.getString("username");
            _selfAvatar = prefs.getString("avatar_url");
        });
    }

    @override
    void initState() {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        super.initState();
        getSharedPrefs();
        databaseUtil = FirebaseDatabaseUtil();
        databaseUtil.initState();
        analytics.logEvent(name: 'Chatting_detail_grup)');

        

        getPlayerCounterChat();

        _scrollController.addListener(() {
            if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
                // reach the bottom
                setState(() {
                    _isAtBottomScroll = true;
                });
            }else{
                setState(() {
                    _isAtBottomScroll = false;
                });
            }
        });

        Timer(Duration(milliseconds: 500), () => _scrollController .jumpTo(_scrollController.position.maxScrollExtent));
    }

    @override
    void dispose() {
        databaseUtil.dispose();
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        super.dispose();
    }

    Future<Null> getPlayerCounterChat() async {
        for(var i=0; i<groupMembers.length; i++){
            _listCounter[i] = (await databaseUtil.getCounterChatTeam(groupMembers[i].toString(), chatRoomId).once()).value ?? 0;
        }
    }

    @override
    Widget build(BuildContext context) {

        return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                title: _appBarTitle(),
                backgroundColor: backgroundPrimary,
                actions: <Widget>[
                    PopupMenuButton(
                        itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 1,
                                child: Text("Bersihkan Percakapan"),
                            ),
                            PopupMenuItem(
                                value: 2,
                                child: Text("Lihat Profile"),
                            ),
                        ],
                        onSelected: (value) {
                            if (value == 1) {
                            } else {}
                        },
                    ),
                ],
            ),
            body: Stack(
                children: <Widget>[
                    _parent(),
                    (!_isAtBottomScroll) ? _buttonScrollToBottom() : SizedBox()
                ],
            ),
        );
    }

    Widget _parent() {
        return Container(
                height: double.infinity,
                width: double.infinity,
                color: backgroundPrimary,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                        _streamDetailChat(),
                        _groupInput()
                    ],
                ));
    }

    Widget _appBarTitle() {
        return Container(
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.chevron_left, color: Colors.white),
                        onPressed: () {
                            Navigator.pop(context);
                        },
                    ),
                    _appbarAvatar(teamAvatarUrl),
                    SizedBox(width: 8),
                    Flexible(
                        flex: 1,
                        child: Container(
                            child: Column(
                                crossAxisAlignment:
                                        CrossAxisAlignment.start, // align horizontal
                                mainAxisAlignment: MainAxisAlignment.center, // align vertical
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                    Text(
                                        teamName,
                                        style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Proxima',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                    ),
                                    Text(
                                        "${groupMembers.length} Members",
                                        style: TextStyle(
                                                color: textGrey, fontFamily: 'Proxima', fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                    )
                                ],
                            ),
                        ),
                    )
                ],
            ),
        );
    }

    Widget _appbarAvatar(String avatar) {
        return Container(
            height: 35,
            width: 35,
            margin: EdgeInsets.only(left: 10, right: 8),
            decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(avatar ??
                                    'https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/2e830410-63fc-4dfc-9443-3fdec18570c0.png'))),
        );
    }

    Widget _streamDetailChat(){
        return Flexible(
            flex: 1,
            child: Container(
                child: StreamBuilder(
                    stream: databaseUtil.getTeamChatDetail(chatRoomId).orderByChild('date').onValue,
                    builder: (context, snap){
                        if(snap.hasData && !snap.hasError && snap.data.snapshot!=null && snap.data.snapshot.value!=null){

                            //taking the data snapshot.
                            Map data = snap.data.snapshot.value;

                            _itemChat.clear();

                            // map to list
                            data.forEach((index, data) => _itemChat.add({"key": index, ...data}));

                            try{
                                // sort data desc a < b
                                _itemChat.sort((a,b){
                                    return a["date"].compareTo(b["date"]);
                                });
                            }catch(e){
                                print('data is awesome!!! just skip this steps');
                            }

                            return ListView.builder(
                                    controller: _scrollController,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: _itemChat.length,
                                    itemBuilder: (context, index){
                                        return _messageItem(_itemChat[index], index);
                                    }
                            );


                        }else{
                            return SizedBox();
                        }
                    },
                ),
            ),
        );
    }

    Widget _groupInput() {
        return Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
            decoration: BoxDecoration(
                    color: badgeBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
            child: Row(
                children: <Widget>[
                    _iconInputIndicator(),
                    _inputMessage(),
                    _buttonSend()
                ],
            ),
        );
    }

    Widget _iconInputIndicator() {
        return InkWell(
            onTap: () {},
            child: Container(
                child: Image(
                    image: AssetImage('assets/images/chatting/emoji.png'),
                ),
            ),
        );
    }

    Widget _inputMessage() {
        return Flexible(
            flex: 1,
            child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                    controller: _textController,
                    onChanged: (String text) =>
                            setState(() => _isComposing = text.toString().trim().length > 0),
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    minLines: 1,
                    decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: inputHintColor),
                            hintText: 'Message ...'),
                ),
            ),
        );
    }

    Widget _buttonSend() {
        return InkWell(
            onTap:
                    _isComposing ? () => _onTextMsgSubmitted(_textController.text) : null,
            child: Container(
                margin: EdgeInsets.only(right: 16),
                child: Image(
                    image: AssetImage('assets/images/chatting/send.png'),
                ),
            ),
        );
    }

    Widget _buttonScrollToBottom() {
        return Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                    decoration: BoxDecoration(
                            boxShadow: [
                                BoxShadow(
                                        blurRadius: .5,
                                        spreadRadius: 1.0,
                                        color: Colors.black.withOpacity(.12))
                            ],
                            color: badgeBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(999))),
                    margin: EdgeInsets.only(bottom: 80, right: 16),
                    child: IconButton(
                            icon: Icon(Icons.keyboard_arrow_down, color: accent),
                            onPressed: () {
                                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                            }),
                ));
    }

    Widget _messageItem(Map snapshot, int index) {

        try{
            var senderId = snapshot['id'] ?? 0;
            var timestamp = snapshot['date'];
            var message = snapshot['text'];
            var senderName = snapshot['name'];
            var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
            var formattedTime = DateFormat('HH:mm').format(date);
            var formattedDate = DateFormat('EEEE, dd MMM yy').format(date);
            var ymd = DateFormat('y-MM-dd').format(date);

            if (index != 0) {
                var prevItem = _itemChat[index-1];
                var prevTimestamp = prevItem['date'];
                var prevDate = new DateTime.fromMillisecondsSinceEpoch(prevTimestamp);
                var prevYmd = DateFormat('y-MM-dd').format(prevDate);
                
                if (ymd != prevYmd) {
                    return Container(
                        child: Column(
                            children: <Widget>[
                                _messageDate(formattedDate),
                                (senderId == _selfPlayerId)
                                        ? _messageRight(message, formattedTime)
                                        : _messageLeft(
                                        message, formattedTime, senderId, senderName),
                            ],
                        ),
                    );
                }
            } else {
                return Container(
                    child: Column(
                        children: <Widget>[
                            _messageDate(formattedDate),
                            (senderId == _selfPlayerId)
                                    ? _messageRight(message, formattedTime)
                                    : _messageLeft(message, formattedTime, senderId, senderName),
                        ],
                    ),
                );
            }

            if (senderId == _selfPlayerId)
                return _messageRight(message, formattedTime);
            else
                return _messageLeft(message, formattedTime, senderId, senderName);
        }catch(e){
            return SizedBox();
        }
    }

    Widget _messageLeft(String message, String time, int senderId, String senderName) {
        return Align(
            alignment: Alignment.centerLeft,
            child: Column(
                children: <Widget>[
                    Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                    BoxShadow(
                                            blurRadius: .5,
                                            spreadRadius: 1.0,
                                            color: Colors.black.withOpacity(.12))
                                ],
                                color: badgeBackgroundColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(5.0),
                                ),
                            ),
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(left: 16, right: 50, bottom: 6, top: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Stack(
                                        children: <Widget>[
                                            _itemSenderName(senderId, senderName),
                                            Container(
                                                margin: EdgeInsets.only(top: 20),
                                                child: Padding(
                                                    padding: EdgeInsets.only(right: 48.0),
                                                    child: Text(
                                                        message,
                                                        style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 16,
                                                                fontFamily: 'Proxima'),
                                                    ),
                                                ),
                                            ),
                                            Positioned(
                                                bottom: 0.0,
                                                right: 0.0,
                                                child: Row(
                                                    children: <Widget>[
                                                        Text(time,
                                                                style: TextStyle(
                                                                    color: textGrey,
                                                                    fontSize: 10.0,
                                                                )),
                                                        SizedBox(width: 3.0),
                                                    ],
                                                ),
                                            )
                                        ],
                                    ),
                                ],
                            )),
                ],
            ),
        );
    }

    Widget _messageRight(String message, String time) {
        return Align(
            alignment: Alignment.centerRight,
            child: ChatBubble(
                message: message,
                isMe: true,
                time: time,
                delivered: true,
            ),
        );
    }

    Widget _messageDate(String date) {
        return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 10, top: 16),
            decoration: BoxDecoration(
                    color: Color(0xFF0A1013),
                    borderRadius: BorderRadius.all(Radius.circular(99))),
            child: Text(
                date,
                style: TextStyle(color: textGrey),
            ),
        );
    }

    Widget _itemSenderName(int senderId, String senderName) {
        var index = groupMembers.indexOf(senderId);
        return Container(
            child: Text(
                senderName,
                style: TextStyle(
                        color: listColors[index],
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Proxima'),
            ),
        );
    }

    Future<Null> _onTextMsgSubmitted(String message) async {

        if(_itemChat.length >= _maxSendInSameTime){
            var prevTime = DateTime.fromMillisecondsSinceEpoch(_itemChat[_itemChat.length - _maxSendInSameTime]['date']).millisecondsSinceEpoch;
            var current = DateTime.now().millisecondsSinceEpoch;

            if((current - prevTime) < _blockTimeInMillis){
                // return message
                return;
            }
        }

        _textController.clear();
        setState(() {
            _isComposing = false;
            for(var i = 0; i<_listCounter.length; i++){
                _listCounter[i] += 1;
            }
        });

        var _timestamp = ServerValue.timestamp;

        databaseUtil.getTeamChatDetail(chatRoomId).push().set({
            'avatar': _selfAvatar,
            'badge_url': '',
            'date': _timestamp,
            'id': _selfPlayerId,
            'is_subscribe': 0,
            'name': _selfUsername,
            'text': message,
            'read_message': false,
            'type': 1,
            'poke_back': false,
            'platform': Platform.operatingSystem,
            'url': '',
            'file_name': '',
        });

        for (var i = 0; i < groupMembers.length; i++) {
            databaseUtil
                    .getTeamChatHistoryDetail(groupMembers[i].toString(), chatRoomId)
                    .update({
                        'last_message': message,
                        'unread_message': (groupMembers[i] == _selfPlayerId) ? 0 : _listCounter[i],
                        'updated_at': _timestamp
                    });
            ApiNotification.sendNotification(_selfToken, _selfPlayerId.toString(), groupMembers[i].toString(), _selfUsername, message, "CHAT");
        }

        Timer(Duration(milliseconds: 500), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
    }
}
