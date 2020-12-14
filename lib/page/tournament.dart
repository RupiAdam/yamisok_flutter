


import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '../search/seacrh.dart';

import 'package:yamisok/component/styleyami.dart';

import 'package:yamisok/component/globals.dart' as globals;




class Tournament extends StatefulWidget {
   static String tag = 'tournament-page';  
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
        
        title: const Text('Tournament'),
        

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
              )),
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
              ))
        ],

        // title: Text('Tabs Demo'),
      ),
      body: ListView(
        children: <Widget>[
          Card1(),
          Card2(),
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
    // var size = globals.varMediaQuery;
     var size = MediaQuery.of(context).size;
//turnament


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


    return ExpandableNotifier(
        child: ScrollOnExpand(
      scrollOnExpand: false,
      scrollOnCollapse: true,
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFF34424e),
              width: 1,
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(10.0) //         <--- border radius here
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
     
    ));
  }
}

class Card2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var size = globals.varMediaQuery;
     var size = MediaQuery.of(context).size;
    //text size
    final double textSize1 = (size.width) / 25; //25sp sample title tournament list 
    final double textSize2 = (size.width) / 38; //25sp sample list tournament on going 
    final double textSize3 = (size.width) / 40; //25sp sample list tournament on going 

    //icon size
    final double itemWidthImgIconAny = (size.width) / 22; //25sp sample title tournament list

    final double itemWidthBotom = (size.width) - 22;
    final double itemHeightBotom = (size.width) / 15;
    final double itemWidthimgList = (size.width) / 12;
    final double itemheightTitle = (size.width) / 10;
     final double itemHeightStatus= (size.width) / 23; //ongoing etc
    
    final double itemWidthtitle = (itemWidthBotom - itemWidthimgList)-25;
    final double itemHeighttitle = (itemWidthBotom - itemWidthimgList)-25;
  
  
  print('lihat status $itemHeightStatus');
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

      print("lihat height titke $itemHeighttitle");
      final seriesspace="        ";
      final subcriptionspace="     ";
      final tournamenttitle="Dota 2 International Tournament Season 2 March 2019 - Compendium";
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.black87,
                    width: itemWidthimgList,
                    height: itemWidthimgList,
                    child: new Image.network(
                      "http://res.cloudinary.com/yamisok/image/upload/h_25,f_auto/v1517223506/game/nzqd3mwrtezrokonqtck.jpg",
                      // fit: BoxFit.cover
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
               
                Container(
                  height: itemheightTitle,
                  

                  width: itemWidthtitle,
                  child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: itemWidthImgIconAny,
                              child: new Image.network(
                                "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/29f0ee5b-d73d-4fe0-94cb-c4658dc8d140.png",
                                // fit: BoxFit.cover
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              height: itemWidthImgIconAny,
                              child: new Image.network(
                                "https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/29f0ee5b-d73d-4fe0-94cb-c4658dc8d140.png",
                                // fit: BoxFit.cover
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        Text(" $subcriptionspace $seriesspace $tournamenttitle",
                            softWrap: true,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: textSize1, 
                            color: textColor1,
                            fontFamily: 'ProximaReguler'),
                          ),
                        
                      ]
                  ),
                ),
                  
                 
                // Text(
                //   "Dota 2 International Tournament",
                //   style: TextStyle(fontSize: textSize1, color: textColor1),
                // )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                   child: Column(
                      children: <Widget>[
                      Container(
                        
                         decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(
                            color: Color(0xFF34424e),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(5.0) //         <--- border radius here
                              ),
                          // gradient: LinearGradient(
                          //   colors: [fristColor, secondColor],
                          //   begin: Alignment(-1.0, -2.0),
                          //   end: Alignment(1.0, 2.0),
                          // ),
                        ),
                        height: itemHeightStatus,
                         child: Container(
                           margin: const EdgeInsets.only(left: 5.0, top:2.0, bottom: 2.0, right: 5.0),
                           child: Text("Ongoing",
                                style: TextStyle( 
                                  color: Colors.white,
                                   fontFamily: 'ProximaBold',
                             fontSize: textSize3,
                              ),
                            ),
                         ),
                       
                      ),
                      Text("23:44:43",
                          style: TextStyle(
                            color: Colors.white,
                             fontFamily: 'ProximaBold',
                              fontSize: textSize2,
                          ),)

                      ]
                    ),
                  ),
                  Container(
                   
                    child: Column(
                      children: <Widget>[
                      Container(
                         
                        child: Text("SLOT",
                          style: TextStyle(
                            color: Color(0xFF707070),
                              fontFamily: 'ProximaBold',
                              fontSize: textSize2,
                              
                          ),
                        ),
                      ),
                      Text("25/50",
                           style: TextStyle(
                            color: textColor2,
                              fontFamily: 'ProximaBold',
                              fontSize: textSize2
                          ),
                          )

                      ]
                    ),
                  ),
                  Container(
                   
                    child: Column(
                      children: <Widget>[
                      Container(
                        
                        child: Text("ENTRANCE FEE",
                          style: TextStyle(
                            color: Color(0xFF707070),
                              fontFamily: 'ProximaBold',
                              fontSize: textSize2
                          ),
                        ),
                      ),
                      Text("23:44:43",
                           style: TextStyle(
                            color: textColor2,
                              fontFamily: 'ProximaBold',
                              fontSize: textSize2
                          ),)

                      ]
                    ),
                  ),
                  Container(
                   
                    child: Column(
                      children: <Widget>[
                      Container(
                         child: Text("PRIZE",
                          style: TextStyle(
                            color: Color(0xFF707070),
                              fontFamily: 'ProximaBold',
                              fontSize: textSize2
                          ),
                        ),
                      
                      ),
                      Text("IDR 10.000.000",
                           style: TextStyle(
                            color: textColor2,
                              fontFamily: 'ProximaBold',
                              fontSize: textSize2
                          ),)

                      ]
                    ),
                  )
                ],
              ),
            )

          ],
        ),
      );
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
              // Expanded(child: buildImg(Colors.lightGreenAccent, 100)),
              // Expanded(child: buildImg(Colors.orange, 100)),
            ],
          ),
          Row(
            children: <Widget>[
              // Expanded(child: buildImg(Colors.lightBlue, 100)),
              // Expanded(child: buildImg(Colors.cyan, 100)),
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
      
      child: ScrollOnExpand(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFF34424e),
                width: 1,
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(10.0) //         <--- border radius here
                  ),
              gradient: LinearGradient(
                colors: [fristColor, secondColor],
                begin: Alignment(-1.0, -2.0),
                end: Alignment(1.0, 2.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Expandable(
                //   collapsed: buildCollapsed1(),
                //   expanded: buildExpanded1(),
                // ),
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
                  Container(
                            // width: itemWidthBotom,
                            width: 900.0,
                           
                            height: itemHeightBotom,
                            decoration: BoxDecoration(
                              color: Color(0xFF303c47),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: const Radius.circular(10.0),
                                  bottomRight: const Radius.circular(10.0)),
                            ),
                      child: Builder(
                        builder: (context) {
                          var controller = ExpandableController.of(context);
                          return GestureDetector(
                            onTap: () {
                              controller.toggle();
                            },
                            child: Container(
                              width: 900.0,
                           
                            height: itemHeightBotom,
                            decoration: BoxDecoration(
                              color: Color(0xFF303c47),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: const Radius.circular(10.0),
                                  bottomRight: const Radius.circular(10.0)),
                            ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Center(
                                  child: Text(
                                    controller.expanded ? "Less" : "See More",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                 
              ],
            ),
          ),
        ),
      ),
    );
  }
}
