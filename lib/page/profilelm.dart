// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;
import 'package:yamisok/component/globals.dart' as globals;
import 'package:yamisok/component/styleyami.dart';
import 'package:yamisok/api/api_service.dart';
import 'package:yamisok/model/profile_model.dart';

class profilefull extends StatefulWidget {
  final Future<Tesprofile> post;

  profilefull({Key key, this.post}) : super(key: key);

  @override
  _profilefullState createState() => _profilefullState();
}

class _profilefullState extends State<profilefull> {
  BuildContext context;
  ApiService apiService;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
    apiService = ApiService();
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
    // this.context = context;
    return Center(
      child: FutureBuilder<Tesprofile>(
        future: apiService.fetchPost(),
        
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // List<Profile> profiles = snapshot.data;

            String usernamedt = snapshot.data.result.detail.username;
            int level = snapshot.data.result.detail.level;
            int cookies = snapshot.data.result.detail.cookies;
            int followers = snapshot.data.result.detail.followers;
            int followings = snapshot.data.result.detail.followings;
            int exp = snapshot.data.result.detail.exp;
            int totalExp = snapshot.data.result.detail.totalExp;
            int nextLevelExp = snapshot.data.result.detail.nextLevelExp;

            
            List<Achievement> achievements = snapshot.data.result.achievements;
            // return _buildListView(profiles);
           
             final ceklen = achievements;
              print('lihat achieve $ceklen[0].title');
              setStates: () {
       
              };
            // int followers = snapshot.data.result.detail.followers;
            // int followings = snapshot.data.result.detail.followings;
            // int cookies = snapshot.data.result.detail.cookies;


            return Container(
              color: backgroundPrimary,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    _buildprofile(usernamedt, 
                                  level, 
                                  cookies,
                                  followers,
                                  followings,
                                  exp,
                                  totalExp,
                                  nextLevelExp
                                ),
                    // HeaderProfileFull(data : usernamedt),
                    // Editprofilelama(),
                    SparatorHeaderSoaial(),
                    SosialMedia(),
                    SparatorHeaderAchivement(),
                    // _buildAchievement(achievements),
                    Achievementfull(),
                    SparatorHeaderCategori(),
                    Categori(),
                    Categori2(),
                    SparatorHeaderdaily(),
                    DailyMission(),
                    SparatorHeaderMatch(),
                    UpcomingMatch(),
                  ],
                ),
              ),
            );
            // return Text(snapshot.data.result.detail.username);
            // return Text("aad");

          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _buildprofile(String usernamedt, int level, int cookies, int followers, int followings, int exp, int totalExp, int nextLevelExp) {
    // var size = globals.varMediaQuery;
     var size = MediaQuery.of(context).size;

    print(cookies);

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = (size.width - 10) / 3;
    final double itemWidthCustom = ((size.width - 10) / 3) * 2;
    final double itemWidthCustomStatusXp = (((size.width - 10) / 3) * 2) - 70;

    final double itemWidth2 = (size.width / 3) * 2;

    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(5.0),
          // padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          color: backgroundSecond,
          child: Row(
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                height: itemWidth,
                width: itemWidth,
                child: new Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Container(
                        color: Color(0xFF151a1d),
                        child: new Image.network(
                            "https://res.cloudinary.com/yamisok/image/upload/v1523937089/profile/skwqq3grrxcpf4tybsim.jpg"),
                      )),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 10.0, bottom: 5.0),
                // color: Colors.amber,
                width: itemWidthCustom,
                height: itemWidth,
                child: new Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          usernamedt,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: textColor2,
                              fontWeight: FontWeight.bold),
                          // fontWeight: FontWeight.bold),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 22.0,
                                padding: const EdgeInsets.all(5.0),
                                color: backgroundYellow,
                                child: new Image.asset(
                                    "assets/images/crown.png",
                                    fit: BoxFit.cover),
                                // child: Text(
                                //   "W",
                                //   style: TextStyle(
                                //       fontSize: 12.0,
                                //       color: backgroundPrimary,
                                //       fontWeight: FontWeight.bold),
                                //   // fontWeight: FontWeight.bold),
                                // ),
                              ),
                              Container(
                                height: 22.0,
                                padding: const EdgeInsets.all(5.0),
                                color: backgroundPrimary,
                                child: Text(
                                  "VIP",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: backgroundYellow,
                                      fontWeight: FontWeight.bold),
                                  // fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "XP",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: textColor2,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 8.0,
                              width: itemWidthCustomStatusXp,
                              // decoration: new BoxDecoration(
                              // color: Colors.purple,
                              //   gradient: new RadialGradient(
                              //     colors: [Colors.red, Colors.cyan, Colors.purple, Colors.lightGreenAccent],
                              //     center: Alignment(-0.7, -0.6),
                              //     radius: 0.2,
                              //     tileMode: TileMode.clamp,
                              //     stops: [0.3, 0.5, 0.6, 0.7]
                              //   ),
                              // ),
                              decoration: new BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),

                                color: Color(0xff707070),
                                //   border: Border.all(
                                //   color: Color(0x61fdd800), //                   <--- border color
                                //   width: 2.0,
                                // ),
                              ),
                            ),
                            Container(
                              height: 8.0,
                              width: 100.0,
                              decoration: new BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                boxShadow: [
                                  new BoxShadow(
                                      color: Color(0xffffd500),
                                      offset: new Offset(0.0, 0.0),
                                      blurRadius: 2.0,
                                      spreadRadius: 0.5)
                                ],
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xffffeb00),
                                    Color(0xfff2a519)
                                  ],
                                  // begin: Alignment(1.0, 2.0),
                                  // end: Alignment(-1.0, -2.0),
                                ),

                                // border: Border.all(
                                //   color: Color(0x61fdd800), //                   <--- border color
                                //   width: 2.0,
                                // ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Text(
                            "Lv.$level",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: textColor2,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 20.0,
                                height: 20.0,
                                child: new Image.asset(
                                  "assets/images/cookies.png",
                                  // fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  "$cookies",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: textColor2,
                                      fontWeight: FontWeight.bold),
                                  // fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Followers",
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: textColor1,
                                        fontWeight: FontWeight.bold),
                                    // fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "$followers",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: textColor2,
                                        fontWeight: FontWeight.bold),
                                    // fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Following",
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: textColor1,
                                        fontWeight: FontWeight.bold),
                                    // fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "$followings",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: textColor2,
                                        fontWeight: FontWeight.bold),
                                    // fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // Widget _buildListView(List<Profile> profiles) {
  //     return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  //     child: ListView.builder(
  //       itemBuilder: (context, index) {
  //         Profile profile = profiles[index];
  //         return Padding(
  //           padding: const EdgeInsets.only(top: 8.0),
  //           child: Card(
  //             child: Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   Text(
  //                     profile.name,
  //                     style: Theme.of(context).textTheme.title,
  //                   ),
  //                   Text(profile.email),
  //                   Text(profile.age.toString()),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: <Widget>[
  //                       FlatButton(
  //                         onPressed: () {
  //                           showDialog(
  //                               context: context,
  //                               builder: (context) {
  //                                 return AlertDialog(
  //                                   title: Text("Warning"),
  //                                   content: Text(
  //                                       "Are you sure want to delete data profile ${profile.name}?"),
  //                                   actions: <Widget>[
  //                                     FlatButton(
  //                                       child: Text("Yes"),
  //                                       onPressed: () {
  //                                         Navigator.pop(context);
  //                                         apiService
  //                                             .deleteProfile(profile.id)
  //                                             .then((isSuccess) {
  //                                           if (isSuccess) {
  //                                             setState(() {});
  //                                             Scaffold.of(this.context)
  //                                                 .showSnackBar(SnackBar(
  //                                                     content: Text(
  //                                                         "Delete data success")));
  //                                           } else {
  //                                             Scaffold.of(this.context)
  //                                                 .showSnackBar(SnackBar(
  //                                                     content: Text(
  //                                                         "Delete data failed")));
  //                                           }
  //                                         });
  //                                       },
  //                                     ),
  //                                     FlatButton(
  //                                       child: Text("No"),
  //                                       onPressed: () {
  //                                         Navigator.pop(context);
  //                                       },
  //                                     )
  //                                   ],
  //                                 );
  //                               });
  //                         },
  //                         child: Text(
  //                           "Delete",
  //                           style: TextStyle(color: Colors.red),
  //                         ),
  //                       ),
  //                       FlatButton(
  //                         // onPressed: () {
  //                         //   Navigator.push(context,
  //                         //       MaterialPageRoute(builder: (context) {
  //                         //     return FormAddScreen(profile: profile);
  //                         //   }));
  //                         // },
  //                         child: Text(
  //                           "Edit",
  //                           style: TextStyle(color: Colors.blue),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //       itemCount: profiles.length,
  //     ),
  //   );

  // }

}

