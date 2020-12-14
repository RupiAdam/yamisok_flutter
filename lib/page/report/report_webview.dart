import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


FirebaseAnalytics analytics = FirebaseAnalytics();

class Todo {
  final String title;
  final String description;

  Todo(this.title, this.description);
}

class ReportWebview extends StatefulWidget {
  final String parameter;

  ReportWebview({Key key, this.parameter}) : super(key: key);

  @override
  _ReportWebviewState createState() => _ReportWebviewState();
}

class _ReportWebviewState extends State<ReportWebview> {

 @override
  void initState() { 
    super.initState();
    //  apiAchive();
  
            
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    analytics.logEvent(name: 'Report_webview');
   
  }
  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    super.dispose();
  } 
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebviewScaffold(
        url:
            "https://docs.google.com/forms/d/e/1FAIpQLSfs9KJm2auJ5GprtMrm8J4xVm2Z45unOPeuSki_i3bdV_OURA/viewform",
        appBar: AppBar(
          backgroundColor: Color(0xFF141A1D),
          title: const Text('Laporan'),
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
