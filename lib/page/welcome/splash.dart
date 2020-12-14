import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yamisok/component/styleyami.dart';
import 'package:yamisok/page/forgotpassword/reset_password.dart';
import 'package:yamisok/page/helper/check_connection.dart';
import 'package:yamisok/page/home/bottom_navigation.dart';
import 'package:yamisok/page/home/home_new.dart' as homev2;
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/page/landing/landing.dart';
import 'package:yamisok/page/login/login.dart' as menulogin;
import 'package:yamisok/page/verification_email/verification_email.dart';
import 'package:yamisok/page/game/connect_game.dart';
import 'package:flutter/services.dart';


void main() =>
  runApp(
    SplashScreen()
  );

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FadeIn();
}

class FadeIn extends State<SplashScreen> {
  Timer _timer; FlutterLogoStyle _logoStyle = FlutterLogoStyle.markOnly;

  static const platform = const MethodChannel('https.yamisok.com/channel');

  Future<void> _getAppLink() async {
    try{
      final String result = await platform.invokeMethod('getAppLink');

      if(result == "null"){
        onDoneLoading();
      }else{
        var uri = Uri.parse(result);
        var path = uri.path.substring(1);

        if(path == "reset_password"){

          var email = uri.queryParameters['email'];
          var token = uri.queryParameters['token'];

          validateResetPassword(email, token);

        }else{
          onDoneLoading();
        }

      }

    }on PlatformException catch (e) {
      // return error
      print('method channel error: $e');
      onDoneLoading();
    }
  }

  FadeIn() {
    _timer = new Timer(
      const Duration(seconds: 1), () {
        setState(() {
          _logoStyle = FlutterLogoStyle.horizontal;
           if (Platform.isAndroid) {
             return new Timer(Duration(seconds: 2), _getAppLink);
           }else{
             return new Timer(Duration(seconds: 2), onDoneLoading);
           }
          //
          });
        }
    );
  }

  onDoneLoading() async {
     checkConnection().then((isConnected) {
      print('masuk k cek koneksi');
      if (!isConnected) {
        print('No internet connection');
      }
    });

    keyStore.getToken().then((resultToken){

       isShowLandingPage().then((isShow){

        if(isShow == null){
          Navigator.pushReplacementNamed(context, LandingPage.route);
        }else{

          keyStore.getLatestPage().then((resultLates){
             if(resultLates == 'null'){
                print('masuk k lates page null');
              if(resultToken == 'null'){
                //token null
              print("MASUK KE LOGIN ");
              Navigator.pushReplacementNamed(context, menulogin.LoginSignUpPage.tag);

              }else{
              print("MASUK KE HOME : ");
              Navigator.pushReplacementNamed(context, Bottomnav.tag);
              }

             }else{

               var rootes=resultLates;
                print('masuk k lates page $rootes');
                if(rootes=='ConnectGame'){
                  Navigator.pushReplacementNamed(context, ConnectGame.tag);
                }else if (rootes=='VerificationEmail'){
                  Navigator.pushReplacementNamed(context, VerificationEmail.tag);
                }else if(rootes=='Home'){
                   Navigator.pushReplacementNamed(context, Bottomnav.tag);
                  // Navigator.pushReplacementNamed(context, homev2.HomeNew.tag);
                }else{
                  print("invalid lates rotes to LOGIN ");
                  Navigator.pushReplacementNamed(context, menulogin.LoginSignUpPage.tag);

                }


             }
          });
        }

      });

    });
  }

  @override Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = (size.width);
    final double itemWidth1 = (size.width)/3;
    final double itemWidthLogo = (size.width)-itemWidth1;
    final double itemHeight = (size.height);
    return MaterialApp(
     home: Scaffold(
        body: Container(
          color: backgroundPrimary,
          height: itemHeight,
          width: itemWidth,
            child: Center(
              child: Image.asset("assets/images/logo.png", width: itemWidthLogo,),
            ),

        ),
      ),
    );
  }

  validateResetPassword(String email, String token) async {

    keyStore.getResetPasswordToken().then((savedToken){
      print("saved_token: $savedToken token: $token email: $email ");

      if(savedToken == token)
        Navigator.pushReplacementNamed(context, ResetPasswordPage.tag);
      else
        onDoneLoading();

    });

  }

}
