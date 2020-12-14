import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;
import 'package:yamisok/component/globals.dart' as globals;
import 'package:yamisok/component/styleyami.dart';
// import 'package:yamisok/component/gridCommunity.dart';
import 'package:yamisok/api/api_comunity.dart';
import 'package:yamisok/model/comunity_model.dart';
import 'package:yamisok/component/background.dart';

import 'package:shimmer/shimmer.dart';
// import 'package:easy_listview/easy_listview.dart';

class Communityfull extends StatefulWidget {
  final Future<Community> post;

  Communityfull({Key key, this.post}) : super(key: key);
  @override
  _CommunityfullState createState() => _CommunityfullState();
}

class _CommunityfullState extends State<Communityfull> {
   BuildContext context;
  ApiServiceComunity apiService;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
    apiService = ApiServiceComunity();
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
    // var size = globals.varMediaQuery;
     var size = MediaQuery.of(context).size;

            final double itemWidth = (size.width - 10) / 2;
             final double itemHeight1 = (size.width - 80) / 2;
            final double itemWidthCustum = (itemWidth * 2) + (itemWidth / 2);
            final double itemWidthAchivement = ((size.width - 10) / 3) + (itemWidth / 2) - 5;
            final double itemHeight = ((size.width - 10) / 3)-10;
            final double itemWidth2 = (size.width / 3) * 2;
            final double itemWidthDaily = itemWidth / 2.5;
            final double itemWidthComunity = (size.width  - 20) / 2;
            final double itemWidthComunitytext1 = (size.width  - 80) / 2;
            final double itemWidthComunitytext2 = (size.width  - 200) / 2;
            final double itemHeightComunity = (size.width  - 100) / 2;
            
            var shimerdt = Shimmer.fromColors(
                baseColor: Color(0xFFE0E0E0),
                // highlightColor: Colors.grey[300],
                // baseColor: Colors.grey[100],
                highlightColor: Colors.grey[50],
                // direction: ,
                // period: const Duration(microseconds: 1),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: itemWidthComunity,
                                height: itemHeightComunity,
                                child: const DecoratedBox(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE0E0E0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext1,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext2,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: itemWidthComunity,
                                height: itemHeightComunity,
                                child: const DecoratedBox(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE0E0E0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext1,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext2,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                     Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: itemWidthComunity,
                                height: itemHeightComunity,
                                child: const DecoratedBox(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE0E0E0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext1,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext2,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: itemWidthComunity,
                                height: itemHeightComunity,
                                child: const DecoratedBox(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE0E0E0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext1,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext2,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                     Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: itemWidthComunity,
                                height: itemHeightComunity,
                                child: const DecoratedBox(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE0E0E0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext1,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext2,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: itemWidthComunity,
                                height: itemHeightComunity,
                                child: const DecoratedBox(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE0E0E0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext1,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: SizedBox(
                                  width: itemWidthComunitytext2,
                                  height: 15.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE0E0E0)
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                  
               
            );
    // this.context = context;
    return Center(
      child: FutureBuilder<Community>(
        future: apiService.fetchPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // var size = globals.varMediaQuery;
             var size = MediaQuery.of(context).size;
            List<ListCommunity> listCommunity = snapshot.data.result.listCommunity;
            final totallist = listCommunity; 
            
            var listViewdt = new 
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: totallist.length,
              itemBuilder: (context, index) {
                final _title = totallist[index].name;
                final _avatarUrl = totallist[index].avatarUrl;
                final _totalMembers = totallist[index].totalMembers;
                // final avatarUrlnew = _dtMission[index].avatarUrl;
                return Container( 
                  color: Colors.amber,
                  child: Text("looping data"),  
                );
              }
              );

            var griddata = new GridView.builder(
              itemCount: totallist.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                 final _title = totallist[index].name;
                 final _avatarUrl = totallist[index].avatarUrl;
                  final _totalMembers = totallist[index].totalMembers;
                  return Container(
                    padding: new EdgeInsets.all(2.0),
                    color: mainbackground,
                    child: new Column(
                        children: <Widget>[
                           Container(
                              height: itemHeight1,
                              width: itemWidth,
                              padding: const EdgeInsets.all(5.0),
                              // color: backgroundYellow,
                              child:  new Image.network(_avatarUrl,
                              fit: BoxFit.cover),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              // color: backgroundYellow,
                              child:  new Text(_title, style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),)
                            ),
                         
                          
                        ]
                      ),
                    
                  );

              });
            
            var griddata1 = new GridView(
                scrollDirection: Axis.vertical,
                controller: ScrollController(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150.0),
                children: List.generate(totallist.length, (index) {
                  return Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: GridTile(
                        footer: Text(
                            totallist[index].name,
                          // totallist.length
                          // 'Item $index',
                          textAlign: TextAlign.center,
                        ),
                        header: Text(
                          'SubItem $index',
                          textAlign: TextAlign.center,
                        ),
                        child: Icon(Icons.access_alarm,
                            size: 40.0, color: Colors.white30),
                      ),
                    ),
                    color: Colors.blue[400],
                    margin: EdgeInsets.all(1.0),
                  );
                }),
              );
          
            var griddata2 = new GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(totallist.length, (index) {
                    return Container(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: GridTile(
                          footer: Text(
                            totallist[index].name,
                            textAlign: TextAlign.center,
                          ),
                          header: Text(
                            'SubItem $index',
                            textAlign: TextAlign.center,
                          ),
                          child: Icon(Icons.access_alarm,
                              size: 40.0, color: Colors.white30),
                        ),
                      ),
                      color: Colors.blue[400],
                      margin: EdgeInsets.all(1.0),
                    );
                  }));

            var griddata3 = new GridView.custom(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              childrenDelegate:
                  SliverChildListDelegate(List.generate(totallist.length, (index) {
                return Container(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: GridTile(
                      footer: Text(
                        totallist[index].name,
                        textAlign: TextAlign.center,
                      ),
                      header: Text(
                        'SubItem $index',
                        textAlign: TextAlign.center,
                      ),
                      child: Icon(Icons.access_alarm,
                          size: 40.0, color: Colors.white30),
                    ),
                  ),
                  color: Colors.blue[400],
                  margin: EdgeInsets.all(1.0),
                );
              })));
            
