import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;

import '../UserDatas/userdata_page.dart';
import 'edit_user_advertise_page.dart';

class AdvertiseUserPageFullView extends StatefulWidget{
  final String name;
  final String surname;
  final String email;
  final String avatarNetworkPath;
  final String phone;
  final bool isUserActivated;
  final int moneyCash;
  final int userID;
  final String userStatus;
  final String postID;
  final String userStatusEndDate;
  const AdvertiseUserPageFullView(
      {super.key,
        required this.name , required this.surname , required this.email,
        required this.avatarNetworkPath , required this.phone,
        required this.isUserActivated , required this.moneyCash, required this.userID,
        required this.userStatus, required this.postID, required this.userStatusEndDate
      }
      );


  @override
  AdvertiseHUserPageFullViewState createState ()=> AdvertiseHUserPageFullViewState();
}
class AdvertiseHUserPageFullViewState extends State<AdvertiseUserPageFullView>{


  //todo => methods to setProper data =>
  String titlePost = "";
  String stationPost = "";
  String descriptionPost = "";
  String addressPost = "";
  String subcategoryPost = "";
  String phonePost = "";
  String createdAt = "";
  List<String> imagePathPost = [];
  String viewCount = "";

  String costVip = "";
  String costTop = "";
  String costColored = "";
  bool vipAdvert = false;
  bool coloredAdvert = false;
  bool activeAdvert = false;

  bool dataGet = false;
  String showDataDescr = "";
  String dateOfPublication="";
  String viewCountString = "";
  String makeVip = "";
  String makeTop = "";
  String makeColored = "";
  String edit = "";
  String delete = "";
  String advertiseVip = "";
  String advertiseColored = "";
  String advertiseActive = "";

  String dataPay1 = "";
  String dataPay2 = "";
  String dataPay3 = "";
  String dataPay4 = "";
  String buySuccess = "";
  String deleteTitile = "";
  String deleteConfirm = "";
  String metroDataShow = "";
  String addressDataShow = "";
  String phoneDataShow = "";

  String notDefined = "";
  void setDataKyrgyz(){
    showDataDescr = "Маалымат";
    dateOfPublication = "Жарыяланган күнү:";
    viewCountString = "Көрүүлөрдүн саны:";
    makeVip = "Жарыялоо ВИП";
    makeTop = "Жарнаманы чокуга көтөрүңүз";
    makeColored = "Жарнаманы түстүү кылыңыз";
    edit = "Жарнаманы түзөтүңүз";
    delete = "Жарнаманы жок кылуу";
    advertiseVip = "ВИП Жарыялоо:";
    advertiseColored = "Жарыя түстүү:";
    advertiseActive = "Активдүү кулактандыруу:";
    dataPay1 = "Сатып алуу";
    dataPay2 = "Сиз сатып жатасыз";
    dataPay3 = "Ырастоо";
    dataPay4 = "Четке кагуу";
    buySuccess = "Ийгиликтүү!";
    deleteTitile = "Жарнаманы жок кылуу";
    deleteConfirm = "Чын элеби? Жок кылынган жарнама кайтарылбайт.";
    metroDataShow = "Метро";
    addressDataShow = "Дареги";
    phoneDataShow = "Байланыш";
    notDefined = "Көрсөтүлгөн эмес";
  }
  void setDataRussian(){
      showDataDescr = "Описание";
      dateOfPublication = "Дата публикации ";
      viewCountString = "Число просмотров ";
      makeVip = "Сделать объявление ВИП";
      makeTop = "Поднять объявление в ТОП";
      makeColored = "Сделать объявление цветным";
      edit = "Редактировать объявление";
      delete = "Удалить объявление";
      advertiseVip = "Объявление ВИП ";
      advertiseColored = "Объявление цветное ";
      advertiseActive = "Объявление активно ";
      dataPay1 = "Покупка";
      dataPay2 = "Вы покупаете";
      dataPay3 = "Подтвердить";
      dataPay4 = "Отклонить";
      buySuccess = "Успешно!";
      deleteTitile = "Удалить объявление";
      deleteConfirm = "Вы уверены? Удаленное объявление нельзя будет вернуть.";
      metroDataShow = "Метро";
      addressDataShow = "Адрес";
      phoneDataShow = "Телефон";
      notDefined = "Не указано";
  }

