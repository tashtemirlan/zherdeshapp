import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;

import 'codesubmit.dart';
import 'login.dart';

class CodeInbox extends StatefulWidget{
  final String userEmailForgetPassword ;
  const CodeInbox({super.key, required this.userEmailForgetPassword});

  @override
  CodeInboxState createState ()=> CodeInboxState(userEmailForgetPassword);
}
class CodeInboxState extends State<CodeInbox>{
  final String userEmailForgetPassword ;
  CodeInboxState(this.userEmailForgetPassword);
  String dataTopic = "";
  String hintText = "";
  String showDataButton = "";

  void setDataKyrgyz(){
    dataTopic = "Почтаңызды текшериңиз";
    hintText = "Сырсөз эсимде жок";
    showDataButton = "Улантуу";
  }
  void setDataRussian(){
    dataTopic = "Проверьте свою почту";
    hintText = "Сырсөздү баштапкы абалга келтирүү коду жөнөтүлдү. Сураныч, почтаны текшериңиз.";
    showDataButton = "Продолжить";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage()));
          return true;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body:Padding(padding: EdgeInsets.only(top: statusBarHeight),
              child: Container(
                width: width,
                height: mainSizedBoxHeightUserNotLogged,
                color: const Color.fromRGBO(250, 250, 250, 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width*0.95,
                      height: mainSizedBoxHeightUserNotLogged,
                      child: Column(
                        children: [
                          SizedBox(
                            width: width*0.95,
                            height: height*0.1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: (){
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (BuildContext context) => const LoginPage()));
                                  },
                                  icon: const Icon(Icons.close, color: Colors.black, size: 30,),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              width: width*0.85,
                              height: 40,
                              child: Text(
                                  dataTopic, textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 28, color: Colors.black, fontWeight: FontWeight.w600
                                  ))
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                              width: width*0.85,
                              height: 40,
                              child: Text(
                                  hintText, textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 14, color: Color.fromRGBO(40, 40, 40, 1),
                                      fontWeight: FontWeight.w300 , letterSpacing: 0.2
                                  ))
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            width: width*0.75, height: mainSizedBoxHeightUserNotLogged*0.45,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/InboxImg.png'),
                                    fit: BoxFit.contain
                                )
                            ),
                          ),
                          const SizedBox(height: 20,),
                          SizedBox(width: width*0.85,
                              height: mainSizedBoxHeightUserNotLogged*0.07,
                              child: ElevatedButton(
                                  onPressed: ()async{
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (BuildContext context) => CodeSubmit(userEmailForgetPassword: userEmailForgetPassword,)));
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
                                      ))
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            )
        )
    );
  }
}