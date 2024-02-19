import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:zherdeshmobileapplication/HomeFiles/home_screen.dart';

import '../UserDatas/userdata_page.dart';
import 'edit_user_advertise_page.dart';

class AdvertiseAnotherUserPageFullView extends StatefulWidget{
  final String postID;
  const AdvertiseAnotherUserPageFullView({super.key, required this.postID});


  @override
  AdvertiseAnotherUserPageFullViewState createState ()=> AdvertiseAnotherUserPageFullViewState();
}
class AdvertiseAnotherUserPageFullViewState extends State<AdvertiseAnotherUserPageFullView>{


  //todo => methods to setProper data =>
  String titlePost = "";
  String stationPost = "";
  String descriptionPost = "";
  String addressPost = "";
  String subcategoryPost = "";
  String phonePost = "";
  List<String> imagePathPost = [];
  String viewCount = "";

  String complaint = "";

  bool dataGet = false;
  String showDataDescr = "";
  String viewCountString = "";
  String dataPay3 = "";
  String dataPay4 = "";
  String selectedOption = "";
  String rekomended = "";
  String complainSuccess = "";

  //Recomended Advertises lists =>
  List<String> recomendedpostIdList = [];
  List<String> recomendedpostTitleList = [];
  List<String> recomendedpostDescriptionList = [];
  List<String> recomendedpostMetroNameList = [];
  List<String> recomendedpostImagePathList = [];
  List<bool> recomendedpostIsColoredList = [];
  List<bool> recomendedpostIsVipList = [];

  String metroDataShow = "";
  String addressDataShow = "";
  String phoneDataShow = "";
  String copied = "";
  void setDataEnglish(){

  }
  void setDataRussian(){
      showDataDescr = "Описание";
      viewCountString = "Число просмотров ";

      complaint = "Пожаловаться";
      dataPay3 = "Подтвердить";
      dataPay4 = "Отклонить";
      rekomended = "Рекомедации";
      complainSuccess = "Успешно!";

      metroDataShow = "Метро";
      addressDataShow = "Адрес";
      phoneDataShow = "Телефон";
      copied = "Скопировано";
  }


