import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:yamisok/api/term_and_condition/term_and_condition_api.dart';
import 'package:yamisok/page/login/register.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/page/utilities/style.dart';

class TermAndConditionSettingPage extends StatefulWidget {
  static String tag = 'term-and-condition-setting-page';

  @override
  _TermAndConditionSettingState createState() =>
      _TermAndConditionSettingState();
}

class _TermAndConditionSettingState extends State<TermAndConditionSettingPage> {
  String _toc = "";
  bool ableToClick = false;
  bool _loading = true;
  bool _isChecked = true;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _getTermCondition();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: backgroundPrimary,
        appBar: AppBar(
          backgroundColor: Color(0xFF141A1D),
          title: const Text('Syarat dan Ketentuan'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: _parent(),
      ),
    );
  }

  Widget _parent() {
    return Container(
      color: backgroundPrimary,
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[_loadingIndicator(), _text()],
      )),
    );
  }

  Widget _text() {
    var mediaquery = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Html(
        data: _toc,

        //Optional parameters:
        padding: EdgeInsets.all(8.0),
        linkStyle: TextStyle(
            color: backgroundBlackDefault,
            fontSize: mediaquery.width / textSize14sp,
            fontFamily: 'ProximaRegular'),
        onLinkTap: (url) {
          print("Opening $url...");
        },
        onImageTap: (src) {
          print(src);
        },
        customTextStyle: (dom.Node node, TextStyle baseStyle) {
          if (node is dom.Element) {
            switch (node.localName) {
              case "p":
                return baseStyle.merge(TextStyle(
                    // height: 1,
                    // fontSize: mediaquery.width / textSize14sp,
                    color: textGrey));
              case "ol":
                return baseStyle.merge(TextStyle(
                    // height: 2,
                    // fontSize: mediaquery.width / textSize14sp,
                    color: textGrey));
            }
          }
          return baseStyle;
        },
        //Must have useRichText set to false for this to work
      ),
      // Text(
      //   ,
      //   style: TextStyle(
      //     fontSize: 15,
      //     color: textGrey
      //   ),
      // ),
    );
  }

  Widget _loadingIndicator() {
    return Visibility(
      child: Container(
        height: 3,
        child: LinearProgressIndicator(
          backgroundColor: backgroundPrimary,
        ),
      ),
      visible: _loading,
    );
  }

  _getTermCondition() {
    setState(() {
      ableToClick = false;
      _loading = true;
    });

    ApiServiceTermCondition.getTermCondition().then((result) async {
      var data = json.decode(result);
      var status = data['status'];

      setState(() {
        _loading = false;
      });

      if (status == 200) {
        var toc = data['description'];
        setState(() {
          _toc = toc;
          ableToClick = true;
        });
      }
    });
  }
}
