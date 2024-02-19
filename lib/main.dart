import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zherdeshmobileapplication/logo_start.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
        theme: ThemeData(
            colorScheme: ThemeData().colorScheme.copyWith(primary: const Color.fromRGBO(77, 170, 232, 1)),
            fontFamily: 'Inter'
        ),
        debugShowCheckedModeBanner: false, //hide debug banner
        home: const LogoStart()
    ));
  });
}
