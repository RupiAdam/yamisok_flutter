import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();


class FAQWebview extends StatefulWidget {
  final String parameter;

  FAQWebview({Key key, this.parameter}) : super(key: key);

  @override
  _FAQWebviewState createState() => _FAQWebviewState();
}

class _FAQWebviewState extends State<FAQWebview> {

  @override
	void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    analytics.logEvent(name: 'Faq');
		super.initState();
    

	}
  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  } 

  @override
  Widget build(BuildContext context) {

 

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebviewScaffold(
        url: "https://yamisok.com/info/faq?id=stronggetting-startedstrong",
        appBar: AppBar(
          backgroundColor: Color(0xFF141A1D),
          title: const Text('F.A.Q'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        withZoom: false,
        withLocalStorage: true,
        hidden: true,
        initialChild: Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