//  Container(
//         color: backgroundPrimary,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Column(
//             children: <Widget>[
//               HeaderProfileFull(),
//               EditProfile(),
//               SparatorHeaderSoaial(),
//               SosialMedia(),
//               SparatorHeaderAchivement(),
//               Achievementfull(),
//               SparatorHeaderCategori(),
//               Categori(),
//               Categori2(),
//               SparatorHeaderdaily(),
//               DailyMission(),
//               SparatorHeaderMatch(),
//               UpcomingMatch(),
//             ],
//           ),
//         ),
//       ),

class HeaderProfileFull extends StatefulWidget {
  // var data;
  @override
  _HeaderProfileFullState createState() => _HeaderProfileFullState();
}

class _HeaderProfileFullState extends State<HeaderProfileFull> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = (size.width - 10) / 3;
    final double itemWidthCustom = ((size.width - 10) / 3) * 2;
    final double itemWidthCustomStatusXp = (((size.width - 10) / 3) * 2) - 70;

    final double itemWidth2 = (size.width / 3) * 2;

    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(5.0),
          // padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          color: backgroundSecond,
          child: Row(
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                height: itemWidth,
                width: itemWidth,
                child: new Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Container(
                        color: Color(0xFF151a1d),
                        child: new Image.network(
                            "https://res.cloudinary.com/yamisok/image/upload/v1523937089/profile/skwqq3grrxcpf4tybsim.jpg"),
                      )),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 10.0, bottom: 5.0),
                // color: Colors.amber,
                width: itemWidthCustom,
                height: itemWidth,
                child: new Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Adang Sutisna",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: textColor2,
                              fontWeight: FontWeight.bold),
                          // fontWeight: FontWeight.bold),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 22.0,
                                padding: const EdgeInsets.all(5.0),
                                color: backgroundYellow,
                                child: new Image.asset(
                                    "assets/images/crown.png",
                                    fit: BoxFit.cover),
                                // child: Text(
                                //   "W",
                                //   style: TextStyle(
                                //       fontSize: 12.0,
                                //       color: backgroundPrimary,
                                //       fontWeight: FontWeight.bold),
                                //   // fontWeight: FontWeight.bold),
                                // ),
                              ),
                              Container(
                                height: 22.0,
                                padding: const EdgeInsets.all(5.0),
                                color: backgroundPrimary,
                                child: Text(
                                  "VIP",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: backgroundYellow,
                                      fontWeight: FontWeight.bold),
                                  // fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "XP",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: textColor2,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 8.0,
                              width: itemWidthCustomStatusXp,
                              // decoration: new BoxDecoration(
                              // color: Colors.purple,
                              //   gradient: new RadialGradient(
                              //     colors: [Colors.red, Colors.cyan, Colors.purple, Colors.lightGreenAccent],
                              //     center: Alignment(-0.7, -0.6),
                              //     radius: 0.2,
                              //     tileMode: TileMode.clamp,
                              //     stops: [0.3, 0.5, 0.6, 0.7]
                              //   ),
                              // ),
                              decoration: new BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),

                                color: Color(0xff707070),
                                //   border: Border.all(
                                //   color: Color(0x61fdd800), //                   <--- border color
                                //   width: 2.0,
                                // ),
                              ),
                            ),
                            Container(
                              height: 8.0,
                              width: 100.0,
                              decoration: new BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                boxShadow: [
                                  new BoxShadow(
                                      color: Color(0xffffd500),
                                      offset: new Offset(0.0, 0.0),
                                      blurRadius: 2.0,
                                      spreadRadius: 0.5)
                                ],
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xffffeb00),
                                    Color(0xfff2a519)
                                  ],
                                  // begin: Alignment(1.0, 2.0),
                                  // end: Alignment(-1.0, -2.0),
                                ),

                                // border: Border.all(
                                //   color: Color(0x61fdd800), //                   <--- border color
                                //   width: 2.0,
                                // ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Text(
                            "Lv.399",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: textColor2,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 20.0,
                                height: 20.0,
                                child: new Image.asset(
                                  "assets/images/cookies.png",
                                  // fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                "1.5k",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: textColor2,
                                    fontWeight: FontWeight.bold),
                                // fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Followers",
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: textColor1,
                                        fontWeight: FontWeight.bold),
                                    // fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "30",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: textColor2,
                                        fontWeight: FontWeight.bold),
                                    // fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Following",
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: textColor1,
                                        fontWeight: FontWeight.bold),
                                    // fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "10",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: textColor2,
                                        fontWeight: FontWeight.bold),
                                    // fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      color: Color(0xFF2f3336),
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'You have 25 days left for your Subscription',
            style: TextStyle(
                fontSize: 12.0,
                color: Color(0xFFcccccc),
                fontWeight: FontWeight.bold),
          ),
          Container(
              height: 30.0,
              width: 90.0,
              decoration: new BoxDecoration(
                color: backgroundYellow,
                // ,
                // border: new Border.all(
                //     color: Colors.green,
                //     width: 5.0,
                //     style: BorderStyle.solid
                // ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Center(
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ))
        ],
      ),
    );
  }
}

