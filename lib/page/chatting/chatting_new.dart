import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yamisok/api/profile/profile_follow.dart';
import 'package:yamisok/page/chatting/chatting_detail_personal.dart';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/page/redux/action.dart' as AppAction;

class ChatNewPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
        return _ChatNewPageState();
    }
}

class _ChatNewPageState extends State<ChatNewPage> {
    TextEditingController _inputController = TextEditingController();
    ScrollController _scrollController = ScrollController();
    String _token;
    int _playerId;

    bool _isOnSearching = false;
    int _page = 0;

    Future<Null> getSharedPrefs(store) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
            _token = prefs.getString("token");
            _playerId = prefs.getInt("id_player");
        });
        ApiServiceProfileFollow.getFollowingFollowers(context, _playerId, _token);
    }

    @override
    void initState() {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        super.initState();

        

        _scrollController.addListener(() {
            var store = StoreProvider.of<AppState>(context);

            if (_scrollController.offset >=
                            _scrollController.position.maxScrollExtent &&
                            !_scrollController.position.outOfRange) {
                print('reach the bottom $_page');

                if (_isOnSearching) {
                    if (store.state.has_more_following_followers) {
                        _page++;
                        ApiServiceProfileFollow.loadMoreSearchFollowingFollowers(
                                        context, _playerId, _token, _page, _inputController.text);
                    }
                } else {
                    if (store.state.has_more_following_followers) {
                        _page++;
                        ApiServiceProfileFollow.loadMoreFollowingFollowers(
                                        context, _playerId, _token, _page);
                    }
                }
            }

            if (_scrollController.offset <=
                            _scrollController.position.minScrollExtent &&
                            !_scrollController.position.outOfRange) {
                // reach the top
            }
        });
    }

    @override
    void dispose() {
        _scrollController.dispose();
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                centerTitle: true,
                title: (!_isOnSearching) ? Text("Obrolan Baru") : _searchMode(),
                backgroundColor: backgroundPrimary,
                actions: <Widget>[
                    (!_isOnSearching)
                                    ? IconButton(
                        icon: Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                            setState(() {
                                _isOnSearching = true;
                            });
                        },
                    )
                                    : SizedBox(),
                    (_isOnSearching)
                                    ? IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                            setState(() {
                                _isOnSearching = false;
                            });
                        },
                    )
                                    : SizedBox(),
                ],
            ),
            body: _parent(),
        );
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
                                SizedBox(
                                    height: 10,
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 60,
                                    color: backgroundPrimary,
                                ),
                                SizedBox(
                                    height: 10,
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 60,
                                    color: backgroundPrimary,
                                ),
                                SizedBox(
                                    height: 10,
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 60,
                                    color: backgroundPrimary,
                                ),
                            ],
                        )),
    );

    Widget _parent() {
        return Container(
                        height: double.infinity,
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        color: backgroundPrimary,
                        child: Column(
                            children: <Widget>[_groupFollowingFollowers()],
                        ));
    }

    Widget _searchMode() {
        return Container(
            child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Container(
                            child: TextField(
                                onChanged: (value) => _inputListener(value),
                                controller: _inputController,
                                decoration: InputDecoration(
                                    hintText: 'cari username ...',
                                    hintStyle: TextStyle(color: inputHintColor),
                                    border: InputBorder.none,
                                ),
                                style: TextStyle(color: Colors.white),
                            ),
                        ),
                    )
                ],
            ),
        );
    }

    Widget _groupFollowingFollowers() {
        return Container(
            child: StoreConnector<AppState, ViewModel>(
                builder: (BuildContext context, ViewModel vm) {
                    var data = vm.state.list_following_followers;
                    if (data.length > 0)
                        return _listFollowing(data);
                    else
                        return _shimmerFollowing;
                },
                converter: (store) {
                    return ViewModel(state: store.state);
                },
                onInit: (store) {
                    getSharedPrefs(store);
                },
            ),
        );
    }

    Widget _listFollowing(List<dynamic> data) {
        return Expanded(
            child: ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                        var otherPlayerId = data[index]['id'];
                                        var senderName = data[index]['username'];
                                        var avatar = data[index]['avatar_url'];
                                        _openChatDetail(senderName, avatar, otherPlayerId);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                                        margin: EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                                        color: badgeBackgroundColor,
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                        child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                                Container(
                                                    child: Row(
                                                        children: <Widget>[
                                                            _playerAvatar(data[index]['avatar_url']),
                                                            SizedBox(width: 16),
                                                            _playerName(data[index]['username'])
                                                        ],
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                );
                            }),
        );
    }

    Widget _playerAvatar(String avatar) {
        return Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(avatar ??
                                                            'https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/2e830410-63fc-4dfc-9443-3fdec18570c0.png'))),
        );
    }

    Widget _playerName(String name) {
        return Container(
            child: Text(
                name,
                style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontFamily: 'Proxima',
                                fontWeight: FontWeight.w600),
            ),
        );
    }

    _inputListener(text) {
        if (text == '') {
            setState(() {
                _page = 0;
                _isOnSearching = false;
            });
            ApiServiceProfileFollow.getFollowingFollowers(context, _playerId, _token);
        } else {
            setState(() {
                _page = 0;
                _isOnSearching = true;
            });
            ApiServiceProfileFollow.searchFollowingFollowers(
                            context, _playerId, _token, text);
        }
    }

    _openChatDetail(String senderName, String avatar, int otherPLayerId) {
        var roomId = (_playerId < otherPLayerId)
                        ? "$_playerId-$otherPLayerId"
                        : "$otherPLayerId-$_playerId";
        Navigator.push(
            context,
            MaterialPageRoute(
                            builder: (context) => ChatDetailPersonalPage(
                                selfId: _playerId.toString(),
                                otherId: otherPLayerId.toString(),
                                playerName: senderName,
                                avatarUrl: avatar,
                                chatRoomId: roomId,
                            )),
        );
    }
}
