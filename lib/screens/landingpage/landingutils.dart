import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socialize/constants/Constantcolors.dart';
import 'package:socialize/screens/landingpage/landingservices.dart';
import 'package:socialize/services/firebaseoperation.dart';

class LandingUtils with ChangeNotifier {
  final picker = ImagePicker();
  ConstantColors constantColors = ConstantColors();
  File userAvatar;
  File get getUserAvatar => userAvatar;
  String avatarUrl;
  String get getUserAvatarUrl => avatarUrl;

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    final pickedUserAvatar = await picker.pickImage(source: source);
    pickUserAvatar == null
        ? print("Select Image")
        : userAvatar = File(pickedUserAvatar.path);
    print(userAvatar.path);
    userAvatar != null
        ? Provider.of<FirebaseOperations>(context, listen: false)
            .uploadUserAvatar(context)
        : print('Image Upload Error');
    notifyListeners();
  }

  Future selectAvatarOptionSheet(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        pickUserAvatar(context, ImageSource.gallery)
                            .whenComplete(() {
                          Navigator.pop(context);
                          Provider.of<LandingService>(context, listen: false)
                              .showUserAvatar(context);
                        });
                      },
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        pickUserAvatar(context, ImageSource.camera)
                            .whenComplete(() {
                          Navigator.pop(context);
                          Provider.of<LandingService>(context, listen: false)
                              .showUserAvatar(context);
                        });
                      },
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )
                  ],
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12)),
          );
        });
  }
}