class SparatorHeaderSoaial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Follow Me",
            style: TextStyle(
              fontSize: 16.0,
              color: textColor1,
            ),
            // fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class SosialMedia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = (size.width - 10) / 5;
    final double itemWidth2 = (size.width / 3) * 2;
    return Container(
      padding: const EdgeInsets.all(5.0),
      // padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Row(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
            height: 35.0,
            width: itemWidth,
            child: new Container(
              decoration: new BoxDecoration(
                // ,
                // border: new Border.all(
                //     color: Colors.green,
                //     width: 5.0,
                //     style: BorderStyle.solid
                // ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Container(
                    color: Color(0xFF3b5998),
                    child: Center(
                      child: Text(
                        "Facebook",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                        // fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            ),
          ),
          new Container(
            padding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
            height: 35.0,
            width: itemWidth,
            child: new Container(
              decoration: new BoxDecoration(
                // ,
                // border: new Border.all(
                //     color: Colors.green,
                //     width: 5.0,
                //     style: BorderStyle.solid
                // ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Container(
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //   color: Color(0xFF34424e),
                      //   width: 1,
                      // ),
                      borderRadius: BorderRadius.all(Radius.circular(
                              10.0) //         <--- border radius here
                          ),
                      gradient: LinearGradient(
                        colors: [Color(0xFF5b92ff), Color(0xFF33ccff)],
                        begin: Alignment(-1.0, -2.0),
                        end: Alignment(1.0, 2.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "twitter",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                        // fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            ),
          ),
          new Container(
            padding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
            height: 35.0,
            width: itemWidth,
            child: new Container(
              decoration: new BoxDecoration(
                // ,
                // border: new Border.all(
                //     color: Colors.green,
                //     width: 5.0,
                //     style: BorderStyle.solid
                // ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Container(
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //   color: Color(0xFF34424e),
                      //   width: 1,
                      // ),
                      borderRadius: BorderRadius.all(Radius.circular(
                              10.0) //         <--- border radius here
                          ),
                      gradient: LinearGradient(
                        colors: [Color(0xFF0c1c44), Color(0xFF1d3e80)],
                        begin: Alignment(-1.0, -2.0),
                        end: Alignment(1.0, 2.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "STEAM",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                        // fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            ),
          ),
          new Container(
            padding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
            height: 35.0,
            width: itemWidth,
            child: new Container(
              decoration: new BoxDecoration(
                // ,
                // border: new Border.all(
                //     color: Colors.green,
                //     width: 5.0,
                //     style: BorderStyle.solid
                // ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Container(
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //   color: Color(0xFF34424e),
                      //   width: 1,
                      // ),
                      borderRadius: BorderRadius.all(Radius.circular(
                              10.0) //         <--- border radius here
                          ),
                      gradient: LinearGradient(
                        colors: [Color(0xFFc70505), Color(0xFFf90000)],
                        begin: Alignment(-1.0, -2.0),
                        end: Alignment(1.0, 2.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Youtube",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                        // fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            ),
          ),
          new Container(
            padding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
            height: 35.0,
            width: itemWidth,
            child: new Container(
              decoration: new BoxDecoration(
                // ,
                // border: new Border.all(
                //     color: Colors.green,
                //     width: 5.0,
                //     style: BorderStyle.solid
                // ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Container(
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //   color: Color(0xFF34424e),
                      //   width: 1,
                      // ),
                      borderRadius: BorderRadius.all(Radius.circular(
                              10.0) //         <--- border radius here
                          ),
                      gradient: LinearGradient(
                        colors: [Color(0xFFae0f60), Color(0xFFdc443e)],
                        begin: Alignment(-1.0, -2.0),
                        end: Alignment(1.0, 2.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Instagram",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                        // fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class SparatorHeaderAchivement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Recent Achievements",
            style: TextStyle(
              fontSize: 16.0,
              color: textColor1,
            ),
            // fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

 Widget _buildAchievement(List<Achievement> achievements) {
    var size = globals.varMediaQuery;
    //  var size = MediaQuery.of(context).size;

    

    final double itemWidth = (size.width - 10) / 3;

    final double itemWidthCustum = (itemWidth * 2) + (itemWidth / 2);
    final double itemWidthAchivement =
        ((size.width - 10) / 3) + (itemWidth / 2) - 5;
    final double itemHeight = (size.width - 10) / 3;
    final double itemWidth2 = (size.width / 3) * 2;

    // return Stack();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          // Achievement achievements = achievements[index];
          return Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                                  "CS GO Yamisok Open Tournament Season 2",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: textColor2,
                                  ),
                                  // fontWeight: FontWeight.bold),
                                ),
                              ),
              ),
            ),
          );
        }
    ),
    );
 }

class Achievementfull extends StatefulWidget {
  @override
  _AchievementfullState createState() => _AchievementfullState();
}

class _AchievementfullState extends State<Achievementfull> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = (size.width - 10) / 3;

    final double itemWidthCustum = (itemWidth * 2) + (itemWidth / 2);
    final double itemWidthAchivement =
        ((size.width - 10) / 3) + (itemWidth / 2) - 5;
    final double itemHeight = (size.width - 10) / 3;
    final double itemWidth2 = (size.width / 3) * 2;

    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(5.0),
          // padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(
                      left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
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
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              child: Container(
                                child: new Image.asset(
                                  "assets/images/achivement1.png",
                                  // fit: BoxFit.cover,
                                ),
                              )),
                        ),

                        Container(
                          width: itemWidthAchivement,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "CS GO Yamisok Open Tournament Season 2",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: textColor2,
                                ),
                                // fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              new Text(
                                "1st Place",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: backgroundYellow,
                                    fontWeight: FontWeight.bold),
                                // fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: <Widget>[
                        //     Container(
                        //       child: Expanded(
                        //         child: Text(
                        //         "My Community ddd",
                        //         style: TextStyle(
                        //           fontSize: 16.0,
                        //           color: textColor1,
                        //         ),
                        //         // fontWeight: FontWeight.bold),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.only(
                      left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
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
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              child: Container(
                                child: new Image.asset(
                                  "assets/images/achivement1.png",
                                  // fit: BoxFit.cover,
                                ),
                              )),
                        ),

                        Container(
                          width: itemWidthAchivement,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "CS GO Yamisok Open Tournament Season 2",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: textColor2,
                                ),
                                // fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              new Text(
                                "1st Place",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: backgroundYellow,
                                    fontWeight: FontWeight.bold),
                                // fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: <Widget>[
                        //     Container(
                        //       child: Expanded(
                        //         child: Text(
                        //         "My Community ddd",
                        //         style: TextStyle(
                        //           fontSize: 16.0,
                        //           color: textColor1,
                        //         ),
                        //         // fontWeight: FontWeight.bold),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SparatorHeaderCategori extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Categories",
            style: TextStyle(
              fontSize: 16.0,
              color: textColor1,
            ),
            // fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class Categori extends StatefulWidget {
  @override
  _CategoriState createState() => _CategoriState();
}

class _CategoriState extends State<Categori> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = (size.width - 10) / 3;
    final double itemWidthicon = itemWidth / 2.2;
    final double itemWidth2 = (size.width / 3) * 2;

    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
          // padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Row(
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                height: itemWidth,
                width: itemWidth,
                child: new Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF34424e),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0) //         <--- border radius here
                        ),
                    gradient: LinearGradient(
                      // colors: [fristColor, secondColor],
                      colors: [fristColor, secondColor],

                      begin: Alignment(-1.0, -2.0),
                      end: Alignment(1.0, 2.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Container(
                            child: new Image.asset(
                                "assets/images/categori_GameConnect.png",
                                fit: BoxFit.cover,
                                height: itemWidthicon),
                          )),
                      Text(
                        "Game Connect",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: textColor1,
                        ),
                        // fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                height: itemWidth,
                width: itemWidth,
                child: new Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Container(
                            child: new Image.asset(
                                "assets/images/categori_Statistics.png",
                                fit: BoxFit.cover,
                                height: itemWidthicon),
                          )),
                      Text(
                        "Statistics",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: textColor1,
                        ),
                        // fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                height: itemWidth,
                width: itemWidth,
                child: new Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Container(
                            child: new Image.asset(
                                "assets/images/categori_Team.png",
                                fit: BoxFit.cover,
                                height: itemWidthicon),
                          )),
                      Text(
                        "Team",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: textColor1,
                        ),
                        // fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              //  new Container(
              //    padding: const EdgeInsets.all(10.0),
              //    height: itemWidth,
              //    width: itemWidth2,
              //    child: new Container(
              //      decoration: new BoxDecoration(
              //        color: contentBackground,
              //        // border: new Border.all(
              //        //     color: Colors.green,
              //        //     width: 5.0,
              //        //     style: BorderStyle.solid
              //        // ),
              //        borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //      ),
              //      child: ClipRRect(
              //        borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //          child: new Image.network(
              //              "https://res.cloudinary.com/yamisok/image/upload/v1523937089/profile/skwqq3grrxcpf4tybsim.jpg")),
              //    ),
              //  ),
            ],
          ),
        ),
      ],
    );
  }
}

