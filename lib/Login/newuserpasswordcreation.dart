import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zherdeshmobileapplication/Login/newusertelephoneandnamecreation.dart';
import 'package:zherdeshmobileapplication/Login/signup.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;


class SignUpPageNewUserCreatePassword extends StatefulWidget{
  final String newUserEmail ;
  SignUpPageNewUserCreatePassword({required this.newUserEmail});

  @override
  SignUpPageNewUserCreatePasswordState createState ()=> SignUpPageNewUserCreatePasswordState(newUserEmail);
}
class SignUpPageNewUserCreatePasswordState extends State<SignUpPageNewUserCreatePassword>{
  final String newUserEmailInState;
  SignUpPageNewUserCreatePasswordState(this.newUserEmailInState);


  String dataTopic = "";
  String password = "";
  String retrypassword = "";
  String continues = "";
  String errormessagePasswordsNotEqual = "";
  String errormessagePasswordsLenTooShort = "";

  //bool to show password ->
  bool passwordVisibleEditor1 = false;
  bool passwordVisibleEditor2 = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRetryController = TextEditingController();

  //key for form field
  final formNewUserPasswordCreation = GlobalKey<FormState>();

  void setDataKyrgyz(){
    dataTopic = "Сырсөздү түзүү";
    password = "Сырсөздү жазыңыз";
    retrypassword = "Сырсөздү кайра жазыңыз";
    continues = "Улантуу";
    errormessagePasswordsNotEqual = "Сырсөз дал келбейт!";
    errormessagePasswordsLenTooShort = "Сырсөз кеминде 8 белгиден турушу керек!";
  }

  void setDataRussian(){
    dataTopic = "Создайте пароль";
    password = "Введите пароль";
    retrypassword = "Повторно введите пароль";
    continues = "Продолжить";
    errormessagePasswordsNotEqual = "Пароли не совпадают!";
    errormessagePasswordsLenTooShort = "Длина пароля должна быть минимум 8 символов!";
  }

  Widget newTextFormFieldPasswordValidNewFirst (width){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: passwordController,
          keyboardType: TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: !passwordVisibleEditor1,
          decoration: InputDecoration(
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
            hintStyle: const TextStyle(fontSize: 16 , color: Color.fromRGBO(154, 154, 154, 1), fontWeight: FontWeight.w400),
            hintText: password,
            contentPadding: const EdgeInsets.symmetric(vertical: 15 , horizontal: 10),
            suffixIcon: IconButton(
              icon: FaIcon(
                // Based on passwordVisible state choose the icon
                passwordVisibleEditor1
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                color: const Color.fromRGBO(137, 138, 141, 1),
                size: 16,
              ),
              onPressed: () {
                setState(() {
                  passwordVisibleEditor1 = !passwordVisibleEditor1;
                });
              },
            ),
            errorStyle:const TextStyle(
              color: Color.fromRGBO(255, 0, 0, 0.5),
              fontSize: 12,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 2,
          ),
          style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
          validator: (String?value){
            if(value!.isEmpty || value.length<8){
              return errormessagePasswordsLenTooShort;
            }
            return null;
          }
      ),
    );
  }

  Widget newTextFormFieldPasswordValidNewSecond (width){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: passwordRetryController,
          keyboardType: TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: !passwordVisibleEditor2,
          decoration: InputDecoration(
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
            hintStyle: const TextStyle(fontSize: 16 , color: Color.fromRGBO(154, 154, 154, 1), fontWeight: FontWeight.w400),
            hintText: retrypassword,
            contentPadding: const EdgeInsets.symmetric(vertical: 15 , horizontal: 10),
            suffixIcon: IconButton(
              icon: FaIcon(
                // Based on passwordVisible state choose the icon
                passwordVisibleEditor2
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                color: const Color.fromRGBO(137, 138, 141, 1),
                size: 16,
              ),
              onPressed: () {
                setState(() {
                  passwordVisibleEditor2 = !passwordVisibleEditor2;
                });
              },
            ),
            errorStyle:const TextStyle(
              color: Color.fromRGBO(255, 0, 0, 0.5),
              fontSize: 12,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 2,
          ),
          style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
          validator: (String?value){
            if(value!.isEmpty || value.length<8){
              return errormessagePasswordsLenTooShort;
            }
            return null;
          }
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordRetryController.dispose();
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
              key: formNewUserPasswordCreation,
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
                          newTextFormFieldPasswordValidNewFirst(width),
                          const SizedBox(height: 10,),
                          newTextFormFieldPasswordValidNewSecond(width),
                          const SizedBox(height: 15,),
                          SizedBox(
                              width: width*0.85,
                              height: mainSizedBoxHeightUserNotLogged*0.07,
                              child: ElevatedButton(
                                  onPressed: () async{
                                    if(passwordController.text==passwordRetryController.text){
                                      if(formNewUserPasswordCreation.currentState!.validate()){
                                        final dio = Dio();
                                        dio.options.headers['Accept-Language'] = globals.userLanguage;
                                        try{
                                          //todo => send data to server : =>
                                          final respose = await dio.post(globals.endpointNewPasswordCreation, data: {"password1" : passwordController.text , "password2" : passwordRetryController.text});
                                          if(respose.statusCode == 200){
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                builder: (BuildContext context) => SignUpPageNewUserCreateNameandPhone(newUserEmail: newUserEmailInState , newUserPassword: passwordController.text,) ));
                                          }
                                        }
                                        catch(error){
                                          if(error is DioException){
                                            if (error.response != null) {
                                              String toParseData = error.response.toString();
                                              dynamic data = jsonDecode(toParseData);
                                              String passwordErrorMessage = data['password1'][0];
                                              Fluttertoast.showToast(
                                                msg: passwordErrorMessage,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                                                backgroundColor: Colors.white, // Background color of the toast
                                                textColor: Colors.black,
                                                fontSize: 12.0,
                                              );
                                            }
                                          }
                                        }
                                      }
                                    }
                                    else{
                                      Fluttertoast.showToast(
                                        msg: errormessagePasswordsNotEqual,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                                        backgroundColor: Colors.white, // Background color of the toast
                                        textColor: Colors.black,
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                      alignment: Alignment.center,
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
                    ),
                  ],
                ),
              )
            ),
          ),
        )
    ),
    );
  }
}