import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:hive_flutter/hive_flutter.dart';

import '../HomeFiles/home_screen.dart';


class AnnouncementPage extends StatefulWidget{

  const AnnouncementPage({super.key});

  @override
  AnnouncementPageState createState ()=> AnnouncementPageState();
}

class AnnouncementPageState extends State<AnnouncementPage>{

  String title = "";
  String showMessageTitle = "";
  String showMessageDescription = "";
  List<String> titles = [];
  List<String> descriptions = [];
  List<String> createdAnnounce = [];
  bool dataGet = false;
  bool anyRecords = false;

  void setDataKyrgyz(){
    title = "Компаниянын кулактандыруулары";
    showMessageTitle = "Кулактандыруулар жок";
    showMessageDescription = "Бул жерден кулактандыруулар\nменен тааныша аласыз";
  }

  void setDataRussian(){
      title = "Анонсы компании";
      showMessageTitle = "Анонсов нет";
      showMessageDescription = "Мы уведомим вас о новых \nанонсах здесь";
  }

  Future<void> getAnnouncement() async{
    final dio = Dio();
    var box = await Hive.openBox("logins");
    String refresh = await box.get("refresh");
    String access = await box.get("access");
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    dio.options.headers['Authorization'] = "Bearer $refresh";
    dio.options.headers['Authorization'] = "Bearer $access";
    try{
      final respose = await dio.get(globals.endpointGetAnnouncementList);
      if(respose.statusCode == 200){
        String jsonString = respose.toString();
        Map<String, dynamic> jsonData = await json.decode(jsonString);
        List<dynamic> results = jsonData['result'];
        for (var result in results) {
          titles.add(result['title']);
          descriptions.add(result['description']);
          createdAnnounce.add(result['created_at'].toString());
        }
        setState(() {
          dataGet = true;
          if(titles.isNotEmpty){
            anyRecords = true;
          }
        });

      }
    }
    catch(error){
      if(error is DioException){
        if (error.response != null) {
          String toParseData = error.response.toString();
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

  Widget announcementCompany(width, height, context){
    return SizedBox(
        width: width*0.95,
        height: height-50,
        child: (anyRecords)? ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: titles.length,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index){
              DateTime dateTime = DateTime.parse(createdAnnounce[index]);
              String dateTimeString = "${dateTime.day} ${dateTime.month} ${dateTime.year}";
              //now we should modify our string to RU =>
              String formattedDateString = formatDateString(dateTimeString);
              if(index==0){
                return Container(
                  width: width*0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10 , top: 10 , bottom: 10 , right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            titles[index] ,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                              "${descriptions[index]} \n\n$formattedDateString",
                              style: const TextStyle(
                                  fontSize: 14, color: Color.fromRGBO(151, 151, 151, 1), fontWeight: FontWeight.w400
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
              else{
                if(index==titles.length-1){
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: width*0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10 , top: 10 , bottom: 10 , right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                titles[index] ,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                  "${descriptions[index]} \n\n$formattedDateString",
                                  style: const TextStyle(
                                      fontSize: 14, color: Color.fromRGBO(151, 151, 151, 1), fontWeight: FontWeight.w400
                                  )
                              ),
                            ),
                            const SizedBox(height: 20,)
                          ],
                        ),
                      ),
                    ),
                  );
                }
                else{
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: width*0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10 , top: 10 , bottom: 10 , right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                titles[index] ,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                  "${descriptions[index]} \n\n$formattedDateString",
                                  style: const TextStyle(
                                      fontSize: 14, color: Color.fromRGBO(151, 151, 151, 1), fontWeight: FontWeight.w400
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
            }
        ) : noRecords(width,height)
    );
  }

  Widget noRecords(width , height){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width*0.75, height: height*0.3,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/noAnnounce.png'),
                  fit: BoxFit.contain
              )
          ),
        ),
        const SizedBox(height: 15,),
        SizedBox(
          width: width*0.9,
          height: 50,
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


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if(globals.userLanguage!="ru"){setDataKyrgyz();}
    if(globals.userLanguage=="ru"){setDataRussian();}
    getAnnouncement();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double mainSizedBoxHeightUserNotLogged = height- statusBarHeight;



    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(positionBottomNavigationBar: 2)));
        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(padding: EdgeInsets.only(top: statusBarHeight),
              child: Container(
                  width: width,
                  height: mainSizedBoxHeightUserNotLogged,
                  color: const Color.fromRGBO(250, 250, 250, 1),
                  child:  SizedBox(
                    width: width*0.95,
                    height: mainSizedBoxHeightUserNotLogged,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //first elem is x to sign out =>
                        SizedBox(
                          width: width*0.95,
                          height: 30,
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
                                  height: 30,
                                  width: width*0.7,
                                  child: Padding(
                                      padding: (globals.userLanguage=="ru")?const EdgeInsets.only(top: 7.5) : const EdgeInsets.only(top: 10),
                                      child: Text(
                                          title, textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: (globals.userLanguage=="ru")?20:16, color: Colors.black, fontWeight: FontWeight.w500
                                          ))
                                  )
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: width*0.95,
                            height: mainSizedBoxHeightUserNotLogged-50,
                            child: (dataGet)? announcementCompany(width, mainSizedBoxHeightUserNotLogged, context) : loadingData(),
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