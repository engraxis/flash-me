import 'package:flashme/res/static_info.dart';
import 'package:flashme/screens/profile_page.dart';
import 'package:flashme/screens/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../res/static_info.dart';
import 'landing_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Stack(children: <Widget>[
          Image.asset(
            'images/background.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/logo.png',
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                Image.asset(
                  'images/flashme.png',
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  checkUser() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser == null) {
      navigation(true);
    } else {
      StaticInfo.currentUser = firebaseUser;
      navigation(false);
    }
  }

  navigation(bool navigateToLogin) async {
    if (navigateToLogin)
      Future.delayed(Duration(seconds: 0), () {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (ctx) => SignIn()), (a) => false);
      });
    else {
      final result = await Firestore.instance
          .collection('users')
          .document(StaticInfo.currentUser.uid)
          .get();
      bool isProfileComplete = false;
      if (result != null) {
        isProfileComplete =
            result.data == null ? false : result.data['isProfileComplete'];
      }
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (ctx) =>
                    isProfileComplete ? LandingPage() : ProfilePage()),
            (a) => false);
      });
    }
  }
}
