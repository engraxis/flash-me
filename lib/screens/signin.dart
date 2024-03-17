import 'package:flashme/res/static_info.dart';
import 'package:flashme/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/landing_page.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool validate = false;
  bool forgot = false;
  bool sent = false;
  bool toggle = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  List<TextEditingController> cons =
      List.generate(2, (t) => TextEditingController());
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  double _rightToLeft;
  double _leftToRight;
  double _btt;
  bool isInit;
  bool runAnimation = false;
  bool disappear = false;
  int animationDuration = 1; //sec

  @override
  void initState() {
    // TODO: implement initState
    isInit = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (isInit) {
      _leftToRight = -100;
      _rightToLeft = -100;
      _btt = MediaQuery.of(context).size.height * 0.5;
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (!runAnimation) {
      Future.delayed(Duration(milliseconds: 500)).then((_) {
        runAnimation = true;
        setState(() {
          _rightToLeft = (MediaQuery.of(context).size.width) / 4;
          _leftToRight = MediaQuery.of(context).size.width / 4;
          _btt = MediaQuery.of(context).size.height * 0.5 -
              (MediaQuery.of(context).size.height * 0.5 -
                  MediaQuery.of(context).size.width * 0.5);
        });
      }).then((_) {
        Future.delayed(Duration(seconds: animationDuration)).then((_) {
          setState(() {
            disappear = true;
          });
        });
      });
    }
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.06),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.38,
                          child: Stack(
                            children: <Widget>[
                              AnimatedPositioned(
                                left: _leftToRight,
                                duration: Duration(seconds: animationDuration),
                                child: Image.asset(
                                  'images/logo.png',
                                  height:
                                      MediaQuery.of(context).size.width * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                ),
                              ),
                              if (!disappear)
                                AnimatedPositioned(
                                  right: _rightToLeft,
                                  duration:
                                      Duration(seconds: animationDuration),
                                  child: Image.asset(
                                    'images/logo.png',
                                    height:
                                        MediaQuery.of(context).size.width * 0.5,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                  ),
                                ),
                              if (disappear)
                                Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.5,
                                ),
                              AnimatedPositioned(
                                width: MediaQuery.of(context).size.width,
                                top: _btt,
                                duration: Duration(seconds: animationDuration),
                                child: Center(
                                  child: Image.asset(
                                    'images/flashme.png',
                                    alignment: Alignment.centerRight,
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Form(
                        key: key,
                        child: Column(
                          children: <Widget>[
                            forgot == true
                                ? SizedBox(
                                    height: sent == false
                                        ? MediaQuery.of(context).size.height /
                                            20
                                        : MediaQuery.of(context).size.height /
                                            15,
                                  )
                                : Container(),
                            sent == true
                                ? Text(
                                    'SENT',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                9,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Container(),
                            sent == true
                                ? SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 50,
                                  )
                                : Container(),
                            sent == true
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width / 7,
                                    ),
                                    child: Text(
                                      'Please follow the instructions in the email to reset your password. You may need to check your spam folder.',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : Container(),
                            forgot == true
                                ? sent == false
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                9,
                                            vertical: 0),
                                        child: Text(
                                          'Please enter your email address and we will send you password reset instructions.',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Container()
                                : Container(),
                            SizedBox(height: 20),
                            sent == false
                                ? showTextField('Email', 0, 0)
                                : Container(),
                            forgot == false
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                120),
                                    child: showTextField('Password', 1, 1))
                                : Container(),
                            Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width / 8.5,
                                  top: MediaQuery.of(context).size.height / 100,
                                  bottom:
                                      MediaQuery.of(context).size.height / 100),
                              child: forgot == false
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              forgot = true;
                                            });
                                          },
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    25),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005),
                            sent == false
                                ? showRaisedButton(
                                    forgot == false ? 'LOGIN' : 'SEND')
                                : Container(),
                            SizedBox(
                              height: validate == false
                                  ? MediaQuery.of(context).size.height * 0.1
                                  : MediaQuery.of(context).size.height * 0.15,
                            ),
                            forgot == false
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) {
                                            return SignUp(false);
                                          },
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Don't have an account? Signup",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25),
                                        ),
                                        Text(
                                          ' Here.',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25),
                                        )
                                      ],
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        forgot = false;
                                        sent = false;
                                      });
                                    },
                                    child: Text(
                                      '< BACK',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //forgot == true ? showPopContainer() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showTextField(String a, int b, int c) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 20,
      ),
      child: TextFormField(
        controller: cons[b],
        validator: (val) {
          if (val.isEmpty) {
            setState(() {
              validate = true;
            });
            return 'Required Field.';
          } else {
            validate = false;
          }
        },
        obscureText: b == 1 ? toggle == false ? true : false : false,
        decoration: InputDecoration(
          hintText: a,
          prefixIcon: c == 0
              ? Icon(
                  Icons.email,
                  color: Colors.black,
                )
              : Icon(Icons.lock, color: Colors.black),
          suffixIcon: b == 1
              ? toggle == false
                  ? IconButton(
                      icon: Icon(
                        Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          toggle = !toggle;
                        });
                      },
                      color: Colors.black,
                    )
                  : IconButton(
                      icon: Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          toggle = !toggle;
                        });
                      },
                      color: Colors.black,
                    )
              : null,
          errorStyle: TextStyle(color: Colors.red),
          hintStyle:
              TextStyle(fontSize: MediaQuery.of(context).size.width / 33),
          filled: true,
          fillColor: Colors.white38,
          errorBorder: outlineInputBorder(false),
          focusedBorder: outlineInputBorder(true),
          enabledBorder: outlineInputBorder(true),
          focusedErrorBorder: outlineInputBorder(true),
        ),
      ),
    );
  }

  OutlineInputBorder outlineInputBorder(bool a) {
    Color c;
    if (a == true) {
      c = Colors.white;
    } else {
      c = Colors.red;
    }
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: c,
        ));
  }

  showRaisedButton(String a) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 20),
      child: ButtonTheme(
        height: 60,
        minWidth: MediaQuery.of(context).size.width,
        child: RaisedButton(
          child: Text(
            a,
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width / 20),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            if (forgot == false) {
              if (key.currentState.validate()) {
                showAlertDialog(context, 'Signing In', 1);
                await dealLogin();
              }
            } else {
              if (key.currentState.validate()) {
                await dealSubmit();
              }
            }
          },
        ),
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

  Widget showPopContainer() {
    return GestureDetector(
      onTap: () {
        setState(() {
          forgot = false;
          sent = false;
        });
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
          color: Colors.pink,
          borderRadius: BorderRadius.circular(12),
        ),
        height: MediaQuery.of(context).size.height / 15,
        width: MediaQuery.of(context).size.height / 15,
      ),
    );
  }

  showAlertDialog(BuildContext context, String a, int b) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return b == 1
              ? AlertDialog(
                  title: Text(a),
                  content: Container(
                    height: MediaQuery.of(context).size.height / 15,
                    width: MediaQuery.of(context).size.width / 10,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                          Color(0xFFFEC72E),
                        ),
                      ),
                    ),
                  ),
                )
              : Container();
        });
  }

  dealLogin() async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: cons[0].text.trim(), password: cons[1].text);
      StaticInfo.currentUser = result.user;
      Navigator.pop(context);

      var result1 = await Firestore.instance
          .collection('users')
          .document(StaticInfo.currentUser.uid)
          .get();
      bool isProfileComplete = false;
      if (result != null)
        isProfileComplete = result1.data == null
            ? false
            : result1.data['isProfileComplete'] == null
                ? false
                : result1.data['isProfileComplete'];
      if (isProfileComplete)
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (ctx) => LandingPage()), (t) => false);
      else
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (ctx) => ProfilePage()), (t) => false);
    } catch (e) {
      Navigator.pop(context);
      List a = e.toString().split(',');
      String b = a[1];
      print(b);
      if (b ==
          ' The password is invalid or the user does not have a password.') {
        showSnackBar('Password is Invalid');
      } else if (b ==
          ' There is no user record corresponding to this identifier. The user may have been deleted.') {
        showSnackBar(
            'There is no account associated with that email address. The account may have been deleted.');
      } else if (b == ' The email address is badly formatted.') {
        showSnackBar('Invalid Email Format');
      } else {
        showSnackBar(b);
      }
    }
  }

  dealSubmit() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: cons[0].text.trim());
      setState(() {
        sent = true;
      });
    } catch (e) {
      List a = e.toString().split(',');
      String b = a[1];
      print(b);
      if (b ==
          ' There is no user record corresponding to this identifier. The user may have been deleted.') {
        showSnackBar(
            'There is no account associated with that email address. The account may have been deleted.');
      } else if (b == ' The email address is badly formatted.') {
        showSnackBar('Invalid Email Format');
      } else {
        showSnackBar(b);
      }
    }
  }
}
