import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_vk/flutter_login_vk.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:zherdeshmobileapplication/Login/newuserpasswordcreation.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;

import '../HomeFiles/home_screen.dart';
import '../PolicyPrivacy/policy_page.dart';
import '../PolicyPrivacy/privacy_page.dart';
import '../logo_start.dart';
import 'login.dart';


class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});

  @override
  SignUpPageState createState ()=> SignUpPageState();
}
class SignUpPageState extends State<SignUpPage>{
  String dataTopic = "";
  String email = "";
  String andText = "";
  String vkSignUp = "";
  String appleSignUp = "";
  String googleSignUp = "";
  String alreadyhaveaccount = "";
  String entertoaccount = "";
  String continues = "";
  String errormessageEmail = "";
  String showRegisterDataPolicyData1 = "";
  String showRegisterDataPolicyData2 = "";
  String showRegisterDataPolicyData3 = "";
  String showRegisterDataPolicyData4 = "";

  TextEditingController emailController = TextEditingController();

  //key for form field
  final formSignUp = GlobalKey<FormState>();
  //todo :=> social sign in :
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //todo => methods to setProper data =>
  void setDataKyrgyz(){
    dataTopic = "Каттоо";
    email = "Эл. почта";
    andText = "же";
    vkSignUp = "ВК аркылуу кириңиз";
    appleSignUp = "Apple аркылуу кириңиз";
    googleSignUp = "Google аркылуу кириңиз";
    continues = "Улантуу";
    alreadyhaveaccount = "Сиздин аккаунтуңуз барбы? ";
    entertoaccount = "Кирүү";
    errormessageEmail = "Почта талаасы бош!";
    showRegisterDataPolicyData1 = "Каттоо жана кирүү менен";
    showRegisterDataPolicyData2 = "\nЖердештин колдонуу шарттарына ";
    showRegisterDataPolicyData3 = "жана";
    showRegisterDataPolicyData4 = " маалыматтарды иштетүү саясатына макул болосуз";
  }

  void setDataRussian(){
    dataTopic = "Регистрация";
    email = "Эл. почта";
    andText = "или";
    vkSignUp = "Войти с помощью VK";
    appleSignUp = "Войти с помощью Apple";
    googleSignUp = "Войти с помощью Google";
    continues = "Продолжить";
    alreadyhaveaccount = "Есть аккаунт? ";
    entertoaccount = "Войти";
    errormessageEmail = "Поле почта пустое!";
    showRegisterDataPolicyData1 = "При регистрации и входе вы соглашаетесь c";
    showRegisterDataPolicyData2 = "\nусловиями использования Жердеш ";
    showRegisterDataPolicyData3 = "и ";
    showRegisterDataPolicyData4 = "политикой обработки данных";
  }