class Categori2 extends StatefulWidget {
  @override
  _Categori2State createState() => _Categori2State();
}

class _Categori2State extends State<Categori2> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = (size.width - 10) / 3;
    final double itemWidthicon = itemWidth / 2.2;
    final double itemWidth2 = (size.width / 3) * 2;

    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
          // padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Row(
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                height: itemWidth,
                width: itemWidth,
                child: new Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Container(
                            child: new Image.asset(
                                "assets/images/categori_MyCommunity.png",
                                fit: BoxFit.cover,
                                height: itemWidthicon),
                          )),
                      Text(
                        "My Community",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: textColor1,
                        ),
                        // fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                height: itemWidth,
                width: itemWidth,
                child: new Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Container(
                            child: new Image.asset(
                                "assets/images/categori_MyPost.png",
                                fit: BoxFit.cover,
                                height: itemWidthicon),
                          )),
                      Text(
                        "My Post",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: textColor1,
                        ),
                        // fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                height: itemWidth,
                width: itemWidth,
                child: new Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Container(
                            child: new Image.asset(
                                "assets/images/categori_Achievements.png",
                                fit: BoxFit.cover,
                                height: itemWidthicon),
                          )),
                      Text(
                        "Achievements",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: textColor1,
                        ),
                        // fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              //  new Container(
              //    padding: const EdgeInsets.all(10.0),
              //    height: itemWidth,
              //    width: itemWidth2,
              //    child: new Container(
              //      decoration: new BoxDecoration(
              //        color: contentBackground,
              //        // border: new Border.all(
              //        //     color: Colors.green,
              //        //     width: 5.0,
              //        //     style: BorderStyle.solid
              //        // ),
              //        borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //      ),
              //      child: ClipRRect(
              //        borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //          child: new Image.network(
              //              "https://res.cloudinary.com/yamisok/image/upload/v1523937089/profile/skwqq3grrxcpf4tybsim.jpg")),
              //    ),
              //  ),
            ],
          ),
        ),
      ],
    );
  }
}