  void _showCupertinoDialogBuyVipAdvertise(BuildContext context , String idPost , String cost) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
              dataPay1 ,textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400 , letterSpacing: -0.4
              )
          ),
          content: Text(
              "$dataPay2 \n$makeVip - $cost Рублей", textAlign: TextAlign.center,
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
                    final dio = Dio();
                    //set Dio response =>
                    var box = await Hive.openBox("logins");
                    String refresh = await box.get("refresh");
                    String access = await box.get("access");
                    dio.options.headers['Accept-Language'] = globals.userLanguage;
                    dio.options.headers['Authorization'] = "Bearer $refresh";
                    dio.options.headers['Authorization'] = "Bearer $access";
                    try{
                      //todo => send data to server : =>
                      final respose = await dio.get("${globals.endpointBuyVipToAdvertise}$idPost");
                      if(respose.statusCode == 200){
                        //work with data =>
                        String dataToParse = respose.toString();
                        Fluttertoast.showToast(
                          msg: buySuccess,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                          backgroundColor: Colors.white, // Background color of the toast
                          textColor: Colors.black,
                        );
                        Navigator.pop(context);
                        setState(() {
                          dataGet= false;
                          getPostInfo();
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
                  },
                  child: Text(
                      dataPay3,
                      style: const TextStyle(
                          fontSize: 14, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w400 , letterSpacing: -0.4
                      )
                  ),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                      dataPay4,
                      style: const TextStyle(
                          fontSize: 14, color: Color.fromRGBO(239, 29, 52, 1), fontWeight: FontWeight.w400 , letterSpacing: -0.4
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

  void _showCupertinoDialogBuyTopAdvertise(BuildContext context , String idPost, String cost){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
              dataPay1 , textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400 , letterSpacing: -0.4
              )
          ),
          content: Text(
              "$dataPay2 \n$makeTop - $cost Рублей", textAlign: TextAlign.center,
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
                    final dio = Dio();
                    //set Dio response =>
                    var box = await Hive.openBox("logins");
                    String refresh = await box.get("refresh");
                    String access = await box.get("access");
                    dio.options.headers['Accept-Language'] = globals.userLanguage;
                    dio.options.headers['Authorization'] = "Bearer $refresh";
                    dio.options.headers['Authorization'] = "Bearer $access";
                    try{
                      //todo => send data to server : =>
                      final respose = await dio.get("${globals.endpointBuyTopToAdvertise}$idPost");
                      if(respose.statusCode == 200){
                        //work with data =>
                        String dataToParse = respose.toString();
                        Fluttertoast.showToast(
                          msg: buySuccess,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                          backgroundColor: Colors.white, // Background color of the toast
                          textColor: Colors.black,
                        );
                        Navigator.pop(context);
                        setState(() {
                          dataGet= false;
                          getPostInfo();
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
                  },
                  child: Text(
                      dataPay3,
                      style: const TextStyle(
                          fontSize: 14, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w400 , letterSpacing: -0.4
                      )
                  ),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                      dataPay4,
                      style: const TextStyle(
                          fontSize: 14, color: Color.fromRGBO(239, 29, 52, 1), fontWeight: FontWeight.w400 , letterSpacing: -0.4
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

  void _showCupertinoDialogBuyColoredAdvertise(BuildContext context , String idPost, String cost) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
              dataPay1 ,textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400 , letterSpacing: -0.4
              )
          ),
          content: Text(
              "$dataPay2 \n$makeColored - $cost Рублей", textAlign: TextAlign.center,
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
                    final dio = Dio();
                    //set Dio response =>
                    var box = await Hive.openBox("logins");
                    String refresh = await box.get("refresh");
                    String access = await box.get("access");
                    dio.options.headers['Accept-Language'] = globals.userLanguage;
                    dio.options.headers['Authorization'] = "Bearer $refresh";
                    dio.options.headers['Authorization'] = "Bearer $access";
                    try{
                      //todo => send data to server : =>
                      final respose = await dio.get("${globals.endpointBuyColoredToAdvertise}$idPost");
                      if(respose.statusCode == 200){
                        //work with data =>
                        String dataToParse = respose.toString();
                        Fluttertoast.showToast(
                          msg: buySuccess,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                          backgroundColor: Colors.white, // Background color of the toast
                          textColor: Colors.black,
                        );
                        Navigator.pop(context);
                        setState(() {
                          dataGet= false;
                          getPostInfo();
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
                  },
                  child: Text(
                      dataPay3,
                      style: const TextStyle(
                          fontSize: 14, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w400 , letterSpacing: -0.4
                      )
                  ),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                      dataPay4,
                      style: const TextStyle(
                          fontSize: 14, color: Color.fromRGBO(239, 29, 52, 1), fontWeight: FontWeight.w400 , letterSpacing: -0.4
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

  void _showCupertinoDialogDeleteAdvertise(BuildContext context , String idPost) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
               deleteTitile, textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400 , letterSpacing: -0.4
              )
          ),
          content: Text(
              deleteConfirm, textAlign: TextAlign.center,
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
                    final dio = Dio();
                    //set Dio response =>
                    var box = await Hive.openBox("logins");
                    String refresh = await box.get("refresh");
                    String access = await box.get("access");
                    dio.options.headers['Accept-Language'] = globals.userLanguage;
                    dio.options.headers['Authorization'] = "Bearer $refresh";
                    dio.options.headers['Authorization'] = "Bearer $access";
                    try{
                      //todo => send data to server : =>
                      final respose = await dio.delete("${globals.endpointDeleteAdvertise}$idPost");
                      if(respose.statusCode == 204){
                        //work with data =>
                        Fluttertoast.showToast(
                          msg: buySuccess,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                          backgroundColor: Colors.white, // Background color of the toast
                          textColor: Colors.black,
                        );
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
                  },
                  child: Text(
                      dataPay3,
                      style: const TextStyle(
                          fontSize: 14, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w400 , letterSpacing: -0.4
                      )
                  ),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                      dataPay4,
                      style: const TextStyle(
                          fontSize: 14, color: Color.fromRGBO(239, 29, 52, 1), fontWeight: FontWeight.w400 , letterSpacing: -0.4
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


  Future<void> getPostInfo() async{
    final dio = Dio();

    //set Dio response =>
    var box = await Hive.openBox("logins");
    String refresh = await box.get("refresh");
    String access = await box.get("access");
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    dio.options.headers['Authorization'] = "Bearer $refresh";
    dio.options.headers['Authorization'] = "Bearer $access";
    try{
      //todo => send data to server : =>
      final respose = await dio.get("${globals.endpointGetInformationAdvertiseUser}${widget.postID}");
      print(respose);
      if(respose.statusCode == 200){
        //work with data =>
        String dataToParse = respose.toString();
        Map<String, dynamic> data = await json.decode(dataToParse);
        titlePost = data['title'];
        descriptionPost = data['description'];
        stationPost = data['metro_name'];
        if(data['address']!=null && data['address']!="default"){
          addressPost = data['address'];
        }
        else{
          addressPost = notDefined;
        }
        if(data['phone']!="0"){
          phonePost = data['phone'];
        }
        else{
          phonePost = notDefined;
        }
        subcategoryPost = data['subcategory']['title'];
        createdAt = data['created_at'].toString();
        viewCount = data['view_count'].toString();
        List<dynamic> imageMassive = data['images'];
        imageMassive.forEach((element) {
          imagePathPost.add(element['image']);
        });
        costVip = data['subcategory']['for_vip'].toString();
        costTop = data['subcategory']['for_top'].toString();
        costColored = data['subcategory']['for_color'].toString();
        vipAdvert = data['is_vip'];
        coloredAdvert = data['is_colored'];
        activeAdvert = data['is_active'];

        setState(() {
            dataGet= true;
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

  Widget loadingData(width , height){
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(left: width*0.3), child :
              Container(
                width: width*0.4,
                height: height*0.4,
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/logo.png"),fit: BoxFit.contain)),
              )),
              const SizedBox(height: 20,),
              Padding(padding: EdgeInsets.only(left: width*0.3) ,
                child: const CircularProgressIndicator(strokeWidth: 2,),
              )
            ],
          )
      ) ,
    );
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

  String showDateCreation(String date){
    String createData = date;
    String dayMonthYear = createData.substring(0,10);
    DateTime dateTime = DateTime.parse(dayMonthYear);

    String dateTimeString = "${dateTime.day} ${dateTime.month} ${dateTime.year}";
    String formattedDateString = formatDateString(dateTimeString);

    String time = createData.substring(11,19);
    String overallTime = "$formattedDateString , $time";

    return overallTime;
  }

  String showRuBoolValue(bool dataBoolean, String userLang){
    if(userLang=="ru"){
      if(dataBoolean){
        return "Да";
      }
      else{
        return "Нет";
      }
    }
    else{
      if(dataBoolean){
        return "Ооба";
      }
      else{
        return "Жок";
      }
    }


  }

  Widget showChoseImages(width , height){
    List<Widget> imageWidgets = List.generate(imagePathPost.length, (index) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
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
          imageUrl: imagePathPost[index],
          imageBuilder: (context, imageProvider){
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: InstaImageViewer(child: Image(
                image: imageProvider,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),),
            );
          },
        ),
      );
    });
    return Container(
        width: width*0.95,
        height: height*0.45,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(245, 245, 245, 1), // Set container color
          borderRadius: BorderRadius.circular(8.0), // Set border radius
        ),
        child: ImageSlideshow(
          initialPage: 0,
          indicatorColor: const Color.fromRGBO(77, 170, 232, 1),
          isLoop: false,
          children: imageWidgets,
        )
    );
  }

  Widget makeAdvertisePremium(width, height, context){
    return GestureDetector(
      onTap: (){
        _showCupertinoDialogBuyVipAdvertise(context, widget.postID, costVip);
      },
      child: Container(
          width: width*0.9,
          height: height* 0.06,
          decoration: BoxDecoration(
            color: Colors.white, // Set container color
            borderRadius: BorderRadius.circular(10.0), // Set border radius
            border: Border.all(
              color: const Color.fromRGBO(255, 183, 13, 1), // Set border color
              width: 2.0, // Set border width
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const  FaIcon(FontAwesomeIcons.crown, color: Color.fromRGBO(255, 183, 3,  1), size: 16),
              const SizedBox(width: 10,),
              Text(
                  makeVip, textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromRGBO(255, 183, 3,  1), fontWeight: FontWeight.w400 , letterSpacing:0
                  )),
            ],
          )
      ),
    );
  }

  Widget makeAdvertiseTop(width, height, context){
    return GestureDetector(
      onTap: (){
        _showCupertinoDialogBuyTopAdvertise(context, widget.postID, costTop);
      },
      child: Container(
          width: width*0.9,
          height: height* 0.06,
          decoration: BoxDecoration(
            color: Colors.white, // Set container color
            borderRadius: BorderRadius.circular(10.0), // Set border radius
            border: Border.all(
              color: const Color.fromRGBO(251, 133, 83, 1), // Set border color
              width: 2.0, // Set border width
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const  FaIcon(FontAwesomeIcons.arrowTrendUp, color: Color.fromRGBO(251, 133, 83, 1), size: 16),
              const SizedBox(width: 10,),
              Text(
                  makeTop, textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromRGBO(251, 133, 83, 1), fontWeight: FontWeight.w400 , letterSpacing:0
                  )),
            ],
          )
      ),
    );
  }

  Widget makeAdvertiseColored(width, height, context){
    return GestureDetector(
      onTap: (){
        _showCupertinoDialogBuyColoredAdvertise(context, widget.postID, costColored);
      },
      child: Container(
          width: width*0.9,
          height: height* 0.06,
          decoration: BoxDecoration(
            color: Colors.white, // Set container color
            borderRadius: BorderRadius.circular(10.0), // Set border radius
            border: Border.all(
              color: const Color.fromRGBO(121, 83, 227, 1), // Set border color
              width: 2.0, // Set border width
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const  FaIcon(FontAwesomeIcons.palette, color: Color.fromRGBO(121, 83, 227, 1), size: 16),
              const SizedBox(width: 10,),
              Text(
                  makeColored, textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromRGBO(121, 83, 227, 1), fontWeight: FontWeight.w400 , letterSpacing:0
                  )),
            ],
          )
      ),
    );
  }

  Widget editAdvertise(width, height, context){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => EditUserAdvertisePage(
              name: widget.name,
              surname: widget.surname,
              email: widget.email,
              avatarNetworkPath: widget.avatarNetworkPath,
              phone: widget.phone,
              isUserActivated: widget.isUserActivated,
              moneyCash: widget.moneyCash,
              userID: widget.userID,
              userStatus: widget.userStatus,
              postID: widget.postID,
              titlePost: titlePost,
              descriptionPost: descriptionPost,
              metroStationPost: stationPost,
              streetPost: addressPost,
              phonePost: phonePost,
              subcategoryPost: subcategoryPost,
              imageListPost: imagePathPost,
              userStatusEndDate: widget.userStatusEndDate,
            )
        )
        );
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
                  edit, textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w400 , letterSpacing:0
                  )),
            ],
          )
      ),
    );
  }

  Widget deleteAdvertise(width, height, context){
    return GestureDetector(
      onTap: () async {
       _showCupertinoDialogDeleteAdvertise(context, widget.postID);
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
              const FaIcon(FontAwesomeIcons.fire, color: Color.fromRGBO(253, 93, 93, 1), size: 16),
              const SizedBox(width: 10,),
              Text(
                  delete, textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromRGBO(253, 93, 93, 1), fontWeight: FontWeight.w400 , letterSpacing:0
                  )),
            ],
          )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //todo => localize data =>
    if(globals.userLanguage!="ru"){
      setDataKyrgyz();
    }
    if(globals.userLanguage=="ru"){
      setDataRussian();
    }
    getPostInfo();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double mainSizedBoxHeightUserNotLogged = height - statusBarHeight;

    return (dataGet)? WillPopScope(
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
          resizeToAvoidBottomInset: true,
          body: Padding(
            padding: EdgeInsets.only(top: statusBarHeight),
            child: Container(
              width: width,
              height: mainSizedBoxHeightUserNotLogged,
              color: const Color.fromRGBO(250, 250, 250, 1),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width*0.95,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
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
                        ],
                      ),
                    ),
                    showChoseImages(width, height),
                    SizedBox(
                      width: width*0.95,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                            titlePost, textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 28, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                              letterSpacing: 0,
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: width*0.5,
                          decoration: BoxDecoration(
                            color:  Colors.white, // Set container color
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: const  Color.fromRGBO(77, 170, 232, 1),
                              width: 2, // Set the border width as needed
                            ),
                          ),
                          child: Text(
                              subcategoryPost, textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w500 , letterSpacing:0
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: width*0.95,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                            showDataDescr, textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 26, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                              letterSpacing: 0,
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    SizedBox(
                      width: width*0.95,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                            descriptionPost, textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 18, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w400 ,
                              letterSpacing: 0,
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    SizedBox(
                      width: width*0.95,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                metroDataShow, textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(2, 48, 71, 0.55), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            ),
                            const SizedBox(width: 10,),
                            Text(
                                stationPost, textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: width*0.95,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                addressDataShow, textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(2, 48, 71, 0.55), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            ),
                            const SizedBox(width: 10,),
                            Text(
                                addressPost, textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: width*0.95,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                phoneDataShow, textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(2, 48, 71, 0.55), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            ),
                            const SizedBox(width: 10,),
                            Text(
                                phonePost, textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: width*0.95,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: dateOfPublication ,
                                    style: const TextStyle(
                                      fontSize: 16, color: Color.fromRGBO(2, 48, 71, 0.55), fontWeight: FontWeight.w500 ,
                                      letterSpacing: 0,
                                    )
                                ),
                                TextSpan(
                                  text: showDateCreation(createdAt),
                                    style: const TextStyle(
                                      fontSize: 16, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                                      letterSpacing: 0,
                                    )
                                )
                              ]
                            )
                        )
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: width*0.95,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                advertiseVip, textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(2, 48, 71, 0.55), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            ),
                            const SizedBox(width: 5,),
                            Text(
                                showRuBoolValue(vipAdvert, globals.userLanguage), textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            )

                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: width*0.95,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                advertiseColored, textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(2, 48, 71, 0.55), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            ),
                            const SizedBox(width: 5,),
                            Text(
                                showRuBoolValue(coloredAdvert, globals.userLanguage), textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            )

                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: width*0.95,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                advertiseActive, textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(2, 48, 71, 0.55), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            ),
                            const SizedBox(width: 5,),
                            Text(
                                showRuBoolValue(activeAdvert, globals.userLanguage), textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: width*0.95,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                viewCountString, textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(2, 48, 71, 0.55), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            ),
                            const SizedBox(width: 5,),
                            Text(
                                viewCount, textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    makeAdvertisePremium(width, height, context),
                    const SizedBox(height: 10,),
                    makeAdvertiseTop(width, height, context),
                    const SizedBox(height: 10,),
                    makeAdvertiseColored(width, height, context),
                    const SizedBox(height: 10,),
                    editAdvertise(width, height, context),
                    const SizedBox(height: 10,),
                    deleteAdvertise(width, height, context),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          )
      ) ,
    ): loadingData(width, height);
  }
}