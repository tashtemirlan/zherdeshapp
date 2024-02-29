import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zherdeshmobileapplication/UserDatas/codesendedtomail_page.dart';
import 'package:zherdeshmobileapplication/UserDatas/edituser_page.dart';

import '../Advertise/user_advert_full_view_page.dart';
import '../HomeFiles/home_screen.dart';

class UserDataPage extends StatefulWidget{
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
  const UserDataPage(
      {super.key,
        required this.name , required this.surname , required this.email,
        required this.avatarNetworkPath , required this.phone,
        required this.isUserActivated , required this.moneyCash, required this.userID,
        required this.userStatus, required this.userStatusEndDate
      }
  );

  @override
  UserDataPageState createState ()=> UserDataPageState();
}

class UserDataPageState extends State<UserDataPage>{

  String changeImageString = "";
  String nameString = "";
  String surnameString = "";
  String emailString = "";
  String phoneNumberString = "";
  String emailConfirmedString = "";
  String emailNotConfirmedString = "";
  String continues = "";
  String title = "";
  String changeUserData = "";
  String statusUser = "";
  String statusUserEndForm = "";
  String moneyTotal = "";
  String myAdvertises = "";
  bool dataGet = false;
  String showMessageTitle = "";
  String showMessageDescription = "";
  String rightDataUserStatus = "";
  bool anyRecords = false;
  bool viewRectangle = true;

  //lists =>
  List<String> postIdList = [];
  List<String> postTitleList = [];
  List<String> postDescriptionList = [];
  List<String> postMetroNameList = [];
  List<bool> postIsActiveList = [];
  List<String> postImagePathList = [];
  List<bool> postIsColoredList = [];
  List<bool> postIsVipList = [];

  String advertiseNotActive = "";
  bool userGetStatus = false;
  void setDataKyrgyz(){
    nameString = "Ысым";
    surnameString = "Атасынын аты";
    emailString = "Почта";
    phoneNumberString = "Байланыш";
    emailConfirmedString = "Почта тастыкталды";
    emailNotConfirmedString = "Почта тастыкталган жок";
    changeUserData = "Профилди түзөт";
    title = "Профиль";
    moneyTotal = "Баланс";
    myAdvertises = "Менин жарыяларым";
    showMessageTitle = "Жарыялар жок";
    showMessageDescription = "Сиз азырынча \nбир дагы жарнама түзө элексиз";
    statusUser = "Статусу";
    statusUserEndForm = "Статустун аяктоо күнү";
    advertiseNotActive = "Активдүү эмес";
  }

  void setDataRussian(){
      nameString = "Имя";
      surnameString = "Фамилия";
      emailString = "Почта";
      phoneNumberString = "Телефон";
      emailConfirmedString = "Почта подтверждена";
      emailNotConfirmedString = "Почта не подтверждена";
      changeUserData = "Редактировать профиль";
      title = "Профиль";
      moneyTotal = "Баланс";
      myAdvertises = "Мои объявления";
      showMessageTitle = "Нет объявлений";
      showMessageDescription = "Вы пока не создали \nни одного объявления";
      statusUser = "Статус";
      statusUserEndForm = "Дата окончания статуса";
      advertiseNotActive = "Не активно";

  }

  String formatDateString(String originalDateString) {
    // Split the original date string
    List<String> dateParts = originalDateString.split(' ');

    // Map month names to their Russian equivalents
    Map<String, String> monthTranslations = {
      '1': 'Января',
      '2': 'Февраля',
      '3': 'Марта',
      '4': 'Апреля',
      '5': 'Мая',
      '6': 'Июня',
      '7': 'Июля',
      '8': 'Августа',
      '9': 'Сентября',
      '10': 'Октября',
      '11': 'Ноября',
      '12': 'Декабря',
    };

    // Extract day, month, and year
    String day = dateParts[0];
    String month = monthTranslations[dateParts[1]] ?? dateParts[1];
    String year = dateParts[2];

    // Construct the formatted date string
    return '$day $month $year';
  }

