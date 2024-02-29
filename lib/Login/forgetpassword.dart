import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;

import 'codeinbox.dart';
import 'login.dart';

class ForgetPassword extends StatefulWidget{
  const ForgetPassword({super.key});

  @override
  ForgetPasswordState createState ()=> ForgetPasswordState();
}
class ForgetPasswordState extends State<ForgetPassword>{
  String dataTopic = "";
  String hintText = "";
  String email = "";
  String showDataButton = "";
  String errorMessageEmail = "";

  TextEditingController emailController = TextEditingController();

  //bool to show if TextFormField have any value or not =>
  bool textFormFieldHaveValue = false;

  //key for form field
  final formKeyForgetPassword = GlobalKey<FormState>();

  //todo => methods to setProper data =>
  void setDataKyrgyz(){
    dataTopic = "Сырсөзүңүздү унуттуңузбу?";
    hintText = "Сырсөздү баштапкы абалга келтирүү үчүн текшерүү кодун жөнөтүңүз жана электрондук почтаңыздын дарегин жазыңыз.";
    email = "Эл. почта";
    showDataButton = "Жөнөтүү";
    errorMessageEmail = "Почта талаасы бош!";
  }
  void setDataRussian(){
    dataTopic = "Забыли пароль?";
    hintText = "Введите свой адрес электронной почты, чтобы отправить код подтверждения для сброса пароля.";
    email = "Эл. почта";
    showDataButton = "Отправить";
    errorMessageEmail = "Поле почты пустое!";
  }

  Widget textFormFieldEmail(width){
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
          onChanged: (valueChanged){
            if(valueChanged.length>0){
              setState(() {
                textFormFieldHaveValue = true;
              });
            }
            else{
              setState(() {
                textFormFieldHaveValue = false;
              });
            }
          },
          validator: (String?value){
            if(value!.isEmpty){
              return errorMessageEmail;
            }
            return null;
          }
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
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
              child: Form(
                key: formKeyForgetPassword,
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
                                  builder: (BuildContext context) => const LoginPage()));
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
                                height: 80,
                                child: Text(
                                    hintText, textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 14, color: Color.fromRGBO(40, 40, 40, 1),
                                        fontWeight: FontWeight.w300 , letterSpacing: 0.2
                                    ))
                            ),
                            const SizedBox(height: 10,),
                            textFormFieldEmail(width),
                            const SizedBox(height: 10,),
                            SizedBox(width: width*0.85,
                                height: mainSizedBoxHeightUserNotLogged*0.07  ,
                                child: ElevatedButton(
                                    onPressed: ()async{
                                      if (formKeyForgetPassword.currentState!.validate()) {
                                        //todo => if email is not empty =>
                                        final dio = Dio();
                                        dio.options.headers['Accept-Language'] = globals.userLanguage;
                                        try{
                                          //todo => send data to server : =>
                                          final respose = await dio.post(globals.endpointResetPassword, data: {"email" : emailController.text});
                                          if(respose.statusCode == 200){
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                builder: (BuildContext context) => CodeInbox(userEmailForgetPassword: emailController.text,)));
                                          }
                                        }
                                        catch(error){
                                          if(error is DioException){
                                            if (error.response != null) {
                                              String toParseData = error.response.toString();
                                              Map<String, dynamic> jsonMap = json.decode(toParseData);
                                              List<String> emails = List<String>.from(jsonMap['email']);
                                              Fluttertoast.showToast(
                                                msg: emails[0],
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
                                        backgroundColor: (textFormFieldHaveValue)?
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromRGBO(77, 170, 232, 1)
                                        ) :
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromRGBO(221, 221, 221, 1)
                                        )
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
      )
    );
  }
}