// Imports the Flutter Driver API.
import 'dart:io';
	
import 'package:intl/intl.dart';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
    
    var now = new DateTime.now();
    var date = new DateFormat("dd-MM-yyyy").format(now);
    var time = DateFormat("H-m-s").format(now);
    print('date runing test'+ new DateFormat("dd-MM-yyyy").format(now));
    print('time runing test'+new DateFormat("H-m-s").format(now)); 
    var nowdatetime = date + " " + time;
  group('Counter App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    // final counterTextFinder = find.byValueKey('counter');
    final fieldusername = find.byValueKey('fieldusername');
    final fieldpass = find.byValueKey('fieldpassword');
    // final buttonlogin = find.byValueKey('buttonlogin');
     

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
       Directory('test_driver/screenshots/$nowdatetime').create();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    // test('starts at 0', () async {
    //   // Use the `driver.getText` method to verify the counter starts at 0.
    //   expect(await driver.getText(counterTextFinder), "0");
    // });

    takeScreenshot(FlutterDriver driver, String path) async {
    final List<int> pixels = await driver.screenshot();
    final File file = new File(path);
    await file.writeAsBytes(pixels);
    print(path);
    }
   
    test('splash screen', () async {
      // First, tap the button.
      await Future.delayed(Duration(milliseconds: 1000));
       await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/1_splash1.png');
      await driver.tap(find.text('Next'));
      await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/2_splash2.png');
      await driver.tap(find.text('Next'));
      await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/3_splash3.png');
      await driver.tap(find.text('Next'));
      await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/4_splash4.png');
      await driver.tap(find.text('LOGIN'));
      
     
    });
    
    test('login', () async {
      // First, tap the button.
      await Future.delayed(Duration(milliseconds: 1000));
      await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/5_login.png');
      await driver.tap(find.byValueKey('field_username'));
      await driver.enterText('adang');
      await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/6_login.png');
      await driver.tap(find.byValueKey('field_password'));
      await driver.enterText('sukses12');
      await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/7_login.png');
      await driver.tap(find.text('Login'));
      await Future.delayed(Duration(milliseconds: 10000));
       await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/8_home.png');
    });


    test('register', ()async{
      await Future.delayed(Duration(milliseconds: 2000));
      await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/9_term_condtions.png');
      await driver.tap(find.byValueKey('tern_conditions'));
    });

    // test('tapProfile', () async {
    //   // First, tap the button.
    //   await Future.delayed(Duration(milliseconds: 1000));
    //   await driver.tap(find.byValueKey('tabprofile'));
    //   await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/9_profile.png');
    //   // await driver.scrollIntoView(find.text('Tentang saya'));
    //   // await Future.delayed(Duration(milliseconds: 2000));
    //   await driver.scrollIntoView(find.byValueKey('tambahendorse'));
    //   await Future.delayed(Duration(milliseconds: 2000));
    //   await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/10_endorse.png');
    //   await driver.tap(find.byValueKey('tambahendorse'));
    //   await Future.delayed(Duration(milliseconds: 2000));
    //   await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/11_tambahendorse.png');
    // });

  });
}

 // await driver.tap(find.byValueKey('fieldusername'));
      // await driver.enterText('adang');
      // await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/1_login_usename.png');
      // await driver.tap(fieldpass);
      // await driver.enterText('sukses12');
      // await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/2_login_pass.png');
      // await Future.delayed(Duration(milliseconds: 5000));
      // await driver.tap(find.text('login_button'));
      // await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/3_login_tap.png');
     
      // await Future.delayed(Duration(milliseconds: 3000));
      // await takeScreenshot(driver, 'test_driver/screenshots/$nowdatetime/2_afterlogin.png');

      // await Future.delayed(Duration(milliseconds: 1000));
      // await driver.scrollIntoView(find.byValueKey('ESPORTS'));
      //  await driver.tap(buttonFinder);
      //   await driver.tap(buttonFinder);
      //    await driver.tap(buttonFinder);

      // Then, verify the counter text is incremented by 1.
      // expect(await driver.getText(counterTextFinder), "1");