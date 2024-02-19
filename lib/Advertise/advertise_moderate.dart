import 'package:flutter/material.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;

import '../HomeFiles/home_screen.dart';


class AdvertiseModeratePage extends StatefulWidget{
  const AdvertiseModeratePage({super.key});

  @override
  AdvertiseModeratePageState createState ()=> AdvertiseModeratePageState();
}
class AdvertiseModeratePageState extends State<AdvertiseModeratePage>{

  String createSuccess = "";
  String showDataButton = "";


  //todo => methods to setProper data =>
  void setDataKyrgyz(){
    createSuccess="";
    showDataButton = "Улантуу";
  }
  void setDataRussian(){
    createSuccess="Ваше обьявление на рассмотрении";
    showDataButton = "Продолжить";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //todo => localize data =>
    if(globals.userLanguage!="kg"){setDataKyrgyz();}

    if(globals.userLanguage=="ru"){setDataRussian();}
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomNavBarHeight = kBottomNavigationBarHeight;
    double mainSizedBoxHeightUserNotLogged = height - bottomNavBarHeight - statusBarHeight;


    return Scaffold(
        body:Padding(padding: EdgeInsets.only(top: statusBarHeight+ 10),
          child: Container(
            width: width,
            height: mainSizedBoxHeightUserNotLogged,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width*0.75, height: mainSizedBoxHeightUserNotLogged*0.5,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/postWaiting.png'),
                          fit: BoxFit.contain
                      )
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                    width: width*0.9,
                    height: 50,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                          createSuccess, textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400
                          )),
                    )
                ),
                const SizedBox(height: 15,),
                SizedBox(width: width*0.9, height: height*0.06  ,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => HomeScreen(positionBottomNavigationBar: 0)));
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(77, 170, 232, 1))
                    ),
                    child: Text(
                        showDataButton,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500 , letterSpacing: 0.2
                        )),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}