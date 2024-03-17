import 'dart:io';
import 'dart:typed_data';

import 'package:flashme/providers/profile_server_comm.dart';
import 'package:flashme/res/constants.dart';
import 'package:flashme/res/static_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majascan/majascan.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/user_model.dart';
import 'package:flutter_contact/contacts.dart' as ios_contact;
import 'package:contacts_service/contacts_service.dart' as android_contact;
import '../res/constants.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin<HomeTab> {
  final dbref = FirebaseDatabase.instance.reference();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ios_contact.Contact contact = ios_contact.Contact();

  UserModel myProfile;
  UserModel friendProfile;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<ProfileServerComm>(context).userModel;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.12,
                vertical: MediaQuery.of(context).size.height * 0.005),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: MediaQuery.of(context).size.width * 0.01,
              crossAxisSpacing: MediaQuery.of(context).size.width * 0.01,
              children: <Widget>[
                for (int i = 0; i < Constants.imgPaths.length - 1; i++)
                  GestureDetector(
                    onTap: () async {
                      final urlString = Constants.imgPaths[i]
                          .substring(7, Constants.imgPaths[i].length - 4);
                      String url = myProfile.toMap()[Constants.imgPaths[i]
                          .substring(7, Constants.imgPaths[i].length - 4)];
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (url.isEmpty) {
                        showAppendedSnackBar('empty');
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
                          if (url.contains('http'))
                            _launchURL(url);
                          else
                            _launchURL('https://$url/');
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height / 40,
              ),
              child: GestureDetector(
                onTap: () async {
                  String cameraScanResult = await MajaScan.startScan(
                      title: 'SCANNER',
                      barColor: Color(0xFFFEC72E),
                      titleColor: Colors.white,
                      qRCornerColor: Color(0xFFFEC72E),
                      qRScannerColor: Color(0xFFFEC72E),
                      flashlightEnable: true,
                      scanAreaScale: 0.7);

                  bool doesUserExist = await Provider.of<ProfileServerComm>(
                          context,
                          listen: false)
                      .doesUserExist(cameraScanResult);
                  if (!doesUserExist) {
                    showSnackBar('Invalid QR code.');
                    return;
                  }

                  if (myProfile.friends.contains(cameraScanResult)) {
                    showSnackBar('Friend already exist.');
                    return;
                  }

                  myProfile.friends.add(cameraScanResult);
                  friendProfile = await Provider.of<ProfileServerComm>(context,
                          listen: false)
                      .fetchNewFriendProfile(cameraScanResult);
                  await addContacts(context, friendProfile);
                  Provider.of<ProfileServerComm>(context, listen: false)
                      .addFriend(myProfile.friends, cameraScanResult);
                },
                child: Container(
                  child: Image.asset(
                    'images/scanner.png',
                    height: MediaQuery.of(context).size.width / 5,
                    width: MediaQuery.of(context).size.width / 5,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  TextStyle textStyle(int a) {
    return TextStyle(
      color: Color(0xFF707070),
      fontSize: MediaQuery.of(context).size.width / a,
      fontWeight: a == 26 || a == 18 ? FontWeight.bold : null,
    );
  }

  void showSnackBar(String msg) {
    SnackBar snackBar = SnackBar(
      content: Text(msg),
    );
    scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void showAppendedSnackBar(String errMsg) {
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
      showAppendedSnackBar('broken');
    }
  }

  addContacts(BuildContext context, UserModel newFriendProfile) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.yellow.shade300,
            title: Text('Add to contacts?'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () async {
                  if (Platform.isIOS) {
                    Navigator.pop(context);
                    alertDialog(context, '');
                    try {
                      Uint8List byteImage =
                          await networkImageToByte(newFriendProfile.picture);
                      if (await Permission.contacts.request().isGranted) {
                        contact.avatar = byteImage;
                        contact.givenName = newFriendProfile.name;
                        contact.emails = [
                          ios_contact.Item(
                              label: 'email', value: newFriendProfile.email)
                        ];
                        contact.phones = [
                          ios_contact.Item(
                              label: 'mobile', value: newFriendProfile.number)
                        ];
                        await ios_contact.Contacts.addContact(contact);
                        Navigator.pop(context);
                        showSnackBar('Added to contacts.');
                      } else {
                        Navigator.pop(context);
                        showSnackBar('Adding to contacts requires permission!');
                      }
                    } catch (e) {
                      Navigator.pop(context);
                    }
                  } else {
                    Navigator.pop(context);
                    alertDialog(context, '');
                    try {
                      Uint8List byteImage =
                          await networkImageToByte(newFriendProfile.picture);
                      if (await Permission.contacts.request().isGranted) {
                        android_contact.Contact contact =
                            android_contact.Contact(
                          givenName: newFriendProfile.name,
                          phones: [
                            android_contact.Item(value: newFriendProfile.number)
                          ],
                          emails: [
                            android_contact.Item(value: newFriendProfile.email)
                          ],
                          avatar: byteImage,
                        );
                        await android_contact.ContactsService.addContact(
                            contact);
                        Navigator.pop(context);
                        showSnackBar('Added to contacts.');
                      } else {
                        showSnackBar('Adding to contacts requires permission!');
                      }
                    } catch (e) {
                      Navigator.pop(context);
                      showAppendedSnackBar(e.toString());
                      print(e.toString());
                    }
                  }
                },
              ),
              FlatButton(
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  alertDialog(BuildContext context, String msg) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.yellow.shade300,
            title: Text('Adding'),
            content: Container(
              height: MediaQuery.of(context).size.height / 15,
              width: MediaQuery.of(context).size.width / 10,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Color(0xFFFEC72E)),
                ),
              ),
            ),
          );
        });
  }
}
