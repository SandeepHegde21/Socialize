import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:socialize/constants/Constantcolors.dart';
import 'package:socialize/screens/HomePage/homepage.dart';
import 'package:socialize/screens/landingpage/landingutils.dart';
import 'package:socialize/services/authentication.dart';
import 'package:socialize/services/firebaseoperation.dart';

class LandingService with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                  radius: 80,
                  backgroundColor: constantColors.transperant,
                  backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: false)
                          .userAvatar),
                ),
                Container(
                  child: Row(
                    children: [
                      MaterialButton(
                        child: Text(
                          "Reselect",
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: constantColors.whiteColor),
                        ),
                        onPressed: () {
                          Provider.of<LandingUtils>(context, listen: false)
                              .pickUserAvatar(context, ImageSource.gallery);
                        },
                      ),
                      MaterialButton(
                        child: Text(
                          "Confirm Image",
                          style: TextStyle(
                            color: constantColors.blueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .uploadUserAvatar(context)
                              .whenComplete(() {
                            signInSheet(context);
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(15)),
          );
        });
  }

  Widget passwordLessSignIn(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView(
                children:
                    snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                  return ListTile(
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FontAwesomeIcons.trash,
                        color: constantColors.redColor,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: constantColors.transperant,
                      backgroundImage:
                          NetworkImage(documentSnapshot['userimage']),
                    ),
                    subtitle: Text(documentSnapshot['useremail']),
                    title: Text(
                      (documentSnapshot.data() as dynamic)['username'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: constantColors.greenColor),
                    ),
                  );
                }).toList(),
              );
            }
          },
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
        ));
  }

  loginSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      hintText: "Enter email..",
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                      hintText: "Enter password..",
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: FloatingActionButton(
                    backgroundColor: constantColors.blueColor,
                    onPressed: () {
                      if (emailcontroller.text.isNotEmpty) {
                        Provider.of<Authentication>(context, listen: false)
                            .logIntoAccount(
                                emailcontroller.text, passwordcontroller.text)
                            .whenComplete(
                          () {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: HomePage(),
                              ),
                            );
                          },
                        );
                      } else {
                        warningText(context, 'Fill all data');
                      }
                    },
                    child: Icon(
                      FontAwesomeIcons.check,
                      color: constantColors.whiteColor,
                    ),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: constantColors.redColor,
                  backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: false)
                          .getUserAvatar),
                  radius: 60,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: usernamecontroller,
                    decoration: InputDecoration(
                      hintText: "Enter name..",
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      hintText: "Enter email..",
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                      hintText: "Enter password..",
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: FloatingActionButton(
                    backgroundColor: constantColors.redColor,
                    onPressed: () {
                      if (emailcontroller.text.isNotEmpty) {
                        Provider.of<Authentication>(context, listen: false)
                            .createAccount(
                                emailcontroller.text, passwordcontroller.text)
                            .whenComplete(() {
                          print('Creating Collections');
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .createUserCollection(context, {
                            'useruid': Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserId,
                            'useremail': emailcontroller.text,
                            'username': usernamecontroller.text,
                            'userimage': Provider.of<LandingUtils>(context,
                                    listen: false)
                                .getUserAvatarUrl
                          });
                        }).whenComplete(() {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: HomePage(),
                                  type: PageTransitionType.bottomToTop));
                        });
                      } else {
                        warningText(context, 'Fill all data');
                      }
                    },
                    child: Icon(
                      FontAwesomeIcons.check,
                      color: constantColors.whiteColor,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(15),
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                warning,
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        });
  }
}