  Widget userProfilePage(width, height, context){
    double userImageHeight = height * 0.25;

    String formattedDateString = "";
    if(widget.userStatusEndDate!=""){
      DateTime dateTime = DateTime.parse(widget.userStatusEndDate.toString());

      String dateTimeString = "${dateTime.day} ${dateTime.month} ${dateTime.year}";
      formattedDateString = formatDateString(dateTimeString);
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          const SizedBox(height: 10,),
          //first section create avatar =>
          SizedBox(
            width: width*0.9,
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
                      imageUrl: '${globals.mainPath}${widget.avatarNetworkPath}',
                      imageBuilder: (context, imageProvider){
                        return Container(
                          width: userImageHeight, height: userImageHeight,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(154, 154, 154, 0.15),
                              borderRadius: BorderRadius.circular(20.0),
                              image: DecorationImage(
                                  image: imageProvider,
                                  filterQuality: FilterQuality.high,
                                  fit: (widget.avatarNetworkPath=="/media/avatars/df/Zherdesh%20logo-05.png")?BoxFit.contain: BoxFit.cover
                              )
                          ),
                        );
                      },
                    )
                )
            ),
          ),
          const SizedBox(height: 15,),
          containerUserData(width, height, nameString, widget.name),
          const SizedBox(height: 10),
          containerUserData(width, height, surnameString, widget.surname),
          const SizedBox(height: 10),
          containerUserData(width, height, emailString, widget.email),
          const SizedBox(height: 10),
          containerUserData(width, height, phoneNumberString, widget.phone),
          const SizedBox(height: 15),
          (widget.isUserActivated) ? userMailConfirmed(width, height, context) : userMailNotConfirmed(width, height, context, widget.isUserActivated),
          const SizedBox(height: 15),
          editUserWidget(width, height, context),
          const SizedBox(height: 20),
          containerUserData(width, height, statusUser, rightDataUserStatus),
          (userGetStatus) ? Padding(
              padding: const EdgeInsets.only(top: 10),
              child: containerUserData(width, height, statusUserEndForm, formattedDateString),
          )
              :
          const SizedBox(),
          const SizedBox(height: 10),
          containerUserData(width, height, moneyTotal, widget.moneyCash.toString()),
          const SizedBox(height: 20),
          SizedBox(
            width: width*0.9,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  myAdvertises, textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 14, color: Color.fromRGBO(148, 148, 148, 1), fontWeight: FontWeight.w400 ,
                    letterSpacing: 0,
                  )
              ),
            ),
          ),
          const SizedBox(height: 10,),
          SizedBox(
              width: width*0.9,
              height: 75,
              child: (viewRectangle)? rowButtonViewRectangle() : rowButtonViewSquare()
          ),
          const SizedBox(height: 10,),
          (viewRectangle)? showUserAdvertiseRectangle(width, height, context) : showAdvertiseSquare(width, height, context),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget rowButtonViewRectangle(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            setState(() {
              viewRectangle= true;
            });
          },
          child: Container(
            width: 45,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black, // Set the border color
                width: 2.0, // Set the border width
              ),
              borderRadius: BorderRadius.circular(5.0), // Optional: Set border radius
            ),
          ),
        ),
        const SizedBox(width: 15,),
        GestureDetector(
          onTap: (){
            setState(() {
              viewRectangle = false;
            });
          },
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(148, 148, 148, 1), // Set the border color
                width: 2.0, // Set the border width
              ),
              borderRadius: BorderRadius.circular(5.0), // Optional: Set border radius
            ),
          ),
        ),
      ],
    );
  }

  Widget rowButtonViewSquare(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            setState(() {
              viewRectangle = true;
            });
          },
          child: Container(
            width: 45,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: const  Color.fromRGBO(148, 148, 148, 1), // Set the border color
                width: 2.0, // Set the border width
              ),
              borderRadius: BorderRadius.circular(5.0), // Optional: Set border radius
            ),
          ),
        ),
        const SizedBox(width: 15,),
        GestureDetector(
          onTap: (){
            setState(() {
              viewRectangle = false;
            });
          },
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black, // Set the border color
                width: 2.0, // Set the border width
              ),
              borderRadius: BorderRadius.circular(5.0), // Optional: Set border radius
            ),
          ),
        ),
      ],
    );
  }

  Widget showUserAdvertiseRectangle(width , height , context){
    return SizedBox(
      width: width*0.9,
      child: (dataGet)? userAdvertiseListChild(width, height, context) : loadingData(),
    );
  }

  Widget showAdvertiseSquare(width , height , context){
    return SizedBox(
      width: width*0.9,
      child: (dataGet)? userSquareAdvertiseListChild(width, height, context) : loadingData(),
    );
  }

  Widget containerUserData(width , height , data , dataValue){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            data, textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 14, color: Color.fromRGBO(148, 148, 148, 1), fontWeight: FontWeight.w400 ,
              letterSpacing: 0,
            )
        ),
        Container(
          width: width*0.9,
          height: height * 0.06,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromRGBO(245, 245, 245, 1)
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const  EdgeInsets.only(left: 10),
              child: Text(
                  dataValue, textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400 ,
                    letterSpacing: 0,
                  )
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget userMailNotConfirmed(width, height, context , isConfirmVal){
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => CodeInboxConfirmEmail(
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
        ));
      },
      child: Container(
        width: width*0.9,
        height: height* 0.06,
        decoration: BoxDecoration(
          color: Colors.white, // Set container color
          borderRadius: BorderRadius.circular(10.0), // Set border radius
          border: Border.all(
            color: const Color.fromRGBO(253, 93, 93, 1), // Set border color
            width: 2.0, // Set border width
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.userXmark, color: Color.fromRGBO(253, 93, 93, 1), size: 16),
            const SizedBox(width: 10,),
            Text(
                emailNotConfirmedString, textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromRGBO(253, 93, 93, 1), fontWeight: FontWeight.w400 , letterSpacing:0
                )),
          ],
        )
      ),
    );
  }

  Widget userMailConfirmed(width, height, context){
    return Container(
      width: width*0.9,
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
          const  FaIcon(FontAwesomeIcons.userCheck, color: Color.fromRGBO(77, 170, 232, 1), size: 16),
          const SizedBox(width: 10,),
          Text(
              emailConfirmedString, textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w400 , letterSpacing:0
              )),
        ],
      )
    );
  }

  Widget editUserWidget(width, height, context){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => EditUserPage(name: widget.name, surname: widget.surname,
              email: widget.email, avatarNetworkPath: widget.avatarNetworkPath,
              phone: widget.phone, isUserActivated: widget.isUserActivated,
              moneyCash: widget.moneyCash , userID: widget.userID, userStatus: widget.userStatus, userStatusEndDate: widget.userStatusEndDate,
            )));
      },
      child: Container(
          width: width*0.9,
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
              const  FaIcon(FontAwesomeIcons.penToSquare, color: Color.fromRGBO(77, 170, 232, 1), size: 16),
              const SizedBox(width: 10,),
              Text(
                  changeUserData, textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w400 , letterSpacing:0
                  )),
            ],
          )
      ),
    );
  }

  Widget noRecords(width , height){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width*0.75, height: height*0.775 - 265,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/noTransactions.png'),
                  fit: BoxFit.contain
              )
          ),
        ),
        const SizedBox(height: 15,),
        SizedBox(
          width: width*0.9,
          height: 40,
          child: Text(
              showMessageTitle, textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 28, color: Colors.black, fontWeight: FontWeight.w600
              )),
        ),
        const SizedBox(height: 3,),
        SizedBox(
          width: width*0.9,
          height: 50,
          child: Text(
              showMessageDescription, textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18, color: Color.fromRGBO(158, 158, 158, 1), fontWeight: FontWeight.w500
              )),
        ),
      ],
    );
  }

  Widget loadingData(){
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 2,),
    );
  }

  Future<void> getUserAdvertiseList() async{
    final dio = Dio();
    var box = await Hive.openBox("logins");
    String refresh = await box.get("refresh");
    String access = await box.get("access");
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    dio.options.headers['Authorization'] = "Bearer $refresh";
    dio.options.headers['Authorization'] = "Bearer $access";

    try{
      final respose = await dio.get(globals.endpointGetUserAdvertiseList);
      if(respose.statusCode == 200){
        String jsonString = respose.toString();
        Map<String, dynamic> jsonDataMap = json.decode(jsonString);
        List<dynamic> postsData = jsonDataMap['result'];
        for (var post in postsData) {
          postIdList.add(post['id'].toString());
          postTitleList.add(post['title']);
          postDescriptionList.add(post['description']);
          postMetroNameList.add(post['metro_name']);
          postIsActiveList.add(post['is_active']);
          postImagePathList.add(post['images']);
          postIsColoredList.add(post['is_colored']);
          postIsVipList.add(post['is_vip']);
        }

        setState(() {
          dataGet = true;
          if(postIdList.isNotEmpty){
            anyRecords = true;
          }
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

  Widget advertiseVip(width,String imagePath, bool isActive, String postTitle , String postDescription , postMetroName , imageHeight, imageCasual){
    return Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (isActive)? imageContainerDataVip(width, imageHeight, imagePath, imageCasual) : postContainerDataNotActiveVip(width , imageHeight, imagePath, imageCasual),
            dataAfterImageVip(width,postTitle, postDescription, postMetroName)
          ],
        ),
    );
  }

  Widget imageContainerDataVip(width , height , imagePath, imageCasual){
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CachedNetworkImage(
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
          imageUrl: '$imagePath',
          imageBuilder: (context, imageProvider){
            return Container(
              width: width*0.95,
              height: height-10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: const Color.fromRGBO(251, 133, 0, 1),
                    width: 2.0, // Set border width
                  ),
                  image: DecorationImage(
                      image: imageProvider,
                      filterQuality: FilterQuality.low,
                      fit: (imageCasual)? BoxFit.contain : BoxFit.cover
                  )
              ),
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundColor: Color.fromRGBO(251, 133, 0, 1),
            radius: 25,
            child: FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 30),
          ),
        )
      ],
    );
  }

  Widget postContainerDataNotActiveVip(width , height, imagePath, imageCasual){
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CachedNetworkImage(
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
          imageUrl: '$imagePath',
          imageBuilder: (context, imageProvider){
            return Container(
              width: width*0.95,
              height: height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: const Color.fromRGBO(251, 133, 0, 1),
                    width: 2.0, // Set border width
                  ),
                  color: const Color.fromRGBO(0, 0, 0, 0.8),
                  image: DecorationImage(
                      image: imageProvider,
                      opacity: 0.25,
                      filterQuality: FilterQuality.low,
                      fit: (imageCasual) ?BoxFit.contain : BoxFit.cover
                  )
              ),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white
                  ),
                  child: Padding(
                    padding:const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        advertiseNotActive, textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, color: Color.fromRGBO(255, 0, 0, 1), fontWeight: FontWeight.w500
                        )),
                  ),
                ),
              ),
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundColor: Color.fromRGBO(251, 133, 0, 1),
            radius: 25,
            child: FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 30),
          ),
        )
      ],
    );
  }


  Widget advertiseCommon(width, String imagePath, bool isActive, bool postIsColored, String postTitle , String postDescription , postMetroName, imageHeight, imageCasual){
    return Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (isActive)? imageContainerData(width, imageHeight, imagePath, postIsColored,imageCasual) : postContainerDataNotActive(width , imageHeight, imagePath, postIsColored,imageCasual),
            dataAfterImageCasual(width,postTitle, postDescription, postMetroName, postIsColored)
          ],
        )
    );
  }

  Widget imageContainerData(width , height , imagePath, bool coloredIsAdvertise,imageCasual){
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CachedNetworkImage(
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
          imageUrl: '$imagePath',
          imageBuilder: (context, imageProvider){
            return Container(
              width: width*0.95,
              height: height-10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: coloredIsAdvertise ? const Color.fromRGBO(33, 158, 188, 1) : const Color.fromRGBO(181, 181, 181, 1),
                    width: 2.0, // Set border width
                  ),
                  image: DecorationImage(
                      image: imageProvider,
                      filterQuality: FilterQuality.low,
                      fit: (imageCasual)? BoxFit.contain : BoxFit.cover
                  )
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundColor: coloredIsAdvertise ? const Color.fromRGBO(33, 158, 188, 1) : const Color.fromRGBO(181, 181, 181, 1),
            radius: 25,
            child: const FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 30),
          ),
        )
      ],
    );
  }

  Widget postContainerDataNotActive(width , height, imagePath , bool coloredIsAdvertise,imageCasual){
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CachedNetworkImage(
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
          imageUrl: '$imagePath',
          imageBuilder: (context, imageProvider){
            return Container(
              width: width*0.95,
              height: height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: (coloredIsAdvertise)? const Color.fromRGBO(33, 158, 188, 1) : const Color.fromRGBO(181, 181, 181, 1),
                    width: 2.0, // Set border width
                  ),
                  color: const Color.fromRGBO(0, 0, 0, 0.8),
                  image: DecorationImage(
                    image: imageProvider,
                    opacity: 0.25,
                    filterQuality: FilterQuality.low,
                    fit: (imageCasual)? BoxFit.contain : BoxFit.cover
                  )
              ),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white
                  ),
                  child: Padding(
                    padding:const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        advertiseNotActive, textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, color: Color.fromRGBO(255, 0, 0, 1), fontWeight: FontWeight.w500
                        )),
                  ),
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundColor: (coloredIsAdvertise)? const Color.fromRGBO(33, 158, 188, 1) : const Color.fromRGBO(181, 181, 181, 1),
            radius: 25,
            child: const FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 30),
          ),
        )
      ],
    );
  }

  Widget dataAfterImageVip(width,postTitleInside, postDescriptionInside , postMetroNameInside){
    return SizedBox(
      width: width*0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width*0.025),
            child: Text(
                postTitleInside, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 18, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                  letterSpacing: 0,
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width*0.025, right: width*0.025 , top: 3),
            child: Text(
                postDescriptionInside, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12, color: Color.fromRGBO(148, 148, 148, 1), fontWeight: FontWeight.w500 ,
                  letterSpacing: 0,
                )
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: width*0.025, right: width*0.025 , top: 5),
              child: Container(
                  width: width*0.95,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(251, 133, 0, 1), // Set container color
                    borderRadius: BorderRadius.circular(5.0), // Set border radius
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          postMetroNameInside, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600 ,
                            letterSpacing: 0,
                          )
                      ),
                      const SizedBox(width: 10,),
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 10,
                        child: FaIcon(FontAwesomeIcons.trainSubway, color: Color.fromRGBO(251, 133, 0, 1) , size: 16,
                      ))
                    ],
                  )
              )
          ),
        ],
      ),
    );
  }

  Widget dataAfterImageCasual(width, postTitleInside, postDescriptionInside , postMetroNameInside, bool coloredIsAdvertise){
    return SizedBox(
      width: width*0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width*0.025),
            child: Text(
                postTitleInside, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 18, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                  letterSpacing: 0,
                )
            ),
          ),
          const SizedBox(height: 3,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width*0.025),
            child: Text(
                postDescriptionInside, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12, color: Color.fromRGBO(148, 148, 148, 1), fontWeight: FontWeight.w500 ,
                  letterSpacing: 0,
                )
            ),
          ),
          const SizedBox(height: 5,),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: width*0.025),
              child: Container(
                  width: width*0.95,
                  height: 45,
                  decoration: BoxDecoration(
                    color: (coloredIsAdvertise) ? const Color.fromRGBO(33, 158, 188, 1) : const Color.fromRGBO(181, 181, 181, 1), // Set container color
                    borderRadius: BorderRadius.circular(5.0), // Set border radius
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          postMetroNameInside, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600 ,
                            letterSpacing: 0,
                          )
                      ),
                      const SizedBox(width: 10,),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 10,
                        child: FaIcon(FontAwesomeIcons.trainSubway, color: (coloredIsAdvertise) ? const Color.fromRGBO(33, 158, 188, 1) : const Color.fromRGBO(181, 181, 181, 1), size: 16),
                      )
                    ],
                  )
              )
          ),
        ],
      ),
    );
  }

  Widget userAdvertiseListChild(width, height, context){
    return SizedBox(
        width: width*0.95,
        child: (anyRecords)? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: postIdList.length,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index){
              String postId = postIdList[index];
              String postTitleInside = postTitleList[index];
              String postDescriptionInside = postDescriptionList[index];
              String postMetroNameInside = postMetroNameList[index];
              bool postIsActiveStringInside = postIsActiveList[index];
              String postImageInside = postImagePathList[index];
              bool imageCasual = (postImageInside=="http://sino0on.ru/media/avatars/df/Zherdesh%20logo-03.png")? true: false;
              bool postIsColoredStringInside = postIsColoredList[index];
              bool postIsVipStringInside = postIsVipList[index];
              double imageHeight = height*0.5;

              if(index==0){
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => AdvertiseUserPageFullView(name: widget.name, surname: widget.surname,
                          email: widget.email, avatarNetworkPath: widget.avatarNetworkPath,
                          phone: widget.phone, isUserActivated: widget.isUserActivated,
                          moneyCash: widget.moneyCash , userID: widget.userID, userStatus: widget.userStatus, userStatusEndDate: widget.userStatusEndDate,
                          postID: postId,
                        )));
                  },
                  child: (postIsVipStringInside)? advertiseVip(width,
                      postImageInside, postIsActiveStringInside, postTitleInside,postDescriptionInside, postMetroNameInside, imageHeight, imageCasual)
                      : advertiseCommon(width, postImageInside,
                      postIsActiveStringInside,postIsColoredStringInside,postTitleInside,postDescriptionInside, postMetroNameInside,imageHeight, imageCasual),
                );
              }
              else{
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => AdvertiseUserPageFullView(name: widget.name, surname: widget.surname,
                          email: widget.email, avatarNetworkPath: widget.avatarNetworkPath,
                          phone: widget.phone, isUserActivated: widget.isUserActivated,
                          moneyCash: widget.moneyCash , userID: widget.userID, userStatus: widget.userStatus, userStatusEndDate: widget.userStatusEndDate,
                          postID: postId,
                        )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: (postIsVipStringInside)? advertiseVip(
                        width, postImageInside, postIsActiveStringInside,
                        postTitleInside,postDescriptionInside, postMetroNameInside, imageHeight, imageCasual)
                      : advertiseCommon(width, postImageInside,
                        postIsActiveStringInside,postIsColoredStringInside,postTitleInside,postDescriptionInside, postMetroNameInside,imageHeight, imageCasual),
                  ),
                );
              }
            }
        ) : noRecords(width,height)
    );
  }




  Widget advertiseVipSquare(width, String imagePath, bool isActive, String postTitle , imageHeight){
    bool imageCasual = (imagePath=="http://sino0on.ru/media/avatars/df/Zherdesh%20logo-03.png")? true: false;
    return Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (isActive)? imageContainerDataVipSquare(width, imageHeight, imagePath, imageCasual) : postContainerDataNotActiveVipSquare(width , imageHeight, imagePath,imageCasual),
            dataAfterImageSquare(width,postTitle)
          ],
        ),
    );
  }

  Widget imageContainerDataVipSquare(width , height , imagePath, imageCasual){
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CachedNetworkImage(
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
          imageUrl: '$imagePath',
          imageBuilder: (context, imageProvider){
            return Container(
              width: width*0.95,
              height: height-10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: const Color.fromRGBO(251, 133, 0, 1),
                    width: 2.0, // Set border width
                  ),
                  image: DecorationImage(
                      image: imageProvider,
                      filterQuality: FilterQuality.low,
                      fit: (imageCasual)?BoxFit.contain : BoxFit.cover
                  )
              ),
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundColor: Color.fromRGBO(251, 133, 0, 1),
            radius: 15,
            child: FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 18),
          ),
        )
      ],
    );
  }

  Widget postContainerDataNotActiveVipSquare(width , height, imagePath, imageCasual){
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CachedNetworkImage(
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
          imageUrl: '$imagePath',
          imageBuilder: (context, imageProvider){
            return Container(
              width: width*0.95,
              height: height-10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: const Color.fromRGBO(251, 133, 0, 1),
                    width: 2.0,
                  ),
                  color: const Color.fromRGBO(0, 0, 0, 0.8),
                  image: DecorationImage(
                      image: imageProvider,
                      opacity: 0.25,
                      filterQuality: FilterQuality.low,
                      fit: (imageCasual)? BoxFit.contain : BoxFit.cover
                  )
              ),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white
                  ),
                  child: Padding(
                    padding:const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        advertiseNotActive, textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14, color: Color.fromRGBO(255, 0, 0, 1), fontWeight: FontWeight.w500
                        )),
                  ),
                ),
              ),
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundColor: Color.fromRGBO(251, 133, 0, 1),
            radius: 15,
            child: FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 18),
          ),
        )
      ],
    );
  }



  Widget advertiseCommonSquare(width, String imagePath, bool isActive, bool postIsColored, String postTitle , imageHeight){
    bool imageCasual = (imagePath=="http://sino0on.ru/media/avatars/df/Zherdesh%20logo-03.png")? true: false;
    return Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (isActive)? imageContainerDataSquare(width, imageHeight, imagePath, postIsColored,imageCasual) : postContainerDataNotActiveSquare(width , imageHeight, imagePath, postIsColored,imageCasual),
            dataAfterImageSquare(width,postTitle)
          ],
        )
    );
  }

  Widget imageContainerDataSquare(width , height , imagePath, bool coloredIsAdvertise,imageCasual){
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CachedNetworkImage(
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
          imageUrl: '$imagePath',
          imageBuilder: (context, imageProvider){
            return Container(
              width: width*0.95,
              height: height-10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: coloredIsAdvertise ? const Color.fromRGBO(33, 158, 188, 1) : const Color.fromRGBO(181, 181, 181, 1),
                    width: 2.0, // Set border width
                  ),
                  color: const Color.fromRGBO(154, 154, 154, 0.15),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: (imageCasual)?BoxFit.contain : BoxFit.cover,
                  )
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundColor: coloredIsAdvertise ? const Color.fromRGBO(33, 158, 188, 1) : const Color.fromRGBO(181, 181, 181, 1),
            radius: 15,
            child: const FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 18),
          ),
        )
      ],
    );
  }

  Widget postContainerDataNotActiveSquare(width , height, imagePath, bool coloredIsAdvertise, imageCasual){
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CachedNetworkImage(
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
          imageUrl: '$imagePath',
          imageBuilder: (context, imageProvider){
            return Container(
              width: width*0.95,
              height: height-10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color.fromRGBO(0, 0, 0, 0.8),
                  border: Border.all(
                    color: (coloredIsAdvertise)? const Color.fromRGBO(33, 158, 188, 1) : const Color.fromRGBO(181, 181, 181, 1),
                    width: 2.0, // Set border width
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    opacity: 0.25,
                    fit: (imageCasual)?BoxFit.contain : BoxFit.cover,
                  )
              ),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white
                  ),
                  child: Padding(
                    padding:const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        advertiseNotActive, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, color: Color.fromRGBO(255, 0, 0, 1), fontWeight: FontWeight.w500
                        )),
                  ),
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundColor: (coloredIsAdvertise)? const Color.fromRGBO(33, 158, 188, 1) : const Color.fromRGBO(181, 181, 181, 1),
            radius: 15,
            child: const FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 18),
          ),
        )
      ],
    );
  }

  Widget dataAfterImageSquare(width, postTitleInside){
    return SizedBox(
      width: width*0.95,
      height: 45,
      child: Padding(
        padding: EdgeInsets.only(left: width*0.025, top: 5,right: width*0.025),
        child: Align(
          alignment: Alignment.center,
          child: Text(
              postTitleInside, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 14, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                letterSpacing: 0,
              )
          ),
        ),
      ),
    );
  }

  Widget userSquareAdvertiseListChild(width , height , context){
    //here we create two list for each section

    //Id:
    List<String> postColumnId1 = [];
    List<String> postColumnId2 = [];
    //title
    List<String> postColumnTitle1 = [];
    List<String> postColumnTitle2 = [];
    //active
    List<bool> postColumnActive1 = [];
    List<bool> postColumnActive2 = [];
    //images
    List<String> postColumnImages1 = [];
    List<String> postColumnImages2 = [];
    //colored
    List<bool> postColumnColored1 = [];
    List<bool> postColumnColored2 = [];
    //vip
    List<bool> postColumnVip1 = [];
    List<bool> postColumnVip2 = [];

    //now we should properly set data =>
    for(int i=0 ; i<postIdList.length; i++){
      String postId = postIdList[i];
      String postTitleInside = postTitleList[i];
      bool postIsActiveStringInside = postIsActiveList[i];
      String postImageInside = postImagePathList[i];
      bool postIsColoredStringInside = postIsColoredList[i];
      bool postIsVipStringInside = postIsVipList[i];
      if(i%2==0){
        postColumnId1.add(postId);
        postColumnTitle1.add(postTitleInside);
        postColumnActive1.add(postIsActiveStringInside);
        postColumnImages1.add(postImageInside);
        postColumnColored1.add(postIsColoredStringInside);
        postColumnVip1.add(postIsVipStringInside);
      }
      else{
        postColumnId2.add(postId);
        postColumnTitle2.add(postTitleInside);
        postColumnActive2.add(postIsActiveStringInside);
        postColumnImages2.add(postImageInside);
        postColumnColored2.add(postIsColoredStringInside);
        postColumnVip2.add(postIsVipStringInside);
      }
    }

    return SizedBox(
        width: width,
        child: (anyRecords)? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: postColumnId1.length,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index){
              double imageHeight = height*0.2;

              if(index==0){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => AdvertiseUserPageFullView(name: widget.name, surname: widget.surname,
                              email: widget.email, avatarNetworkPath: widget.avatarNetworkPath,
                              phone: widget.phone, isUserActivated: widget.isUserActivated,
                              moneyCash: widget.moneyCash , userID: widget.userID, userStatus: widget.userStatus, userStatusEndDate: widget.userStatusEndDate,
                              postID: postColumnId1[index],
                            )));
                      },
                      child: (postColumnVip1[index])? advertiseVipSquare(width*0.45,
                          postColumnImages1[index], postColumnActive1[index], postColumnTitle1[index], imageHeight)
                          : advertiseCommonSquare(width*0.45, postColumnImages1[index],
                          postColumnActive1[index],postColumnColored1[index],postColumnTitle1[index],imageHeight),
                    ),
                    index<postColumnId2.length ?
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => AdvertiseUserPageFullView(name: widget.name, surname: widget.surname,
                              email: widget.email, avatarNetworkPath: widget.avatarNetworkPath,
                              phone: widget.phone, isUserActivated: widget.isUserActivated,
                              moneyCash: widget.moneyCash , userID: widget.userID, userStatus: widget.userStatus, userStatusEndDate: widget.userStatusEndDate,
                              postID: postColumnId2[index],
                            )));
                      },
                      child: (postColumnVip2[index])? advertiseVipSquare(width*0.45,
                          postColumnImages2[index], postColumnActive2[index], postColumnTitle2[index], imageHeight)
                          : advertiseCommonSquare(width*0.45, postColumnImages2[index],
                          postColumnActive2[index],postColumnColored2[index],postColumnTitle2[index],imageHeight),
                    ) :
                    Container()
                  ],
                );
              }
              else{
                return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => AdvertiseUserPageFullView(name: widget.name, surname: widget.surname,
                                email: widget.email, avatarNetworkPath: widget.avatarNetworkPath,
                                phone: widget.phone, isUserActivated: widget.isUserActivated,
                                moneyCash: widget.moneyCash , userID: widget.userID, userStatus: widget.userStatus,
                                postID: postColumnId1[index], userStatusEndDate: widget.userStatusEndDate,
                              )));
                        },
                        child: (postColumnVip1[index])? advertiseVipSquare(width*0.45,
                            postColumnImages1[index], postColumnActive1[index], postColumnTitle1[index], imageHeight )
                            : advertiseCommonSquare(width*0.45, postColumnImages1[index],
                            postColumnActive1[index],postColumnColored1[index],postColumnTitle1[index],imageHeight),
                      ),
                      index<postColumnId2.length ?
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => AdvertiseUserPageFullView(name: widget.name, surname: widget.surname,
                                email: widget.email, avatarNetworkPath: widget.avatarNetworkPath,
                                phone: widget.phone, isUserActivated: widget.isUserActivated,
                                moneyCash: widget.moneyCash , userID: widget.userID, userStatus: widget.userStatus,
                                postID: postColumnId2[index], userStatusEndDate: widget.userStatusEndDate,
                              )));
                        },
                        child: (postColumnVip2[index])? advertiseVipSquare(width*0.45,
                            postColumnImages2[index], postColumnActive2[index], postColumnTitle2[index], imageHeight)
                            : advertiseCommonSquare(width*0.45, postColumnImages2[index],
                            postColumnActive2[index],postColumnColored2[index],postColumnTitle2[index],imageHeight),
                      ) :
                      Container()
                    ],
                  ),
                );
              }
            }
        ) : noRecords(width,height)
    );
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if(globals.userLanguage!="ru"){
      if(widget.userStatus=="basic"){
        rightDataUserStatus = "Жөнөкөй";
      }
      else{
        rightDataUserStatus = widget.userStatus;
        userGetStatus = true;
      }
      setDataKyrgyz();
    }

    if(globals.userLanguage=="ru"){
      if(widget.userStatus=="basic"){
        rightDataUserStatus = "Базовый";
      }
      else{
        rightDataUserStatus = widget.userStatus;
        userGetStatus = true;
      }
      setDataRussian();
    }

    getUserAdvertiseList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double mainSizedBoxHeightUserNotLogged = height - statusBarHeight;


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
                child: SizedBox(
                  width: width*0.95,
                  height: mainSizedBoxHeightUserNotLogged,
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
                                      builder: (BuildContext context) => HomeScreen(positionBottomNavigationBar: 2)));
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
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          width: width*0.95,
                          height: mainSizedBoxHeightUserNotLogged-60,
                          child: userProfilePage(width, mainSizedBoxHeightUserNotLogged, context),
                        ),
                      )
                    ],
                  ),
                )
            )
          )
      ),
    );
  }
}

