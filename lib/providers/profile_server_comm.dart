import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../res/static_info.dart';

class ProfileServerComm with ChangeNotifier {
  UserModel _userModel;
  List<dynamic> _friendsList = [];
  List<UserModel> _allFriendsProfile = [];

  UserModel get userModel {
    return _userModel;
  }

  List<dynamic> get friendsList {
    return _friendsList;
  }

  List<UserModel> get allFriendsProfile {
    return _allFriendsProfile;
  }

  Future<bool> doesUserExist(String uid) async {
    var documents = await Firestore.instance.collection('users').getDocuments();
    for (var document in documents.documents)
      if (document.documentID.contains(uid)) return true;
    return false;
  }

  Future<UserModel> fetchNewFriendProfile(String uid) async {
    var profileData =
        await Firestore.instance.collection('users').document(uid).get();
    return UserModel.fromMap(profileData.data);
  }

  Future<void> fetchProfileAndFriends() async {
    _friendsList.clear();
    _allFriendsProfile.clear();

    var profileData = await Firestore.instance
        .collection('users')
        .document(StaticInfo.currentUser.uid)
        .get();
    _userModel = UserModel.fromMap(profileData.data);
    _friendsList = _userModel.friends;

    for (int i = 0; i < _friendsList.length; i++) {
      var snaps = await Firestore.instance
          .collection('users')
          .document(_friendsList[i])
          .get();
      _allFriendsProfile.add(UserModel.fromMap(snaps.data));
    }
    notifyListeners();
  }

  Future<void> upDateProfile(UserModel editedUserModel) async {
    await Firestore.instance
        .collection('users')
        .document(StaticInfo.currentUser.uid)
        .setData(editedUserModel.toMap());
    _userModel = editedUserModel;
    notifyListeners();
  }

  Future<void> removeFriend(
      List<dynamic> newFriendsList, int removeIndex) async {
    await Firestore.instance
        .collection('users')
        .document(StaticInfo.currentUser.uid)
        .updateData({'friends': newFriendsList});
    _userModel.friends = newFriendsList;
    _friendsList = _userModel.friends;
    _allFriendsProfile.removeAt(removeIndex);
    notifyListeners();
  }

  Future<void> addFriend(
      List<dynamic> newFriendsList, String newFriendUID) async {
    await Firestore.instance
        .collection('users')
        .document(StaticInfo.currentUser.uid)
        .updateData({'friends': newFriendsList});
    Firestore.instance
        .collection('users')
        .document(newFriendUID)
        .get()
        .then((onValue) {
      _allFriendsProfile.add(UserModel.fromMap(onValue.data));
    });

    _userModel.friends = newFriendsList;
    _friendsList = _userModel.friends;
    notifyListeners();
  }

  Future<void> createNewProfile(UserModel myProfile) async {
    await Firestore.instance
        .collection('users')
        .document(StaticInfo.currentUser.uid)
        .setData(
          myProfile.toMap(),
        );
  }
}