class SparatorHeaderdaily extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Daily Mission",
            style: TextStyle(
              fontSize: 16.0,
              color: textColor1,
            ),
            // fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class DailyMission extends StatefulWidget {
  @override
  _DailyMissionState createState() => _DailyMissionState();
}

class _DailyMissionState extends State<DailyMission> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = (size.width - 10) / 3;

    final double itemWidthCustum = (itemWidth * 2) + (itemWidth / 2);
    final double itemWidthAchivement =
        ((size.width - 10) / 3) + (itemWidth / 2) - 5;
    final double itemHeight = (size.width - 10) / 3;
    final double itemWidth2 = (size.width / 3) * 2;

    final double itemWidthDaily = itemWidth / 2.5;

    return Container(
      padding: const EdgeInsets.all(5.0),
      // padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: new Container(
        padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
        child: new Container(
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Image.asset("assets/images/categori_GameConnect.png",
                        fit: BoxFit.cover, width: itemWidthDaily),
                    Expanded(
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Daily Mission Number 1",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: textColor1,
                                    fontWeight: FontWeight.bold),
                                // fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "250 Cookies",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: textColor1,
                                    fontWeight: FontWeight.bold),
                                // fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Claim",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: backgroundYellow,
                            fontWeight: FontWeight.bold),
                        // fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Image.asset("assets/images/categori_GameConnect.png",
                        fit: BoxFit.cover, width: itemWidthDaily),
                    Expanded(
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Daily Mission Number 1",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: textColor1,
                                    fontWeight: FontWeight.bold),
                                // fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "250 Cookies",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: textColor1,
                                    fontWeight: FontWeight.bold),
                                // fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Claimed",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: textColor1,
                            fontWeight: FontWeight.bold),
                        // fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SparatorHeaderMatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Upcoming Match",
            style: TextStyle(
              fontSize: 16.0,
              color: textColor1,
            ),
            // fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class UpcomingMatch extends StatefulWidget {
  @override
  _UpcomingMatchState createState() => _UpcomingMatchState();
}

