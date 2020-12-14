import 'dart:async';

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


// class EsportsWebview extends StatelessWidget {
//    final Todo todo;

//   // In the constructor, require a Todo.
//   EsportsWebview({Key key, @required this.todo}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }
class SteamWebview extends StatefulWidget {
   final String parameter;
   final flutterWebviewPlugin = new FlutterWebviewPlugin();
 
  SteamWebview({Key key, this.parameter}) : super(key: key);
  @override
  _SteamWebviewState createState() => _SteamWebviewState();
}

class _SteamWebviewState extends State<SteamWebview> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onProgressChanged;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;


  // final _codeCtrl = TextEditingController(text: 'window.navigator.userAgent');

  // final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _history = [];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    flutterWebViewPlugin.close();

    
    // Add a listener to on destroy WebView, so you can make came actions.
    // _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
    //   if (mounted) {
    //     // Actions like show a info toast.
    //     _scaffoldKey.currentState.showSnackBar(
    //         const SnackBar(content: const Text('Webview Destroyed')));
    //   }
    // });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        var stringdata = url;
          if(stringdata.contains('auth/redirect-steam?steam_id')){
            String string1= stringdata.split("steam_id=").last;
            String string2= string1.split("&nickname=").first;
            String string3= stringdata.split("&nickname=").last;
            String string4= string3.split("&status=").first;
              setState(() {
                 Navigator.pop(context, "succes/$string2#-#$string4");
                // _errorusername=messages;
              });
          }
      
      // print('lihat url change $url');
      // http://ap01.yamisok.com/auth/redirect-steam?steam_id
        // setState(() {
        //   _history.add('onUrlChanged: $url');
        // });
      }
    });

    // _onProgressChanged =
    //     flutterWebViewPlugin.onProgressChanged.listen((double progress) {
    //   if (mounted) {
    //     setState(() {
    //       _history.add('onProgressChanged: $progress');
    //     });
    //   }
    // });

    // _onScrollYChanged =
    //     flutterWebViewPlugin.onScrollYChanged.listen((double y) {
    //   if (mounted) {
    //     setState(() {
    //       _history.add('Scroll in Y Direction: $y');
    //     });
    //   }
    // });

    // _onScrollXChanged =
    //     flutterWebViewPlugin.onScrollXChanged.listen((double x) {
    //   if (mounted) {
    //     setState(() {
    //       _history.add('Scroll in X Direction: $x');
    //     });
    //   }
    // });

    // _onStateChanged =
    //     flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
    //   if (mounted) {
    //     setState(() {
    //       _history.add('onStateChanged: ${state.type} ${state.url}');
    //     });
    //   }
    // });

    // _onHttpError =
    //     flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
    //   if (mounted) {
    //     setState(() {
    //       _history.add('onHttpError: ${error.code} ${error.url}');
    //     });
    //   }
    // });
    analytics.logEvent(name: 'Connect_game_steam_web');
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }
 
  
  @override
  Widget build(BuildContext context) {
   
    print('lihat data url ${widget.parameter} ');
    return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: WebviewScaffold(
              url: widget.parameter,
              appBar: AppBar(
                backgroundColor: Color(0xFF141A1D),
                title: const Text('Steam'),
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