  Future<void> getPostInfo() async{
    print("Get post data : ");
    final dio = Dio();
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    try{
      //todo => send data to server : =>
      final respose = await dio.get("${globals.endpointGetAnotherUserAdvertises}${widget.postID}");
      if(respose.statusCode == 200){
        //work with data =>
        String dataToParse = respose.toString();
        print("DATA : $dataToParse");
        Map<String, dynamic> data = await json.decode(dataToParse);
        titlePost = data['title'];
        descriptionPost = data['description'];
        stationPost = data['metro_name'];
        if(data['address']!=null){
          addressPost = data['address'];
        }
        else{
          addressPost = "-";
        }
        phonePost = data['phone'];
        subcategoryPost = data['subcategory'];
        viewCount = data['view_count'].toString();
        List<dynamic> imageMassive = data['images'];
        imageMassive.forEach((element) {
          imagePathPost.add(element['image']);
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

  Future<void> getRecomendedList() async{
    print("Get rekomended");
    final dio = Dio();
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    try{
      //todo => send data to server : =>
      final respose = await dio.get("${globals.endpointGetRecomended}${widget.postID}");
      if(respose.statusCode == 200){
        //work with data =>
        String dataToParse = respose.toString();
        print("Respose rekomended : $dataToParse");
        Map<String, dynamic> jsonDataMap =  await json.decode(dataToParse);
        List<dynamic> postsData = jsonDataMap['result'];
        for (var post in postsData) {
          recomendedpostIdList.add(post['id'].toString());
          recomendedpostTitleList.add(post['title']);
          recomendedpostDescriptionList.add(post['description']);
          recomendedpostMetroNameList.add(post['metro_name']);
          recomendedpostImagePathList.add(post['images']);
          recomendedpostIsColoredList.add(post['is_colored']);
          recomendedpostIsVipList.add(post['is_vip']);
        }
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

  Future<void> getAllData() async{
    await getPostInfo();
    await getRecomendedList();
    setState(() {
      dataGet= true;
    });
  }

  Widget loadingData(width , height){
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pop();
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
          isLoop: true,
          children: imageWidgets,
        )
    );
  }

  Future<void> getComplaintsInfo(List<int> idComplainList, List<String> titleComplain) async{
    print("Get complaints");
    final dio = Dio();
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    try{
      //todo => send data to server : =>
      final respose = await dio.get(globals.endpointGetComplainList);
      if(respose.statusCode == 200){
        //work with data =>
        String dataToParse = respose.toString();
        Map<String, dynamic> jsonMap = json.decode(dataToParse);

        List<Map<String, dynamic>> result = List.from(jsonMap['result']);

        for (Map<String, dynamic> item in result) {
          int id = item['id'];
          String title = item['title'];

          idComplainList.add(id);
          titleComplain.add(title);
        }
        //update data =>
        setState(() {
            selectedOption = titleComplain[0];
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

  void _showCupertinoDialogComplain(BuildContext context , String idPost) async{
    List<int> idComplainList = [];
    List<String> titleComplain = [];
    // waiting =>
    await getComplaintsInfo(idComplainList, titleComplain).then((value) =>
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: Text(
                    complaint , textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400 , letterSpacing: -0.4
                    )
                ),
                content: StatefulBuilder(
                  builder: (context, setState){
                    return SingleChildScrollView(
                      child: Column(
                        children: titleComplain.map((complain) => RadioListTile<String>(
                            title: Text(complain, textAlign: TextAlign.start,),
                            value: complain,
                            groupValue: selectedOption,
                            onChanged: (value){
                              setState(() {
                                selectedOption = value!;
                                print(selectedOption);
                              });
                            }
                        )
                        ).toList(),
                      ),
                    );
                  },
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          //todo : => complain
                          final dio = Dio();
                          //get access and refresh token from Hive =>
                          var box = await Hive.openBox("logins");
                          String refresh = await box.get("refresh");
                          String access = await box.get("access");
                          //set Dio response =>
                          dio.options.headers['Accept-Language'] = globals.userLanguage;
                          dio.options.headers['Authorization'] = "Bearer $refresh";
                          dio.options.headers['Authorization'] = "Bearer $access";
                          int posComplainString = titleComplain.indexOf(selectedOption);
                          try{
                            //todo => send data to server : =>
                            final respose = await dio.post(globals.endpointPostComplain ,
                                data: {
                                  "complaint_list" : idComplainList[posComplainString],
                                  "announcement" : widget.postID
                                }
                            );
                            if(respose.statusCode == 201){
                              //work with data =>
                              Fluttertoast.showToast(
                                msg: complainSuccess,
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
                                String toParseData = error.response.toString();
                                print(toParseData);
                              }
                            }
                          }
                          Navigator.of(context).pop();
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
                            complaint,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500 , letterSpacing: -0.4
                            )
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
        )
    );

  }

  Widget complainToAdvert(width, height, context){
    return GestureDetector(
      onTap: () async {
        var box = await Hive.openBox("logins");
        bool isEmailInHive= box.containsKey("refresh");
        bool isPasswordInHive= box.containsKey("access");
        if(isEmailInHive && isPasswordInHive){
          _showCupertinoDialogComplain(context, widget.postID);
        }
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
              const  FaIcon(FontAwesomeIcons.triangleExclamation, color: Color.fromRGBO(253, 93, 93, 1), size: 16),
              const SizedBox(width: 10,),
              Text(
                  complaint, textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromRGBO(253, 93, 93, 1), fontWeight: FontWeight.w400 , letterSpacing:0
                  )),
            ],
          )
      ),
    );
  }

  //todo : => create list of advertises :

  Widget advertiseVip(width,String imagePath,String postTitle , String postDescription , postMetroName , imageHeight, imageCasual){
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.transparent,
        border: Border.all(
          color: const Color.fromRGBO(251, 133, 0, 1),
          width: 2.0, // Set border width
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          dataAfterImageVip(width,postTitle, postDescription, postMetroName),
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: imageContainerDataVip(width, imageHeight, imagePath, imageCasual)
          )
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
              width: width*0.25,
              height: width*0.25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
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
            radius: 12.5,
            child: FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 15),
          ),
        )
      ],
    );
  }



  Widget advertiseCommon(width, String imagePath, bool postIsColored, String postTitle , String postDescription , postMetroName, imageHeight, imageCasual){
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.transparent,
        border: Border.all(
          color: postIsColored ? const Color.fromRGBO(33, 158, 188, 1) : const Color.fromRGBO(181, 181, 181, 1),
          width: 2.0, // Set border width
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          dataAfterImageCasual(width,postTitle, postDescription, postMetroName, postIsColored),
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: imageContainerData(width, imageHeight, imagePath, postIsColored ,imageCasual)
          )
        ],
      ),
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
              width: width*0.25,
              height: width*0.25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
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
            radius: 12.5,
            child: const FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 15),
          ),
        )
      ],
    );
  }

  Widget dataAfterImageVip(width,postTitleInside, postDescriptionInside , postMetroNameInside){
    return SizedBox(
      width: width*0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: width*0.025, left:width*0.025 , top: 15),
            child: Text(
                postTitleInside, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 18, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                  letterSpacing: 0,
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width*0.025, right: width*0.025 , top: 5),
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
              padding: EdgeInsets.only(left: width*0.025, right: width*0.025 , top: 15),
              child: Container(
                  width: width*0.95,
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(251, 133, 0, 1),
                    borderRadius: BorderRadius.circular(8.0), // Set border radius
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          postMetroNameInside, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600 ,
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
          const SizedBox(height: 10,)
        ],
      ),
    );
  }

  Widget dataAfterImageCasual(width, postTitleInside, postDescriptionInside , postMetroNameInside, bool coloredIsAdvertise){
    return SizedBox(
      width: width*0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: width*0.025, left:width*0.025 , top: 15),
            child: Text(
                postTitleInside, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 18, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                  letterSpacing: 0,
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width*0.025, right: width*0.025 , top: 5),
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
              padding: EdgeInsets.only(left: width*0.025, right: width*0.025 , top: 15),
              child: Container(
                  width: width*0.95,
                  height: 25,
                  decoration: BoxDecoration(
                    color: coloredIsAdvertise ? const Color.fromRGBO(33, 158, 188, 1) : const Color.fromRGBO(181, 181, 181, 1), // Set container color
                    borderRadius: BorderRadius.circular(8.0), // Set border radius
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          postMetroNameInside, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600 ,
                            letterSpacing: 0,
                          )
                      ),
                      const SizedBox(width: 10,),
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 10,
                          child: FaIcon(FontAwesomeIcons.trainSubway, color: coloredIsAdvertise ? const Color.fromRGBO(33, 158, 188, 1) : const Color.fromRGBO(181, 181, 181, 1), size: 16,
                          ))
                    ],
                  )
              )
          ),
          const SizedBox(height: 10,)
        ],
      ),
    );
  }

  Widget userAdvertiseListChild(width, height, context){
    return SizedBox(
        width: width*0.95,
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: recomendedpostIdList.length,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index){
              if(index==0){
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => AdvertiseAnotherUserPageFullView(
                          postID: recomendedpostIdList[index],
                        )));
                  },
                  child: (recomendedpostIsVipList[index])? advertiseVip(width,
                      recomendedpostImagePathList[index], recomendedpostTitleList[index],recomendedpostDescriptionList[index], recomendedpostMetroNameList[index], height,
                      (recomendedpostImagePathList[index] == "http://sino0on.ru/media/avatars/df/Zherdesh%20logo-03.png")? true: false)
                      : advertiseCommon(width, recomendedpostImagePathList[index],
                      recomendedpostIsColoredList[index],recomendedpostTitleList[index],recomendedpostDescriptionList[index], recomendedpostMetroNameList[index],height,
                      (recomendedpostImagePathList[index] == "http://sino0on.ru/media/avatars/df/Zherdesh%20logo-03.png")? true: false),
                );
              }
              else{
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => AdvertiseAnotherUserPageFullView(
                          postID: recomendedpostIdList[index],
                        )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: (recomendedpostIsVipList[index])? advertiseVip(width,
                        recomendedpostImagePathList[index], recomendedpostTitleList[index],recomendedpostDescriptionList[index], recomendedpostMetroNameList[index], height,
                        (recomendedpostImagePathList[index] == "http://sino0on.ru/media/avatars/df/Zherdesh%20logo-03.png")? true: false)
                        : advertiseCommon(width, recomendedpostImagePathList[index],
                        recomendedpostIsColoredList[index],recomendedpostTitleList[index],recomendedpostDescriptionList[index], recomendedpostMetroNameList[index],height,
                        (recomendedpostImagePathList[index] == "http://sino0on.ru/media/avatars/df/Zherdesh%20logo-03.png")? true: false),
                  ),
                );
              }
            }
        )
    );
  }

  Future<void> _launchURL(Uri url) async {
    await launchUrl(url);
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
      setDataEnglish();
    }
    if(globals.userLanguage=="ru"){
      setDataRussian();
    }
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double mainSizedBoxHeightUserNotLogged = height - statusBarHeight;

    return (dataGet)? WillPopScope(
        onWillPop: () async{
          Navigator.of(context).pop();
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
                              Navigator.of(context).pop();
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
                            ),
                            const SizedBox(width: 10,),
                            GestureDetector(
                              onTap: (){
                                //copy data =>
                                Clipboard.setData(ClipboardData(text: phonePost));
                                //show copied =>
                                Fluttertoast.showToast(
                                  msg: copied,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                                  backgroundColor: Colors.white, // Background color of the toast
                                  textColor: Colors.black,
                                );
                              },
                              child: const FaIcon(FontAwesomeIcons.solidCopy , size: 24, color: Color.fromRGBO(188, 188, 188, 1),),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    complainToAdvert(width, height, context),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: width*0.95,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: (){
                                String launch = "https://t.me/share/url?url=google.com";
                                Uri uri = Uri.parse(launch);
                                _launchURL(uri);
                              },
                              child: Container(
                                width: width*0.1,
                                height: width*0.1,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(0, 119, 255, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: FaIcon(FontAwesomeIcons.vk , size: width*0.1-10, color: Colors.white),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                width: width*0.1,
                                height: width*0.1,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(249, 116, 0, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: FaIcon(FontAwesomeIcons.odnoklassniki , size: width*0.1-10, color: Colors.white),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                width: width*0.1,
                                height: width*0.1,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(37, 211, 102, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: FaIcon(FontAwesomeIcons.whatsapp , size: width*0.1-10, color: Colors.white),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                width: width*0.1,
                                height: width*0.1,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(34, 158, 217, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: FaIcon(FontAwesomeIcons.telegram , size: width*0.1-10, color: Colors.white),
                                ),
                              ),
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
                    const SizedBox(height: 5,),
                    Padding(
                        padding: EdgeInsets.only(left: width*0.025+5, right: width*0.025+5),
                        child: SizedBox(height: 30 , width: width*0.95, child: Text(rekomended , textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 18, color: Colors.black , fontWeight: FontWeight.w500 ),),
                        )
                    ),
                    const SizedBox(height: 10,),
                    //Recomended ads
                    SizedBox(
                      width: width*0.95,
                      child: userAdvertiseListChild(width, mainSizedBoxHeightUserNotLogged, context),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          )
      ) ,
    ): loadingData(width, height);
  }
}