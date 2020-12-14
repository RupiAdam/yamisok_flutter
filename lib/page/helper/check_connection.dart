import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yamisok/page/utilities/style.dart';

Future<bool> checkConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  bool isConnected = (connectivityResult == ConnectivityResult.wifi ||
      connectivityResult == ConnectivityResult.mobile);
  return isConnected;
}

showAlertConnection(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Container(
        child: Text("Cek Koneksi Internet kamu", style: TextStyle(
                      fontSize: textSize18sp
                      ),
      ),);
    },
  );
}
_showDialogConnection(BuildContext context) {
    // flutter defined function
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          // title: new Text("Alert Dialog title"),
          content: Column(
            children: <Widget>[
              Container(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text("Cek Koneksi Internet kamu", style: TextStyle(
                      fontSize: textSize18sp
                      ),
                    ),
                    GestureDetector(
                      onTap: Navigator.of(context).pop,
                      child: Icon(Icons.close)
                    )
                  ],
                ),
              ),
            ],
          ),
          
        );
      },
    );
  }
