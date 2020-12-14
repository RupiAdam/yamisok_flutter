import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yamisok/api/api_discover.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'package:yamisok/model/model_discover.dart';
import 'package:yamisok/component/styleyami.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yamisok/component/background.dart';

class Discover extends StatefulWidget {
  final Future<DiscoverModel> post;
  Discover({Key key, this.post}) : super(key: key);

  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  ApiService apiService;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    super.initState();
      // _datanew="new";
      //  _loopingListData();
    // _listAchievment= _listAchievment;
    //da
    apiService = ApiService();
    
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
    // var size = globals.varMediaQuery;
     var size = MediaQuery.of(context).size;

            final double itemWidth = (size.width - 10) / 3;
            final double itemHeight1 = (size.width) / 4;
           
            final double itemHeight = ((size.width - 10) / 4)-10;
            
            final double itemWidthComunity = (size.width  - 20) / 2;
            final double itemWidthComunitytext1 = (size.width  - 80) / 2;
            final double itemWidthComunitytext2 = (size.width  - 200) / 2;
            final double itemHeightComunity = (size.width  - 100) / 2;

            print("lihat height $itemHeight ");
            
            var shimerdt = Shimmer.fromColors(
                baseColor: Color(0xFFE0E0E0),
                // highlightColor: Colors.grey[300],
                // baseColor: Colors.grey[100],
                highlightColor: Colors.grey[50],
                // direction: ,
                // period: const Duration(microseconds: 1),
                child: Column(
                  verticalDirection: VerticalDirection.down,
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
      child: FutureBuilder<DiscoverModel>(
        future: apiService.fetchPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // var size = globals.varMediaQuery;
            List<Result> listResult = snapshot.data.result;
            final totallist = listResult; 
             var griddata = new GridView.builder(
              itemCount: totallist.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                 final _title = totallist[index].content;
                 String _imagesUrl;
                 final _avatarUrl = totallist[index].images;
                  var optiondisplay=new Container();

                 if(_avatarUrl==null){
                             
                    optiondisplay = new Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF34424e),
                            width: 1.0,
                          ),
                          // borderRadius: BorderRadius.all(
                          //     Radius.circular(10.0) //         <--- border radius here
                          //     ),
                          gradient: LinearGradient(
                            // colors: [fristColor, secondColor],
                            colors: [fristColor, secondColor],

                            begin: Alignment(-1.0, -2.0),
                            end: Alignment(1.0, 2.0),
                          ),
                        ),
                         height: itemWidth,
                          width: itemWidth,
                        child:Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Text(_title, 
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              
                              // decoration: TextDecoration.underline,
                              // decorationColor: Colors.red,
                              decorationStyle: TextDecorationStyle.wavy,
                            ),
                        ),
                          ),
                        )
                    );
                  }else if (_avatarUrl==""){
                    optiondisplay = new Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF34424e),
                            width: 1.0,
                          ),
                          // borderRadius: BorderRadius.all(
                          //     Radius.circular(10.0) //         <--- border radius here
                          //     ),
                          gradient: LinearGradient(
                            // colors: [fristColor, secondColor],
                            colors: [fristColor, secondColor],

                            begin: Alignment(-1.0, -2.0),
                            end: Alignment(1.0, 2.0),
                          ),
                        ),
                          // color: Colors.grey,
                         height: itemWidth,
                          width: itemWidth,
                        child:Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Text(_title, 
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              // decoration: TextDecoration.underline,
                              // decorationColor: Colors.red,
                              decorationStyle: TextDecorationStyle.wavy,
                            ),
                        ),
                          ),
                        )
                    );
                  }else{
                   

                  
                    
                    optiondisplay = new Container(
                            height: itemWidth,
                              width: itemWidth,
                               child:  new Image.network(_avatarUrl,
                              fit: BoxFit.cover),
                      );
                  
                 }

                 var str2="literals, allowing effective";
                
                   
                //  var okw=str2.padLeft(8, 'x'); // xxLorem
                 str2.indexOf('lit');

                 print('lihat pad left $str2' );
                  // final _totalMembers = totallist[index].totalMembers;
                  return Container(
                    color: mainbackground,
                    child: new Column(
                        children: <Widget>[
                          optiondisplay
                           
                         
                          
                        ]
                      ),
                    
                  );

              });
            
           
            // return Container(
            //     child: griddata
            // );

            return Container(
                color: Color(0xFF151a1d),
                child: griddata
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return shimerdt;
         
      
        },
      ),
    );
  }
}