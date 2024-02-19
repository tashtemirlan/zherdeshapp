import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:zherdeshmobileapplication/UserDatas/userdata_page.dart';

import 'codesendedtomailsubmit.dart';



class CodeInboxConfirmEmail extends StatefulWidget{
  final String name;
  final String surname;
  final String email;
  final String avatarNetworkPath;
  final String phone;
  final bool isUserActivated;
  final int moneyCash;
  final int userID;
  final String userStatus;
  final String userStatusEndDate;
  const CodeInboxConfirmEmail(
      {super.key,
        required this.name , required this.surname , required this.email,
        required this.avatarNetworkPath , required this.phone,
        required this.isUserActivated , required this.moneyCash , required this.userID, required this.userStatus,
        required this.userStatusEndDate
      }
      );

  @override
  CodeInboxConfirmEmailState createState ()=> CodeInboxConfirmEmailState();
}
class CodeInboxConfirmEmailState extends State<CodeInboxConfirmEmail>{

  String dataTopic = "";
  String hintText = "";
  String showDataButton = "";
  String buttonNotReady = "";
  bool codeSended = false;

  void setDataKyrgyz(){
    dataTopic = "Кирүү";
    hintText = "Сырсөз эсимде жок";
    showDataButton = "Кирүү";
  }
  void setDataRussian(){
    dataTopic = "Проверьте свою почту";
    hintText = "Код для подтверждения почты отправлен. Пожалуйста, проверьте почту.";
    showDataButton = "Продолжить";
    buttonNotReady = "Подождите";
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

    //send code to user =>
    Future<void> sendCode() async{
      final dio = Dio();
      //get access and refresh token from Hive =>
      var box = await Hive.openBox("logins");
      String refresh = await box.get("refresh");
      String access = await box.get("access");
      //set Dio response =>
      dio.options.headers['Accept-Language'] = globals.userLanguage;
      dio.options.headers['Authorization'] = "Bearer $refresh";
      dio.options.headers['Authorization'] = "Bearer $access";
      try{
        final respose = await dio.post(globals.endpointConfirmEmailToConfirmUser,
            data: {"is_confirm" : widget.isUserActivated});
        if(respose.statusCode == 200){
          setState(() {
            codeSended = true;
          });
        }
      }
      catch(error){
        if(error is DioException){
          if (error.response != null) {
            String toParseData = error.response.toString();
            print(toParseData);
          }
        }
      }
    }

    if(!codeSended){
      sendCode();
    }

    return WillPopScope(
        onWillPop: () async{
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => UserDataPage(
                name: widget.name,
                surname: widget.surname,
                email: widget.email,
                avatarNetworkPath: widget.avatarNetworkPath,
                phone: widget.phone,
                isUserActivated: widget.isUserActivated,
                moneyCash: widget.moneyCash,
                userID: widget.userID,
                userStatus: widget.userStatus,
                userStatusEndDate: widget.userStatusEndDate,
              )
          )
          );
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
                                          builder: (BuildContext context) => UserDataPage(
                                            name: widget.name,
                                            surname: widget.surname,
                                            email: widget.email,
                                            avatarNetworkPath: widget.avatarNetworkPath,
                                            phone: widget.phone,
                                            isUserActivated: widget.isUserActivated,
                                            moneyCash: widget.moneyCash,
                                            userID: widget.userID,
                                            userStatus: widget.userStatus,
                                            userStatusEndDate: widget.userStatusEndDate,
                                          )
                                      )
                                      );
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
                                      if(codeSended){
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                CodeSubmitInboxConfirmEmail(
                                                  name: widget.name,
                                                  surname: widget.surname,
                                                  email: widget.email,
                                                  avatarNetworkPath: widget.avatarNetworkPath,
                                                  phone: widget.phone,
                                                  isUserActivated: widget.isUserActivated,
                                                  moneyCash: widget.moneyCash,
                                                  userID: widget.userID,
                                                  userStatus: widget.userStatus,
                                                  userStatusEndDate: widget.userStatusEndDate,
                                                )));
                                      }
                                      else{
                                        Fluttertoast.showToast(
                                          msg: buttonNotReady,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                                          backgroundColor: Colors.white, // Background color of the toast
                                          textColor: Colors.black,
                                        );
                                      }
                                    },
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        backgroundColor: (codeSended)?
                                            MaterialStateProperty.all<Color>(const Color.fromRGBO(77, 170, 232, 1))
                                            :
                                            MaterialStateProperty.all<Color>(const Color.fromRGBO(158, 158, 158, 1))
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