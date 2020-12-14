import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yamisok/api/misc/chatting_api.dart';
import 'package:yamisok/api/misc/notification.dart';
import 'package:yamisok/app/FirebaseDatabaseUtil.dart';
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/page/profile/profile_others.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:intl/intl.dart';
import 'package:yamisok/widget/chatting/chat_bubble_widget.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

class ChatDetailPersonalPage extends StatefulWidget{

	String selfId = "";
	String otherId = "";
	String playerName = "";
	String avatarUrl  = "";
	String chatRoomId = "";

	ChatDetailPersonalPage({Key key, @required this.selfId, @required this.otherId, @required this.playerName, @required this.avatarUrl, @required this.chatRoomId}) : super(key: key);

	@override
	State<StatefulWidget> createState() {
		return _ChatDetailState(selfId: selfId, otherPlayerId: otherId, otherPlayerName: playerName, otherPlayerAvatarUrl: avatarUrl, chatRoomId: chatRoomId);
	}

}

class _ChatDetailState extends State<ChatDetailPersonalPage>{

	FirebaseDatabaseUtil databaseUtil;

	int _selfPlayerId = 0;
	String _selfToken = "";
	String _selfUsername = "";
	String _selfAvatar = "";

	String selfId = "";
	String otherPlayerId = "";
	String otherPlayerName = "";
	String otherPlayerAvatarUrl  = "";
	String chatRoomId = "";

	Map pureData;
	List _itemStorage = [];
	List _itemChat = [];

	ScrollController _scrollController = ScrollController();
	final TextEditingController _textController = TextEditingController();
	bool _isComposing = false;
	bool _isAtBottomScroll = true;

	var _blockTimeInMillis = 3000;
	var _maxSendInSameTime = 3;

	int _otherPlayerUnreadChat = 0;
	bool _isLoading = true;
	bool _isPokeActive = false;

	static const CHAT_TYPE_TEXT = 1;
	static const CHAT_TYPE_POKE = 2;

	_ChatDetailState({this.selfId, this.otherPlayerId, this.otherPlayerName, this.otherPlayerAvatarUrl, this.chatRoomId});

	@override
	void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
		super.initState();
		getSharedPrefs();
		databaseUtil = FirebaseDatabaseUtil();
		databaseUtil.initState();
		analytics.logEvent(name: 'Chatting_detail_personal');

		getStorageChat();
		getOtherPlayerCounterChat();

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

