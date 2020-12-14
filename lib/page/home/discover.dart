import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

Client client = Client();
List<String> dogImages = new List();
List listdiscover = [];

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];

  RefreshController _scrollController =  RefreshController(initialRefresh: false);
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
   
    // if failed,use refreshFailed()
    setState(() {
      // fetchFive();
       emptyListData();
       fetchAPi();
    });
    
    _scrollController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    // if(mounted)
    print("jlan onload");
    
    setState(() {
      fetchAPiLoad();
    });
    _scrollController.loadComplete();
  }

  @override
  void initState(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    super.initState();
    // if(dogImages.length==0){
    //     fetchFive();
    // }
    
    fetchAPi();
    // _scrollController.addListener((){
    //   if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
    //     fetchFive();
    //   }

    // });
  }
  @override
  void dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    _scrollController.dispose();
    super.dispose();
  }
  // http://www.mocky.io/v2/5d63b70e3200007500ba1ce0
  fetchAPiLoad() async {
  final response = await client.get('http://www.mocky.io/v2/5d63b8bb3200006d00ba1cf8',
                                    headers: {"content-type": "application/json"});
    final statuscodeprint = response.statusCode;
    print('lihat status code $statuscodeprint');
    if(response.statusCode==200){
      Map<String, dynamic> user = jsonDecode(response.body);
      var bodylog = json.decode(response.body);
      var newtes = bodylog['listdiscover'];
      var newtes2 = newtes[1];
      print('Howdy, $bodylog[1].');
      print('Howdy2, $newtes');
      print('Howdy3, $newtes2');
      // var vardatanew=newtes[0];

      setState(() {
         listdiscover.addAll(newtes);
       });
     
       var newprint= listdiscover[0]['img_url'];
        
        print("errorlihat $newprint");
      
        // listdiscover.add(newtes);
      //  listdiscover=newtes;
      // });
    }else{
      throw Exception('failed to load images');
    }
  }

  fetchAPi() async {
  final response = await client.get('http://www.mocky.io/v2/5d639f433200006f00ba1c10',
                                    headers: {"content-type": "application/json"});
    final statuscodeprint = response.statusCode;
    print('lihat status code $statuscodeprint');
    if(response.statusCode==200){
      Map<String, dynamic> user = jsonDecode(response.body);
      var bodylog = json.decode(response.body);
      var newtes = bodylog['listdiscover'];
      var newtes2 = newtes[1];
      print('Howdy, $bodylog[1]');
      print('Howdy2, $newtes');
      print('Howdy3, $newtes2');
      // var vardatanew=newtes[0];
      

      setState(() {
         listdiscover.addAll(newtes);
        //  listdiscover.addAll()
       });
     
       var newprint= listdiscover[0]['img_url'];
        
        print("errorlihat $newprint");
      
        // listdiscover.add(newtes);
      //  listdiscover=newtes;
      // });
    }else{
      throw Exception('failed to load images');
    }
  }
 

  emptyListData(){
    listdiscover.clear();
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

    
   var newUi= new Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(
          
        ),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("pull up load");
            }
            else if(mode==LoadStatus.loading){
              body = Container(
                  child: Text("Load More"),
              );
            }
            else if(mode == LoadStatus.failed){
              body = Text("Load Failed!Click retry!");
            }
            else{
              body = shimerdt;
            }
            // return shimerdt;
            return Container(
              height: 200.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _scrollController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: GridView.builder(
              // controller: _scrollController,
          itemCount: listdiscover.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3),
          itemBuilder:(BuildContext context, int index){


            var newprint= listdiscover[index]['img_url'];
            // final newtes2 = listdiscover[index]['img_url'];
            // print('Howdy, ${newtes2['img_url']}!');
            // // final newtes2 = newtes['img_url']
            print('lihat print  $newprint');
            return Container(
              constraints: BoxConstraints.tightFor(height: 150.0),
              // child: Text("data"),
              // child :Image.network("src")
              child:Image.network(newprint, fit: BoxFit.fitWidth,)
            );
          },
        ),
      ),
    );
  
        //  if(dogImages.length>=0){
        //     return dataUI;
           
        //   }else if(dogImages.length==0) {
        //      return Container(
        //       child: Text("ada"),
        //     );
        //   }
        //   // switch (snapshot.connectionState) {
        //   //   case ConnectionState.none:
        //   //     return Text('Press button to start.');
        //   //   case ConnectionState.active:
        //   //   case ConnectionState.waiting:
        //   //     return shimerdt;
        //   //   case ConnectionState.done:
        //   //     if (snapshot.hasError)
        //   //       return Text('Error: ${snapshot.error}');sss
        //   //     // return Text('Result: ${snapshot.data}');
        //   //     return dataUI;
        //   // }
        //   return shimerdt; // unreachable
    
    if(listdiscover.length==0){
      return shimerdt;
    }else{
       return newUi;
    }
    
    
  }

}

