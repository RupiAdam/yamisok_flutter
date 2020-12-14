import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:cloudinary_client/models/CloudinaryResponse.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yamisok/api/profile/profile_picture_api.dart';
import 'package:yamisok/component/globals.dart';
import 'package:yamisok/page/profile/profile_image_cropper.dart';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/page/utilities/style.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

class UpdateProfilePicturePage extends StatefulWidget {
  final String dataAvatarUrl;
  final String dataShortbio;

  const UpdateProfilePicturePage({Key key, this.dataAvatarUrl, this.dataShortbio}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UpdateProfilePictureState();
  }
}

class _UpdateProfilePictureState extends State<UpdateProfilePicturePage> {
  String _avatarUrl;
  String _token;
  int _playerId;
  String _username;
  int _currentStatusLength = 0;
  bool _isImageChanged = false;
  File _selectedFile;
  int _state = 0;

  TextEditingController _inputController = TextEditingController();
  CloudinaryClient _cloudinaryClient = CloudinaryClient(
      CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET, CLOUDINARY_CLOUD_NAME);

  Future<Null> fetchSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString("token");
      _playerId = prefs.getInt("id_player");
      // _avatarUrl = prefs.getString("avatar_url");
      _username = prefs.getString("username");
    });
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
    fetchSharedPref();
    analytics.logEvent(name: 'Update_profile_piture');

    _inputController.text = widget.dataShortbio;

    setState(() {
      _avatarUrl = widget.dataAvatarUrl;
    });
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text("Ubah profil"),
          backgroundColor: backgroundPrimary,
          leading: IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () {
              if (_isImageChanged || _inputController.text.length > 0)
                _showDialogWarning();
              else
                Navigator.pop(context);
            },
          )),
      body: _parent(),
    );
  }

  Widget _parent() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.all(16),
      color: backgroundPrimary,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[_groupInput(), _buttonSave()],
      ),
    );
  }

  Widget _groupInput() {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          (_isImageChanged) ? _profileImageFile() : _profileImage(),
          _buttonChangePicture(),
          _labelStatus(),
          _inputStatus(),
          _labelMaxChar()
        ],
      ),
    );
  }

  Widget _profileImage() {
    var mediaquery = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        _selectPicture();
      },
      child: Container(
        margin: EdgeInsets.only(top: 16),
        width: double.infinity,
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                height: 100,
                child: Center(
                  child: new Image.asset(
                    "assets/images/smiley.png",
                    height: mediaquery.width / 25,
                  ),
                ),
                color: Color(0xFF141A1D),
              ),
              Positioned(
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(_avatarUrl ??
                                'https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/2e830410-63fc-4dfc-9443-3fdec18570c0.png'))),
                  ),
                )
              )
            ],
          ),

          // child: Container(
          //   width: 100,
          //   height: 100,
          //   decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       image: DecorationImage(
          //           fit: BoxFit.fill,
          //           image: NetworkImage(_avatarUrl ??
          //               'https://cdn.zeplin.io/5ce628d2578b652ab8bdaa79/assets/2e830410-63fc-4dfc-9443-3fdec18570c0.png'))),
          // ),
        ),
      ),
    );
  }

  Widget _profileImageFile() {
    var store = StoreProvider.of<AppState>(context);
    return GestureDetector(
      onTap: () {
        _selectPicture();
      },
      child: Container(
        margin: EdgeInsets.only(top: 16),
        width: double.infinity,
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            child: CircleAvatar(
              backgroundColor: backgroundPrimary,
              backgroundImage: FileImage(File(store.state.new_profile_picture)),
              radius: 100,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonChangePicture() {
    return Container(
      width: double.infinity,
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _selectPicture();
            },
            borderRadius: BorderRadius.circular(10),
            splashColor: accent,
            child: Container(
              height: 40,
              width: 130,
              child: Center(
                child: Text(
                  'Ganti foto profil',
                  style: TextStyle(color: accent, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _labelStatus() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 16, left: 16),
      child: Text(
        "Status Kamu",
        style:
            TextStyle(fontFamily: "Proxima", color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _inputStatus() {
    return Container(
      decoration: BoxDecoration(
          color: inputBackground,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      child: TextField(
        autofocus: true,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: "update status ...",
            hintStyle:
                TextStyle(color: inputHintColor, fontStyle: FontStyle.italic),
            border: InputBorder.none,
            counterText: ''),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.multiline,
        controller: _inputController,
        maxLines: null,
        minLines: 3,
        maxLength: 70,
        onChanged: (value) {
          setState(() {
            _currentStatusLength = value.length;
          });
        },
      ),
    );
  }

  Widget _labelMaxChar() {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(top: 10, right: 16),
      child: Text(
        "$_currentStatusLength/70 karakter",
        style:
            TextStyle(fontFamily: "Proxima", color: textColor1, fontSize: 16),
      ),
    );
  }

  Widget _buttonSave() {
    var mediaquery = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: mediaquery.width / buttonHeight1,
      child: ButtonTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        buttonColor: accent,
        minWidth: double.infinity,
        height: mediaquery.width / buttonHeight1,
        child: RaisedButton(
          disabledTextColor: buttonDisabledText,
          disabledColor: buttonDisabledBackgroud,
          onPressed: (_state == 1)
              ? null
              : () {
                  setState(() {
                    _state = 1;
                  });
                  if (_isImageChanged)
                    _uploadImage();
                  else
                    _saveProfilePicture(_avatarUrl);
                },
          child: _buttonIndicator(),
        ),
      ),
    );
  }

  Widget _buttonIndicator() {
    if (_state == 0) {
      return Text("Selesai", style: buttonTextStyle);
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      );
    }
  }

  _selectPicture() async {
    _selectedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (_selectedFile.path != null) {
      print('path: ${_selectedFile.path}');
      setState(() {
        _isImageChanged = true;
      });

      var store = StoreProvider.of<AppState>(context);
      store.state.new_profile_picture = _selectedFile.path;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileImgaeCropperPage()),
      );
    }
  }

  _uploadImage() async {
    var store = StoreProvider.of<AppState>(context);
    CloudinaryResponse response = await _cloudinaryClient.uploadImage(
        store.state.new_profile_picture,
        filename: 'profile_picture_$_playerId');
    _saveProfilePicture(response.secure_url);
  }

  _saveProfilePicture(String url) async {
    ApiServiceProfilePicture.saveProfilePicture(
            _username, _playerId, _token, url, _inputController.text)
        .then((resp) {
      print('return api $resp');
      var data = json.decode(resp);
      var status = data['status'];

      setState(() {
        _state = 0;
      });

      if (status == 200) {
        updateProfilePictureOnLocal(url);
        Navigator.pop(context, "succes");

        if (_inputController.text.length > 0)
          _updateProfileStatus(_inputController.text);
      } else {
        var message = data['messages'];
        _showDialog(message);
      }
    });
  }

  _updateProfileStatus(String status) {
    ApiServiceProfilePicture.updateStatus(_username, _playerId, _token, status)
        .then((resp) {
      print('return api status $resp');
      var data = json.decode(resp);
      var status = data['status'];

      setState(() {
        _state = 0;
      });

      if (status == 200) {
        Navigator.pop(context, "succes");
      } else {
        var message = data['messages'];
        _showDialog(message);
      }
    });
  }

  _showDialog(String description) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          content: new Text(description),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new RaisedButton(
              padding: EdgeInsets.all(13),
              color: accent,
              child: new Text(
                "Tutup",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showDialogWarning() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          content: Text("Apakah Anda akan membatalkan perubahan yang dibuat?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Batalkan Perubahan",
                    style: TextStyle(color: Colors.black))),
            RaisedButton(
              padding: EdgeInsets.all(13),
              color: accent,
              child: Text(
                "Lanjutkan",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> updateProfilePictureOnLocal(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("avatar_url", url);
  }
}
