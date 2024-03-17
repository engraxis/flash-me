import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import './link_entry_page.dart';
import '../res/static_info.dart';
import '../models/user_model.dart';
import '../providers/profile_server_comm.dart';
import '../res/constants.dart';
import '../screens/landing_page.dart';

enum SourceOfImage { Gallery, Camera, None }

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, String> userProfile = {};
  final _form = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey objectKey = GlobalKey();
  String name = '';
  String number = '';
  bool isImgPicked = false;
  File image;
  bool isUploading = false;

  List<ImageProvider> images = [
    AssetImage(Constants.imgPaths[0]),
    AssetImage(Constants.imgPaths[1]),
    AssetImage(Constants.imgPaths[2]),
    AssetImage(Constants.imgPaths[3]),
    AssetImage(Constants.imgPaths[4]),
    AssetImage(Constants.imgPaths[5]),
    AssetImage(Constants.imgPaths[6]),
    AssetImage(Constants.imgPaths[7]),
    AssetImage(Constants.imgPaths[8]),
    AssetImage(Constants.imgPaths[9]),
  ];

  @override
  Widget build(BuildContext context) {
    SourceOfImage selectedImgSource = SourceOfImage.None;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "images/logo.png",
                      height: MediaQuery.of(context).size.height * 0.09,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Image.asset(
                      "images/flashme.png",
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  "COMPLETE YOUR PROFILE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                InkWell(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (ctx) => SimpleDialog(
                              backgroundColor: Colors.yellow.shade300,
                              title: Text(
                                'Select image source',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        selectedImgSource =
                                            SourceOfImage.Camera;
                                        Navigator.of(ctx).pop();
                                      },
                                      color: Colors.white38,
                                      child: Text('Camera',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        selectedImgSource =
                                            SourceOfImage.Gallery;
                                        Navigator.of(ctx).pop();
                                      },
                                      color: Colors.white38,
                                      child: Text('Gallery',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                )
                              ],
                            ));

                    var rawImg = await ImagePicker.pickImage(
                        source: selectedImgSource == SourceOfImage.None
                            ? null
                            : selectedImgSource == SourceOfImage.Gallery
                                ? ImageSource.gallery
                                : ImageSource.camera);

                    if (rawImg != null) {
                      var cropped = await ImageCropper.cropImage(
                        sourcePath: rawImg.path,
                        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
                      );
                      if (cropped != null)
                        setState(() {
                          isImgPicked = true;
                          image = cropped;
                        });
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.height * 0.2,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: isImgPicked
                        ? ClipRRect(
                            child: Image.file(image, fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10),
                          )
                        : Center(
                            child: Text(
                              "Profile Picture",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white38,
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  height: MediaQuery.of(context).size.height * 0.17,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 20,
                    ),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            onSaved: (value) {
                              name = value;
                            },
                            validator: (value) {
                              return value.isEmpty
                                  ? 'Please enter your name.'
                                  : null;
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: "Name",
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              filled: true,
                              fillColor: Colors.white38,
                              errorStyle: TextStyle(color: Colors.red),
                              errorBorder: outlineInputBorder(false),
                              focusedBorder: outlineInputBorder(true),
                              enabledBorder: outlineInputBorder(true),
                              focusedErrorBorder: outlineInputBorder(true),
                            ),
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            onSaved: (value) {
                              number = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter cell number.';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: "Contact number",
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                              filled: true,
                              fillColor: Colors.white38,
                              errorStyle: TextStyle(color: Colors.red),
                              errorBorder: outlineInputBorder(false),
                              focusedBorder: outlineInputBorder(true),
                              enabledBorder: outlineInputBorder(true),
                              focusedErrorBorder: outlineInputBorder(true),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03),
                  height: MediaQuery.of(context).size.height * 0.21,
                  width: MediaQuery.of(context).size.width -
                      (MediaQuery.of(context).size.width * 0.03),
                  child: LayoutBuilder(
                    builder: (context, constraints) => GridView.count(
                      crossAxisCount: 5,
                      mainAxisSpacing: constraints.maxWidth * 0.04,
                      crossAxisSpacing: constraints.maxWidth * 0.04,
                      children: <Widget>[
                        for (int i = 0; i < Constants.imgPaths.length - 1; i++)
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (ctx) => LinkEntryPage(
                                    index: i,
                                    containsData: userProfile.containsKey(
                                                Constants.socialNames[i]) &&
                                            userProfile[
                                                    Constants.socialNames[i]] !=
                                                null
                                        ? userProfile[
                                                    Constants.socialNames[i]] ==
                                                ''
                                            ? false
                                            : true
                                        : false,
                                    socialLink:
                                        userProfile[Constants.socialNames[i]],
                                  ),
                                ),
                              )
                                  .then((result) {
                                userProfile[Constants.socialNames[i]] = result;
                                setState(() {});
                              });
                            },
                            child: userProfile
                                    .containsKey(Constants.socialNames[i])
                                ? userProfile[Constants.socialNames[i]] == '' ||
                                        userProfile[Constants.socialNames[i]] ==
                                            null
                                    ? Image(image: images[i])
                                    : Stack(
                                        children: <Widget>[
                                          Image(image: images[i]),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Icon(
                                              Icons.done,
                                              size: 30,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      )
                                : Image(image: images[i]),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 20),
                  child: ButtonTheme(
                    height: 60,
                    minWidth: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () async {
                        FocusScope.of(context).requestFocus();
                        setState(() {
                          isUploading = true;
                        });
                        if (!isImgPicked) {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Profile picture is required.',
                                style: TextStyle(color: Colors.black),
                              ),
                              backgroundColor: Colors.white38,
                            ),
                          );
                          setState(() {
                            isUploading = false;
                          });
                          return null;
                        }
                        final isValid = _form.currentState.validate();
                        if (!isValid) {
                          setState(() {
                            isUploading = false;
                          });
                          return null;
                        }
                        _form.currentState.save();

                        //Upload Profile Picture
                        var imgUpload = FirebaseStorage.instance
                            .ref()
                            .child('profilepictures')
                            .child('${StaticInfo.currentUser.uid}')
                            .putFile(image);
                        var imageUrl = await (await imgUpload.onComplete)
                            .ref
                            .getDownloadURL();

                        if (imageUrl == null) {
                          setState(() {
                            isUploading = false;
                          });
                          return null;
                        }

                        await Provider.of<ProfileServerComm>(context,
                                listen: false)
                            .createNewProfile(
                          UserModel(
                            isProfileComplete: true,
                            name: name,
                            picture: imageUrl,
                            number: number,
                            email: StaticInfo.currentUser.email,
                            facebook: userProfile['facebook'],
                            instagram: userProfile['instagram'],
                            snapchat: userProfile['snapchat'],
                            twitter: userProfile['twitter'],
                            youtube: userProfile['youtube'],
                            linkedin: userProfile['linkedin'],
                            tiktok: userProfile['tiktok'],
                            soundcloud: userProfile['soundcloud'],
                            spotify: userProfile['spotify'],
                            music: userProfile['music'],
                            friends: [],
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (ctx) => LandingPage()),
                        );
                        setState(() {
                          isUploading = false;
                        });
                      },
                      child: isUploading
                          ? CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                Color(0xFFFEC72E),
                              ),
                            )
                          : Text(
                              'COMPLETE',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width / 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

OutlineInputBorder outlineInputBorder(bool a) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: a == true ? Colors.white : Colors.red,
    ),
  );
}