  Widget signupTextFormFieldEmailValidNew (width){
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
              return errormessageEmail;
            }
            return null;
          }
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      String? email = googleSignInAccount.email;
      String? fullName = googleSignInAccount.displayName;
      List<String>? parts = fullName?.split(" ");
      String? firstName = parts?[0];
      String? lastName = parts?[1];
      String? avatarString = googleSignInAccount.photoUrl;
      String? password = googleSignInAuthentication.accessToken;

      //register google acc =>
      final dio = Dio();
      dio.options.headers['Accept-Language'] = globals.userLanguage;
      try{
        final respose = await dio.post(
            globals.endpointRegisterGoogle,
            data: {
              "email" : email,
              "password_refresh_token" : password,
              "avatar" : avatarString,
              "first_name" : firstName,
              "last_name" : lastName
            });
        if(respose.statusCode == 201){
          Map<String, dynamic> jsonData = jsonDecode(respose.toString());
          // Access the values
          String refresh = jsonData["tokens"]['refresh'];
          String access = jsonData["tokens"]['access'];


          var box = await Hive.openBox("logins");
          box.put("refresh", refresh);
          box.put("access", access);
          box.put("Social", "Google");

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const LogoStart()));
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

    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignInApple() async {
    try {
      //register apple acc =>
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print(credential);
      print(credential.authorizationCode);
      print(credential.email);
      print(credential.familyName);
      print(credential.givenName);
      print(credential.identityToken);
      print(credential.userIdentifier);

    } catch (error) {
      print(error);
    }
  }

  Widget userSignUpButton(width , mainSizedBoxHeightUserNotLogged){
    if(Platform.isIOS){
      return GestureDetector(
        onTap: ()async{
          print("Apple");
          await _handleSignInApple();
        },
        child: Container(
            width: width*0.85,
            height: mainSizedBoxHeightUserNotLogged*0.075,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color.fromRGBO(234, 234, 234, 1),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.apple, color: Colors.black, size: 20,),
                    Padding(padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        appleSignUp ,textAlign: TextAlign.center, style: const TextStyle(
                          fontSize: 18, color: Colors.black,
                          fontWeight: FontWeight.w400 , letterSpacing: 0.2
                      ),
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      );
    }
    else{
      return Container();
    }
  }

  Future<void> _handleSignInVK() async {
    try {
      // Create an instance of VKLogin
      final vk = VKLogin();
      // Initialize
      await vk.initSdk();
      // Log in
      final res = await vk.logIn(scope: [
        VKScope.email,
      ]);

      // Check result
      if (res.isValue) {
        // There is no error, but we don't know yet
        // if user logged in or not.
        // You should check isCanceled
        final VKLoginResult result = res.asValue!.value;

        if (result.isCanceled) {
          // User cancel log in
        } else {
          // Logged in

          // Send access token to server for validation and auth
          final VKAccessToken? accessToken = result.accessToken;
          if (accessToken != null) {
            // Get profile data
            final profileRes = await vk.getUserProfile();
            final profile = profileRes.asValue?.value;
            if (profile != null) {
              //register VK acc =>
              final dio = Dio();
              dio.options.headers['Accept-Language'] = globals.userLanguage;
              try{
                final respose = await dio.post(
                    globals.endpointRegisterVK,
                    data: {
                      "email" : "${profile.userId}@vk.com",
                      "password_refresh_token" : profile.userId,
                      "avatar" : profile.photo200,
                      "first_name" : profile.firstName,
                      "last_name" : profile.lastName
                    });
                if(respose.statusCode == 201){
                  Map<String, dynamic> jsonData = jsonDecode(respose.toString());
                  // Access the values
                  String refresh = jsonData["tokens"]['refresh'];
                  String access = jsonData["tokens"]['access'];


                  var box = await Hive.openBox("logins");
                  box.put("refresh", refresh);
                  box.put("access", access);
                  box.put("Social", "VK");

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const LogoStart()));
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


          } else {
            print('Something goes wrong');
          }
        }
      } else {
        // Log in failed
        final errorRes = res.asError!;
        print('Error while log in: ${errorRes.error}');
      }

    } catch (error) {
      print(error);
    }
  }


  @override
  void dispose() {
    emailController.dispose();
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
              builder: (BuildContext context) => const HomeScreen(positionBottomNavigationBar: 2)));
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
                    key: formSignUp,
                    child: SizedBox(
                      width: width*0.95,
                      height: mainSizedBoxHeightUserNotLogged,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      builder: (BuildContext context) => const HomeScreen(positionBottomNavigationBar: 2)));
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
                                      )),
                                ),
                                const SizedBox(height: 15),
                                signupTextFormFieldEmailValidNew(width),
                                const SizedBox(height: 10),
                                SizedBox(
                                    width: width*0.85,
                                    height: mainSizedBoxHeightUserNotLogged*0.07,
                                    child: ElevatedButton(
                                        onPressed: () async{
                                          if(formSignUp.currentState!.validate()){
                                            final dio = Dio();
                                            dio.options.headers['Accept-Language'] = globals.userLanguage;
                                            try{
                                              final respose = await dio.post(globals.endpointCheckEmailSignUp, data: {"email" : emailController.text});
                                              if(respose.statusCode == 200){
                                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                    builder: (BuildContext context) => SignUpPageNewUserCreatePassword(newUserEmail: emailController.text)));
                                              }
                                            }
                                            catch(error){
                                              if(error is DioException){
                                                if (error.response != null) {
                                                  String toParseData = error.response.toString();
                                                  dynamic data = jsonDecode(toParseData);
                                                  String emailErrorMessage = data['email'][0];
                                                  Fluttertoast.showToast(
                                                    msg: emailErrorMessage,
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
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: width*0.85,
                                  height: 20,
                                  child: Text(
                                      andText, textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 14, color: Color.fromRGBO(122, 122, 122, 1), fontWeight: FontWeight.w300 , letterSpacing: 0.2
                                      )),
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: (){
                                    print("VK");
                                    _handleSignInVK();
                                  },
                                  child: Container(
                                      width: width*0.85,
                                      height: mainSizedBoxHeightUserNotLogged*0.075,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color.fromRGBO(234, 234, 234, 1),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const FaIcon(FontAwesomeIcons.vk, color: Color.fromRGBO(0, 119, 255, 1), size: 20,),
                                              Padding(padding: const EdgeInsets.only(left: 10),
                                                child: Text(
                                                  vkSignUp , textAlign: TextAlign.center ,style: const TextStyle(
                                                  fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400 , letterSpacing: 0.2,
                                                ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                                const SizedBox(height: 10),
                                userSignUpButton(width, mainSizedBoxHeightUserNotLogged),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () async{
                                    await _handleSignIn();
                                  },
                                  child: Container(
                                      width: width*0.85,
                                      height: mainSizedBoxHeightUserNotLogged*0.075,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color.fromRGBO(234, 234, 234, 1),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Align(alignment: Alignment.center,
                                        child: SizedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image.asset('assets/icon/googleicon.png', width: 20, height: 20),
                                              Padding(padding: const EdgeInsets.only(left: 10),
                                                child: Text(
                                                  googleSignUp ,textAlign: TextAlign.center, style: const TextStyle(
                                                    fontSize: 18, color: Colors.black,
                                                    fontWeight: FontWeight.w400 , letterSpacing: 0.2
                                                ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: width*0.85,
                                    height: 20,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            alreadyhaveaccount,
                                            style: const TextStyle(
                                                fontSize: 16, color: Colors.black,
                                                fontWeight: FontWeight.w400 , letterSpacing: 0.2
                                            )),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                builder: (BuildContext context) => const LoginPage()));
                                          },
                                          child: Text(
                                              entertoaccount,
                                              style: const TextStyle(
                                                  fontSize: 16, color: Color.fromRGBO(77, 170, 232, 1),
                                                  fontWeight: FontWeight.w500 , letterSpacing: 0.2
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