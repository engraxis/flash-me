import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './providers/profile_server_comm.dart';
import './screens/splash_screen.dart';
import './res/constants.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    for (int i = 0; i < Constants.imgPaths.length - 1; i++)
      precacheImage(AssetImage(Constants.imgPaths[i]), context);
    return ChangeNotifierProvider(
      create: (_) => ProfileServerComm(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Montserrat',
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
