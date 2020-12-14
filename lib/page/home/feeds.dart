import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yamisok/api/api_feeds.dart';
import 'package:yamisok/component/globals.dart' as globals;
import 'package:yamisok/model/model_feeds.dart';
import 'package:yamisok/component/styleyami.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:flutter_html/flutter_html.dart';

  

class Feeds extends StatefulWidget {
  final Future<FeedsModel> post;
  Feeds({Key key, this.post}) : super(key: key);

  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
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
            //responsive size all component
            final double itemWidth = (size.width - 10) / 4;
            final double _text_size_feeds_userimg = (size.width) / 30;
            final double _text_size_feeds_usertime = (size.width) / 35;



            final double itemWidthProfile = (size.width) / 8;
            
            final double itemHeightfotoProfile = (size.width) / 10;
            final double itemHeightfotoProfileComent = (size.width) / 14;
            
            final double sizetextcomunity2 = (size.width) / 35;

            final double itemWidthCustum = (itemWidth * 2) + (itemWidth / 2);
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
   
   return Container(
      child: FutureBuilder<FeedsModel>(
        future: apiService.fetchPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // var size = globals.varMediaQuery;
            List<Result> listResult = snapshot.data.result;
            final totallist = listResult; 
            
            var listViewdt = new 
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: totallist.length,
              itemBuilder: (context, index) {
                final _id = totallist[index].postId;
                final _verification = 2;
                final _title = totallist[index].username;
                final _avatarUrl = totallist[index].avatarUrl;
                final _totalMembers = totallist[index].content;
                var  _membercustom="~"; 
                var titlecustom=new Container(

                );

                
                
               
            // final avatarUrlnew = _dtMission[index].avatarUrl;
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                  // padding: const EdgeInsets.only(
                      // left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                  height: itemHeight,
                  width: itemWidthCustum,
                  child: new Container(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                            // borderRadius:BorderRadius.all(Radius.circular(10.0)),
                            borderRadius: BorderRadius.only(
                              topLeft:  const  Radius.circular(10.0),
                              bottomLeft: const  Radius.circular(10.0)),
                            
                            child: Container(
                              color: Colors.black87,
                              // width: itemHeightfotoProfile,
                              // height: itemHeightfotoProfile,
                              width: 10.0,
                              height: 10.0,
                              child: new Image.network(_avatarUrl,
                              // fit: BoxFit.cover
                              fit: BoxFit.contain,
                              ),
                             
                            )),
                        SizedBox(
                                width: 5.0,
                        ),
                        Container(
                         
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              titlecustom,
                              new Text(
                                " $_membercustom",
                                style: TextStyle(
                                    fontSize: sizetextcomunity2,
                                    color: Color(0xFF95989a),
                                    fontWeight: FontWeight.bold),
                                // fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                );
              }
              );


             var listsample= new 
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: totallist.length,
              itemBuilder: (context, index) {
                final _id = totallist[index].postId;
                final _verification = 2;
                final _username = totallist[index].username;
                final _avatarUrl = totallist[index].avatarUrl;
                final _textContent = totallist[index].content;
                String htmlContent = _textContent;

                var  _membercustom="~"; 
                var titlecustom=new Container(

                );

              
                
                // final avatarUrlnew = _dtMission[index].avatarUrl;
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  //header
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                          // padding: const EdgeInsets.only(
                              // left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                 
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                  Container(
                                      width: itemHeightfotoProfile,
                                      height: itemHeightfotoProfile,
                                    // height: itemWidthProfile,
                                    // width: itemWidthProfile,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: new NetworkImage(_avatarUrl)
                                        )
                                      ),
                                    
                                  
                                
                                  ),
                                  Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(_username,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                    fontSize: _text_size_feeds_userimg,
                                                    color: Colors.white,
                                                    
                                                  ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                              child: new Text("1 hours ago",
                                              textAlign: TextAlign.left,
                                                style: TextStyle(
                                                      fontSize: _text_size_feeds_usertime,
                                                      color: Colors.white,
                                                  ),
                                          ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  )
                                
                              ],
                            ),
                            ),

                          Container(
                            child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Icon(Icons.more_horiz,
                                color: Colors.white,)
                              ),
                          ),
                        ],
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  _textContent,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                          fontSize: _text_size_feeds_userimg,
                                          color: Colors.white,
                                      ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[

                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.favorite,
                                          color: Colors.white,),
                                        Text(" Like",
                                        style: TextStyle(
                                        fontSize: _text_size_feeds_userimg,
                                        color: Colors.white,
                                    )),
                                      ],
                                    ),
                                  ),
                                   Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.comment,
                                          color: Colors.white,),
                                        Text(" Comment",
                                        style: TextStyle(
                                        fontSize: _text_size_feeds_userimg,
                                        color: Colors.white,
                                    )),
                                      ],
                                    ),
                                  ),
                                    Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.reply,
                                          color: Colors.white,),
                                        Text(" Share",
                                        style: TextStyle(
                                        fontSize: _text_size_feeds_userimg,
                                        color: Colors.white,
                                    )),
                                      ],
                                    ),
                                  ),
                                  
                                 
                                ],
                              ),
                              Container(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                        Container(
                                            width: itemHeightfotoProfileComent,
                                            height: itemHeightfotoProfileComent,
                                          // height: itemWidthProfile,
                                          // width: itemWidthProfile,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                              fit: BoxFit.cover,
                                              image: new NetworkImage(_avatarUrl)
                                              )
                                            ),
                                          
                                        
                                      
                                        ),
                                        Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child: new Text(_username,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                      fontSize: _text_size_feeds_userimg,
                                                      color: Colors.white,
                                                      
                                                    ),
                                            ),
                                        ),
                                        )
                                      
                                    ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text("Pengajuan aplikasi terbaru Anda ditolak karena melanggar Kebijakan Program Pengembang Google Play. Jika Anda mengajukan",
                                      textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                        fontSize: _text_size_feeds_userimg,
                                                        color: Colors.white,)),
                                    )
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      

                    ],
                  )
                );
              }
              );


            return Container(
                color: Color(0xFF151a1d),
                child: listsample
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