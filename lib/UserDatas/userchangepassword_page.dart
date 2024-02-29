import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:zherdeshmobileapplication/UserDatas/passwordchanged_page.dart';

import 'edituser_page.dart';


class UserChangePassword extends StatefulWidget{
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
  const UserChangePassword(
      {super.key,
        required this.name , required this.surname , required this.email,
        required this.avatarNetworkPath , required this.phone,
        required this.isUserActivated , required this.moneyCash , required this.userID, required this.userStatus,
        required this.userStatusEndDate
      }
      );

  @override
  UserChangePasswordState createState ()=> UserChangePasswordState();
}
class UserChangePasswordState extends State<UserChangePassword>{

  String dataTopic = "";
  String password = "";
  String oldpassword = "";
  String retrypassword = "";
  String continues = "";
  String errormessagePasswordsNotEqual = "";
  String errormessagePasswordsLenTooShort = "";

  //bool to show password ->
  bool passwordVisibleEditorOld = false;
  bool passwordVisibleEditor1 = false;
  bool passwordVisibleEditor2 = false;

  TextEditingController passwordControllerOld = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRetryController = TextEditingController();

  //key for form field
  final formNewUserPasswordCreation = GlobalKey<FormState>();

  void setDataKyrgyz(){
    dataTopic = "Кирүү";
    oldpassword = "Эски сырсөз";
    password = "Сөздү кириш";
    retrypassword = "Сырсөздү кайра киргизиңиз";
    continues = "Улантуу";
    errormessagePasswordsNotEqual = "Сырсөздөр дал келбейт!";
    errormessagePasswordsLenTooShort = "Сырсөздүн узундугу кеминде 8 белгиден турушу керек!";
  }

  void setDataRussian(){
    dataTopic = "Смена пароля";
    oldpassword = "Старый пароль";
    password = "Введите пароль";
    retrypassword = "Повторно введите пароль";
    continues = "Продолжить";
    errormessagePasswordsNotEqual = "Пароли не совпадают!";
    errormessagePasswordsLenTooShort = "Длина пароля должна быть минимум 8 символов!";
  }

  Widget newTextFormFieldPasswordValidOld(
      width , TextEditingController controller ,
      bool passwordVisible, String data , String errorMessage){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.visiblePassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: !passwordVisibleEditorOld,
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
            hintText: data,
            contentPadding: const EdgeInsets.symmetric(vertical: 15 , horizontal: 10),
            suffixIcon: IconButton(
              icon: FaIcon(
                // Based on passwordVisible state choose the icon
                passwordVisibleEditorOld
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                color: const Color.fromRGBO(137, 138, 141, 1),
                size: 16,
              ),
              onPressed: () {
                setState(() {
                  passwordVisibleEditorOld = !passwordVisibleEditorOld;
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
              return errorMessage;
            }
            return null;
          }
      ),
    );
  }

  Widget newTextFormFieldPasswordValidFirst(
      width , TextEditingController controller ,
      bool passwordVisible, String data , String errorMessage){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: controller,
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
            hintText: data,
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
              return errorMessage;
            }
            return null;
          }
      ),
    );
  }

  Widget newTextFormFieldPasswordValidSecond(
      width , TextEditingController controller ,
      bool passwordVisible, String data , String errorMessage){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: controller,
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
            hintText: data,
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
              return errorMessage;
            }
            return null;
          }
      ),
    );
  }


  @override
  void dispose() {
    passwordControllerOld.dispose();
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
            builder: (BuildContext context) => EditUserPage(
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
                                    builder: (BuildContext context) => EditUserPage(
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
                              newTextFormFieldPasswordValidOld(width, passwordControllerOld ,passwordVisibleEditorOld , oldpassword , errormessagePasswordsLenTooShort),
                              const SizedBox(height: 10,),
                              newTextFormFieldPasswordValidFirst(width, passwordController ,passwordVisibleEditor1 , password , errormessagePasswordsLenTooShort),
                              const SizedBox(height: 10,),
                              newTextFormFieldPasswordValidSecond(width, passwordRetryController ,passwordVisibleEditor2 , retrypassword , errormessagePasswordsLenTooShort),
                              const SizedBox(height: 15,),
                              SizedBox(
                                  width: width*0.85,
                                  height: mainSizedBoxHeightUserNotLogged*0.07,
                                  child: ElevatedButton(
                                      onPressed: () async{
                                        if(passwordController.text==passwordRetryController.text){
                                          if(formNewUserPasswordCreation.currentState!.validate()){
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
                                              final respose = await dio.post(globals.endpointChangePasswordUser,
                                                  data: {"old_password" : passwordControllerOld.text , "new_password" : passwordController.text});
                                              if(respose.statusCode == 200){
                                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                    builder: (BuildContext context) => PasswordChangedPage()));
                                                }
                                            }
                                            catch(error){
                                              if(error is DioException){
                                                if (error.response != null) {
                                                  String toParseData = error.response.toString();
                                                  Map<String, dynamic> jsonDecode = json.decode(toParseData);
                                                  print(jsonDecode);

                                                  List<String> oldPasswordErrors = [];
                                                  List<String> newPasswordErrors = [];

                                                  String passwordErrorMessage = "";
                                                  if (jsonDecode.containsKey('old_password')) {
                                                    oldPasswordErrors = jsonDecode['old_password'].cast<String>();
                                                    passwordErrorMessage = "$passwordErrorMessage${oldPasswordErrors[0]}";
                                                  }
                                                  // Accessing and printing error messages for new_password
                                                  if (jsonDecode.containsKey('new_password')) {
                                                    newPasswordErrors = jsonDecode['new_password'].cast<String>();
                                                    passwordErrorMessage = "$passwordErrorMessage${newPasswordErrors[0]}";
                                                  }
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