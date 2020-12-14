import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '../search/seacrh.dart';

import 'package:yamisok/component/styleyami.dart';

import 'package:yamisok/component/globals.dart' as globals;

var size = globals.varMediaQuery;
//  var size = MediaQuery.of(context).size;


final double itemWidth = (size.width - 10) / 4;
final double itemHeight1 = (size.width) / 4;
final double sizetextcomunity = (size.width) / 25;
final double sizetextcomunity2 = (size.width) / 30;

final double itemWidthCustum = (itemWidth * 2) + (itemWidth / 2);
final double itemWidthAchivement =
    ((size.width - 10) / 3) + (itemWidth / 2) - 5;
final double itemHeight = ((size.width - 10) / 4) - 10;
final double itemWidth2 = (size.width / 3) - 10;
final double itemWidthDaily = itemWidth / 2.5;
final double itemWidthComunity = (size.width - 20) / 2;
final double itemWidthComunitytext1 = (size.width - 80) / 2;
final double itemWidthComunitytext2 = (size.width - 200) / 2;
final double itemHeightComunity = (size.width - 100) / 2;

class Tournament extends StatefulWidget {
  @override
  State createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<Tournament> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF22272B),
        appBar: AppBar(
             
            backgroundColor: Color(0XFF22272B),
            // bottom: TabBar(
            //   indicatorColor: Colors.yellowAccent[700],
            //    labelColor: Colors.grey[50],
            //   tabs: [
                
            //     Tab(text: "Feeds",
            //     ),
            //     Tab(text: "Discover",
            //     ),
            //   ],
            // ),
            title: const Text('Tournament'),
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
      body: ListView(
        children: <Widget>[
          Card1(),
          Card2(),
        ],
      ),
    );
  }
}

const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class Card1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      scrollOnExpand: false,
      scrollOnCollapse: true,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
             decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF34424e),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(
                        10.0) //         <--- border radius here
                    ),
                gradient: LinearGradient(
                  colors: [fristColor, secondColor],
                  begin: Alignment(-1.0, -2.0),
                  end: Alignment(1.0, 2.0),
                ),
              ),
                          
            child: Column(
              children: <Widget>[
                SizedBox(
                    height: 150,
                    child: Stack(children: [
                     // CarouselSlider(
                      //   items: child,
                      //   autoPlay: true,
                      //   aspectRatio: 2.0,
                      //   onPageChangedCallback: (index) {
                      //     setState(() {
                      //       _current = index;
                      //     });
                      //   },
                      // ),
                      // Positioned(
                      //   top: 0.0,
                      //   left: 0.0,
                      //   right: 0.0,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: map<Widget>(imgList, (index, url) {
                      //       return Container(
                      //         width: 8.0,
                      //         height: 8.0,
                      //         margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      //         decoration: BoxDecoration(
                      //           shape: BoxShape.circle,
                      //           color: _current == index ? Color.fromRGBO(0, 0, 0, 0.9) : Color.fromRGBO(0, 0, 0, 0.4)
                      //         ),
                      //       );
                      //     }),
                      //   )
                      // )
                    ])),
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    tapHeaderToExpand: true,
                    tapBodyToCollapse: true,
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        // child: Text(
                        //   "ExpandablePanel",
                        //    style: TextStyle(
                        //             fontSize: sizetextcomunity2,
                        //             color: Color(0xFF95989a),
                        //             fontWeight: FontWeight.bold),
                          
                        // )
                      ),
                    // collapsed: Text(
                    //   "Series",
                    //   softWrap: true,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (var i in Iterable.generate(5))
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                loremIpsum,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    fontSize: sizetextcomunity2,
                                    color: Color(0xFF95989a),
                                    fontWeight: FontWeight.bold),
                              )),
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          crossFadePoint: 0,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ),
    ));
  }
}

class Card2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    buildImg(Color color, double height) {
      return SizedBox(
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
            ),
          ));
    }

    buildCollapsed1() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Expandable",
                    style: Theme.of(context).textTheme.body1,
                  ),
                ],
              ),
            ),
          ]);
    }

    buildCollapsed2() {
      return buildImg(Colors.lightGreenAccent, 150);
    }

    buildCollapsed3() {
      return Container();
    }

    buildExpanded1() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Expandable",
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Text(
                    "3 Expandable widgets",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ]);
    }

    buildExpanded2() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: buildImg(Colors.lightGreenAccent, 100)),
              Expanded(child: buildImg(Colors.orange, 100)),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: buildImg(Colors.lightBlue, 100)),
              Expanded(child: buildImg(Colors.cyan, 100)),
            ],
          ),
        ],
      );
    }

    buildExpanded3() {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              loremIpsum,
              softWrap: true,
            ),
          ],
        ),
      );
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ScrollOnExpand(
        child: Container(
             decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF34424e),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(
                        10.0) //         <--- border radius here
                    ),
                gradient: LinearGradient(
                  colors: [fristColor, secondColor],
                  begin: Alignment(-1.0, -2.0),
                  end: Alignment(1.0, 2.0),
                ),
              ), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expandable(
                  collapsed: buildCollapsed1(),
                  expanded: buildExpanded1(),
                ),
                Expandable(
                  collapsed: buildCollapsed2(),
                  expanded: buildExpanded2(),
                ),
                Expandable(
                  collapsed: buildCollapsed3(),
                  expanded: buildExpanded3(),
                ),
                Divider(
                  height: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Builder(
                      builder: (context) {
                        var controller = ExpandableController.of(context);
                        return Center(
                          child: FlatButton(
                            color: Colors.amber,
                            // child: Container(
                            //     controller.expanded ? "Less" : "More",

                            //   ),
                            child: Text(
                              controller.expanded ? "Less" : "More",
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: Colors.deepPurple),
                            ),

                            onPressed: () {
                              controller.toggle();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          
        ),
      ),
    ));
  }
}
