import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yamisok/component/keyStore.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/page/utilities/style.dart';
import 'package:yamisok/page/login/login.dart' as menulogin;

class LandingPage extends StatefulWidget{

  static String route = 'landing-page';

  @override
  State<StatefulWidget> createState() {
    return new _LandingPageState();
  }

}

class _LandingPageState extends State<LandingPage>{

  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: _Parent(),
      ),
    );
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    super.initState();
  }


  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    super.dispose();
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 10.0,
      width: isActive ? 10.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive ? dotActive : dotInactive,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _Parent(){

    var height = MediaQuery.of(context).size.height;

    return new Container(
        color: landingBackgroundColor,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: height * 0.87,
                child: PageView(
                  physics: ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: <Widget>[
                    _Onboard1(),
                    _Onboard2(),
                    _Onboard3(),
                    _Onboard4(),
                  ],
                ),
              ),
              Container(
                // margin: EdgeInsets.only(bottom: 20),
                // height: height * 0.13,
                child: _currentPage != _numPages - 1
                    ? _buildPageIndicator()
                    : _showLoginButton(),
              )
            ],
          ),
      );
  }

  Widget _Onboard1() {
    return new Container(
      padding: EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image(
              image: AssetImage(
                'assets/images/landing/onboarding_1.png',
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          ),
          SizedBox(height: 30.0),
          Text(
            'Cari Teman Main Bareng',
            style: TextStyle(
              color: Color(0xFFf3c500),
              fontFamily: 'Oswald-Regular',
              fontSize: MediaQuery.of(context).size.width/textSize19sp,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.0),
          Text(
            'Sekarang gak perlu khawatir lagi main sendirian, karena di Yamisok kamu bisa cari teman main bareng sesuai dengan game favoritmu.',
            style: TextStyle(
              color: textColor2,
              fontSize: MediaQuery.of(context).size.width/textSize14sp,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _Onboard2() {
    return new Container(
      padding: EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image(
              image: AssetImage(
                'assets/images/landing/onboarding_2.png',
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          ),
          SizedBox(height: 30.0),
          Text(
            'Cari Tempat Main Bareng',
            style: TextStyle(
              color: Color(0xFFf3c500),
              fontFamily: 'Oswald-Regular',
              fontSize: MediaQuery.of(context).size.width/textSize19sp,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.0),
          Text(
            'Jelajahi tempat nongkrong dan mabar terdekat dari tempatmu. Kamu bisa dapatkan teman baru maupun aktivitas seru lainnya.',
            style: TextStyle(
              color: textColor2,
              fontSize: MediaQuery.of(context).size.width/textSize14sp,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _Onboard3() {
    return new Container(
      padding: EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image(
              image: AssetImage(
                'assets/images/landing/onboarding_3.png',
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          ),
          SizedBox(height: 30.0),
          Text(
            'Cari Teman Didekat Kamu',
            style: TextStyle(
              color: Color(0xFFf3c500),
              fontFamily: 'Oswald-Regular',
              fontSize: MediaQuery.of(context).size.width/textSize19sp,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.0),
          Text(
            'Udah gak jaman sekarang main sendirian. Cari teman main yang lokasinya ada disekitar kamu, ajak main dan dapetin teman sebanyak-banyaknya. Psstt, Siapa tau kamu juga bisa dapet jodoh disini...',
            style: TextStyle(
              color: textColor2,
              fontSize: MediaQuery.of(context).size.width/textSize14sp,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _Onboard4() {
    return new Container(
      padding: EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image(
              image: AssetImage(
                'assets/images/landing/onboarding_4.png',
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          ),
          SizedBox(height: 30.0),
          Text(
            'Event untuk diikuti',
            style: TextStyle(
              color: Color(0xFFf3c500),
              fontFamily: 'Oswald-Regular',
              fontSize: MediaQuery.of(context).size.width/textSize19sp,
              height: 1.5,
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            'Ada banyak event, turnamen maupun aktifitas di sekitar kamu. Pastikan kamu tetap up to date dan tidak ketinggalan event esports terdekat di sekitarmu.',
            style: TextStyle(
              color: textColor2,
              fontSize: MediaQuery.of(context).size.width/textSize14sp,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    List<Widget> list = [];
    list.add(_skipButton());
    list.add(SizedBox(width: 50.0,));
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    list.add(SizedBox(width: 50.0,));
    list.add(_nextButton());
    return new Container(
      padding: EdgeInsets.only(top: 16, bottom: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list,
      ),
    );
  }

  Widget _skipButton() {
    return new Opacity(
      opacity: 0.0,
      child:
        InkWell(
          onTap: null,
          child: Text(
            'Skip',
            style:
              TextStyle(color: textGrey,fontSize: 21.0),
          )
      ),
    );
  }

  Widget _nextButton() {
    return new InkWell(
      onTap: (){
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
      child: Text(
        'Next',
        style: TextStyle(
            color: textGrey,
            fontSize: 21.0
        ),
      ),
    );
  }

  Widget _showLoginButton() {

    var mediaquery = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      width: double.infinity,
      height: mediaquery.width / buttonHeight1,
      child: ButtonTheme(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
        ),
        buttonColor: backgroundYellow,
        minWidth: double.infinity,
        height: mediaquery.width / buttonHeight1,
        child: RaisedButton(
          onPressed: (){
            disableLandingPage();
            Navigator.pushReplacementNamed(context, menulogin.LoginSignUpPage.tag);
          },
          child: new Text('Login',
              style: new TextStyle(
                  fontSize: mediaquery.width / textSize17sp,
                  color: Colors.black,
                  fontFamily: 'ProximaBold')),
        ),
      ),
    );
  }

}