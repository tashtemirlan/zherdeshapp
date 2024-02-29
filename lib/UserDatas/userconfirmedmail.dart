import 'package:flutter/material.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:zherdeshmobileapplication/HomeFiles/home_screen.dart';


class EmailConfirmCompletedPage extends StatefulWidget{
  const EmailConfirmCompletedPage({super.key});

  @override
  EmailConfirmCompletedPageState createState ()=> EmailConfirmCompletedPageState();
}
class EmailConfirmCompletedPageState extends State<EmailConfirmCompletedPage>{

  String createSuccess = "";
  String showDataButton = "";


  //todo => methods to setProper data =>
  void setDataKyrgyz(){
    createSuccess = "Сиз аккаунтту ийгиликтүү ачып алдыңыз!\n Жердешке кош келиңиз! Алга!";
    showDataButton = "Улантуу";
  }
  void setDataRussian(){
    createSuccess="Вы успешно подтвердили почту!";
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
    if(globals.userLanguage!="ru"){setDataKyrgyz();}

    if(globals.userLanguage=="ru"){setDataRussian();}
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomNavBarHeight = kBottomNavigationBarHeight;
    double mainSizedBoxHeightUserNotLogged = height - bottomNavBarHeight - statusBarHeight;

    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
          body:Padding(padding: EdgeInsets.only(top: statusBarHeight),
            child: Container(
              width: width,
              height: mainSizedBoxHeightUserNotLogged,
              color: const Color.fromRGBO(250, 250, 250, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width*0.75, height: mainSizedBoxHeightUserNotLogged*0.35,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/regFinish.png'),
                            fit: BoxFit.contain
                        )
                    ),
                  ),
                  const SizedBox(height: 35,),
                  SizedBox(
                    width: width*0.9,
                    height: 50,
                    child: Text(
                        createSuccess, textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16, color: Colors.black,
                        )),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(width: width*0.9, height: mainSizedBoxHeightUserNotLogged*0.07  ,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => HomeScreen(positionBottomNavigationBar: 2)));
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
                            fontSize: 16, color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}