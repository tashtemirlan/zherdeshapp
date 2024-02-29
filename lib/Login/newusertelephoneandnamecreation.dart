import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zherdeshmobileapplication/Login/signup.dart';
import 'package:zherdeshmobileapplication/Login/signup_completed.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:hive_flutter/hive_flutter.dart';


class SignUpPageNewUserCreateNameandPhone extends StatefulWidget{
  final String newUserEmail ;
  final String newUserPassword;
  SignUpPageNewUserCreateNameandPhone({required this.newUserEmail , required this.newUserPassword});

  @override
  SignUpPageNewUserCreateNameandPhoneState createState ()=> SignUpPageNewUserCreateNameandPhoneState(newUserEmail, newUserPassword);
}
class SignUpPageNewUserCreateNameandPhoneState extends State<SignUpPageNewUserCreateNameandPhone>{
  final String newUserEmail ;
  final String newUserPassword;
  SignUpPageNewUserCreateNameandPhoneState(this.newUserEmail , this.newUserPassword);

  String dataTopic = "";
  String name = "";
  String surname = "";
  String phonenumber = "";
  String continues = "";
  String errormessageFieldNameEmpty = "";
  String errormessageFieldSurnameEmpty = "";
  String errormessageFieldPhoneEmpty = "";


  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  //key for form field
  final formNewUserTelephoneAndNameCreation = GlobalKey<FormState>();

  void setDataKyrgyz(){
    dataTopic = "Өзүңүз жөнүндө көбүрөөк маалымат кошуңуз";
    name = "Атыңызды жазыңыз";
    surname = "Аты жөнүңүздү жазыңыз";
    phonenumber = "Телефон номериңизди жазыңыз";
    continues = "Улантуу";
    errormessageFieldNameEmpty = "Аты талаа бош!";
    errormessageFieldSurnameEmpty = "Аты жөнүңүздүн талаасы бош!";
    errormessageFieldPhoneEmpty = "Телефон талаасы бош!";
  }

  void setDataRussian(){
    dataTopic = "Добавьте больше данных о себе";
    name = "Введите ваше имя";
    surname = "Введите вашу фамилию";
    phonenumber = "Введите ваш номер телефона";
    continues = "Продолжить";
    errormessageFieldNameEmpty = "Поле имя пустое!";
    errormessageFieldSurnameEmpty = "Поле фамилия пустое!";
    errormessageFieldPhoneEmpty = "Поле телефон пустое!";
  }

  Widget newTextFormFieldName (width){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: nameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.name,
          decoration:  InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(221, 221, 221, 1)),
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
            hintText: name,
            fillColor: Colors.white,
            filled: true,
            errorStyle:const TextStyle(
              color: Color.fromRGBO(255, 0, 0, 0.5),
              fontSize: 12,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 1,
          ),
          style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
          validator: (String?value){
            if(value!.isEmpty){
              return errormessageFieldNameEmpty;
            }
            return null;
          }
      ),
    );
  }

  Widget newTextFormFieldSurname (width){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: surnameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.name,
          decoration:  InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(221, 221, 221, 1)),
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
            hintText: surname,
            fillColor: Colors.white,
            filled: true,
            errorStyle:const TextStyle(
              color: Color.fromRGBO(255, 0, 0, 0.5),
              fontSize: 12,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 1,
          ),
          style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
          validator: (String?value){
            if(value!.isEmpty){
              return errormessageFieldSurnameEmpty;
            }
            return null;
          }
      ),
    );
  }

  Widget newTextFormFieldPhone (width){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: phoneNumberController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.phone,
          decoration:  InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(221, 221, 221, 1)),
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
            hintText: phonenumber,
            fillColor: Colors.white,
            filled: true,
            errorStyle:const TextStyle(
              color: Color.fromRGBO(255, 0, 0, 0.5),
              fontSize: 12,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 1,
            suffixIcon: IconButton(
              icon: Icon(Icons.task_alt, color: Colors.green.shade400, size: 22,),
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
          validator: (String?value){
            if(value!.isEmpty){
              return errormessageFieldPhoneEmpty;
            }
            return null;
          }
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    phoneNumberController.dispose();
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
    double mainSizedBoxHeightUserNotLogged = height - bottomNavBarHeight-statusBarHeight;


    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const SignUpPage()));
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
                key: formNewUserTelephoneAndNameCreation,
                child: SizedBox(
                  width: width*0.95,
                  height: mainSizedBoxHeightUserNotLogged,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width*0.95,
                        height: 30,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => const SignUpPage()));
                            },
                            icon: const Icon(Icons.close, color: Colors.black, size: 30,),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mainSizedBoxHeightUserNotLogged * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width*0.85,
                              height: 40,
                              child: Text(
                                  dataTopic, textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 32, color: Colors.black, fontWeight: FontWeight.w600
                                  )),
                            ),
                            const SizedBox(height: 30,),
                            newTextFormFieldName(width),
                            const SizedBox(height: 10,),
                            newTextFormFieldSurname(width),
                            const SizedBox(height: 10,),
                            newTextFormFieldPhone(width),
                            const SizedBox(height: 15,),
                            SizedBox(
                                width: width*0.85,
                                height: mainSizedBoxHeightUserNotLogged*0.07,
                                child: ElevatedButton(
                                    onPressed: () async{
                                      if(formNewUserTelephoneAndNameCreation.currentState!.validate()){
                                        final dio = Dio();
                                        dio.options.headers['Accept-Language'] = globals.userLanguage;
                                        try{
                                          //todo => send data to server : =>
                                          final respose = await dio.post(globals.endpointNewUserTelephoneAndNameCreation,
                                              data: {
                                                "phone" : phoneNumberController.text ,
                                                "first_name" : nameController.text,
                                                "last_name" : surnameController.text,
                                                "password1" : newUserPassword ,
                                                "email" : newUserEmail
                                              }
                                          );
                                          if(respose.statusCode == 200){
                                            String toParseData = respose.toString();
                                            print(toParseData);
                                            Map<String, dynamic> jsonData = jsonDecode(toParseData);
                                            Map<String, dynamic> tokensJson = jsonData['tokens'];
                                            // Access the values
                                            String refresh = tokensJson['refresh'];
                                            String access = tokensJson['access'];

                                            var box = await Hive.openBox("logins");
                                            box.put("email", newUserEmail);
                                            box.put("password", newUserPassword);
                                            box.put("refresh", refresh);
                                            box.put("access", access);
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                builder: (BuildContext context) => const SignUpCompletedPage()));
                                          }
                                        }
                                        catch(error){
                                          if(error is DioException){
                                            if (error.response != null) {
                                              String toParseData = error.response.toString();
                                              print("ERROR $toParseData");
                                              print("DATA : ${phoneNumberController.text} , "
                                                  "${nameController.text} , "
                                                  "${surnameController.text} , $newUserPassword , $newUserEmail");
                                            }
                                          }
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        backgroundColor: MaterialStateProperty.all<Color>( const Color.fromRGBO(77, 170, 232, 1))
                                    ),
                                    child: Text(
                                        continues,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.white, letterSpacing: 0.2 , fontWeight: FontWeight.w500
                                        ))
                                )
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
      ),
    );

  }
}