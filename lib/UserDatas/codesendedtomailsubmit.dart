import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:zherdeshmobileapplication/UserDatas/userconfirmedmail.dart';
import 'package:zherdeshmobileapplication/UserDatas/userdata_page.dart';


class CodeSubmitInboxConfirmEmail extends StatefulWidget{
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
  const CodeSubmitInboxConfirmEmail(
      {super.key,
        required this.name , required this.surname , required this.email,
        required this.avatarNetworkPath , required this.phone,
        required this.isUserActivated , required this.moneyCash , required this.userID , required this.userStatus,
        required this.userStatusEndDate
      }
      );

  @override
  CodeSubmitInboxConfirmEmailState createState ()=> CodeSubmitInboxConfirmEmailState();
}
class CodeSubmitInboxConfirmEmailState extends State<CodeSubmitInboxConfirmEmail>{


  String dataTopic = "";
  String hintText = "";
  String codeSubmit = "";
  String showDataButton = "";
  String errorMessageCode = "";
  String newCodeData = "";
  String showNewCodeGranted = "";
  TextEditingController codeController = TextEditingController();

  //key for form field
  final formCodeSubmit = GlobalKey<FormState>();

  //bool to get if code is validated =>
  bool codeValidated = false;
  bool dataSet = false;
  bool newCodeClickable = true;


  //todo => methods to setProper data =>
  void setDataKyrgyz(){
    dataTopic = "Кирүү";
    hintText = "Сырсөз эсимде жок";
    codeSubmit = "Электрондук почта";
    showDataButton = "Кирүү";
    errorMessageCode = "Коддун узундугу 6 белгиден аз!";
    newCodeData = "Жаңы код алыңыз";
    showNewCodeGranted = "Жаңы код жөнөтүлдү!";
  }
  void setDataRussian(){
    dataTopic = "Введите код";
    hintText = "Укажите код из почты - он придет на вашу почту в течение 2 минут";
    codeSubmit = "Код подтверждения";
    showDataButton = "Продолжить";
    errorMessageCode = "Длина кода меньше 6 символов!";
    newCodeData = "Получить новый код";
    showNewCodeGranted = "Новый код отправлен!";
  }

  //set logic =>
  Timer? _timer;
  int _seconds = 0; // Initial value in seconds
  Color timerClickable = const Color.fromRGBO(77, 170, 232, 1);


  void _startTimer(String userlocale) {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
          newCodeData = _formatTime(_seconds);
        } else {
          _timer?.cancel();
          newCodeClickable = true;
          timerClickable = const Color.fromRGBO(77, 170, 232, 1);
          if(userlocale=="ru"){
            newCodeData = "Получить новый код";
          }
          else{
            newCodeData = "NEW CODE REDEEM";
          }
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }


  @override
  void dispose() {
    _timer?.cancel();
    codeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //todo => localize data =>
    if(globals.userLanguage!="ru"){
      if(!dataSet){
        setDataKyrgyz();
        dataSet = true;
      }
    }

    if(globals.userLanguage=="ru"){
      if(!dataSet){
        setDataRussian();
        dataSet = true;
      }
    }
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
                child: Form(
                    key: formCodeSubmit,
                    child: SizedBox(
                      width: width*0.95,
                      height: mainSizedBoxHeightUserNotLogged,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width*0.95,
                            height: 30,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
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
                            ),
                          ),
                          SizedBox(
                            height: mainSizedBoxHeightUserNotLogged * 0.8,
                            child: Column(
                              children: [
                                SizedBox(
                                    width: width*0.85,
                                    height: 40,
                                    child: Text(
                                        dataTopic, textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 32, color: Colors.black, fontWeight: FontWeight.w600
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
                                const SizedBox(height: 10,),
                                Container(
                                  width: width*0.85,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Align(alignment: Alignment.centerLeft,
                                      child:TextFormField(controller: codeController, keyboardType: TextInputType.number,
                                        decoration:  InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: (codeValidated)?
                                                  const Color.fromRGBO(76, 197, 19, 0.6) :
                                                  const Color.fromRGBO(244, 244, 244, 0.93)
                                              ),
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(color: Color.fromRGBO(70, 170, 232, 1)),
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(color: Color.fromRGBO(255, 0, 0, 0.5)),
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(color: Color.fromRGBO(255, 0, 0, 0.5)),
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          contentPadding: const EdgeInsets.only(left: 10, right: 20),
                                          hintStyle: const TextStyle(fontSize: 16 , color: Color.fromRGBO(154, 154, 154, 1) , fontWeight: FontWeight.w400),
                                          hintText: codeSubmit,
                                          filled: true,
                                          fillColor: Colors.white,
                                          errorStyle:const TextStyle(
                                              color: Color.fromRGBO(255, 0, 0, 0.5),
                                              fontSize: 12,
                                              letterSpacing: 0.2,
                                              fontWeight: FontWeight.w300
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
                                        onChanged: (valueChanged){
                                          if(formCodeSubmit.currentState!.validate()){
                                            setState(() {
                                              codeValidated = true;
                                            });
                                          }
                                          else{
                                            codeValidated = false;
                                          }
                                        },
                                        validator: (String?value){
                                          if(value == null || value.length<7){
                                            return errorMessageCode;}
                                          return null;},
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(6),
                                          TextInputFormatter.withFunction((oldValue, newValue) {
                                            final text = newValue.text;
                                            if (text.length > 3) {
                                              return TextEditingValue(
                                                text: '${text.substring(0, 3)} ${text.substring(3)}',
                                                selection: newValue.selection.copyWith(
                                                  baseOffset: newValue.selection.baseOffset + 1,
                                                  extentOffset: newValue.selection.extentOffset + 1,
                                                ),
                                              );
                                            }
                                            return newValue;
                                          }),
                                        ],
                                      )
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                SizedBox(width: width*0.85,
                                    height: mainSizedBoxHeightUserNotLogged*0.07 ,
                                    child: ElevatedButton(
                                        onPressed: ()async{
                                          if(formCodeSubmit.currentState!.validate()){
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
                                              final respose = await dio.post(globals.endpointSendCodeToConfirmUser,
                                                  data: {"code" : codeController.text.replaceAll(" ", "")});
                                              if(respose.statusCode == 200){
                                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                    builder: (BuildContext context) => const EmailConfirmCompletedPage()));
                                              }
                                            }
                                            catch(error){
                                              if(error is DioException){
                                                if (error.response != null) {
                                                  String toParseData = error.response.toString();
                                                  Map<String, dynamic> json = jsonDecode(toParseData);
                                                  String showErrorMessage = json['detail'];
                                                  Fluttertoast.showToast(
                                                    msg: showErrorMessage,
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                                                    backgroundColor: Colors.white, // Background color of the toast
                                                    textColor: Colors.black,
                                                  );
                                                }
                                              }
                                            }
                                            setState((){
                                              codeValidated = true;
                                            });
                                          }
                                          else{
                                            codeValidated = false;
                                          }
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
                                const SizedBox(height: 10,),
                                GestureDetector(
                                  onTap: () async{
                                    if(newCodeClickable){
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
                                        final respose = await dio.post(globals.endpointSendCodeAgainToConfirmUser);
                                        if(respose.statusCode == 200){
                                          setState(() {
                                            _seconds = 120;
                                            newCodeClickable = false;
                                            timerClickable = const Color.fromRGBO(40, 40, 40, 1);
                                            Fluttertoast.showToast(
                                              msg: showNewCodeGranted,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                                              backgroundColor: Colors.white, // Background color of the toast
                                              textColor: Colors.black,
                                            );
                                            _startTimer(globals.userLanguage);
                                          });
                                        }
                                      }
                                      catch(error){
                                        if(error is DioException){
                                          if (error.response != null) {
                                            String toParseData = error.response.toString();
                                            Map<String, dynamic> json = jsonDecode(toParseData);
                                            String showErrorMessage = json['detail'];
                                            Fluttertoast.showToast(
                                              msg: showErrorMessage,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                                              backgroundColor: Colors.white, // Background color of the toast
                                              textColor: Colors.black,
                                            );
                                          }
                                        }
                                      }
                                    }
                                  },
                                  child: Text(
                                      newCodeData,
                                      style: TextStyle(
                                          fontSize: 14, color: timerClickable, fontWeight: FontWeight.w500 , letterSpacing: 0.2
                                      )),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ),
            )
        )
    );
  }
}