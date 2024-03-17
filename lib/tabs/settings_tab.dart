import 'package:flashme/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';

import '../res/constants.dart';
import '../res/static_info.dart';
import '../screens/signin.dart';
import '../screens/profile_edit_page.dart';
import '../screens/legal_text.dart';

class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab>
    with AutomaticKeepAliveClientMixin<SettingsTab> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey objectKey = GlobalKey();
  @override
  void initState() => super.initState();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.005,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white38,
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "MY QR CODE",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.07,
                            fontWeight: FontWeight.bold),
                      ),
                      RepaintBoundary(
                        key: objectKey,
                        child: QrImage(
                          data: StaticInfo.currentUser.uid,
                          size: MediaQuery.of(context).size.width * 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 60,
              ),
              showContainer('PRIVACY POLICY', 1),
              showContainer('TERMS & CONDITIONS', 1),
              SizedBox(
                height: MediaQuery.of(context).size.height / 60,
              ),
              //showContainer('Delete Account', 2),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 20),
                child: ButtonTheme(
                  height: MediaQuery.of(context).size.height / 12,
                  minWidth: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) => ProfileEditPage()),
                      );
                      StaticInfo.currentUser.reload();
                    },
                    color: Colors.white,
                    child: Text(
                      'EDIT PROFILE',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width / 15,
                          fontWeight: FontWeight.bold),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 60,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 20),
                child: ButtonTheme(
                  height: MediaQuery.of(context).size.height / 12,
                  minWidth: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (ctx) => SignIn()),
                            (_) => false);
                        StaticInfo.currentUser.reload();
                      } catch (e) {
                        List a = e.toString().split(',');
                        String b = a[1];
                        showSnackBar(b);
                      }
                    },
                    color: Colors.white,
                    child: Text(
                      'LOGOUT',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width / 15,
                          fontWeight: FontWeight.bold),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showContainer(String a, int b) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 100),
      child: GestureDetector(
        onTap: () async {
          if (b == 2) {
            showAlertdialog(context);
          }
          if (a == 'PRIVACY POLICY') {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => LegalText('pdfs/privacy_policy.pdf')));
          }
          if (a == 'TERMS & CONDITIONS') {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => LegalText('pdfs/terms_and_conditions.pdf')));
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 12,
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white38,
            border: Border.all(width: 1, color: Colors.white),
          ),
          child: b == 1
              ? Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 12),
                    child: Text(
                      a,
                      style: TextStyle(
                        color: Color(0xFF707070),
                        fontSize: b == 1 || b == 2
                            ? MediaQuery.of(context).size.width / 24
                            : MediaQuery.of(context).size.width / 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    a,
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: b == 1 || b == 2
                          ? MediaQuery.of(context).size.width / 24
                          : MediaQuery.of(context).size.width / 13,
                      fontWeight: b == 3 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget showPopContainer() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.height / 50,
            top: MediaQuery.of(context).size.height / 50),
        child: Center(
            child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        )),
        decoration: BoxDecoration(
          color: Color(0xFF09F2BC),
          borderRadius: BorderRadius.circular(12),
        ),
        height: MediaQuery.of(context).size.height / 15,
        width: MediaQuery.of(context).size.height / 15,
      ),
    );
  }

  showSnackBar(String a) {
    SnackBar snackBar = SnackBar(
      content: Text(a),
    );
    scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  showAlertdialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Are you sure you want to delete your Account?'),
          actions: <Widget>[
            FlatButton(
              textColor: Color(0xFF09F2BC),
              child: Text('Yes'),
              onPressed: () async {
                final dbref = FirebaseDatabase.instance.reference();
                try {
                  await dbref
                      .child(Constants.users)
                      .child(StaticInfo.currentUser.uid)
                      .remove();
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(builder: (ctx) => SignUp(true)),
                  //     (t) => false);
                } catch (e) {
                  Navigator.pop(context);
                  showSnackBar(e.toString());
                }
              },
            ),
            FlatButton(
              textColor: Color(0xFF09F2BC),
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
