import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:zherdeshmobileapplication/HomeFiles/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class TransferPage extends StatefulWidget{
  const TransferPage({super.key});

  @override
  TransferPageState createState ()=> TransferPageState();
}
class TransferPageState extends State<TransferPage>{

  String topic = "";
  String cashAdding = "";
  String transactions = "";
  String showMessageTitle = "";
  String showMessageDescription = "";
  bool dataGet = false;
  bool anyRecords = false;
  List<String> descriptions = [];
  List<String> createdDates = [];
  List<String> formattedTotals = [];

  void setDataKyrgyz(){

  }
  void setDataRussian(){
    topic = "История оплат";
    cashAdding = "Пополнение счета";
    transactions = "Транзакции";
    showMessageTitle = "Пока нет транзакций";
    showMessageDescription = "Они появятся здесь при первой транзакции";
  }


  Future<void> getTransferList() async{
    final dio = Dio();
    var box = await Hive.openBox("logins");
    String refresh = await box.get("refresh");
    String access = await box.get("access");
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    dio.options.headers['Authorization'] = "Bearer $refresh";
    dio.options.headers['Authorization'] = "Bearer $access";

    try{
      final respose = await dio.get(globals.endpointGetTransactionList);
      if(respose.statusCode == 200){
        String jsonString = respose.toString();
        Map<String, dynamic> jsonData = await json.decode(jsonString);
        List<dynamic> results = jsonData['result'];

        for (var result in results) {
          descriptions.add(result['description']);
          createdDates.add(result['created_at']);
          formattedTotals.add(result['total'].toString());
        }
        setState(() {
          dataGet = true;
          if(descriptions.isNotEmpty){
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

  Future<void> _launchURL(Uri url) async {
    await launchUrl(url);
  }

  Future<void> addMoneyHundred() async{
    final dio = Dio();
    var box = await Hive.openBox("logins");
    String refresh = await box.get("refresh");
    String access = await box.get("access");
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    dio.options.headers['Authorization'] = "Bearer $refresh";
    dio.options.headers['Authorization'] = "Bearer $access";
    try{
      final respose = await dio.get("${globals.endpointAddMoney}100");
      if(respose.statusCode == 200){
        String jsonString = respose.toString();
        Map<String, dynamic> data = jsonDecode(jsonString);
        String paymentUrl = data['payment_url'];
        String encodedURL = Uri.encodeFull(paymentUrl);
        Uri uri = Uri.parse(encodedURL);
        _launchURL(uri);
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

  Future<void> addMoneyFifeHundred() async{
    final dio = Dio();
    var box = await Hive.openBox("logins");
    String refresh = await box.get("refresh");
    String access = await box.get("access");
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    dio.options.headers['Authorization'] = "Bearer $refresh";
    dio.options.headers['Authorization'] = "Bearer $access";
    try{
      final respose = await dio.get("${globals.endpointAddMoney}500");
      if(respose.statusCode == 200){
        String jsonString = respose.toString();
        Map<String, dynamic> data = jsonDecode(jsonString);
        String paymentUrl = data['payment_url'];
        String encodedURL = Uri.encodeFull(paymentUrl);
        Uri uri = Uri.parse(encodedURL);
        _launchURL(uri);
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

  Future<void> addMoneyThousand() async{
    final dio = Dio();
    var box = await Hive.openBox("logins");
    String refresh = await box.get("refresh");
    String access = await box.get("access");
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    dio.options.headers['Authorization'] = "Bearer $refresh";
    dio.options.headers['Authorization'] = "Bearer $access";
    try{
      final respose = await dio.get("${globals.endpointAddMoney}1000");
      if(respose.statusCode == 200){
        String jsonString = respose.toString();
        Map<String, dynamic> data = jsonDecode(jsonString);
        String paymentUrl = data['payment_url'];
        String encodedURL = Uri.encodeFull(paymentUrl);
        Uri uri = Uri.parse(encodedURL);
        _launchURL(uri);
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

  Future<void> addMoneyFiveThousand() async{
    final dio = Dio();
    var box = await Hive.openBox("logins");
    String refresh = await box.get("refresh");
    String access = await box.get("access");
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    dio.options.headers['Authorization'] = "Bearer $refresh";
    dio.options.headers['Authorization'] = "Bearer $access";
    try{
      final respose = await dio.get("${globals.endpointAddMoney}5000");
      if(respose.statusCode == 200){
        String jsonString = respose.toString();
        Map<String, dynamic> data = jsonDecode(jsonString);
        String paymentUrl = data['payment_url'];
        String encodedURL = Uri.encodeFull(paymentUrl);
        Uri uri = Uri.parse(encodedURL);
        _launchURL(uri);
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

  //todo : => change listtile to complete column with right data and change all logic to one single child scroll view

  Widget transaction(width , height , moneyTotal , description , formattedDateString , time){
    if(moneyTotal.contains("-")){
      return SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: width*0.1 , left: width*0.025 , top: 5),
              child: SizedBox(
                width: width*0.875,
                child: Text(
                    description , textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500
                    )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width*0.05),
              child: SizedBox(
                width: width*0.95,
                child: Text(
                    moneyTotal, textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontSize: 12, color: Color.fromRGBO(151, 151, 151, 1), fontWeight: FontWeight.w500
                    )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width*0.025),
              child: SizedBox(
                width: width*0.95,
                child: Text(
                    "\n$formattedDateString , $time", textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 12, color: Color.fromRGBO(151, 151, 151, 1), fontWeight: FontWeight.w300
                    )
                ),
              ),
            ),
          ],
        ),
      );
    }
    else{
      return SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: width*0.1 , left: width*0.025 , top: 5),
              child: SizedBox(
                width: width*0.875,
                child: Text(
                    description , textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500
                    )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width*0.05),
              child: SizedBox(
                width: width*0.95,
                child: Text(
                    moneyTotal, textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontSize: 12, color: Color.fromRGBO(55, 194, 68, 1), fontWeight: FontWeight.w500
                    )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width*0.025),
              child: SizedBox(
                width: width*0.95,
                child: Text(
                    "\n$formattedDateString , $time", textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 12, color: Color.fromRGBO(151, 151, 151, 1), fontWeight: FontWeight.w300
                    )
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget userProfileTransactions(width,height, context){
    return SizedBox(
      width: width*0.95,
      child: (anyRecords)? ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: descriptions.length,
          padding: const EdgeInsets.all(0),
          itemBuilder: (context, index){
            String createData = createdDates[index];
            String dayMonthYear = createData.substring(0,10);
            DateTime dateTime = DateTime.parse(dayMonthYear);

            String dateTimeString = "${dateTime.day} ${dateTime.month} ${dateTime.year}";
            String formattedDateString = formatDateString(dateTimeString);

            String time = createData.substring(11,19);
            String moneyTotal = formattedTotals[index];

            String description = descriptions[index];

            if(index==0){
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white
                ),
                child: transaction(width, height, moneyTotal, description, formattedDateString, time),
              );
            }
            else{
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white
                  ),
                  child: transaction(width, height, moneyTotal, description, formattedDateString, time),
                ),
              );
            }
          }
      ) : noRecords(width , height)
    );
  }

  Widget noRecords(width , height){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width*0.75, height: height*0.7 - 310,
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

  Widget loadingData(width , height){
    return SizedBox(
      width: width*0.95,
      height: height*0.7 - 200,
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2,),
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
    if(globals.userLanguage!="ru"){setDataKyrgyz();}

    if(globals.userLanguage=="ru"){setDataRussian();}

    getTransferList();
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
              builder: (BuildContext context) => HomeScreen(positionBottomNavigationBar: 2)));
          return true;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body:Padding(padding: EdgeInsets.only(top: statusBarHeight),
              child: Container(
                  width: width,
                  height: mainSizedBoxHeightUserNotLogged,
                  color:const  Color.fromRGBO(250, 250, 250, 1),
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
                                      padding: const EdgeInsets.only(top: 7.5),
                                      child: Text(
                                          topic, textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500
                                          ))
                                  )
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: mainSizedBoxHeightUserNotLogged-40,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                SizedBox(
                                    height: 25 ,
                                    width: width*0.95,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        cashAdding ,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(fontSize: 18, color: Colors.black),),
                                    )
                                ),
                                const SizedBox(height: 10,),
                                SizedBox(
                                  width: width*0.95,
                                  height: mainSizedBoxHeightUserNotLogged*0.3 + 30,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          addMoneyHundred();
                                        },
                                        child: Container(
                                          width: width*0.95,
                                          height: mainSizedBoxHeightUserNotLogged * 0.075,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(padding: EdgeInsets.only(left: 15),
                                                  child: SizedBox(
                                                    child: Text(
                                                      "100" , style: TextStyle(color: Colors.black , fontSize: 16),
                                                    ),
                                                  )
                                              ),
                                              Padding(padding: EdgeInsets.only(right: 15),
                                                  child: SizedBox(
                                                    child: Icon(Icons.add, color: Color.fromRGBO(77, 170, 232, 1), size: 25,),
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      GestureDetector(
                                        onTap: (){
                                          addMoneyFifeHundred();
                                        },
                                        child: Container(
                                          width: width*0.95,
                                          height: mainSizedBoxHeightUserNotLogged * 0.075,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(padding: EdgeInsets.only(left: 15),
                                                  child: SizedBox(
                                                    child: Text(
                                                      "500" , style: TextStyle(color: Colors.black , fontSize: 16),
                                                    ),
                                                  )
                                              ),
                                              Padding(padding: EdgeInsets.only(right: 15),
                                                  child: SizedBox(
                                                    child: Icon(Icons.add, color: Color.fromRGBO(77, 170, 232, 1), size: 25,),
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      GestureDetector(
                                        onTap: (){
                                          addMoneyThousand();
                                        },
                                        child: Container(
                                          width: width*0.95,
                                          height: mainSizedBoxHeightUserNotLogged * 0.075,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(padding: EdgeInsets.only(left: 15),
                                                  child: SizedBox(
                                                    child: Text(
                                                      "1000" , style: TextStyle(color: Colors.black , fontSize: 16),
                                                    ),
                                                  )
                                              ),
                                              Padding(padding: EdgeInsets.only(right: 15),
                                                  child: SizedBox(
                                                    child: Icon(Icons.add, color: Color.fromRGBO(77, 170, 232, 1), size: 25,),
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      GestureDetector(
                                        onTap: (){
                                          addMoneyFiveThousand();
                                        },
                                        child: Container(
                                          width: width*0.95,
                                          height: mainSizedBoxHeightUserNotLogged * 0.075,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(padding: EdgeInsets.only(left: 15),
                                                  child: SizedBox(
                                                    child: Text(
                                                      "5000" , style: TextStyle(color: Colors.black , fontSize: 16),
                                                    ),
                                                  )
                                              ),
                                              Padding(padding: EdgeInsets.only(right: 15),
                                                  child: SizedBox(
                                                    child: Icon(Icons.add, color: Color.fromRGBO(77, 170, 232, 1), size: 25,),
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 25 ,
                                  width: width*0.95,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      transactions ,
                                      style: const TextStyle(fontSize: 18, color: Colors.black),),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  child: (dataGet)? userProfileTransactions(width, mainSizedBoxHeightUserNotLogged ,context): loadingData(width , mainSizedBoxHeightUserNotLogged),
                                ),
                                const SizedBox(height : 20)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              )
            )
        )
    );
  }
}