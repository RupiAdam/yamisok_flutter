import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/page/utilities/style.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:yamisok/app/FirebaseDatabaseUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpcomingCard extends StatelessWidget {
  final String detail;
  final String status;
  final String game;
  final bool multiStatus;
  final String dateTime;
  final String playerId;
  final String tournamentId;
  final String matchId;

  const UpcomingCard({this.game, this.detail, this.status, this.dateTime, this.multiStatus, this.playerId, this.tournamentId, this.matchId});

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;

    String _game = game ?? '';
    String _detail = detail ?? '';
    String _status = status ?? 'INCOMING';
    DateTime parsedDate = DateTime.parse(dateTime+"Z");
    parsedDate = parsedDate.subtract(new Duration(hours: 7));
    FirebaseDatabaseUtil databaseUtil = FirebaseDatabaseUtil();
    databaseUtil.initState();

    Widget _countdown(status,_dateCountdown, playerId, tournamentId, matchId) {
      int estimateTs = _dateCountdown.toLocal().millisecondsSinceEpoch;

      String _displayStatus = '-';

      switch (status) {
        case 'INCOMING':
          _displayStatus = 'Akan datang';
          break;
        case 'FINISH':
          _displayStatus = 'Selesai';
          break;
        case 'LIVE':
          _displayStatus = 'Sedang berlangsung';
          break;
        case 'DELAY':
          _displayStatus = 'Delay';
          break;
        default:
          _displayStatus = 'Tidak ada status';
          break;
      }

      if (status == 'INCOMING') {
        return StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 1), (i) => i),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              DateFormat format = DateFormat("mm:ss");
              int now = DateTime
                  .now()
                  .millisecondsSinceEpoch;
              int techMeeting = _dateCountdown
                  .subtract(new Duration(hours: 1))
                  .millisecondsSinceEpoch;
              int removeMatch = _dateCountdown
                  .add(new Duration(hours: 2))
                  .millisecondsSinceEpoch;

              Duration remaining = Duration(milliseconds: estimateTs - now);

              var dateString = '';
              if (now > techMeeting && now < estimateTs) {
                if (status == 'INCOMING') {
                  _displayStatus = 'Technical Meeting';
                }
                dateString = '${format.format(
                    DateTime.fromMillisecondsSinceEpoch(
                        remaining.inMilliseconds))}';
              } else if (now < estimateTs) {
                dateString = '${remaining.inHours}:${format.format(
                    DateTime.fromMillisecondsSinceEpoch(
                        remaining.inMilliseconds))}';
              } else if (now > removeMatch) {
                databaseUtil.removeUpcomingMatch(
                    playerId, tournamentId, matchId);
                databaseUtil.dispose();
              } else {
                if (status == 'INCOMING') {
                  _displayStatus = 'Sedang berlangsung';
                }
                dateString = '';
              }

              return Row(children: <Widget>[
                Text(_displayStatus + " ",
                    style: TextStyle(
                        fontSize: mediaquery.width / textSize12sp,
                        color: Colors.white,
                        fontFamily: 'ProximaRegular')),
                Text(dateString,
                    style: TextStyle(
                        fontSize: mediaquery.width / textSize14sp,
                        color: Colors.yellow,
                        fontFamily: 'ProximaRegular'))

              ]);
            });
      } else {
        return Row(children: <Widget>[
          Text(_displayStatus + " ",
              style: TextStyle(
                  fontSize: mediaquery.width / textSize12sp,
                  color: Colors.white,
                  fontFamily: 'ProximaRegular'))

        ]);
      }
    }

    // Time Selection
    Widget _timeStatus(status,playerId,tournamentId,matchId) {
      return _countdown(_status,parsedDate,playerId, tournamentId, matchId);
    }



    return Container(
      margin:multiStatus==true ? EdgeInsets.only(right: 15) : EdgeInsets.only(right: 5, left: 0),
      // margin: EdgeInsets.only(right: 15),
      // padding: EdgeInsets.only(left: 15, right: 15),
      // height: mediaquery.width / 6.5,
      width:multiStatus==true ? mediaquery.width - (mediaquery.width / 4) : mediaquery.width,
      decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF465158),
            width: 0.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Color(0xFF38424b)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0)),
                  color: Color(0xFF59626b)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: (mediaquery.width / 4) + 10,
                      child: Text(_game,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: mediaquery.width / textSize12sp,
                              color: Colors.white,
                              fontFamily: 'ProximaRegular')),
                    ),
                    _timeStatus(_status,playerId, tournamentId, matchId)
                  ]),
            ),
            Container(
                padding: EdgeInsets.all(5),
                height: mediaquery.width / 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(10.0),
                      bottomRight: const Radius.circular(10.0)),
                  color: Color(0xFF38424b),
                ),
                child: Text(_detail,
                    style: TextStyle(
                        fontSize: mediaquery.width / textSize14sp,
                        color: Colors.white,
                        fontFamily: 'ProximaBold')))
          ]),
    );
  }
}

class UpcomingVerticalScroll extends StatelessWidget {
  final List list;
  final String playerId;

  const UpcomingVerticalScroll({this.list, this.playerId});

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;