class _UpcomingMatchState extends State<UpcomingMatch> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = (size.width - 10) / 3;

    final double itemWidthCustum = (itemWidth * 2) + (itemWidth / 2);
    final double itemWidthAchivement =
        ((size.width - 10) / 3) + (itemWidth / 2) - 5;
    final double itemHeight = (size.width - 10) / 3;
    final double itemWidth2 = (size.width / 3) * 2;

    final double itemWidthDaily = itemWidth / 2.5;

    return Container(
      padding: const EdgeInsets.all(5.0),
      // padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: new Container(
        padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
        child: new Container(
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0)),
                  color: Color(0xFF192024),
                ),
                height: 60.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Yamisok Open Tournament Mobile Smartfren  Mobile Smartfren",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: textColor1,
                                ),
                                // fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "20 Mar 18",
                            style: TextStyle(fontSize: 14.0, color: textColor1),
                            // fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "07:00",
                            style: TextStyle(fontSize: 14.0, color: textColor1),
                            // fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  new Image.asset("assets/images/categori_GameConnect.png",
                      fit: BoxFit.cover, width: itemWidthDaily),
                  Expanded(
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Daily Mission Number 1",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: textColor1,
                                  fontWeight: FontWeight.bold),
                              // fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "0",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: textColor1,
                          fontWeight: FontWeight.bold),
                      // fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  new Image.asset("assets/images/categori_GameConnect.png",
                      fit: BoxFit.cover, width: itemWidthDaily),
                  Expanded(
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Daily Mission Number 1",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: textColor1,
                                  fontWeight: FontWeight.bold),
                              // fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "2",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: textColor1,
                          fontWeight: FontWeight.bold),
                      // fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//data lama
class HeaderProfileNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              elevation: 10.0,
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Row(
                  // mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Boston (BOS)',
                                style: dropDownLableStylSsearch,
                              )),
                          Divider(
                            color: Colors.grey,
                            height: 20.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'New York city (JFK)',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 3,
                      child: Icon(
                        Icons.import_export,
                        color: Colors.black,
                        size: 32.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class HeaderProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 3;
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)),
            child: Container(
              height: itemWidth,
              color: contentBackground,
              child: Image.network(
                "http://theelevationawards.com/wp-content/uploads/2016/04/Elevation-Awards-Logo-300x214.png",
                width: itemWidth,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HeaderProfile2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            // borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Container(
              color: contentBackground,
              height: 146.0,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 100.0,
                        height: 100.0,
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: SizedBox(
                                child: CircularProgressIndicator(),
                                height: 20.0,
                                width: 20.0,
                              ),
                            ),
                            Center(
                              // child: FadeInImage.memoryNetwork(
                              //   placeholder: kTransparentImage,
                              //   image:
                              //       'https://res.cloudinary.com/yamisok/image/upload/v1523937089/profile/skwqq3grrxcpf4tybsim.jpg',
                              // ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          color: Colors.yellow,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, top: 5.0),
                                        child: Text(
                                          'Adang Sutisna',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'New Sheriff in Town',
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Color(0xFF959595),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0, top: 5.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'level',
                                            style: TextStyle(
                                                fontSize: 9.0,
                                                color: Color(0xFF959595),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10.0, left: 10.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '35',
                                            style: TextStyle(
                                                fontSize: 22.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              //bar status
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: 10.0,
                                  color: Colors.blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, top: 5.0),
                                        child: Text(
                                          'Adang Sutisna',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'New Sheriff in Town',
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Color(0xFF959595),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, top: 5.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'level',
                                            style: TextStyle(
                                                fontSize: 9.0,
                                                color: Color(0xFF959595),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '35',
                                            style: TextStyle(
                                                fontSize: 22.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10.0,
                        // child: Image.network(
                        //   '',

                        //   ),
                        child: Stack(
                          children: <Widget>[
                            Center(
                              // child: FadeInImage.memoryNetwork(
                              //   placeholder: kTransparentImage,
                              //   image: 'https://picsum.photos/250?image=9',
                              // ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Achievements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Container(
                  color: Color(0xFF151a1d),
                  height: 43.0,
                  width: 43.0,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.network(
                        "http://theelevationawards.com/wp-content/uploads/2016/04/Elevation-Awards-Logo-300x214.png"),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Container(
                  color: Color(0xFF151a1d),
                  height: 43.0,
                  width: 43.0,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.network(
                        "https://www.communityarchives.org.uk/wp-content/uploads/2015/12/Comm-Archive-Heritage-Award-logo-only-320x320.png"),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Container(
                  color: Color(0xFF151a1d),
                  height: 43.0,
                  width: 43.0,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.network(
                        "https://sitejerk.com/images/award-transparent-9.png"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CATEGORIES extends StatelessWidget {
  List<String> widgetList = [
    'https://sitejerk.com/images/award-transparent-9.png',
    'https://sitejerk.com/images/award-transparent-9.png',
    'https://sitejerk.com/images/award-transparent-9.png'
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;
    print(kToolbarHeight);
    print(size.width);
    print(size.height);

    return new Container(
      child: new GridView.count(
        crossAxisCount: 3,
        childAspectRatio: (itemWidth / itemWidth),
        controller: new ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: widgetList.map((String value) {
          return Padding(
            padding: const EdgeInsets.all(7.0),
            child: new Container(
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
              margin: new EdgeInsets.all(1.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(
                  child: Image.network(value),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
