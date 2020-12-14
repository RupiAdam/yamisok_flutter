import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:yamisok/api/esport/esport_api.dart';


//list esport
List listEsport = [];

class EsportPage extends StatefulWidget {
  @override
  _EsportPageState createState() => _EsportPageState();
}

class _EsportPageState extends State<EsportPage> {
  //get api achieve
  void apiEsport() {
    listEsport.clear();
    var limit = '3';
    ApiServiceEsport.apiesport(limit).then((result) async {
      var resultdt = json.decode(result);
      final messages = resultdt['messages'];
      final status = resultdt['status'];
      if (status == true) {
        print('masuk k satstus 200');
        var resultlist = resultdt['result'];
        print('lihat body, $resultlist');
        if (mounted) {
          setState(() {
            listEsport.addAll(resultlist);
            //  listdiscover.addAll()
          });
        }
        print("status true");
      } else {
        print("status false");
      }
    });
  }

   @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
    

    // apiDetail();
    apiEsport();
   
    // store.dispatch(apigetlocation);

    // storeapp.dispatch(apipopular);
  }

  @override
  void dispose() {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    // listDataMembers.clear();
    // _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}