    List _list = list;

      return Align(
          alignment: Alignment.centerLeft,
          child: Container(
              height: mediaquery.width / 4,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  final detail = _list[index]['detail'].toString() ?? '';
                  final event_time =
                      _list[index]['event_time'].toString() ?? '';
                  final game_name = _list[index]['game_name'].toString() ?? '';
                  final status = _list[index]['status'].toString() ?? '';
                  final tournamentId = _list[0]['tournament_id'].toString() ?? '';
                  final matchId = _list[0]['match_id'].toString() ?? '';

                  return Padding(
                    padding: const EdgeInsets.all(0),
                    child: new InkWell(
                      child: Column(
                        children: <Widget>[
                          UpcomingCard(
                            playerId: playerId,
                            multiStatus:true,
                            game: game_name,
                            detail: detail,
                            status: status,
                            dateTime: event_time,
                            tournamentId: tournamentId,
                            matchId: matchId,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )));
  }
}

class UpcomingSigle extends StatelessWidget {
  final List list;
  final String playerId;

  const UpcomingSigle({this.list, this.playerId});
  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;

    List _list = list;
    final detail = _list[0]['detail'].toString() ?? '';
    final event_time = _list[0]['event_time'].toString() ?? '';
    final game_name = _list[0]['game_name'].toString() ?? '';
    final status = _list[0]['status'].toString() ?? '';
    final tournamentId = _list[0]['tournament_id'].toString() ?? '';
    final matchId = _list[0]['match_id'].toString() ?? '';


  return Align(
    alignment: Alignment.centerLeft,
    child: Container(

        height: mediaquery.width / 4,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: new InkWell(
            child: Column(
              children: <Widget>[
                UpcomingCard(
                  playerId: playerId,
                  multiStatus:false,
                  game: game_name,
                  detail: detail,
                  status: status,
                  dateTime: event_time,
                  tournamentId: tournamentId,
                  matchId: matchId,
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}

class UpcomingWidget extends StatelessWidget {
  /// Local State

  /// Additional Widget

  /// Override widget view in the StatelessWidget
  @override
  Widget build(BuildContext context) {
    return UpcomingMatchWidget();
  }
}

class UpcomingMatchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UpcomingMatchState();
  }
}

class _UpcomingMatchState extends State<UpcomingMatchWidget> {
  FirebaseDatabaseUtil databaseUtil;
  int _playerId = 0;
  String _token = '';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    databaseUtil = FirebaseDatabaseUtil();
    databaseUtil.initState();
  }

  @override
  void dispose() {
    super.dispose();
    databaseUtil.dispose();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString("token");
      _playerId = prefs.getInt("id_player");
    });
  }

  @override
  Widget build(BuildContext context) {
    return _streamUpcomingMatch();
  }

  Widget _label(text) {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
                fontSize: mediaquery.width / textSize14sp,
                color: backgroundYellow,
                fontFamily: 'ProximaBold'),
          ),
        ],
      ),
    );
  }

  Widget _streamUpcomingMatch() {
    var mediaquery = MediaQuery.of(context).size;
    var referencePath = databaseUtil.getUpcomingMatch(_playerId.toString());

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: StreamBuilder(
        stream: referencePath.onValue,
        builder: (context, snap) {
          if (snap.hasData &&
              !snap.hasError &&
              snap.data.snapshot.value != null) {
            //taking the data snapshot.
            Map data = snap.data.snapshot.value;

            List item =[];
            //  print("lihat jumlah item : $data");

            // map to list
            data.forEach((index, data) => item.add({"key": index, ...data}));

            try {
              // sort data
              item.sort((a, b) {
                return (b["event_time"] ?? 0).compareTo(a["event_time"] ?? 0);
              });
            } catch (e) {
              print('data is awesome!!! just skip this steps');
            }

            // print("lihat upcoming match item total ${item.length} : " + item.toString());

            return Column(
              children: <Widget>[
                SizedBox(height: mediaquery.width / 20),
                _label('Jadwal tim kamu'),
                item.length==1 ? UpcomingSigle(list: item , playerId: _playerId.toString(),): UpcomingVerticalScroll(list: item, playerId: _playerId.toString(),),
              ],
            );
          } else {
            return Column(
              children: <Widget>[
                SizedBox(height: mediaquery.width / 20),
                _label('Jadwal tim kamu'),
                Container(
                  margin: EdgeInsets.only(right: 5, left: 0),
                  height: mediaquery.width / 6.5,
                  width: mediaquery.width,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF465158),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Color(0xFF38424b)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5),
                          height: mediaquery.width / 8,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(10.0),
                                topRight: const Radius.circular(10.0),
                                bottomLeft: const Radius.circular(10.0),
                                bottomRight: const Radius.circular(10.0)),
                            color: Color(0xFF38424b),
                          ),
                          child: Center(
                            child: Text("Kamu belum memiliki jadwal bertanding",
                              style: TextStyle(
                                fontSize: mediaquery.width / textSize14sp,
                                color: Colors.white,
                                fontFamily: 'ProximaRegular'
                              )
                            )
                          )
                        )
                      ]),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
