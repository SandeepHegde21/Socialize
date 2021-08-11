import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialize/constants/Constantcolors.dart';
import 'package:socialize/screens/landingpage/landinghelpers.dart';
import 'package:socialize/screens/landingpage/landingservices.dart';
import 'package:socialize/screens/splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:socialize/services/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LandingService()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => LandingHelpers())
      ],
      child: MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            accentColor: constantColors.blueColor,
            fontFamily: 'Poppins',
            canvasColor: constantColors.transperant),
      ),
    );
  }
}
