import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:zherdeshmobileapplication/Login/login.dart';
import 'package:zherdeshmobileapplication/Login/signup.dart';
import 'package:zherdeshmobileapplication/UserDatas/announcments_page.dart';
import 'package:zherdeshmobileapplication/UserDatas/userdata_page.dart';
import 'package:zherdeshmobileapplication/UserDatas/settings_page.dart';
import 'package:zherdeshmobileapplication/UserDatas/transfer_page.dart';
import 'package:zherdeshmobileapplication/logo_start.dart';

import '../UserDatas/buyvipstatus_page.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  ProfilePageState createState ()=> ProfilePageState();
}
class ProfilePageState extends State<ProfilePage>{

  String dataShowUserNotRegistered = "";
  String elevatedButtonShowUserNotRegisteredLogin = "";
  String elevatedButtonShowUserNotRegisteredSignUp = "";
  String showRegisterData1 = "";
  String showRegisterData2 = "";
  String showRegisterDataPolicyData1 = "";
  String showRegisterDataPolicyData2 = "";
  String showRegisterDataPolicyData3 = "";
  String showRegisterDataPolicyData4 = "";
  String topic = "";
  String description ="";
  //todo: local variable to set rightly data =>
  bool dataGet = false;
  String fullName = "";
  String imagePath = "";
  String editProfile = "";
  String vipButton = "";
  String addMoneyButton = "";
  String announcementButton = "";
  String exit = "";
  String alertDialogTitle = "";
  String alertDialogDescription = "";
  String choiceYes = "";
  String choiceNo = "";

  //todo: data to set when fetching :=>
  String fetchedName ="";
  String fetchedSurname ="";
  String fetchedEmail ="";
  String fetchedPhone ="";
  bool fetchedUserActivated = false;
  int fetchedMoneys = 0;
  int fetchedUserID = 0;
  String fetchUserStatus = "";
  String fetchDateEndStatus = "";
  //todo => set colors => 
  Color colorData1 = const Color.fromRGBO(2,48, 71, 1);
  Color colorData2 = const Color.fromRGBO(2,77, 115, 1);
  Color colorData3 = const Color.fromRGBO(33,158, 188, 1);
  Color colorData4 = const Color.fromRGBO(26,133, 158, 1);
  Color colorData5 = const Color.fromRGBO(142, 202 , 230, 1);
  Color colorData6 = const Color.fromRGBO(113,168, 193, 1);
  Color colorData7 = const Color.fromRGBO(251,133, 0, 1);
  Color colorData8 = const Color.fromRGBO(182,96, 0, 1);
  Color colorData9 = const Color.fromRGBO(255,183, 3, 1);
  Color colorData0 = const Color.fromRGBO(215, 155 , 4, 1);

  String buttonVipTopic = "";
  String buttonVipDescription = "";
  String buttonAddMoneyTopic = "";
  String buttonAddMoneyDescription = "";
  String buttonUserTopic = "";
  String buttonUserDescription = "";
  String buttonAnnouncementsTopic = "";
  String buttonAnnouncementsDescription = "";
  String buttonSettingsTopic = "";
  String buttonSettingsDescription = "";

