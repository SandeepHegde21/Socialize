import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:socialize/constants/Constantcolors.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:socialize/screens/HomePage/homepage.dart';
import 'package:socialize/screens/landingpage/landingservices.dart';
import 'package:socialize/screens/landingpage/landingutils.dart';
import 'package:socialize/services/authentication.dart';

class LandingHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login.png'),
        ),
      ),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
      child: Container(
        constraints: BoxConstraints(maxWidth: 170),
        child: RichText(
          text: TextSpan(
              text: "Are ",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'you ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0),
                ),
                TextSpan(
                  text: 'Social',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0),
                ),
                TextSpan(
                  text: '?',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0),
                )
              ]),
        ),
      ),
      top: 450,
      left: 10,
    );
  }

  Widget mainButtons(BuildContext context) {
    return Positioned(
      top: 630,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                print('Email tapped');
                emailAuthSheet(context);
              },
              child: Container(
                child: Icon(
                  EvaIcons.emailOutline,
                  color: constantColors.yellowColor,
                  size: 50,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: constantColors.yellowColor,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Signing with Google");
                Provider.of<Authentication>(context, listen: false)
                    .signInWithGoogle()
                    .whenComplete(() {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: HomePage(),
                          type: PageTransitionType.leftToRight));
                });
              },
              child: Container(
                child: Icon(
                  EvaIcons.googleOutline,
                  color: constantColors.redColor,
                  size: 50,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: constantColors.redColor),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
      child: Container(
        child: Column(
          children: [
            Text(
              "By continuing u agree to the terms and policy ",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            )
          ],
        ),
      ),
      top: 700,
      left: 20,
      right: 20,
    );
  }

  emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
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
                Provider.of<LandingService>(context, listen: false)
                    .passwordLessSignIn(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.blueColor,
                      onPressed: () {
                        Provider.of<LandingService>(context, listen: false)
                            .loginSheet(context);
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    MaterialButton(
                      color: constantColors.redColor,
                      onPressed: () {
                        Provider.of<LandingUtils>(context, listen: false)
                            .selectAvatarOptionSheet(context);
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          );
        });
  }
}
