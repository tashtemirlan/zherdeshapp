import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;

import '../HomeFiles/home_screen.dart';


class BuyVipPage extends StatefulWidget {
  const BuyVipPage({super.key});

  @override
  State<BuyVipPage> createState() => BuyVipPageState();

}

class BuyVipPageState extends State<BuyVipPage> {

  bool dataGet = false;
  String dataShowMain = "";
  String skidka = "";
  String obiavlenie = "";
  String duration = "";
  String moneyName = "";

  String dataPay1 = "";
  String dataPay2 = "";
  String dataPay3 = "";
  String dataPay4 = "";

  String dataHelp1 ="";
  String dataHelp2 ="";

  String buySuccessful = "";
  List<String> vipList = [];
  List<String> megaVipList = [];
  List<String> superVipList = [];
  void setDataKyrgyz(){

  }
  void setDataRussian(){
      dataShowMain = "Обновите свой план что б получить много привелегий!";
      skidka = "Скидка";
      obiavlenie = "Объявлений максимум";
      duration = "Дней";
      moneyName = "Рублей";

      dataPay1 = "Покупка";
      dataPay2 = "Вы покупаете";
      dataPay3 = "Подтвердить";
      dataPay4 = "Отклонить";

      dataHelp1 = "за";
      dataHelp2 = "на";

      buySuccessful = "Вы успешно купили\nновый план!";
  }