  bool defaultImage = false;
  //todo => methods to setProper data =>
  void setDataKyrgyz(){
    dataShowUserNotRegistered = "Жердештин бардык функцияларын \nколдонуу үчүн кириңиз же катталыңыз.";
    elevatedButtonShowUserNotRegisteredLogin = "Кирүү же катталуу";
    showRegisterData1 = "Электрондук почта аркылуу кирүү";
    showRegisterData2 = "Кирүү";
    showRegisterDataPolicyData1 = "Катталуу жана кирүү учурунда";
    showRegisterDataPolicyData2 = "сиз Жердештин пайдалануу шарттарына ";
    showRegisterDataPolicyData3 = "жана ";
    showRegisterDataPolicyData4 = "маалыматтарды иштетүү саясатына макул болосуз";
  }
  void setDataRussian(){
    dataShowUserNotRegistered = "Войдите или зарегистрируйтесь, чтобы \nпользоваться всеми функциями Жердеш.";
    elevatedButtonShowUserNotRegisteredLogin = "Войти";
    elevatedButtonShowUserNotRegisteredSignUp = "Зарегистрироваться";
    showRegisterData1 = "Войти через почту";
    showRegisterData2 = "Зарегистрироваться";
    topic = "Разместите свое объявление - Просто и быстро!";
    description="Прежде чем опубликовать свое объявление, пожалуйста, войдите в свой аккаунт или зарегистрируйтесь";
    editProfile = "Изменить профиль";
    vipButton = "VIP услуги";
    addMoneyButton = "Пополнить счет";
    announcementButton = "Анонсы от компании";
    exit = "Выйти";
    alertDialogTitle = "Вы уверены, что хотите выйти из аккаунта?";
    alertDialogDescription = "Все несохраненные данные могут быть утеряны.";
    choiceYes = "Выйти";
    choiceNo = "Отмена";

    buttonVipTopic = "VIP";
    buttonVipDescription = "Премиум статус позволяет оставлять больше своих объявлений в приложении";
    buttonAddMoneyTopic = "Счет";
    buttonAddMoneyDescription = "Пополните свой счет";
    buttonUserTopic = "Профиль";
    buttonUserDescription = "Редактировать информацию";
    buttonAnnouncementsTopic = "Анонсы";
    buttonAnnouncementsDescription = "Анонсы от Жердеш";
    buttonSettingsTopic = "Настройки";
    buttonSettingsDescription = "Изменить язык и др.";
  }


