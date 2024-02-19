import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zherdeshmobileapplication/PolicyPrivacy/policy_page.dart';

import '../HomeFiles/home_screen.dart';
import '../PolicyPrivacy/privacy_page.dart';


class SettingPage extends StatefulWidget{

  const SettingPage({super.key});

  @override
  SettingPageState createState ()=> SettingPageState();
}

class SettingPageState extends State<SettingPage>{

  String title = "";
  String setLanguage = "";
  String created = "";
  String company = "";
  String russia = "";
  String kyrgyzstan = "";
  String selectedOption = globals.userLanguage;
  String kgValue = "ky";
  String ruValue = "ru";
  String langChangedKg  = "New Kyrgyz!";
  String langChangedRu  = "Язык изменен!";
  String promo = "";
  String send = "";
  String successfulPromoCodeRedeemed = "";
  String failedPromoCodeRedeemed = "";
  String errorMessagePromoCodeEmpty = "";
  String privacy ="";
  String policy = "";
  String and = "";
  String rules = "";
  String social = "";

  TextEditingController promoCodeTextEditingController = TextEditingController();

  void setDataKyrgyz(){

  }

  void setDataRussian(){
    title = "Настройки";
    setLanguage = "Выберите язык";
    created = "Разработано командой";
    company = "TEIT\nCORP";
    russia = "Русский";
    kyrgyzstan = "Кыргызский";
    errorMessagePromoCodeEmpty = "Поле промо кода пустое!";
    promo = "Промо код";
    send = "Отправить";
    successfulPromoCodeRedeemed = "Промо код\nактивирован!";
    failedPromoCodeRedeemed = "Код не действителен!";
    privacy = "Условия использования";
    policy = "Политика обработки данных";
    and = "и";
    rules = "Правила и политика";
    social = "Наши соц. сети";
  }