  void _showCupertinoDialog(BuildContext context , String idBuy, String status , String cost , String durationBuy) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              dataPay1 , textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400 , letterSpacing: -0.4
              )
          ),
          content: Text(
              "$dataPay2 $status $dataHelp1 \n$cost $moneyName $dataHelp2 $durationBuy $duration", textAlign: TextAlign.center,
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
                      final respose = await dio.get("${globals.endpointBuyVipStatus}$idBuy");
                      if(respose.statusCode == 200){
                        //work with data =>
                        String dataToParse = respose.toString();
                        Fluttertoast.showToast(
                          msg: buySuccessful,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                          backgroundColor: Colors.white, // Background color of the toast
                          textColor: Colors.black,
                        );
                        Navigator.pop(context);
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

  Widget buyStatus(width, height, context, String data1 , String data2){
    return Padding(
      padding: EdgeInsets.only(left: width*0.05 , right: width*0.05),
      child: Container(
        width: width*0.9,
        height: height* 0.1,
        decoration: BoxDecoration(
          color: Colors.white, // Set container color
          borderRadius: BorderRadius.circular(10.0), // Set border radius
          border: Border.all(
            color: const Color.fromRGBO(77, 170, 232, 1), // Set border color
            width: 2.0, // Set border width
          ),
        ),
        child:SizedBox(
          height: 27,
          child: Padding(padding: const EdgeInsets.only(left: 10) ,
            child: Text(
                "$data1 $duration / $data2 $moneyName", textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 , letterSpacing:0
                )),),
        )
    ),
    );
  }

  Widget statusStars(int starCount){
    if(starCount==3){
      return const SizedBox(
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.solidStar, color: Color.fromRGBO(255, 183, 3, 1), size: 24),
              FaIcon(FontAwesomeIcons.solidStar, color: Color.fromRGBO(255, 183, 3, 1), size: 24),
              FaIcon(FontAwesomeIcons.solidStar, color: Color.fromRGBO(255, 183, 3, 1), size: 24),
            ],
          )
      );
    }
    if(starCount==2){
      return const SizedBox(
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.solidStar, color: Color.fromRGBO(255, 183, 3, 1), size: 24),
              FaIcon(FontAwesomeIcons.solidStar, color: Color.fromRGBO(255, 183, 3, 1), size: 24),
            ],
          )
      );
    }
    if(starCount==1){
      return const SizedBox(
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.solidStar, color: Color.fromRGBO(255, 183, 3, 1), size: 24),
            ],
          )
      );
    }
    return Container();
  }

  Widget userStatusContainer(width , height , String vipStatus , String announceCount , String discount ,
      String id1 , String cost1 , String len1,
      String id2 , String cost2 , String len2 ,
      String id3 , String cost3 , String len3,
      int starNumber
      ){
    return Container(
      width: width*0.9,
      height: height*0.24+160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(251, 133, 0, 1),
            Color.fromRGBO(255, 183, 3, 1),
            Color.fromRGBO(142, 202, 230, 1),
            Color.fromRGBO(3, 158, 188, 1)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.33, 0.66, 1.0], // Adjust stops for each color
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          width: width*0.9 - 10,
          height: height*0.24+150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              SizedBox(
                height: 24,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20 , right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          vipStatus, textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 22, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.bold , letterSpacing:0
                          )
                      ),
                      statusStars(starNumber)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 27,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                      "$discount% $skidka", textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 18, color: Color.fromRGBO(33, 158, 188, 1), fontWeight: FontWeight.bold , letterSpacing:0
                      )
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 27,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                      "$announceCount $obiavlenie", textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 18, color: Color.fromRGBO(33, 158, 188, 1), fontWeight: FontWeight.bold , letterSpacing:0
                      )
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  _showCupertinoDialog(context, id1 , vipStatus , cost1, len1);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: width*0.05 , right: width*0.05),
                  child: Container(
                      width: width*0.8,
                      height: height* 0.08,
                      decoration: BoxDecoration(
                        color: Colors.white, // Set container color
                        borderRadius: BorderRadius.circular(10.0), // Set border radius
                        border: Border.all(
                          color: const Color.fromRGBO(77, 170, 232, 1), // Set border color
                          width: 2.0, // Set border width
                        ),
                      ),
                      child:SizedBox(
                        height: 27,
                        child: Padding(padding: const EdgeInsets.only(left: 10) ,
                          child: Text(
                              "$len1 $duration / $cost1 $moneyName", textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 , letterSpacing:0
                              )),),
                      )
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  _showCupertinoDialog(context, id2, vipStatus , cost2, len2);
                },
                child:  Padding(
                  padding: EdgeInsets.only(left: width*0.05 , right: width*0.05),
                  child: Container(
                      width: width*0.8,
                      height: height* 0.08,
                      decoration: BoxDecoration(
                        color: Colors.white, // Set container color
                        borderRadius: BorderRadius.circular(10.0), // Set border radius
                        border: Border.all(
                          color: const Color.fromRGBO(77, 170, 232, 1), // Set border color
                          width: 2.0, // Set border width
                        ),
                      ),
                      child:SizedBox(
                        height: 27,
                        child: Padding(padding: const EdgeInsets.only(left: 10) ,
                          child: Text(
                              "$len2 $duration / $cost2 $moneyName", textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 , letterSpacing:0
                              )),),
                      )
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  _showCupertinoDialog(context, id3, vipStatus , cost3, len3);
                },
                child:  Padding(
                  padding: EdgeInsets.only(left: width*0.05 , right: width*0.05),
                  child: Container(
                      width: width*0.8,
                      height: height* 0.08,
                      decoration: BoxDecoration(
                        color: Colors.white, // Set container color
                        borderRadius: BorderRadius.circular(10.0), // Set border radius
                        border: Border.all(
                          color: const Color.fromRGBO(77, 170, 232, 1), // Set border color
                          width: 2.0, // Set border width
                        ),
                      ),
                      child:SizedBox(
                        height: 27,
                        child: Padding(padding: const EdgeInsets.only(left: 10) ,
                          child: Text(
                              "$len3 $duration / $cost3 $moneyName", textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 , letterSpacing:0
                              )),),
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget vipLists(width, height, context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        userStatusContainer(width, height, superVipList[0], superVipList[1], superVipList[2],
          superVipList[3], superVipList[4], superVipList[5],
          superVipList[6], superVipList[7], superVipList[8],
          superVipList[9], superVipList[10], superVipList[11], 3
        ),
        const SizedBox(height: 15,),
        userStatusContainer(width, height, megaVipList[0], megaVipList[1], megaVipList[2],
         megaVipList[3], megaVipList[4], megaVipList[5],
         megaVipList[6], megaVipList[7], megaVipList[8],
         megaVipList[9], megaVipList[10], megaVipList[11], 2
        ),
        const SizedBox(height: 15,),
        userStatusContainer(width, height, vipList[0], vipList[1], vipList[2],
            vipList[3], vipList[4], vipList[5],
            vipList[6], vipList[7], vipList[8],
            vipList[9], vipList[10], vipList[11], 1
        ),
      ],
    );
  }

  Widget loadingData(){
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 2,),
    );
  }

  Widget vipTop (width , firstContainer , firstContainerHeight, heightOfVipImage){
    return  SizedBox(
        width: width,
        height: firstContainer,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                  width: width,
                  height: firstContainerHeight,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(2, 48, 71, 1)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => HomeScreen(positionBottomNavigationBar: 2)));
                            },
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30,),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: width*0.025),
                          child: SizedBox(
                            width: width * 0.95,
                            height: 72,
                            child: Text(
                              dataShowMain ,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ),
                    ],
                  )
              ),
            ),
            SizedBox(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: heightOfVipImage,
                  height: heightOfVipImage,
                  decoration:const BoxDecoration(
                    image:  DecorationImage(
                      image: AssetImage('assets/images/vip.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            )
          ],
        )
    );
  }

  Future<void> getVipList() async{
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
      final respose = await dio.get(globals.endpointGetVipLists);
      if(respose.statusCode == 200){
        //work with data =>
        String dataToParse = respose.toString();

        // Parse JSON
        Map<String, dynamic> jsonDataMap = await jsonDecode(dataToParse);

        // Extract the "result" array from the JSON
        List<dynamic> resultArray = jsonDataMap['result'];

        // Iterate through the result array
        resultArray.forEach((categoryData) {
          // Extract data from each category
          String title = categoryData['title'];
          String quantity = categoryData['quantity_announce'].toString();
          String discount = categoryData['discount'].toString();

          if (title == 'VIP') {
            vipList.add(title);
            vipList.add(quantity);
            vipList.add(discount);
          } else if (title == 'MEGA VIP') {
            megaVipList.add(title);
            megaVipList.add(quantity);
            megaVipList.add(discount);
          } else if (title == 'SUPER VIP') {
            superVipList.add(title);
            superVipList.add(quantity);
            superVipList.add(discount);
          }

          // Extract and add packet data to the corresponding list
          List<dynamic> packetsData = categoryData['packets'];
          packetsData.forEach((packetData) {
            String id = packetData['id'].toString();
            String price = packetData['price'].toString();
            String days = packetData['days'].toString();


            // Add the flattened data to the appropriate list based on the category title
            if (title == 'VIP') {
              vipList.add(id);
              vipList.add(price);
              vipList.add(days);
            } else if (title == 'MEGA VIP') {
              megaVipList.add(id);
              megaVipList.add(price);
              megaVipList.add(days);
            } else if (title == 'SUPER VIP') {
              superVipList.add(id);
              superVipList.add(price);
              superVipList.add(days);
            }
          });
        });
        setState(() {
          dataGet = true;

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
    getVipList();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double mainSizedBoxHeightUserNotLogged = height- statusBarHeight;
    double heightOfVipImage = mainSizedBoxHeightUserNotLogged/6;
    double firstContainer = mainSizedBoxHeightUserNotLogged * 0.4;
    double firstContainerHeight = firstContainer*0.95;
    double scrolling = mainSizedBoxHeightUserNotLogged - firstContainer;


    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(positionBottomNavigationBar: 2)));
        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
              padding: EdgeInsets.only(top: statusBarHeight),
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
                            vipTop(width, firstContainer, firstContainerHeight, heightOfVipImage),
                            const SizedBox(height: 30,),
                            (dataGet)? vipLists(width, scrolling, context) : loadingData(),
                            const SizedBox(height: 20,)
                          ],
                        ),
                      )
                  )
              )
          )
      ),
    );
  }
}
class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height-50)
      ..quadraticBezierTo(
        size.width / 2,
        size.height,
        size.width,
        size.height-50,
      )
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}