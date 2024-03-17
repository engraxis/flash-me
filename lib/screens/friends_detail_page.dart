import 'package:flashme/res/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class FriendsDetailPage extends StatefulWidget {
  UserModel friendProfile;
  FriendsDetailPage(this.friendProfile);
  @override
  _FriendsDetailPageState createState() => _FriendsDetailPageState();
}

class _FriendsDetailPageState extends State<FriendsDetailPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height / 4.5),
          child: appBarModified(),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.12,
                    vertical: MediaQuery.of(context).size.height * 0.005),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: MediaQuery.of(context).size.width * 0.01,
                  crossAxisSpacing: MediaQuery.of(context).size.width * 0.01,
                  children: <Widget>[
                    for (int i = 0; i < Constants.imgPaths.length; i++)
                      GestureDetector(
                        onTap: () async {
                          final urlString = Constants.imgPaths[i]
                              .substring(7, Constants.imgPaths[i].length - 4);
                          String url = widget.friendProfile.toMap()[Constants
                              .imgPaths[i]
                              .substring(7, Constants.imgPaths[i].length - 4)];
                          FocusScope.of(context).requestFocus(new FocusNode());
                          if (url.isEmpty) {
                            showSnackBar('empty');
                            return;
                          }
                          switch (urlString) {
                            case 'facebook':
                              if (url.contains('https')) {
                                if (url.contains('facebook.com')) {
                                  _launchURL("$url");
                                } else {
                                  _launchURL("www.facebok.com/$url");
                                }
                              } else {
                                _launchURL('https://www.facebook.com/$url/');
                              }
                              break;
                            case 'instagram':
                              if (url.contains('https')) {
                                if (url.contains('instagram.com')) {
                                  _launchURL("$url");
                                } else {
                                  _launchURL("www.instagram.com/$url");
                                }
                              } else {
                                _launchURL('https://www.instagram.com/$url/');
                              }
                              break;
                            case 'snapchat':
                              if (url.contains('http'))
                                _launchURL(url);
                              else
                                _launchURL('https://$url/');
                              break;
                            case 'twitter':
                              if (url.contains('http'))
                                _launchURL(url);
                              else
                                _launchURL('https://$url/');
                              break;
                            case 'youtube':
                              if (url.contains('http'))
                                _launchURL(url);
                              else
                                _launchURL('https://$url/');
                              break;
                            case 'linkedin':
                              if (url.contains('http'))
                                _launchURL(url);
                              else
                                _launchURL('https://$url/');
                              break;
                            case 'tiktok':
                              if (url.contains('http'))
                                _launchURL(url);
                              else
                                _launchURL('https://$url/');
                              break;
                            case 'soundcloud':
                              if (url.contains('http'))
                                _launchURL(url);
                              else
                                _launchURL('https://$url/');
                              break;
                            case 'spotify':
                              if (url.contains('http'))
                                _launchURL(url);
                              else
                                _launchURL('https://$url/');
                              break;
                            case 'music':
                              if (url.contains('http'))
                                _launchURL(url);
                              else
                                _launchURL('https://$url/');
                              break;
                            case 'number':
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return SimpleDialog(
                                        backgroundColor: Colors.yellow.shade300,
                                        children: [
                                          SizedBox(height: 20),
                                          Text(
                                            '  Friend\'s cell number:',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            url,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 20),
                                        ]);
                                  });
                              break;
                            default:
                          }
                        },
                        child: Image.asset(
                          Constants.imgPaths[i],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  TextStyle textStyle(double b, int a) {
    return TextStyle(
        color: Colors.black,
        fontSize: b,
        fontWeight: a == 1 ? FontWeight.bold : null);
  }

  void showSnackBar(String errMsg) {
    SnackBar snackBar = SnackBar(
      content: Text('Can not launch. Link $errMsg.'),
    );
    scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showSnackBar('broken');
    }
  }

  Widget appBarModified() {
    return LayoutBuilder(builder: (contex, constraints) {
      return Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth / 20),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: constraints.maxHeight * 0.25),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.red,
                  icon: Icon(Icons.arrow_back_ios),
                  iconSize: constraints.maxHeight * 0.2,
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: constraints.maxHeight / 20,
                        bottom: constraints.maxHeight / 20,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          widget.friendProfile.picture,
                          fit: BoxFit.cover,
                          height: constraints.maxHeight * 0.5,
                          width: constraints.maxHeight * 0.5,
                        ),
                      ),
                    ),
                    Text(
                      widget.friendProfile.name,
                      style: textStyle(constraints.maxHeight / 6, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Container tabContainer(BoxConstraints constraints, String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      margin: EdgeInsets.all(1),
      width: constraints.maxWidth / 4,
      height: constraints.maxHeight / 5,
      child: Center(
        child: Text(
          text,
          style: textStyle(constraints.maxHeight / 11, 1),
        ),
      ),
    );
  }
}
