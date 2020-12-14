import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yamisok/page/helper/check_connection.dart';
import 'package:yamisok/page/utilities/color.dart';
import '../utilities/style.dart';

class NoConnection extends StatefulWidget {
  static String tag = 'search-friend';

  @override
  State<StatefulWidget> createState() {
    return _NoConnectionState();
  }
}

class _NoConnectionState extends State<NoConnection> {
  void getinfoconnections() {
     checkConnection().then((statusInternet) {
      Timer _timer;
      _timer = new Timer(const Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() {
           getinfoconnections();
          });
        }
      });

      if(statusInternet==true){
        if (mounted) {
          setState(() {
           Navigator.pop(context);
          });
        }
        
      }
      return print('lihat data connections $statusInternet');

      

    });
   }

  
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
     getinfoconnections();
    super.initState();


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
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //     title: Text("Cari Teman"),
        //     backgroundColor: backgroundPrimary,
        //     leading: IconButton(
        //       icon: Icon(Icons.chevron_left, color: Colors.white),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //     )),
        body: parent());
  }

  Widget parent() {
    var mediaquery = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      width: mediaquery.width,
      height: mediaquery.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: mediaquery.height / 6,
            ),
            logoImage(),
            Text('Koneksi terputus.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: mediaquery.width / textSize18sp,
                    fontFamily: 'ProximaBold')),
            SizedBox(
              height: 10.0,
            ),
            Text('Pastikan anda terhubung dengan jaringan',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: mediaquery.width / textSize14sp,
                    fontFamily: 'ProximaRegular')),
            Text('internet. Silahkan coba sambung kembali',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: mediaquery.width / textSize14sp,
                    fontFamily: 'ProximaRegular')),
            SizedBox(
              height: mediaquery.height / 6,
            ),
            buttonReconnect()
          ],
        ),
      ),
    );
  }

  Widget logoImage() {
    var size = MediaQuery.of(context).size;

    final double itemWidthpadding = (size.width) / 4;
    final double itemWidthpadding2 = itemWidthpadding / 4;
    final double itemWidth = (size.width) / 1.5;
    return Column(
      children: <Widget>[
        SizedBox(
          height: itemWidthpadding2,
        ),
        Container(
            width: size.width,
            child: new Image.asset("assets/images/noConnection.png")),
        SizedBox(
          height: itemWidthpadding2,
        )
      ],
    );
  }

  Widget buttonReconnect() {
    var mediaquery = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      width: mediaquery.width / 1.5,
      height: mediaquery.width / buttonHeight1,
      child: ButtonTheme(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
        ),
        buttonColor: backgroundYellow,
        minWidth: double.infinity,
        height: mediaquery.width / buttonHeight1,
        child: RaisedButton(
          onPressed: () {
            
          },
          child: new Text('Sambung Kembali',
              style: new TextStyle(
                  fontSize: mediaquery.width / textSize17sp,
                  color: Colors.black,
                  fontFamily: 'ProximaBold')),
        ),
      ),
    );
  }
}
