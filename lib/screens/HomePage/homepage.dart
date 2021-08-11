import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialize/constants/Constantcolors.dart';
import 'package:socialize/screens/HomePage/homepagehelpers.dart';
import 'package:socialize/screens/chatroom/chatroom.dart';
import 'package:socialize/screens/feeds/feeds.dart';
import 'package:socialize/screens/profiles/profiles.dart';
import 'package:socialize/services/firebaseoperation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConstantColors constantColors = ConstantColors();
  final PageController homePagecontrolller = PageController();
  int pageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<FirebaseOperations>(context, listen: false)
        .initUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: PageView(
        controller: homePagecontrolller,
        children: [Feeds(), ChatRoom(), Profiles()],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomePagehelpers>(context)
          .bottomNavBar(context, pageIndex, homePagecontrolller),
    );
  }
}
