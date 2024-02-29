import 'package:flutter/material.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:zherdeshmobileapplication/Login/login.dart';


class PasswordResetedPage extends StatefulWidget{
  const PasswordResetedPage({super.key});

  @override
  PasswordResetedPageState createState ()=> PasswordResetedPageState();
}
class PasswordResetedPageState extends State<PasswordResetedPage>{

  String passwordReset = "";
  String description = "";
  String showDataButton = "";


  //todo => methods to setProper data =>
  void setDataKyrgyz(){
    passwordReset="Сырсөз ийгиликтүү баштапкы абалга келтирилди!";
    description = "Эми сиз жаңы сырсөзүңүздү колдонуп аккаунтуңузга кире аласыз.";
    showDataButton = "Кирүү";
  }
  void setDataRussian(){
    passwordReset="Пароль успешно сброшен!";
    description = "Теперь вы можете войти в свой аккаунт с использованием нового пароля.";
    showDataButton = "Войти";
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
          body:Padding(padding: EdgeInsets.only(top: statusBarHeight+ 10),
            child: Container(
              width: width,
              height: mainSizedBoxHeightUserNotLogged,
              color: const Color.fromRGBO(250, 250, 250, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width*0.75, height: height*0.3,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/passwordReseted.png'),
                            fit: BoxFit.contain
                        )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: width*0.9,
                    height: 80,
                    child: Text(
                        passwordReset, textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28, color: Colors.black, fontWeight: FontWeight.w600
                        )),
                  ),
                  const SizedBox(height: 15,),
                  SizedBox(
                    width: width*0.9,
                    height: 40,
                    child: Text(
                        description, textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300 , letterSpacing: 0.2
                        )),
                  ),
                  const SizedBox(height: 25,),
                  SizedBox(width: width*0.9, height: mainSizedBoxHeightUserNotLogged* 0.07,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => const LoginPage()));
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
                            fontSize: 18, color: Colors.white, letterSpacing: 0.2 , fontWeight: FontWeight.w500
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