		Timer(Duration(milliseconds: 1000), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));

	}

	@override
	void dispose() {
		// clear unread chat
		databaseUtil.getPersonalChatHistoryDetail(_selfPlayerId.toString(), chatRoomId).update({
			'unread_message': 0,
		});
		databaseUtil.dispose();

		SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

		super.dispose();
	}

	Future<Null> getSharedPrefs() async {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		var block = await keyStore.getLatestPokedTIme(otherPlayerId) ?? 0;
		var now = DateTime.now().toUtc().millisecondsSinceEpoch;
		setState(() {
			_selfToken = prefs.getString("token");
			_selfPlayerId = prefs.getInt("id_player");
			_selfUsername = prefs.getString("username");
			_selfAvatar = prefs.getString("avatar_url");
			_isPokeActive = (now < block) ? false : true;
		});
	}

	Future<Null> getOtherPlayerCounterChat() async {
		_otherPlayerUnreadChat = (await databaseUtil.getCounterChatPersonal(otherPlayerId, chatRoomId).once()).value ?? 0;
	}

	Future<Null> getStorageChat() async{

		var sample = (await databaseUtil.getStoragePersonalDetail(selfId, chatRoomId).once()).value;

		if(sample != null) sample.forEach((index, data) => _itemStorage.add({"key": index, ...data}));

		setState(() {
			_isLoading = false;
		});

	}

	@override
	Widget build(BuildContext context) {
//		Timer(Duration(milliseconds: 1000), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
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
								child: Text("Laporkan Pengguna"),
							),
							PopupMenuItem(
								value: 3,
								child: Text("Lihat Profile"),
							),
							PopupMenuItem(
								value: 4,
								child: Text("Colek"),
							),
						],
						onSelected: (value) {
							if(value == 1){
								_moveChatItemToStorage();
							}else if(value == 2){

							}else if(value == 3){
								var idhero = 'chat-detail-$otherPlayerId';
								Navigator.push(
									context,
									MaterialPageRoute(builder: (context) => ProfileOthers(id: otherPlayerId, username: otherPlayerName, images: otherPlayerAvatarUrl, idhero:idhero)),
								);
							}else if(value == 4){
								if(_isPokeActive){
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
							}
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

	Widget _parent(){
		return Container(
				height: double.infinity,
				width: double.infinity,
				color: backgroundPrimary,
				child: Column(
					mainAxisSize: MainAxisSize.max,
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: <Widget>[
//						_parentChatList(),
						_streamDetailChat(),
						_groupInput()
					],
				)
		);
	}

	Widget _appBarTitle(){
		return
			Container(
				child: Row(
					mainAxisSize: MainAxisSize.max,
					mainAxisAlignment: MainAxisAlignment.start,
					children: <Widget>[
						IconButton(
							icon: Icon(Icons.chevron_left, color: Colors.white),
							onPressed: (){
								Navigator.pop(context);
							},
						),
						_appbarAvatar(otherPlayerAvatarUrl),
						SizedBox(width: 8),
						Flexible(
							flex: 1,
							child: Text(otherPlayerName,
								style: TextStyle(
										color: Colors.white,
										fontFamily: 'Proxima',
										fontSize: 20,
										fontWeight: FontWeight.w400
								),
								overflow: TextOverflow.ellipsis,
								maxLines: 1,
							),
						)
					],
				),
			);
	}

	Widget _appbarAvatar(String avatar){
		return Container(
			height: 35,
			width: 35,
			margin: EdgeInsets.only(left: 10, right: 8),
			decoration: BoxDecoration(
					shape: BoxShape.circle,
					image: DecorationImage(
							fit: BoxFit.fill,
							image: NetworkImage(
									avatar ?? 'https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/2e830410-63fc-4dfc-9443-3fdec18570c0.png'
							)
					)
			),
		);
	}

	Widget _streamDetailChat(){
		return Flexible(
			flex: 1,
			child: Container(
				child: StreamBuilder(
					stream: databaseUtil.getPersonalChatDetail(chatRoomId).orderByChild('date').onValue,
					builder: (context, snap){

						_itemChat.clear();
						_itemChat.addAll(_itemStorage);

						if(snap.hasData && !snap.hasError && snap.data.snapshot!=null && snap.data.snapshot.value!=null){

							//taking the data snapshot.
							pureData = snap.data.snapshot.value;

							// map to list
							pureData.forEach((index, data) => _itemChat.add({"key": index, ...data}));

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
							print('else condition');
							if(_itemChat.length>0) {
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
										itemBuilder: (context, index) {
											return _messageItem(_itemChat[index], index);
										}
								);
							}else
								return SizedBox();
						}
					},
				),
			),
		);
	}

	Widget _groupInput(){
		return Container(
			margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
			decoration: BoxDecoration(
					color: badgeBackgroundColor,
					borderRadius: BorderRadius.all(Radius.circular(10.0))
			),
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

	Widget _iconInputIndicator(){
		return InkWell(
			onTap: (){},
			child: Container(
				child: Image(
					image: AssetImage(
							'assets/images/chatting/emoji.png'
					),
				),
			),
		);
	}

	Widget _inputMessage(){
		return Flexible(
			flex: 1,
			child: Container(
				margin: EdgeInsets.only(left: 10, right: 10),
				child: TextField(
					controller: _textController,
					onChanged: (String text) =>  setState(() => _isComposing = text.toString().trim().length > 0),
					style: TextStyle(
							color: Colors.white
					),
					keyboardType: TextInputType.multiline,
					maxLines: 4,
					minLines: 1,
					decoration: InputDecoration(
							border: InputBorder.none,
							hintStyle: TextStyle(
									color: inputHintColor
							),
							hintText: 'Message ...'
					),
				),
			),
		);
	}

	Widget _buttonSend(){
		return InkWell(
			onTap: _isComposing
					? () => _onTextMsgSubmitted(_textController.text)
					: null,
			child: Container(
				margin: EdgeInsets.only(right: 16),
				child: Image(
					image: AssetImage(
							'assets/images/chatting/send.png'
					),
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
								_scrollController
										.jumpTo(_scrollController.position.maxScrollExtent);
							}),
				));
	}

	Widget _messageItem(Map snapshot, int index){

		var senderId = snapshot['id'];
		var timestamp = snapshot['date'];
		var message = snapshot['text'];
		var type = snapshot['type'] ?? 1;
		var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
		var formattedTime = DateFormat('HH:mm').format(date);
		var formattedDate = DateFormat('EEEE, dd MMM yy').format(date);
		var ymd = DateFormat('y-MM-dd').format(date);


		if(index != 0){
			var prevItem = _itemChat[index-1];
			var prevTimestamp = prevItem['date'];
			var prevDate = new DateTime.fromMillisecondsSinceEpoch(prevTimestamp);
			var prevYmd = DateFormat('y-MM-dd').format(prevDate);

			if(ymd != prevYmd){
				return Container(
					child: Column(
						children: <Widget>[
							_messageDate(formattedDate),
							(type == CHAT_TYPE_TEXT)
								? (senderId == _selfPlayerId) ? _messageRight(message, formattedTime) : _messageLeft(message, formattedTime)
								: _messagePoke((senderId == _selfPlayerId)),
						],
					),
				);
			}
		}else{
			return Container(

				child: Column(
					children: <Widget>[
						_messageDate(formattedDate),
						(type == CHAT_TYPE_TEXT)
								? (senderId == _selfPlayerId) ? _messageRight(message, formattedTime) : _messageLeft(message, formattedTime)
								: _messagePoke((senderId == _selfPlayerId))
					],
				),
			);
		}

		if(type == CHAT_TYPE_TEXT){
			if(senderId == _selfPlayerId)
				return _messageRight(message, formattedTime);
			else
				return _messageLeft(message, formattedTime);

		}else if(type == CHAT_TYPE_POKE){
			return Container(
				child: Column(
					children: <Widget>[
						_messagePoke((senderId == _selfPlayerId))
					],
				),
			);
		}


	}

	Widget _messageLeft(String message, String time){

		return Align(
			alignment: Alignment.centerLeft,
			child: ChatBubble(
				message: message,
				isMe: false,
				time: time,
				delivered: true,
			),
		);
	}

	Widget _messageRight(String message, String time){
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

	Widget _messageDate(String date){

		return Container(
			padding: EdgeInsets.all(10),
			margin: EdgeInsets.only(bottom: 10, top: 16),
			decoration: BoxDecoration(
					color: Color(0xFF0A1013),
					borderRadius: BorderRadius.all(Radius.circular(99))
			),
			child: Text(
				date,
				style: TextStyle(
						color: textGrey
				),
			),
		);

	}

	Widget _messagePoke(bool isSelf){

		var message = (isSelf) ? "Kamu telah mencolek $otherPlayerName" : "Kamu telah dicolek oleh $otherPlayerName";

		return Container(
			padding: EdgeInsets.all(10),
			margin: EdgeInsets.only(bottom: 10, top: 16),
			decoration: BoxDecoration(
				border: Border.all(color: Colors.white, width: 0.7),
				color: (isSelf) ? Color(0xff1ac5bf) : Color(0xFF151A1E),
				borderRadius: BorderRadius.all(Radius.circular(99)),
			),
			child: Text(
				message,
				style: TextStyle(
						color: Colors.white
				),
			),
		);

	}

	Future<Null> _onTextMsgSubmitted(String message) async {

		analytics.logEvent(name: 'kirim_pesan');

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
			_otherPlayerUnreadChat++;
		});

//		var _timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
		var _timestamp = ServerValue.timestamp;

		databaseUtil.getPersonalChatDetail(chatRoomId).push().set({
			'avatar': _selfAvatar,
			'badge_url': '',
			'date': _timestamp,
			'id': _selfPlayerId,
			'is_subscribe': 0,
			'name': _selfUsername,
			'text': message,
			'type': 1,
			'poke_back': false,
			'platform': Platform.operatingSystem,
			'url': '',
			'file_name': '',
		});

		var otherPlayerInfo = HashMap();
		otherPlayerInfo['avatar_url'] = otherPlayerAvatarUrl;
		otherPlayerInfo['avatar_url_sm'] = otherPlayerAvatarUrl;
		otherPlayerInfo['name'] = otherPlayerName;
		otherPlayerInfo['username'] = otherPlayerName;
		otherPlayerInfo['id'] = otherPlayerId;

		var selfPlayerInfo = HashMap();
		selfPlayerInfo['avatar_url'] = _selfAvatar;
		selfPlayerInfo['avatar_url_sm'] = _selfAvatar;
		selfPlayerInfo['name'] = _selfUsername;
		selfPlayerInfo['username'] = _selfUsername;
		selfPlayerInfo['id'] = _selfPlayerId;

		// update other history
		databaseUtil.getPersonalChatHistoryDetail(otherPlayerId, chatRoomId).update({
			'last_message': message,
			'unread_message': _otherPlayerUnreadChat,
			'last_seen': 0,
			'read_message': false,
			'room_id': chatRoomId,
			'sender_player': selfPlayerInfo,
			'updated_at': _timestamp,
		});

		// update self history
		databaseUtil.getPersonalChatHistoryDetail(_selfPlayerId.toString(), chatRoomId).update({
			'last_message': message,
			'last_seen': 0,
			'unread_message': 0,
			'read_message': false,
			'room_id': chatRoomId,
			'sender_player': otherPlayerInfo,
			'updated_at': _timestamp,
		});

		Timer(Duration(milliseconds: 200), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));

		ApiNotification.sendNotification(_selfToken, _selfPlayerId.toString(), otherPlayerId, _selfUsername, message, "CHAT");

		ApiChatting.sendMetrics(_selfToken, _selfPlayerId.toString(), otherPlayerId);

	}

	_moveChatItemToStorage(){
		databaseUtil.getStoragePersonalDetail(otherPlayerId, chatRoomId).set(pureData);
		databaseUtil.getStoragePersonalDetail(_selfPlayerId.toString(), chatRoomId).remove();
		databaseUtil.getPersonalChatDetail(chatRoomId).remove();
	}

	_sendPoke(){
		setState(() {
			_isPokeActive = false;
		});

		var roomId = (int.parse(selfId) < int.parse(otherPlayerId)) ? "$selfId-$otherPlayerId" : "$otherPlayerId-$selfId";
		var _timestamp = ServerValue.timestamp;

		var blockTime = DateTime.now().toUtc().millisecondsSinceEpoch + (MINUTES_OF_BLOCK_POCKING * 60000);
		keyStore.setPokedTime(otherPlayerId, blockTime);

		databaseUtil.getPersonalChatDetail(roomId).push().set({
			'avatar': _selfAvatar,
			'badge_url': '',
			'date': _timestamp,
			'id': _selfPlayerId,
			'is_subscribe': 0,
			'name': _selfUsername,
			'text': 'poked',
			'type': 2, // 1: text, 2: poke
			'poke_back': false,
			'platform': Platform.operatingSystem,
			'url': '',
			'file_name': '',
		});


		var otherPlayerInfo = HashMap();
		otherPlayerInfo['avatar_url'] = otherPlayerAvatarUrl;
		otherPlayerInfo['avatar_url_sm'] = otherPlayerAvatarUrl;
		otherPlayerInfo['name'] = otherPlayerName;
		otherPlayerInfo['username'] = otherPlayerName;
		otherPlayerInfo['id'] = otherPlayerId;

		var selfPlayerInfo = HashMap();
		selfPlayerInfo['avatar_url'] = _selfAvatar;
		selfPlayerInfo['avatar_url_sm'] = _selfAvatar;
		selfPlayerInfo['name'] = _selfUsername;
		selfPlayerInfo['username'] = _selfUsername;
		selfPlayerInfo['id'] = _selfPlayerId;

		// update other history
		databaseUtil.getPersonalChatHistoryDetail(otherPlayerId, roomId).update({
			'last_message': 'Kamu telah dicolek $selfUsername',
			'unread_message': _otherPlayerUnreadChat+1,
			'last_seen': 0,
			'read_message': false,
			'room_id': roomId,
			'sender_player': selfPlayerInfo,
			'updated_at': _timestamp,
		});

		// update self history
		databaseUtil.getPersonalChatHistoryDetail(selfId, roomId).update({
			'last_message': 'Kamu telah mencolek $otherPlayerName',
			'last_seen': 0,
			'unread_message': 0,
			'read_message': false,
			'room_id': roomId,
			'sender_player': otherPlayerInfo,
			'updated_at': _timestamp,
		});

		ApiNotification.sendNotification(selfToken, selfId, otherPlayerId, selfUsername, "Mencolek kamu!", "CHAT");
	}

}