  Future<void> getUserInfo() async{
    print("Get user data account");
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
      final respose = await dio.get(globals.endpointGetUserData);
      if(respose.statusCode == 200){
        String userDataJson = respose.toString();
        Map<String, dynamic> userMap = json.decode(userDataJson);
        String firstName = userMap['user']['first_name'];
        String lastName = userMap['user']['last_name'];
        String imageServerPath = userMap['user']['avatar'];
        String mail = userMap['user']['email'];
        bool userActivated = userMap['user']['is_confirm'];
        int moneys = userMap['user']['user_cabinet']['balance'];
        int userId = userMap['user']['id'];

        
        setState(() {
          dataGet = true;
          fullName = "$firstName $lastName";
          imagePath = imageServerPath;
          fetchedName = firstName;
          fetchedSurname = lastName;
          fetchedEmail = mail;
          fetchedPhone = (userMap['user']['phone'] == null)? "" : userMap['user']['phone'].toString();
          fetchedUserActivated = userActivated;
          fetchedMoneys = moneys;
          fetchedUserID = userId;
          fetchUserStatus = (userMap['user']['user_cabinet']['user_status']==null)? "basic" : userMap['user']['user_cabinet']['user_status']['title'] ;
          fetchDateEndStatus = (userMap['user']['user_cabinet']['user_status']==null)? "" : userMap['user']['user_cabinet']['user_status']['end_date'].toString();
          if(imageServerPath=="/media/avatars/df/Zherdesh%20logo-05.png"){
            defaultImage = true;
          }
          else{
            defaultImage = false;
          }
        });
      }
    }
    catch(error){
      if(error is DioException){
        if (error.response != null) {
          String toParseData = error.response.toString();
          print("Error while fetch data from user $toParseData");
        }
      }
    }
  }

  void _showCupertinoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
              alertDialogTitle , textAlign: TextAlign.center,
              style: const TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400 , letterSpacing: -0.4
              )
          ),
          content: Text(
              alertDialogDescription ,  textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400 , letterSpacing: -0.4
              )
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: ()async{
                    var box = await Hive.openBox("logins");
                    await box.clear();
                    print("Logins box is cleared !");
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => const LogoStart()));
                  },
                  child: Text(
                      choiceYes,
                      style: const TextStyle(
                          fontSize: 14, color: Color.fromRGBO(239, 29, 52, 1), fontWeight: FontWeight.w400 , letterSpacing: -0.4
                      )
                  ),
                ),
                const SizedBox(width: 15,),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                      choiceNo,
                      style: const TextStyle(
                          fontSize: 14, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w400 , letterSpacing: -0.4
                      )
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }

  Widget userProfile(width, height ,statusBarHeight,  mainSizedBoxHeightUserNotLogged , BuildContext context){
    double userImageHeight = mainSizedBoxHeightUserNotLogged * 0.2;
    double userPart = userImageHeight + 45;
    double buttonVipHeight = mainSizedBoxHeightUserNotLogged * 0.375;
    double othersButtonsHeight = buttonVipHeight * 0.5;
    double buttonVipNextHeight = othersButtonsHeight - 5;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:Padding(padding: EdgeInsets.only(top: statusBarHeight),
          child: Container(
            width: width,
            height: mainSizedBoxHeightUserNotLogged,
            color: const Color.fromRGBO(250, 250, 250, 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //first section create avatar =>
                SizedBox(
                  width: width,
                  height: userPart,
                  child: Column(
                    children: [
                      SizedBox(
                        width: width*0.95,
                        child: Align(
                          alignment: Alignment.center,
                          child: InstaImageViewer(
                            child: CachedNetworkImage(
                                progressIndicatorBuilder: (context, url, downloadProgress){
                                  return Center(
                                    child: SizedBox(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                          strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                },
                                imageUrl: '${globals.mainPath}$imagePath',
                                imageBuilder: (context, imageProvider){
                                  return Container(
                                    width: userImageHeight, height: userImageHeight,
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(154, 154, 154, 0.15),
                                        borderRadius: BorderRadius.circular(20.0),
                                        image: DecorationImage(
                                            image: imageProvider,
                                            filterQuality: FilterQuality.high,
                                            fit: (defaultImage)? BoxFit.contain : BoxFit.cover
                                        )
                                    ),
                                  );
                                },
                            )
                          )
                        ),
                      ),
                      const SizedBox(height: 5,),
                      SizedBox(
                        width: width*0.95,
                        height: 40,
                        child: Text(
                            fullName, textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 28, color: Colors.black, fontWeight: FontWeight.w600 ,
                                letterSpacing: 0, fontStyle: FontStyle.italic , fontFamily: 'ButtonDescription'
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: width*0.95,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => const BuyVipPage()));
                            },
                            child: Container(
                                width: width*0.475-5,
                                height: buttonVipHeight,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      colorData1,
                                      colorData2,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12 , right: 15, bottom: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              buttonVipTopic ,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                  fontSize: 30, color: Colors.white, fontWeight: FontWeight.w400 ,
                                                  fontFamily: 'ButtonTopic'
                                              )
                                          ),
                                          const SizedBox(width: 5,),
                                          Container(
                                            width: 35,
                                            height: 35,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage('assets/images/crown.png'), // Replace with your image path
                                                fit: BoxFit.contain, // Adjust the fit as needed
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                          buttonVipDescription,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.white, fontWeight: FontWeight.w400 ,
                                              fontFamily: 'ButtonDescription'
                                          )
                                      )
                                    ],
                                  ),
                                ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) => const TransferPage()));
                                },
                                child: Container(
                                    width: width*0.475-5,
                                    height: buttonVipNextHeight,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          colorData3,
                                          colorData4,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: Padding(
                                    padding: const EdgeInsets.only(left: 12 , right: 15, bottom: 20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            buttonAddMoneyTopic,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400 ,
                                                fontFamily: 'ButtonTopic'
                                            )
                                        ),
                                        Text(
                                            buttonAddMoneyDescription,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                fontSize: 10, color: Colors.white, fontWeight: FontWeight.w400 ,
                                                fontFamily: 'ButtonDescription'
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) => UserDataPage(
                                          name: fetchedName,
                                          surname: fetchedSurname,
                                          email: fetchedEmail,
                                          avatarNetworkPath: imagePath,
                                          phone: fetchedPhone,
                                          isUserActivated: fetchedUserActivated,
                                          moneyCash: fetchedMoneys,
                                          userID: fetchedUserID,
                                          userStatus: fetchUserStatus,
                                          userStatusEndDate: fetchDateEndStatus,
                                      )
                                  )
                                  );
                                },
                                child: Container(
                                    width: width*0.475-5,
                                    height: buttonVipNextHeight,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          colorData5,
                                          colorData6,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: Padding(
                                    padding: const EdgeInsets.only(left: 12 , right: 15, bottom: 20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            buttonUserTopic ,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400 ,
                                                fontFamily: 'ButtonTopic'
                                            )
                                        ),
                                        Text(
                                            buttonUserDescription,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                fontSize: 10, color: Colors.white, fontWeight: FontWeight.w400 ,
                                                fontFamily: 'ButtonDescription'
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => const AnnouncementPage()));
                            },
                            child: Container(
                                width: width*0.475-5,
                                height: othersButtonsHeight,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      colorData7,
                                      colorData8,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: Padding(
                                padding: const EdgeInsets.only(left: 12 , right: 15, bottom: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        buttonAnnouncementsTopic ,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400 ,
                                            fontFamily: 'ButtonTopic'
                                        )
                                    ),
                                    Text(
                                        buttonAnnouncementsDescription,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white, fontWeight: FontWeight.w400 ,
                                            fontFamily: 'ButtonDescription'
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => const SettingPage()));
                            },
                            child: Container(
                                width: width*0.475-5,
                                height: othersButtonsHeight,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      colorData9,
                                      colorData0,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: Padding(
                                padding: const EdgeInsets.only(left: 12 , right: 15, bottom: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        buttonSettingsTopic ,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400,
                                            fontFamily: 'ButtonTopic'
                                        )
                                    ),
                                    Text(
                                        buttonSettingsDescription,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white, fontWeight: FontWeight.w400,
                                            fontFamily: 'ButtonDescription'
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    _showCupertinoDialog(context);
                  },
                  child: Container(
                    width: width*0.95,
                    height: mainSizedBoxHeightUserNotLogged* 0.06,
                    decoration: BoxDecoration(
                      color: Colors.white, // Set container color
                      borderRadius: BorderRadius.circular(20.0), // Set border radius
                      border: Border.all(
                        color: const Color.fromRGBO(255, 58, 0, 1), // Set border color
                        width: 2.0, // Set border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const  Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: FaIcon(FontAwesomeIcons.arrowRightFromBracket, color: Color.fromRGBO(255, 58, 0, 1), size: 16) ,),
                          const SizedBox(width: 10,),
                          Text(
                              exit, textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(255, 58, 0, 1), fontWeight: FontWeight.w400 , letterSpacing:0
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        )
    );
  }

  Widget loadingData(width , height){
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(left: width*0.3), child :
            Container(
              width: width*0.4,
              height: height*0.4,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/logo.png"),fit: BoxFit.contain, filterQuality: FilterQuality.high,)),
            )),
            const SizedBox(height: 20,),
            Padding(padding: EdgeInsets.only(left: width*0.3) ,
              child: const CircularProgressIndicator(strokeWidth: 2,),
            )
          ],
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomNavBarHeight = kBottomNavigationBarHeight;
    double mainSizedBoxHeightUserNotLogged = height - bottomNavBarHeight - statusBarHeight;

    //todo => localize data =>
    if(globals.userLanguage!="ru"){setDataKyrgyz();}

    if(globals.userLanguage=="ru"){setDataRussian();}

    if(globals.isUserRegistered){
      return (dataGet)? userProfile(width, height, statusBarHeight, mainSizedBoxHeightUserNotLogged , context) : loadingData(width, height);
    }
    else{
      return Scaffold(
        body: Padding(padding: EdgeInsets.only(top: statusBarHeight),
          child: Container(
            width: width,
            height: mainSizedBoxHeightUserNotLogged,
            color: const Color.fromRGBO(250, 250, 250, 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: width*0.9,
                  child: Text(
                      topic, textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 24, color: Colors.black, fontWeight: FontWeight.w600 , letterSpacing: -0.5,
                          height: 1.2
                      )),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  width: width*0.9,
                  child: Text(
                      description, textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400,
                          height: 1.4
                      )),
                ),
                const SizedBox(height: 10,),
                SizedBox(width: width*0.9, height: mainSizedBoxHeightUserNotLogged*0.07,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => const LoginPage()));
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
                        elevatedButtonShowUserNotRegisteredLogin,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500 , letterSpacing: 0.2
                        )),
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(width: width*0.9, height: mainSizedBoxHeightUserNotLogged*0.07  ,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => const SignUpPage()));
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
                        elevatedButtonShowUserNotRegisteredSignUp,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500 , letterSpacing: 0.2
                        )),
                  ),
                ),
                SizedBox(height: mainSizedBoxHeightUserNotLogged*0.1,),
                Container(
                  width: width*0.9, height: height*0.3,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/SignUpImg.png'),
                          fit: BoxFit.contain
                      )
                  ),
                ),
              ],
            ),
          )
        ) ,
      );
    }
  }
}