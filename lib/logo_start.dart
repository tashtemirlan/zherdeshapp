import 'dart:async';
import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_vk/flutter_login_vk.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zherdeshmobileapplication/HomeFiles/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;

class LogoStart extends StatefulWidget{
  const LogoStart({super.key});

  @override
  LogoStartState createState ()=> LogoStartState();

}

class LogoStartState extends State<LogoStart>{
  String noInternetRu = "Нет подключения\nк интернету!";
  String noInternetKg = "Интернетке байланыш жок";

  Future<bool> checkLaunchData() async{
    var box = await Hive.openBox("LaunchData");
    bool isLanguageSet = box.containsKey("Language");
    //clear search settings = >
    var boxSearchSettings = await Hive.openBox("categorySearch");
    bool isSearchSettingsLasted = boxSearchSettings.containsKey("selectedSubCategoriesIndex");
    if(isSearchSettingsLasted){
      await boxSearchSettings.delete("selectedSubCategoriesIndex");
      await boxSearchSettings.delete("selectedSubCategoriesTitle");
    }
    if(isLanguageSet){
      String language = box.get("Language");
      globals.userLanguage = language;
      return true;
    }
    else{
      globals.userLanguage = "ru";
      return true;
    }
  }

  Future<bool> isUserHaveInternet() async{
    Dio dio = Dio();
    try {
      await dio.head('https://www.google.com');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isUserLogged() async{
    //check our logic =>
    var box = await Hive.openBox("logins");
    bool isRefreshTokenInHive= box.containsKey("refresh");
    bool isAccessTokenInHive= box.containsKey("access");
    if(isRefreshTokenInHive && isAccessTokenInHive){
      String refresh = box.get("refresh");

      final dio = Dio();
      dio.options.headers['Accept-Language'] = globals.userLanguage;
      try{
        //try to refresh our tokens =>

        final respose = await dio.post(globals.endpointRefreshTokens, data: {"refresh" : refresh});
        if(respose.statusCode == 200){
          String toParseData = respose.toString();

          Map<String, dynamic> jsonData = jsonDecode(toParseData);
          // Access the values
          String refresh = jsonData['refresh'];
          String access = jsonData['access'];

          box.put("refresh", refresh);
          box.put("access", access);


          globals.isUserRegistered = true;
          return true;
        }
        else{
          return false;
        }
      }
      catch(error){
        if(error is DioException){
          if (error.response != null) {
            String toParseData = error.response.toString();
            dynamic data = jsonDecode(toParseData);
            String loginErrorMessage = data['detail'];
            Fluttertoast.showToast(
              msg: loginErrorMessage,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
              backgroundColor: Colors.white, // Background color of the toast
              textColor: Colors.black,
              fontSize: 12.0,
            );
          }
        }
      }
      return false;
    }
    else{
      globals.isUserRegistered = false;
      return false;
    }
  }

  Future<void> logoMainMethod() async{
    //todo: ensure to initialize all neccessary voids and methods =>
    await Hive.initFlutter();
    // todo : initialize our app metrica =>
    AppMetrica.activate(const AppMetricaConfig("6236d4b9-5df2-4616-9121-4b0ed7a52fb1"));
    //initialize VK =>
    final vk = VKLogin();
    await vk.initSdk();
    bool userCompletedLaunch = await checkLaunchData();
    if(userCompletedLaunch){
      bool userHaveInternet = await isUserHaveInternet();
      if(userHaveInternet){
        bool userLogged = await isUserLogged();
        if(userLogged){
          if(globals.userLanguage=="ru"){
            Fluttertoast.showToast(
              msg: "Добро пожаловать!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 12.0,
            );
          }
          else{
            Fluttertoast.showToast(
              msg: "Кош келиңиз!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 12.0,
            );
          }
        }
        Timer(const Duration(milliseconds: 1250),()=>Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(positionBottomNavigationBar: 0,))));
      }
      else{
        // if user don't have internet
        if(globals.userLanguage=="ru"){
          Fluttertoast.showToast(
            msg: noInternetRu,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 12.0,
          );
        }
        else{
          Fluttertoast.showToast(
            msg: noInternetKg,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 12.0,
          );
        }
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    logoMainMethod();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(left: width*0.3), child :
            Container(
              width: width*0.4,
              height: height*0.4,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/logo.png"),fit: BoxFit.contain)),
            )),
          ],
        )
    );
  }
}