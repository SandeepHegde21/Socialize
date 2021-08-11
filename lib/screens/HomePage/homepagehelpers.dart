import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:socialize/constants/Constantcolors.dart';
import 'package:socialize/services/firebaseoperation.dart';

class HomePagehelpers with ChangeNotifier {
  Widget bottomNavBar(
      BuildContext context, int index, PageController pageController) {
    ConstantColors constantColors = ConstantColors();
    return CustomNavigationBar(
      items: [
        CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
        CustomNavigationBarItem(icon: Icon(Icons.message)),
        CustomNavigationBarItem(
          icon: CircleAvatar(
            radius: 35,
            backgroundColor: constantColors.blueGreyColor,
            backgroundImage: NetworkImage(
                Provider.of<FirebaseOperations>(context, listen: false)
                    .initUserImage),
          ),
        ),
      ],
      bubbleCurve: Curves.bounceIn,
      currentIndex: index,
      scaleCurve: Curves.decelerate,
      selectedColor: constantColors.blueColor,
      unSelectedColor: constantColors.whiteColor,
      strokeColor: constantColors.blueColor,
      iconSize: 30.0,
      scaleFactor: 0.5,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(val);
        notifyListeners();
      },
      backgroundColor: Colors.black,
    );
  }
}
