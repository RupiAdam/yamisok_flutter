import 'package:flutter/material.dart';
import 'feeds.dart';
import 'discover.dart';
import '../../search/seacrh.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          
           appBar: AppBar(
             
            backgroundColor: Color(0XFF22272B),
            bottom: TabBar(
              indicatorColor: Colors.yellowAccent[700],
               labelColor: Colors.grey[50],
              tabs: [
                
                Tab(text: "Feeds",
                ),
                Tab(text: "Discover",
                ),
              ],
            ),
            title: const Text('Home'),
            // leading: new Container(
            //   color: Colors.amber,
            //   width: 300.0,
            //   child: Padding(
            //   padding: const EdgeInsets.only(left: 10.0),
            //   child: new Text("Home", style: new TextStyle(fontSize: 20.0),),
            // )),
            
            actions: <Widget>[
              GestureDetector(
                // When the child is tapped, show a snackbar.
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchRedux()),
                  );
                  // final snackBar = SnackBar(content: Text("Tap"));

                  // Scaffold.of(context).showSnackBar(snackBar);
                },
                // The custom button
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: new Icon(Icons.search),
                )
              ),
               GestureDetector(
                // When the child is tapped, show a snackbar.
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchRedux()),
                  );
                  // final snackBar = SnackBar(content: Text("Tap"));

                  // Scaffold.of(context).showSnackBar(snackBar);
                },
                // The custom button
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: new Icon(Icons.notifications_active),
                )
              )
              ],
         
            // title: Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              Feeds(),
              Discover(),
              // Discover(),
            ],
          ),
        ),
      ),
    );
  }


  // Widget build(BuildContext context){
  //   return new Container(
  //     child: new Center(
  //       child: new Column(
  //         children: <Widget>[
            
  //           new Padding(padding: new EdgeInsets.all(20.0),),
  //           new Text("feeds On Progres", style: new TextStyle(fontSize: 30.0),),
  //           new Padding(padding: new EdgeInsets.all(20.0),),
  //           new Text(
  //                     'y',
  //                   style: TextStyle(fontFamily: 'YamiFont', fontSize: 90.0,),),
  //         ],
  //       ),
  //     ), 
  //   );
  // }
}

