import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/utilities/color.dart';
import 'package:yamisok/page/utilities/style.dart';

class ProfileImgaeCropperPage extends StatefulWidget{
	@override
	State<StatefulWidget> createState() => _ProfileImageCropSate();

}

class _ProfileImageCropSate extends State<ProfileImgaeCropperPage>{

	final cropKey = GlobalKey<CropState>();
	File _file;
	File _sample;
	File _lastCropped;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

	@override
	void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
		super.dispose();
		_file?.delete();
		_sample?.delete();
//		_lastCropped?.delete();
	}

	@override
	Widget build(BuildContext context) {
		var store = StoreProvider.of<AppState>(context);
		_sample = File(store.state.new_profile_picture);
		_file = File(store.state.new_profile_picture);
		return Scaffold(
			resizeToAvoidBottomInset: false,
			appBar: AppBar(
					title: Text("Ubah profil"),
					backgroundColor: backgroundPrimary,
					leading: IconButton(
						icon: Icon(Icons.chevron_left, color: Colors.white),
						onPressed: (){
							Navigator.pop(context);
						},
					)
			),
			body: Container(
				width: double.infinity,
				height: double.infinity,
				color: backgroundPrimary,
				child: Center(
					child: _buildCroppingImage(),
				),
			),
		);
	}

	Widget _buildCroppingImage() {
		return Container(
			child: Column(
			children: <Widget>[
			    Expanded(
			        child: Crop.file(_sample, key: cropKey, aspectRatio: 1/1,),
			    ),
			    Container(
			        alignment: AlignmentDirectional.center,
			        child: Row(
			            mainAxisAlignment: MainAxisAlignment.spaceAround,
			            children: <Widget>[
							_buttonSave(),
			            ],
			        ),
			    )
			],
			),
		);
	}

	Widget _buttonSave(){
		var mediaquery = MediaQuery.of(context).size;
		return Container(
			margin: EdgeInsets.only(bottom: 16, top: 16),
			width: mediaquery.width * 0.87,
			height: mediaquery.width/buttonHeight1,
			child: ButtonTheme(
				shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(5)
				),
				buttonColor: accent,
				minWidth: double.infinity,
				height: mediaquery.width/buttonHeight1,
				child: RaisedButton(
					onPressed: (){
						_cropImage();
					},
					child: Text(
						"Selesai",
						style: buttonTextStyle,
					),
				),
			),
		);
	}

	Future<void> _cropImage() async {
		final scale = cropKey.currentState.scale;
		final area = cropKey.currentState.area;
		if (area == null) {
			// cannot crop, widget is not setup
			return;
		}

		// scale up to use maximum possible number of pixels
		// this will sample image in higher resolution to make cropped image larger
		final sample = await ImageCrop.sampleImage(
			file: _file,
			preferredSize: (2000 / scale).round(),
		);

		final file = await ImageCrop.cropImage(
			file: sample,
			area: area,
		);

		sample.delete();

		_lastCropped?.delete();
		_lastCropped = file;

		var store = StoreProvider.of<AppState>(context);
		store.state.new_profile_picture = _lastCropped.path;

		Navigator.pop(context);
	}

}