            var griddata4 = new   GridView.extent(
                maxCrossAxisExtent: 200.0,
                children: List.generate(totallist.length, (index) {
                  return Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: GridTile(
                        footer: Text(
                          'Item $index',
                          textAlign: TextAlign.center,
                        ),
                        header: Text(
                          'SubItem $index',
                          textAlign: TextAlign.center,
                        ),
                        child: Icon(Icons.access_alarm,
                            size: 40.0, color: Colors.white30),
                      ),
                    ),
                    color: Colors.blue[400],
                    margin: EdgeInsets.all(1.0),
                  );
                })
                );


            // return Container(
            //     child: griddata
            // );

            return Container(
                child: griddata
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return shimerdt;
         
          
          
          // Container(
          //     padding: const EdgeInsets.all(8.0),
          //     child: GridView.count(
          //         crossAxisCount: 2,
          //         children: <Widget>[
          //           Shimmer.fromColors(
          //             baseColor: Color(0xFFE0E0E0),
          //              highlightColor: Colors.grey[300],
          //               child: Container(
          //               padding: const EdgeInsets.all(8.0),
          //               child: new Card(
          //                   child: new Column(
          //                     children: <Widget>[
          //                       const SizedBox(
          //                           width: 42.0,
          //                           height: 42.0,
          //                           child: const DecoratedBox(
          //                             decoration: const BoxDecoration(
          //                               color: Colors.red
          //                             ),
          //                           ),
          //                         ),

          //                       // new Image.network(_avatarUrl),
          //                       new Text("asdasdasdas")
          //                     ]
          //                   ),
          //                 )
          //             ),
          //           ),
          //           Shimmer.fromColors(
          //             baseColor: Color(0xFFE0E0E0),
          //             highlightColor: Colors.grey[300],
          //             child: Container(
          //               padding: const EdgeInsets.all(8.0),
          //               child: new Card(
          //                   child: new Column(
          //                     children: <Widget>[
          //                       const SizedBox(
          //                           width: 42.0,
          //                           height: 42.0,
          //                           child: const DecoratedBox(
          //                             decoration: const BoxDecoration(
          //                               color: Colors.red
          //                             ),
          //                           ),
          //                         ),

          //                       // new Image.network(_avatarUrl),
          //                       new Text("asdasdasdas")
          //                     ]
          //                   ),
          //                 )
          //           ),
          //            ),
          //            Shimmer.fromColors(
          //             baseColor: Color(0xFFE0E0E0),
          //              highlightColor: Colors.grey[300],
          //               child: Container(
          //               padding: const EdgeInsets.all(8.0),
          //               child: new Card(
          //                   child: new Column(
          //                     children: <Widget>[
          //                       const SizedBox(
          //                           width: 42.0,
          //                           height: 42.0,
          //                           child: const DecoratedBox(
          //                             decoration: const BoxDecoration(
          //                               color: Colors.red
          //                             ),
          //                           ),
          //                         ),

          //                       // new Image.network(_avatarUrl),
          //                       new Text("asdasdasdas")
          //                     ]
          //                   ),
          //                 )
          //           ),
          //            ),
          //         ],
          //       ),
          //   );
          



          // CircularProgressIndicator();
        },
      ),
    );
  }

}