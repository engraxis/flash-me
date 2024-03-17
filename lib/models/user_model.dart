import 'package:flutter/foundation.dart';

class UserModel {
  bool isProfileComplete;
  String name,
      picture,
      number,
      email,
      facebook,
      instagram,
      snapchat,
      twitter,
      youtube,
      linkedin,
      tiktok,
      soundcloud,
      spotify,
      music;
  List<dynamic> friends;

  UserModel({
    this.isProfileComplete,
    @required this.name,
    @required this.picture,
    @required this.number,
    this.email,
    this.facebook,
    this.instagram,
    this.snapchat,
    this.twitter,
    this.youtube,
    this.linkedin,
    this.tiktok,
    this.soundcloud,
    this.spotify,
    this.music,
    this.friends,
  });

  Map<String, dynamic> toMap() {
    return {
      'isProfileComplete': this.isProfileComplete ?? '',
      'name': this.name ?? '',
      'picture': this.picture ?? '',
      'number': this.number ?? '',
      'email': this.email ?? '',
      'facebook': this.facebook ?? '',
      'instagram': this.instagram ?? '',
      'snapchat': this.snapchat ?? '',
      'twitter': this.twitter ?? '',
      'youtube': this.youtube ?? '',
      'linkedin': this.linkedin ?? '',
      'tiktok': this.tiktok ?? '',
      'soundcloud': this.soundcloud ?? '',
      'spotify': this.spotify ?? '',
      'music': this.music ?? '',
      'friends': this.friends ?? [],
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return new UserModel(
      isProfileComplete: map['isProfileComplete'] as bool,
      name: map['name'] as String,
      picture: map['picture'] as String,
      number: map['number'] as String,
      email: map['email'] as String,
      facebook: map['facebook'] as String,
      instagram: map['instagram'] as String,
      snapchat: map['snapchat'] as String,
      twitter: map['twitter'] as String,
      youtube: map['youtube'] as String,
      linkedin: map['linkedin'] as String,
      tiktok: map['tiktok'] as String,
      soundcloud: map['soundcloud'] as String,
      spotify: map['spotify'] as String,
      music: map['music'] as String,
      friends: map['friends'] as List,
    );
  }
}