  Widget containerUserData(width , data , TextEditingController controller , TextInputType type , String errorMessage){
    return SizedBox(
      width: width*0.95,
      child: TextFormField(
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: type,
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
            labelText: data,
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
              return errorMessage;
            }
            return null;
          }
      ),
    );
  }

  Widget submitPromoCode(width, height, context){
    return GestureDetector(
      onTap: () async {
        print("Submit promo code");
        String promoGetFromUser = promoCodeTextEditingController.text;
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
          final respose = await dio.get("${globals.endpointSendPromoCode}?promocode=$promoGetFromUser");
          if(respose.statusCode == 200){
            Fluttertoast.showToast(
              msg: successfulPromoCodeRedeemed,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
              backgroundColor: Colors.white, // Background color of the toast
              textColor: Colors.black,
            );
          }
        }
        catch(error){
          if(error is DioException){
            if (error.response != null) {
              Fluttertoast.showToast(
                msg: failedPromoCodeRedeemed,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                backgroundColor: Colors.white, // Background color of the toast
                textColor: Colors.black,
              );
            }
          }
        }
      },
      child: Container(
          width: width*0.95,
          height: height* 0.06,
          decoration: BoxDecoration(
            color: Colors.white, // Set container color
            borderRadius: BorderRadius.circular(10.0), // Set border radius
            border: Border.all(
              color: const Color.fromRGBO(77, 170, 232, 1), // Set border color
              width: 2.0, // Set border width
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.paperPlane, color: Color.fromRGBO(77, 170, 232, 1), size: 16),
              const SizedBox(width: 10,),
              Text(
                  send, textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w500 , letterSpacing:0
                  )),
            ],
          )
      ),
    );
  }

  Future<void> _launchURL(Uri url) async {
    await launchUrl(url);
  }



  @override
  void dispose() {
    promoCodeTextEditingController.dispose();
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
    double mainSizedBoxHeightUserNotLogged = height- statusBarHeight;

    double socialNetworkContainer = width/5;
    double socialNetworkLogo = width/8;

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
                child:  SizedBox(
                  width: width*0.95,
                  height: mainSizedBoxHeightUserNotLogged,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //first elem is x to sign out =>
                        SizedBox(
                          width: width*0.95,
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: IconButton(
                                  onPressed: (){
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (BuildContext context) => const HomeScreen(positionBottomNavigationBar: 2)));
                                  },
                                  icon: const Icon(Icons.arrow_back_ios, color: Color.fromRGBO(171, 176, 186, 1), size: 30,),
                                ),
                              ),
                              SizedBox(
                                  height: 40,
                                  width: width*0.7,
                                  child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                          title, textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500
                                          ))
                                  )
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                            height: 25 ,
                            width: width*0.95,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                setLanguage ,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 18, color: Colors.black ,
                                ),
                              ),
                            )
                        ),
                        const SizedBox(height: 10,),
                        SizedBox(
                          width: width*0.95,
                          child: Column(
                            children: [
                              Container(
                                width: width*0.95,
                                height: mainSizedBoxHeightUserNotLogged*0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                    color: const Color.fromRGBO(221, 221, 221, 1), // Set border color
                                    width: 1.0, // Set border width
                                  ),
                                  color: Colors.white,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: RadioListTile(
                                    title: Text(kyrgyzstan),
                                    value: kgValue,
                                    groupValue: selectedOption,
                                    onChanged: (value) async {
                                      var box = await Hive.openBox("LaunchData");
                                      box.put("Language", kgValue);
                                      Fluttertoast.showToast(
                                        msg: langChangedKg,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                                        backgroundColor: Colors.white, // Background color of the toast
                                        textColor: Colors.black,
                                      );
                                      setState(() {
                                        selectedOption = value!;
                                        globals.userLanguage = kgValue;

                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    secondary: Container(
                                      width: width*0.2,
                                      height: mainSizedBoxHeightUserNotLogged*0.075,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        border: Border.all(
                                          color: const Color.fromRGBO(221, 221, 221, 1), // Set border color
                                          width: 1.0, // Set border width
                                        ),
                                        image: const DecorationImage(
                                          image: AssetImage('assets/images/flagKg.png'), // Replace with your image path
                                          fit: BoxFit.cover, // Adjust the fit as needed
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: width*0.95,
                                  height: mainSizedBoxHeightUserNotLogged * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                      color: const Color.fromRGBO(221, 221, 221, 1), // Set border color
                                      width: 1.0, // Set border width
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: RadioListTile(
                                      title: Text(russia),
                                      value: ruValue,
                                      groupValue: selectedOption,
                                      onChanged: (value) async{
                                        var box = await Hive.openBox("LaunchData");
                                        box.put("Language", ruValue);
                                        Fluttertoast.showToast(
                                          msg: langChangedRu,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                                          backgroundColor: Colors.white, // Background color of the toast
                                          textColor: Colors.black,
                                        );
                                        setState(() {
                                          selectedOption = value!;
                                          globals.userLanguage = ruValue;
                                        });
                                      },
                                      controlAffinity: ListTileControlAffinity.trailing,
                                      secondary: Container(
                                        width: width*0.2,
                                        height: mainSizedBoxHeightUserNotLogged*0.075,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          border: Border.all(
                                            color: const Color.fromRGBO(221, 221, 221, 1), // Set border color
                                            width: 1.0, // Set border width
                                          ),
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/flagRu.png'), // Replace with your image path
                                            fit: BoxFit.cover, // Adjust the fit as needed
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        SizedBox(
                            height: 25 ,
                            width: width*0.95,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                promo ,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 18, color: Colors.black ,
                                ),
                              ),
                            )
                        ),
                        const SizedBox(height: 10,),
                        containerUserData(width, promo, promoCodeTextEditingController, TextInputType.text, errorMessagePromoCodeEmpty),
                        const SizedBox(height: 15,),
                        submitPromoCode(width, height, context),
                        const SizedBox(height: 20,),
                        //zherdesh company
                        SizedBox(
                            height: 25 ,
                            width: width*0.95,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                rules ,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400 ,
                                    fontFamily: 'ButtonDescription'
                                ),
                              ),
                            )
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: mainSizedBoxHeightUserNotLogged*0.2,
                              height: mainSizedBoxHeightUserNotLogged*0.25,
                              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/logo.png"),fit: BoxFit.fill)),
                            ),
                            const SizedBox(width: 15,),
                            SizedBox(
                                height: 100 ,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (BuildContext context) => const PrivacyPage()));
                                        },
                                        child: Text(
                                          privacy ,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12, color: Color.fromRGBO(77, 170, 232, 1) , fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        and ,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 18, color: Color.fromRGBO(122, 122, 122, 1) , fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (BuildContext context) => const PolicyPage()));
                                        },
                                        child: Text(
                                          policy ,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12, color: Color.fromRGBO(77, 170, 232, 1) , fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ),
                          ],
                        ),
                        const SizedBox(height: 15,),
                        SizedBox(
                            height: 25 ,
                            width: width*0.95,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                social ,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400 ,
                                    fontFamily: 'ButtonDescription'
                                ),
                              ),
                            )
                        ),
                        const SizedBox(height: 15,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: (){
                                String launch = "https://vk.com/id835685516";
                                Uri uri = Uri.parse(launch);
                                _launchURL(uri);
                              },
                              child: Container(
                                width: socialNetworkContainer,
                                height: socialNetworkContainer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: const Color.fromRGBO(0, 119, 255, 1),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: FaIcon(FontAwesomeIcons.vk, color: const Color.fromRGBO(255, 255, 255, 1), size: socialNetworkLogo,),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                String launch = "https://ok.ru/profile/574226572471?utm_campaign=ios_share&utm_content=profile";
                                Uri uri = Uri.parse(launch);
                                _launchURL(uri);
                              },
                              child: Container(
                                width: socialNetworkContainer,
                                height: socialNetworkContainer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: const Color.fromRGBO(249, 116, 0, 1),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: FaIcon(FontAwesomeIcons.odnoklassniki, color: const Color.fromRGBO(255, 255, 255, 1), size: socialNetworkLogo,),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                String launch = "https://t.me/zherdeshru_official";
                                Uri uri = Uri.parse(launch);
                                _launchURL(uri);
                              },
                              child: Container(
                                width: socialNetworkContainer,
                                height: socialNetworkContainer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: const Color.fromRGBO(0, 119, 255, 1),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: FaIcon(FontAwesomeIcons.telegram, color: const Color.fromRGBO(255, 255, 255, 1), size: socialNetworkLogo,),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                String launch = "https://www.instagram.com/zherdesh.ru_official?igsh=MW5ubGd5aTY5N2ducA==";
                                Uri uri = Uri.parse(launch);
                                _launchURL(uri);
                              },
                              child: Container(
                                width: socialNetworkContainer,
                                height: socialNetworkContainer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF405DE6), // Instagram Purple
                                      Color(0xFF833AB4), // Instagram Pink
                                      Color(0xFFC13584), // Instagram Dark Pink
                                      Color(0xFFFD1D1D), // Instagram Red
                                    ],
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: FaIcon(FontAwesomeIcons.instagram, color: const Color.fromRGBO(255, 255, 255, 1), size: socialNetworkLogo,),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                )
            ),
          )
      ),
    );

  }
}