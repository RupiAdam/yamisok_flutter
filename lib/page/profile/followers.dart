import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yamisok/api/profile/profile_follow.dart';
import 'package:yamisok/page/chatting/chatting_detail_personal.dart';
import 'package:yamisok/page/profile/profile_others.dart';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/component/styleyami.dart' as yamiStyle;
import 'package:yamisok/page/redux/action.dart' as AppAction;
import 'package:yamisok/page/utilities/style.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();


class ProfileFollowersPage extends StatefulWidget{

  static String tag = 'profile-followers-page';

  int otherPlayerId = 0;

  // constructor for self
  ProfileFollowersPage();

  // constructor for other
  ProfileFollowersPage.otherPlayer({this.otherPlayerId});

  @override
  State<StatefulWidget> createState() {
    return _ProfileFollowersPageState();
  }

}

class _ProfileFollowersPageState extends State<ProfileFollowersPage>{

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
    store.dispatch(AppAction.GetFollowersAction(selfId: _playerId.toString(), otherId: (widget.otherPlayerId == 0) ? _playerId.toString() : widget.otherPlayerId.toString(), token: _token));
  }


  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _scrollController.addListener(() {

      var store = StoreProvider.of<AppState>(context);

      if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
        print('reach the bottom $_page');

        if(_isOnSearching){
          if (store.state.has_more_followers) {
            _page++;
            ApiServiceProfileFollow.loadMoreSearchFollowers(context, (widget.otherPlayerId == 0) ? _playerId.toString() : widget.otherPlayerId.toString(), _playerId.toString(), _token, _page, _inputController.text);
          }
        }else{
          if (store.state.has_more_followers) {
            _page++;
            store.dispatch(AppAction.LoadMoreFollowersItemAction(token: _token, selfId: _playerId.toString(), otherId: (widget.otherPlayerId == 0) ? _playerId.toString() : widget.otherPlayerId.toString(), page: _page));
          }
        }
      }

      if (_scrollController.offset <= _scrollController.position.minScrollExtent && !_scrollController.position.outOfRange) {
        // reach the top
      }

    });
    analytics.logEvent(name: 'Followers');
    super.initState();
  }


  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    var store = StoreProvider.of<AppState>(context);
    store.state.list_followers.clear();
    store.state.has_more_followers= true;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
              title: Text("Followers"),
              backgroundColor: backgroundPrimary,
              leading: IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.white),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
      ),
      body: _parent(),
    );
  }

  var _shimmerFollowing = Padding(
    padding: EdgeInsets.all(16),
    child: Shimmer.fromColors(
            baseColor: yamiStyle.colorShimer,
            highlightColor: yamiStyle.colorlightShimer,
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

  Widget _parent(){
    return Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: backgroundPrimary,
            child: Column(
              children: <Widget>[
                _searchBar(),
                _groupFollowing()
              ],
            )
    );
  }

  Widget _groupFollowing(){
    return Container(
      child: StoreConnector<AppState, ViewModel>(
        builder: (BuildContext context, ViewModel vm){
          var data = vm.state.list_followers;
          if(data.length > 0)
            return _listFollowing(data);
          else
            return _shimmerFollowing;
        },
        converter: (store){
          return ViewModel(
                  state: store.state,
                  getFollowers: (int id, String token) =>
                          store.dispatch(AppAction.GetFollowersAction(selfId: _playerId.toString(), otherId: (widget.otherPlayerId == 0) ? _playerId.toString() : widget.otherPlayerId.toString(), token: _token))
          );
        }, onInit: (store){
        getSharedPrefs(store);
      },
      ),
    );
  }

  Widget _listFollowing(List<dynamic> data){
    return
      Expanded(
              child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index){
                        var imageUrl = data[index]['avatar_url'];
                        var username = data[index]['username'];
                        var id = data[index]['id'].toString();
                        var hasFollowed = data[index]['hasFollowed'];

                        return Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    _playerAvatar(id, username, imageUrl),
                                    SizedBox(width: 16),
                                    _playerName(id, username, imageUrl)
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    _buttonChat(id, username, imageUrl),
                                    hasFollowed ? _buttonFollowing() : _buttonFollow(index, data[index]['id'].toString())
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }
              )
      );
  }

  Widget _playerAvatar(String id, String name, String imagesUrl){
    var idhero = 'following$id';
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileOthers(id: id, username: name, images: imagesUrl, idhero:idhero)),
        );
      },
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                                imagesUrl ?? 'https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/2e830410-63fc-4dfc-9443-3fdec18570c0.png'
                        )
                )
        ),
      ),
    );
  }

  Widget _playerName(String id, String name, String imagesUrl){
    var idhero = 'following$id';
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileOthers(id: id, username: name, images: imagesUrl, idhero:idhero)),
        );
      },
      child: Container(
        child: Text(
          name,
          style: TextStyle(
                  fontSize: 14,
                  color: Colors.white
          ),
        ),
      ),
    );
  }

  Widget _buttonChat(String id, String name, String imagesUrl){
    return GestureDetector(
      onTap: (){
        var roomId = (_playerId < int.parse(id)) ? "$_playerId-${int.parse(id)}" : "${int.parse(id)}-$_playerId";
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatDetailPersonalPage(
            selfId: _playerId.toString(),
            otherId: id,
            playerName: name,
            avatarUrl: imagesUrl,
            chatRoomId: roomId,
          )),
        );
      },
      child: Center(
        child: Container(
                height: 30,
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(const Radius.circular(5)),
                        color: badgeBackgroundColor
                ),
                child: Icon(
                  Icons.chat_bubble,
                  color: Colors.white,
                  size: 14,
                )
        ),
      ),
    );
  }

  Widget _buttonFollowing(){
    return Container(
      height: 30,
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: badgeBackgroundColor
      ),
      child: Text('following',
        style: TextStyle(color: Colors.white, fontFamily: 'ProximaBold'),
      ),
    );
  }

  Widget _buttonFollow(int position, String followId){
    return GestureDetector(
      onTap: (){_followPlayer(position, followId);},
      child: Container(
        height: 30,
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: accent
        ),
        child: Center(
          child: Text('follow',
            style: TextStyle(color: Colors.black, fontFamily: 'ProximaBold'),
          ),
        ),
      ),
    );
  }

  Widget _searchBar(){
    var mediaquery = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 2),
      decoration: BoxDecoration(
              color: inputBackground,
              borderRadius: BorderRadius.all(const Radius.circular(8.0))
      ),
      child: TextField(
        controller: _inputController,
        onChanged: (text){
          _inputListener(text);
        },
        style: TextStyle(
                color: textColor2,
                fontSize: mediaquery.width/textSize14sp,
                fontFamily: 'ProximaReguler'
        ),
        decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: inputHintColor,
                ),
                hintText: 'Cari orang yang kamu ikuti',
                suffixIcon: GestureDetector(
                  onTap: (){},
                  child: Icon(
                    Icons.search,
                    size: mediaquery.width/20,
                    color: inputHintColor,
                  ),
                )
        ),
      ),
    );
  }

  _inputListener(text){
    var store = StoreProvider.of<AppState>(context);
    if(text == ''){
      setState(() {
        _page = 0;
        _isOnSearching = false;
      });
      store.dispatch(AppAction.GetFollowersAction(selfId: _playerId.toString(), otherId: (widget.otherPlayerId == 0) ? _playerId.toString() : widget.otherPlayerId.toString(), token: _token));
    }else{
      setState(() {
        _page = 0;
        _isOnSearching = true;
      });
      ApiServiceProfileFollow.initSearchFollowers(context, (widget.otherPlayerId == 0) ? _playerId.toString() : widget.otherPlayerId.toString(), _playerId.toString(), _token, text);
    }
  }

  _followPlayer(int position, String followId){
    ApiServiceProfileFollow.followUser(context, (widget.otherPlayerId == 0) ? _playerId : widget.otherPlayerId, _token, position, followId);
  }

}
