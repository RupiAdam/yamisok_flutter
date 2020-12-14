import 'package:flutter/material.dart';
import 'package:yamisok/component/background.dart';
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/component/styleyami.dart';
import 'package:yamisok/page/login/login.dart';
import 'package:yamisok/main.dart';

class More extends StatelessWidget{
  static String tag = 'more-page';
  @override
  Widget build(BuildContext context){
    return new Container(
      color: mainbackground,
      child: new Column(
        children: <Widget>[
          new ListTile(
              leading: Image.asset("assets/images/chat.png",
              height: 35.0,
              ),
              title: Text('Chat', style: new TextStyle(fontSize: 14.0, color: Colors.white),),
             ),
          new Divider(
            color: Color(0xFF2f3336),
            height: 1.0,
          ),
          new ListTile(
              leading: Image.asset("assets/images/team.png",
              height: 35.0,
              ),
              title: Text('Team', style: new TextStyle(fontSize: 14.0, color: Colors.white),),
             ),
          new Divider(
            color: Color(0xFF2f3336),
            height: 1.0,
          ),
          new ListTile(
              leading: Image.asset("assets/images/leaderboard.png",
              height: 35.0,
              ),
              title: Text('Leaderboard', style: new TextStyle(fontSize: 14.0, color: Colors.white),),
             ),
          new Divider(
            color: Color(0xFF2f3336),
            height: 1.0,
          ),
          new ListTile(
              leading: Image.asset("assets/images/lucky.png",
              height: 35.0,
              ),
              title: Text('Lucky Draw', style: new TextStyle(fontSize: 14.0, color: Colors.white),),
             ),
          new Divider(
            color: Color(0xFF2f3336),
            height: 1.0,
          ),
          new ListTile(
              leading: Image.asset("assets/images/faq.png",
              height: 35.0,
              ),
              title: Text('F.A.Q', style: new TextStyle(fontSize: 14.0, color: Colors.white),),
             ),
          new Divider(
            color: Color(0xFF2f3336),
            height: 1.0,
          ),
          new ListTile(
              leading: Image.asset("assets/images/report.png", height: 35.0,),
              title: Text('Report', style: new TextStyle(fontSize: 14.0, color: Colors.white),),
             ),
          new Divider(
            color: Color(0xFF2f3336),
            height: 1.0,
          ),
           new ListTile(
              leading: Image.asset("assets/images/logout.png",height: 35.0,),
              title: Text('Log Out', style: new TextStyle(fontSize: 14.0, color: Colors.white),),
              // onTap: (){ logout(context);},
              onTap: (){ _asyncConfirmDialog(context).then((rst){ if(rst == ConfirmAction.ACCEPT) logout(context);});
              },
             ),
          new Divider(
            color: Color(0xFF2f3336),
            height: 1.0,
          ) 
          // new Padding(padding: new EdgeInsets.all(20.0),),
          // new Text("More On Progres", style: new TextStyle(fontSize: 30.0),),
          // new Padding(padding: new EdgeInsets.all(20.0),),
          
        ],
      ), 
      
    );
  }
}

void logout(context){
  keyStore.setToken('null').then((val){
    print("reset token logout sucess");
    // Navigator.pop(context);
    keyStore.getToken().then((rst){ 
      print("THEN CEK TOKENNYA : $rst");
      // Navigator.of(context).pushNamed(Home.tag);
      // Navigator.pushNamed(context, '/login');
      Navigator.pushReplacementNamed(context, LoginSignUpPage.tag);
      // Navigator.popUntil(context, ModalRoute.withName('/login'));
      // Navigator.push(context, new MaterialPageRoute(
      //   builder: (context) =>
      //     new LoginSignUpPage())
      // );
    });
  });
}

enum ConfirmAction { CANCEL, ACCEPT }
 
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog( 
        content: const Text(
            'Are you sure want to logout?'),
        actions: <Widget>[
          FlatButton(
            color: Colors.black87,
            textColor: yamiyelowColor,
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            color: Colors.black87,
            textColor: Colors.white54,
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}