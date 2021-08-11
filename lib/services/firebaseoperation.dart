import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:socialize/screens/landingpage/landingutils.dart';
import 'package:socialize/services/authentication.dart';

class FirebaseOperations with ChangeNotifier {
  UploadTask imageUploadTask;
  String initUserEmail;
  String initUserImage;
  String initUserName;

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageRefernce = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');
    imageUploadTask = imageRefernce.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar);
    await imageUploadTask.whenComplete(() {
      print('ImageUploaded');
    });
    imageRefernce.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).avatarUrl =
          url.toString();
      print(
          "the user profile avatar url=${Provider.of<LandingUtils>(context, listen: false).avatarUrl}");
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .get()
        .then((doc) {
      print("fetching data");
      initUserName = (doc.data() as dynamic)['username'];
      initUserEmail = (doc.data() as dynamic)['useremail'];
      initUserImage = (doc.data() as dynamic)['userimage'];
      print(initUserEmail);
      print(initUserImage);
      print(initUserName);

      notifyListeners();
    });
  }
}
