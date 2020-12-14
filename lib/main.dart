import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yamisok/api/misc/firebase_api.dart';
import 'package:yamisok/page/find_friend/find_friend.dart';

import 'package:yamisok/page/forgotpassword/forgot_password_cek_email.dart';
import 'package:yamisok/page/forgotpassword/forgot_password_email.dart';
import 'package:yamisok/page/forgotpassword/reset_password.dart';
import 'package:yamisok/page/forgotpassword/reset_password_success.dart';
import 'package:yamisok/page/game/connect_game.dart';
import 'package:yamisok/page/game/connect_game_manual.dart';
import 'package:yamisok/page/game/connect_game_ocr.dart';
import 'package:yamisok/page/game/connect_game_steam.dart';
import 'package:yamisok/page/profile/following.dart';
import 'package:yamisok/page/term_and_condition/term_and_condition.dart';
import 'package:yamisok/page/utilities/color.dart';

import 'package:yamisok/page/verification_email/verification_email.dart';
import 'package:yamisok/page/verification_email/verification_email_success.dart';

import 'package:yamisok/page/profile/edit_aboutme.dart';

import 'package:yamisok/page/login/login.dart' as menulogin;
// import 'package:yamisok/page/home/home.dart' as menuhome;
import 'package:yamisok/page/more.dart' as menumore;
// import 'package:yamisok/page/profile_firebase_storage.dart';
import 'package:yamisok/page/tournament.dart' as tournamentPage;
import 'package:yamisok/page/home/bottom_navigation.dart';
// import 'package:yamisok/page/profile/profile.dart' as profilePage;

// import 'package:yamisok/component/all_library.dart';

import 'package:yamisok/page/welcome/splash.dart' as welcome;
import 'package:yamisok/page/home/home_new.dart' as homev2;

// import 'package:yamisok/page/game/connect_game.dart' as connectgame;
import 'package:yamisok/page/game/connect_game.dart' as connectgame;
import 'package:yamisok/page/login/basic_info.dart' as basic;

import 'package:yamisok/page/profile/edit_profile.dart';

//redux
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/redux/reducer.dart';
import 'package:yamisok/page/landing/landing.dart' as landingPage;

//firebase
import 'dart:io' show Platform;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      
//              _showItemDialog(message);
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
//              _navigateToItemDetail(message);
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
//              _navigateToItemDetail(message);
    },
  );
  

  FirebaseAnalytics analytics = FirebaseAnalytics();

  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  final store = new Store<AppState>(reducer,
      initialState: new AppState(),
      middleware: [
        new QuoteMiddleware(),
        new PopularMiddleware(),
        new NewMiddleware()
      ]);

  final routes = <String, WidgetBuilder>{
    Bottomnav.tag: (context) => Bottomnav(),
    homev2.HomeNew.tag: (context) => homev2.HomeNew(),
    connectgame.ConnectGame.tag: (context) => connectgame.ConnectGame(),
    // ProfileFirestore.tag: (context) => ProfileFirestore(),
    menulogin.LoginSignUpPage.tag: (context) => menulogin.LoginSignUpPage(),
    // menuhome.Feeds.tag: (context) => menuhome.Feeds(),
    menumore.More.tag: (context) => menumore.More(),
    basic.BasicInfo.tag: (context) => basic.BasicInfo(),
    tournamentPage.Tournament.tag: (context) => tournamentPage.Tournament(),
    landingPage.LandingPage.route: (context) => landingPage.LandingPage(),
    ForgotPasswordCekEmailPage.tag: (context) => ForgotPasswordCekEmailPage(),
    ResetPasswordPage.tag: (context) => ResetPasswordPage(),
    ResetPasswordSuccessPage.tag: (context) => ResetPasswordSuccessPage(),
    VerificationEmailSuccess.tag: (context) => VerificationEmailSuccess(),
    TermAndConditionPage.tag: (context) => TermAndConditionPage(),
    VerificationEmail.tag: (context) => VerificationEmail(),
    ConnectGame.tag: (context) => ConnectGame(),
    // profilePage.Profile.tag: (context) => Profile(),
    ProfileFollowingPage.tag: (context) => ProfileFollowingPage()
  };


  //  final FirebaseApp app = await FirebaseApp.configure(
  //   name: 'db2',
  //   options: Platform.isIOS
  //       ? const FirebaseOptions(
  //           googleAppID: '1:670051004056:ios:6fe38c2658bcd97a03aaed',
  //           gcmSenderID: '670051004056',
  //           databaseURL: 'https://yamisok-c3ca8.firebaseio.com',
  //         )
  //       : const FirebaseOptions(
  //           googleAppID: '1:670051004056:android:29d36a1c0f034a09',
  //           apiKey: 'AIzaSyC8OymKTzlHNOIHmL1YL4eAdUoJg_v92DQ',
  //           databaseURL: 'https://yamisok-c3ca8.firebaseio.com',
  //         ),
  // );

  runApp(StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors
              .pink[800], //Changing this will change the color of the TabBar
          accentColor: Colors.yellowAccent[700],
          // canvasColor: Colors.transparent,
          dialogBackgroundColor: Colors.white,
          scaffoldBackgroundColor: backgroundPrimary
        ),

        title: "Yamisok",
        home: new welcome.SplashScreen(),
        // home: FindFriend(),
        // home: ConnectGame(),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        routes: routes,
      )));
}
