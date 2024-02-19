import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zherdeshmobileapplication/Login/signup.dart';

import '../HomeFiles/home_screen.dart';
import '../PolicyPrivacy/policy_page.dart';
import '../PolicyPrivacy/privacy_page.dart';
import '../logo_start.dart';
import 'forgetpassword.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  LoginPageState createState ()=> LoginPageState();
}
class LoginPageState extends State<LoginPage>{
  String dataTopic = "";
  String forgetPassword = "";
  String email = "";
  String password = "";
  String showDataButton = "";
  String errorMessageEmail = "";
  String errorMessagePassword = "";
  String donthaveaccount = "";
  String signuptoaccount = "";
  String showRegisterDataPolicyData1 = "";
  String showRegisterDataPolicyData2 = "";
  String showRegisterDataPolicyData3 = "";
  String showRegisterDataPolicyData4 = "";
  //bool to show password ->
  bool passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //key for form field
  final formLogin = GlobalKey<FormState>();

  void setDataKyrgyz(){
    dataTopic = "Кирүү";
    forgetPassword = "Сырсөз эсимде жок";
    email = "Эл. почта";
    password = "Сырсөз";
    showDataButton = "Улантуу";
    errorMessageEmail = "Почта талаасы бош!";
    errorMessagePassword = "Сырсөз кеминде 8 белгиден турушу керек!";
    donthaveaccount = "Катталуу керек? ";
    signuptoaccount ="Каттоо";
    showRegisterDataPolicyData1 = "Каттоо жана кирүү менен";
    showRegisterDataPolicyData2 = "\nЖердештин колдонуу шарттарына ";
    showRegisterDataPolicyData3 = "жана";
    showRegisterDataPolicyData4 = " маалыматтарды иштетүү саясатына макул болосуз";
  }
  void setDataRussian(){
    dataTopic = "Войти";
    forgetPassword = "Забыли пароль?";
    email = "Эл. почта";
    password = "Пароль";
    showDataButton = "Продолжить";
    errorMessageEmail = "Поле почты пустое!";
    errorMessagePassword = "Длина пароля должна быть минимум 8 символов!";
    donthaveaccount = "Нужен аккаунт? ";
    signuptoaccount ="Зарегистрироваться";
    showRegisterDataPolicyData1 = "При регистрации и входе вы соглашаетесь с";
    showRegisterDataPolicyData2 = "\nусловиями использования Жердеш ";
    showRegisterDataPolicyData3 = "и ";
    showRegisterDataPolicyData4 = "политикой обработки данных";
  }

  Widget loginTextFormFieldEmailValidNew (width){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: emailController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.emailAddress,
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
            hintText: email,
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
              return errorMessageEmail;
            }
            return null;
          }
      ),
    );
  }

  Widget loginTextFormFieldPasswordValidNew (width){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: passwordController,
          keyboardType: TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: !passwordVisible,
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
                passwordVisible
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                color: const Color.fromRGBO(137, 138, 141, 1),
                size: 16,
              ),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
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
              return errorMessagePassword;
            }
            return null;
          }
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if(globals.userLanguage!="ru"){setDataKyrgyz();}
    if(globals.userLanguage=="ru"){setDataRussian();}
  }


  @override
  Widget build(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomNavBarHeight = kBottomNavigationBarHeight;
    double mainSizedBoxHeightUserNotLogged = height - bottomNavBarHeight - statusBarHeight;


    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(positionBottomNavigationBar: 2)));
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
                  key: formLogin,
                  child: SizedBox(
                    width: width*0.95,
                    height: mainSizedBoxHeightUserNotLogged,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //first elem is x to sign out =>
                        SizedBox(
                          width: width*0.95,
                          height: 30,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (BuildContext context) => HomeScreen(positionBottomNavigationBar: 2)));
                              },
                              icon: const Icon(Icons.close, color: Colors.black, size: 30,),
                            ),
                          ),
                        ),
                        //second elem is form =>
                        SizedBox(
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
                              const SizedBox(height: 30),
                              loginTextFormFieldEmailValidNew(width),
                              const SizedBox(height: 10),
                              loginTextFormFieldPasswordValidNew(width),
                              const SizedBox(height: 10,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) => const ForgetPassword()));
                                },
                                child: SizedBox(
                                    width: width*0.85,
                                    height: 20,
                                    child: Text(
                                        forgetPassword, textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            fontSize: 14, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w500 , letterSpacing: 0.2
                                        ))
                                ),
                              ),
                              const SizedBox(height: 15,),
                              SizedBox(width: width*0.85,
                                  height: mainSizedBoxHeightUserNotLogged*0.07  ,
                                  child: ElevatedButton(
                                      onPressed: ()async{
                                        print("Pressed");
                                        if(formLogin.currentState!.validate()){
                                          final dio = Dio();
                                          dio.options.headers['Accept-Language'] = globals.userLanguage;
                                          try{
                                            final respose = await dio.post(globals.endpointLogin, data: {"email" : emailController.text , "password" : passwordController.text});
                                            if(respose.statusCode == 200){
                                              String toParseData = respose.toString();

                                              Map<String, dynamic> jsonData = jsonDecode(toParseData);
                                              // Access the values
                                              String refresh = jsonData['refresh'];
                                              String access = jsonData['access'];

                                              var box = await Hive.openBox("logins");
                                              box.put("email", emailController.text);
                                              box.put("password", passwordController.text);
                                              box.put("refresh", refresh);
                                              box.put("access", access);

                                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                  builder: (BuildContext context) => const LogoStart()));
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
                            ],
                          ),
                        ),
                        //third elem is additional placeholders
                        SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: width*0.85,
                                  height: 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          donthaveaccount,
                                          style: const TextStyle(
                                              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400, letterSpacing:  0.2
                                          )),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                                              builder: (BuildContext context) => const SignUpPage()));
                                        },
                                        child: Text(
                                            signuptoaccount,
                                            style: const TextStyle(
                                                fontSize: 16, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w500 , letterSpacing: 0.2
                                            )),
                                      ),
                                    ],
                                  )
                              ),
                              const SizedBox(height: 25,),
                              SizedBox(
                                width: width*0.9,
                                height: 50,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: showRegisterDataPolicyData1,
                                      style: const TextStyle(fontSize: 12 ,
                                          color: Color.fromRGBO(122, 122, 122, 1),
                                          letterSpacing: 0.2,
                                          fontWeight: FontWeight.w300
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: showRegisterDataPolicyData2,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // Handle tap gesture here
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (BuildContext context) => const PrivacyPage()));
                                              },
                                            style: const TextStyle(fontSize: 12,
                                                color: Color.fromRGBO(77, 170, 232, 1),
                                                letterSpacing: 0.2,
                                                fontWeight: FontWeight.w500
                                            )
                                        ),
                                        TextSpan(
                                            text: showRegisterDataPolicyData3,
                                            style: const TextStyle(fontSize: 12,
                                                color: Color.fromRGBO(122, 122, 122, 1),
                                                letterSpacing: 0.2,
                                                fontWeight: FontWeight.w300
                                            )
                                        ),
                                        TextSpan(
                                            text: showRegisterDataPolicyData4,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // Handle tap gesture here
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (BuildContext context) => const PolicyPage()));
                                              },
                                            style: const TextStyle(fontSize: 12,
                                                color: Color.fromRGBO(77, 170, 232, 1),
                                                letterSpacing: 0.2,
                                                fontWeight: FontWeight.w500
                                            )
                                        ),
                                      ]
                                  ),
                                ) ,
                              )
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