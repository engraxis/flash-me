import 'package:flashme/res/static_info.dart';
import 'package:flashme/screens/profile_page.dart';
import 'package:flashme/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'legal_text.dart';

class SignUp extends StatefulWidget {
  bool nav;

  SignUp(this.nav);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String reqId;
  bool toggle1 = false;
  bool toggle2 = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  List<TextEditingController> cons =
      List.generate(5, (t) => TextEditingController());
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/background.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Image.asset(
                      'images/logo.png',
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    Image.asset(
                      'images/flashme.png',
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Form(
                      key: key,
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height / 120),
                              child: showTextField('Email', 2, 1)),
                          Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height / 120),
                              child: showTextField('Password', 3, 0)),
                          Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height / 120),
                              child: showTextField('Confirm Password', 4, 0)),
                          showRaisedButton('SIGNUP'),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.021,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => LegalText(
                                          'pdfs/terms_and_conditions.pdf')));
                            },
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "By signing up, you agree to our",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.021),
                                ),
                                Text(
                                  'Terms & Conditions',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.021),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 70,
                        ),
                        child: Text('< BACK',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              //showPopContainer()
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
            return 'Required Field';
          } else {
            if (b == 2) {
              if (!isEmail(cons[2].text.trim())) {
                return 'Invalid Email Format';
              }
            }
            if (b == 3) {
              if (cons[3].text.trim().length < 6) {
                return 'Password MUST be at least 6 Characters';
              }
            }
            if (b == 4) {
              if (cons[3].text.trim() != cons[4].text.trim()) {
                return "Passwords don't Match";
              }
            }
          }
        },
        obscureText: b == 3
            ? toggle1 == false ? true : false
            : b == 4 ? toggle2 == false ? true : false : false,
        decoration: InputDecoration(
          hintText: a.trim(),
          prefixIcon: c == 1
              ? Icon(Icons.email, color: Colors.black)
              : Icon(Icons.lock, color: Colors.black),
          suffixIcon: b == 3
              ? toggle1 == false
                  ? IconButton(
                      icon: Icon(
                        Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          toggle1 = !toggle1;
                        });
                      },
                      color: Colors.black,
                    )
                  : IconButton(
                      icon: Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          toggle1 = !toggle1;
                        });
                      },
                      color: Colors.black,
                    )
              : b == 4
                  ? toggle2 == false
                      ? IconButton(
                          icon: Icon(
                            Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              toggle2 = !toggle2;
                            });
                          },
                          color: Colors.black,
                        )
                      : IconButton(
                          icon: Icon(Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              toggle2 = !toggle2;
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
          horizontal: MediaQuery.of(context).size.width / 20,
          vertical: MediaQuery.of(context).size.height / 57),
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
            if (key.currentState.validate()) {
              showAlertDialog(context, 'Signing Up', 1);
              await dealSignUp();
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
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget showPopContainer() {
    return GestureDetector(
      onTap: () {
        if (widget.nav == false) {
          Navigator.pop(context);
        } else {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (ctx) => SignIn()), (_) => false);
        }
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

  dealSignUp() async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: cons[2].text.trim(), password: cons[3].text.trim());
      reqId = result.user.uid;
      await dealLogin();
    } catch (e) {
      Navigator.pop(context);
      List a = e.toString().split(',');
      String b = a[1];
      showSnackBar(b);
    }
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
              email: cons[2].text.trim(), password: cons[3].text.trim());
      StaticInfo.currentUser = result.user;
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (ctx) => ProfilePage()), (t) => false);
    } catch (e) {
      Navigator.pop(context);
      List a = e.toString().split(',');
      String b = a[1];
      showSnackBar(b);
    }
  }
}
