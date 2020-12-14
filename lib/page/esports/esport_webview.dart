import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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

class EsportWebview extends StatefulWidget {
  //  final Todo todo;
  final String parameter;
 
  EsportWebview({Key key, this.parameter}) : super(key: key);
  // In the constructor, require a Todo.
  // EsportWebview({Key key, @required this.todo}) : super(key: key);

  @override
  _EsportWebviewState createState() => _EsportWebviewState();
}

class _EsportWebviewState extends State<EsportWebview> {

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
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
              debugShowCheckedModeBanner: false,
              home: WebviewScaffold(
              url: widget.parameter,
              appBar: AppBar(
                backgroundColor: Color(0xFF141A1D),
                title: const Text('News'),
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