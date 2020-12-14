import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yamisok/page/utilities/color.dart';
import '../utilities/style.dart';

class ServerError extends StatefulWidget {
  static String tag = 'search-friend';

  @override
  State<StatefulWidget> createState() {
    return _ServerErrorState();
  }
}

class _ServerErrorState extends State<ServerError> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
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
            Text('Sedang terjadi gangguan',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: mediaquery.width / textSize18sp,
                    fontFamily: 'ProximaBold')),
            Text('pada sistem internal',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: mediaquery.width / textSize18sp,
                    fontFamily: 'ProximaBold')),
            SizedBox(
              height: 10.0,
            ),
            Text('Coba sambung kembali dalam beberapa',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: mediaquery.width / textSize14sp,
                    fontFamily: 'ProximaRegular')),
            Text('saat untuk dapat melanjutkan.',
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
            width: size.width / 2,
            child: new Image.asset("assets/images/serverError.png")),
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
          onPressed: () {},
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
