import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zherdeshmobileapplication/Categories/catigories_page.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:zherdeshmobileapplication/Search/search_settings.dart';

import '../Advertise/advertise_another_page.dart';
import '../Search/search_category.dart';
import '../Search/search_page.dart';


enum MediaType{
  image,
  video
}

class Story{
  final String fileUrl;
  final MediaType mediaType;
  final Duration duration;

  const Story({
    required this.fileUrl,
    required this.mediaType,
    required this.duration,
  });
}

class Stories{
  final String title;
  final String storiesAvatarUrl;
  final List<Story> storyList;

  const Stories({
    required this.title,
    required this.storiesAvatarUrl,
    required this.storyList,
  });
}

class Banner{
  final String imagePath;
  final String bannerUrl;

  const Banner({
    required this.imagePath,
    required this.bannerUrl,
  });
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  HomePageState createState ()=> HomePageState();
}

class HomePageState extends State<HomePage>{

  //todo => create strings which will show data =>
  String searchText = "";
  String lastAdvertises = "";
  String showAllGroups = "";

  bool dataGet = false;
  bool anyRecordsBanners = false;
  bool anyRecordsStories = false;

  //todo => define int to store page of user search :
  int pageNumber = 1;
  String failureToFetchAdvertises = "";
  //todo => methods to setProper data =>
  void setDataKyrgyz(){
    searchText = "Издөө";
    showAllGroups = "Бардык категория-\nларды көрсөтүү";
    lastAdvertises = "Акыркы жарыялар";

  }
  void setDataRussian(){
    searchText = "Поиск";
    showAllGroups = "Показать все \nкатегории";
    lastAdvertises = "Последние объявления";
    failureToFetchAdvertises = "Не удалось загрузить\nновые объявления";
  }

  List<AssetImage> assetImagesHome = [
    const AssetImage('assets/images/autoHome.png'),
    const AssetImage('assets/images/kgHome.png'),

    const AssetImage('assets/images/flatHome.png'),
    const AssetImage('assets/images/serviceHome.png'),

    const AssetImage('assets/images/workHome.png'),
    const AssetImage('assets/images/electoHome.png'),

    const AssetImage('assets/images/clothesHome.png'),
    const AssetImage('assets/images/hotelHome.png'),

    const AssetImage('assets/images/childClotheHome.png'),
    const AssetImage('assets/images/techHome.png'),

    const AssetImage('assets/images/goodsHome.png'),
    const AssetImage('assets/images/beautyHome.png'),

    const AssetImage('assets/images/autogoodsHome.png'),
    const AssetImage('assets/images/airHome.png'),
  ];


  //Stories
  List<Stories> listStories = [];

  //categories =>
  List<String> categoriesHomePageTitle = [];
  List<int> categoriesHomePageId = [];

  //banners =>
  List<Banner> listBanner = [];

  //Advertises lists =>
  List<String> postIdList = [];
  List<String> postTitleList = [];
  List<String> postDescriptionList = [];
  List<String> postMetroNameList = [];
  List<String> postImagePathList = [];
  List<bool> postIsColoredList = [];
  List<bool> postIsVipList = [];

  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

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
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/logo.png"),fit: BoxFit.contain)),
            )),
            const SizedBox(height: 20,),
            Padding(padding: EdgeInsets.only(left: width*0.3) ,
              child: const CircularProgressIndicator(strokeWidth: 2,),
            )
          ],
        )
    );
  }

  Future<void> getCategoriesHomePage() async{
    final dio = Dio();
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    try{
      final respose = await dio.get(globals.endpointGetHomeCategories);
      if(respose.statusCode == 200){
        String userDataJson = respose.toString();
        Map<String, dynamic> jsonData = json.decode(userDataJson);
        List<dynamic> result = jsonData['result'];
        for (var categoryData in result) {
          int id = categoryData['id'];
          String title = categoryData['title'];
          categoriesHomePageTitle.add(title);
          categoriesHomePageId.add(id);
        }
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

  Future<void> getStoriesHomePage() async{
    final dio = Dio();

    dio.options.headers['Accept-Language'] = globals.userLanguage;
    try{
      final respose = await dio.get(globals.endpointGetHomeStories);
      if(respose.statusCode == 200){
        String userDataJson = respose.toString();
        dynamic parsedData = await jsonDecode(userDataJson);
        // Accessing data
        List<dynamic> result = parsedData["result"];
        for (var entry in result) {
          String title = entry["title"];
          String image = entry["image"];
          List<dynamic> files = entry["files"];
          List<Story> dataFilesStory = [];
          if (files.isNotEmpty) {
            for (var file in files) {
              String fileUrl = file["file"];
              if(fileUrl.endsWith(".png")||fileUrl.endsWith(".jpg")||fileUrl.endsWith(".jpeg")||fileUrl.endsWith(".gif")){
                  //image duration = 10 sec
                Story storyFromServer = Story(fileUrl: fileUrl, mediaType: MediaType.image, duration: const Duration(seconds: 10));
                dataFilesStory.add(storyFromServer);
              }
              else{
                final headers = respose.headers;
                final contentLength = headers['content-length'];
                if (contentLength != null) {
                  final fileSize = int.parse(contentLength[0]);
                  Story storyFromServer = Story(fileUrl: fileUrl, mediaType: MediaType.video, duration: Duration(milliseconds: fileSize));
                  dataFilesStory.add(storyFromServer);
                }
              }
            }
            //todo => if we have any file into : =>
           Stories storiesFromServer = Stories(title: title, storiesAvatarUrl: image, storyList: dataFilesStory);
           listStories.add(storiesFromServer);
          } else {
            print("No files available");
          }
        }
        
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

  Future<void> getBannersHomePage() async{
    final dio = Dio();

    dio.options.headers['Accept-Language'] = globals.userLanguage;
    try{
      final respose = await dio.get(globals.endpointGetHomeBanners);
      if(respose.statusCode == 200){
        String userDataJson = respose.toString();
        dynamic parsedData = await jsonDecode(userDataJson);

        List<dynamic> result = parsedData["result"];
        result.forEach((element) {
          String image = element["image"];
          String url = element["url"];

          Banner bannerFromServer = Banner(imagePath: image, bannerUrl: url);
          listBanner.add(bannerFromServer);
        });
        //todo : => shuffle banners :
        listBanner.shuffle();
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

  Future<void> getHomeAdvertises() async {
    final dio = Dio();
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    try{
      final respose = await dio.get("${globals.endpointGetHomeAdvertises}?limit=${globals.countNumberOfAdvertises}&page=$pageNumber");
      if(respose.statusCode == 200){
        String jsonString = respose.toString();
        Map<String, dynamic> jsonDataMap =  await json.decode(jsonString);
        List<dynamic> postsData = jsonDataMap['results'];
        for (var post in postsData) {
          postIdList.add(post['id'].toString());
          postTitleList.add(post['title']);
          postDescriptionList.add(post['description']);
          postMetroNameList.add(post['metro_name']);
          postImagePathList.add(post['images']);
          postIsColoredList.add(post['is_colored']);
          postIsVipList.add(post['is_vip']);
        }
        setState(() {

        });
      }
    }
    catch(error){
      if(error is DioException){
        if (error.response != null) {
          String toParseData = error.response.toString();
          print(toParseData);
          Fluttertoast.showToast(
            msg: failureToFetchAdvertises,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
            backgroundColor: Colors.white, // Background color of the toast
            textColor: Colors.black,
          );
        }
      }
    }
  }

  Future<void> loadMoreAdvertises() async {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      getHomeAdvertises();
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> getHomePageData() async{
    await getCategoriesHomePage();
    await getStoriesHomePage();
    await getBannersHomePage();
    await getHomeAdvertises();
    if(mounted){
      setState(() {
        dataGet = true;
        if(listStories.isNotEmpty){
          anyRecordsStories = true;
        }
        if(listBanner.isNotEmpty){
          anyRecordsBanners = true;
        }
      });
    }
  }

  Future<void> _launchURL(Uri url) async {
    await launchUrl(url);
  }

  Widget showBannerNewImages(width , height){
    List<Widget> imageWidgets = List.generate(listBanner.length, (index) {
      String urlBannerPath = listBanner[index].bannerUrl;
      String encodedURL = Uri.encodeFull(urlBannerPath);
      Uri uri = Uri.parse(encodedURL);
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GestureDetector(
          onTap: (){
            _launchURL(uri);
          },
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
            imageUrl: listBanner[index].imagePath,
            imageBuilder: (context, imageProvider){
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              );
            },
          ),
        ),
      );
    });
    return (anyRecordsBanners)?
    Container(
        width: width*0.95,
        height: height*0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), // Set border radius
        ),
        child: Align(
          alignment: Alignment.center,
          child: CarouselSlider(
            options: CarouselOptions(
              height: height * 0.25,
              viewportFraction: 0.65,
              autoPlay: true,
              autoPlayInterval: const Duration(milliseconds: 1500),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              enableInfiniteScroll: true,
              enlargeCenterPage: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              onPageChanged: (index, reason) {
                // Handle page change if needed
              },
            ),
            items: imageWidgets,
          ),
        )
    )
        :
    const SizedBox();
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
            itemCount: postIdList.length,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index){
              if(index==0){
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AdvertiseAnotherUserPageFullView(
                          postID: postIdList[index],
                        )));
                  },
                  child: (postIsVipList[index])? advertiseVip(width,
                      postImagePathList[index], postTitleList[index],postDescriptionList[index], postMetroNameList[index], height,
                      (postImagePathList[index] == "http://sino0on.ru/media/avatars/df/Zherdesh%20logo-03.png")? true: false)
                      : advertiseCommon(width, postImagePathList[index],
                      postIsColoredList[index],postTitleList[index],postDescriptionList[index], postMetroNameList[index],height,
                      (postImagePathList[index] == "http://sino0on.ru/media/avatars/df/Zherdesh%20logo-03.png")? true: false),
                );
              }
              else{
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AdvertiseAnotherUserPageFullView(
                          postID: postIdList[index],
                        )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: (postIsVipList[index])? advertiseVip(width,
                        postImagePathList[index], postTitleList[index],postDescriptionList[index], postMetroNameList[index], height,
                        (postImagePathList[index] == "http://sino0on.ru/media/avatars/df/Zherdesh%20logo-03.png")? true: false)
                        : advertiseCommon(width, postImagePathList[index],
                        postIsColoredList[index],postTitleList[index],postDescriptionList[index], postMetroNameList[index],height,
                        (postImagePathList[index] == "http://sino0on.ru/media/avatars/df/Zherdesh%20logo-03.png")? true: false),
                  ),
                );
              }
            }
        )
    );
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //todo => localize data =>
    if(globals.userLanguage!="ru"){setDataKyrgyz();}

    if(globals.userLanguage=="ru"){setDataRussian();}
    getHomePageData();

    // Add a listener to the scroll controller to detect when the user reaches the end
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
        pageNumber ++;
        loadMoreAdvertises();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomNavBarHeight = kBottomNavigationBarHeight;
    double mainSizedBoxHeightUserNotLogged = height - bottomNavBarHeight - statusBarHeight;

    double heightCategoryImage = mainSizedBoxHeightUserNotLogged*0.05;
    double textSize = 16;
    double cardHeight = heightCategoryImage  + textSize*1.5;

    double storiesHeight = mainSizedBoxHeightUserNotLogged* 0.125;

    return (dataGet)? Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Container(
          width: width,
          height: mainSizedBoxHeightUserNotLogged,
          color: const Color.fromRGBO(250, 250, 250, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              //search
              Padding(
                padding: EdgeInsets.only(left: width*0.025 , right: width*0.025),
                child: Container(
                  width: width*0.95,
                  color: const Color.fromRGBO(250, 250, 250, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SearchPage()),
                          );
                        },
                        child: Container(
                          width: width*0.95-40,
                          height: mainSizedBoxHeightUserNotLogged*0.06,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            border: Border.all(
                              color: const Color.fromRGBO(234, 234, 234, 1),
                              width: 1.0, // Adjust the width as needed
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 15,),
                              const FaIcon(FontAwesomeIcons.magnifyingGlass , size: 18, color: Color.fromRGBO(120, 120, 120, 1),),
                              const SizedBox(width: 10,),
                              SizedBox(
                                  width: width*0.95-110,
                                  child: Text(
                                      searchText,
                                      style: const TextStyle(fontSize: 16 , color: Color.fromRGBO(120, 120, 120, 1)))
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SearchSettingsPage()),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: SizedBox(
                            width: 20,
                            child: FaIcon(FontAwesomeIcons.sliders , size: 20, color: Colors.black,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // making others to scroll =>
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.025),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.all(0),
                        controller: _scrollController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Stories
                            const SizedBox(height: 10,),
                            Padding(
                                padding: EdgeInsets.only(left: width*0.05, right: width*0.035),
                                child: (anyRecordsStories)?
                                SizedBox(height: storiesHeight,
                                  width: width*2,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: listStories.length,
                                    padding: const EdgeInsets.all(0),
                                    itemBuilder: (BuildContext context, int index){
                                      String text = listStories[index].title;
                                      String imagePath = listStories[index].storiesAvatarUrl;
                                      //first
                                      if(index==0){
                                        return GestureDetector(
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (BuildContext context) => StoryScreen(
                                                  stories: listStories[index].storyList,
                                                  imagePath: listStories[index].storiesAvatarUrl,
                                                  title: listStories[index].title,
                                                )
                                            )
                                            );
                                          },
                                          child: SizedBox(
                                            width: storiesHeight-21,
                                            height: storiesHeight-21,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: storiesHeight-21,
                                                  height: storiesHeight-21,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(251, 133, 0, 1),
                                                        Color.fromRGBO(255, 183, 3, 1),
                                                        Color.fromRGBO(142, 202, 230, 1),
                                                        Color.fromRGBO(3, 158, 188, 1)
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                      stops: [0.0, 0.33, 0.66, 1.0], // Adjust stops for each color
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(3),
                                                    child: Container(
                                                      width: storiesHeight-27,
                                                      height: storiesHeight-27,
                                                      decoration: const BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(2.5),
                                                        child: Container(
                                                          width: storiesHeight-32,
                                                          height: storiesHeight-32,
                                                          decoration: const BoxDecoration(
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: CachedNetworkImage(
                                                            placeholder: (context, url) => Center(
                                                              child: Container(
                                                                decoration: const BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: Colors.white
                                                                ),
                                                              ),
                                                            ),
                                                            imageUrl: imagePath,
                                                            imageBuilder: (context, imageProvider){
                                                              return Container(
                                                                width: storiesHeight-32,
                                                                height: storiesHeight-32,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    image: DecorationImage(
                                                                      image: imageProvider,
                                                                      fit: BoxFit.cover,
                                                                    )
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 21,
                                                  child: Text(
                                                      text,
                                                      style: const TextStyle(fontSize: 14 , color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      //others
                                      else{
                                        return Padding(
                                            padding: const EdgeInsets.only(left: 15),
                                            child: GestureDetector(
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (BuildContext context) => StoryScreen(
                                                      stories: listStories[index].storyList,
                                                      imagePath: listStories[index].storiesAvatarUrl,
                                                      title: listStories[index].title,
                                                    )
                                                )
                                                );
                                              },
                                              child: SizedBox(
                                                width: storiesHeight-21,
                                                height: storiesHeight-21,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: storiesHeight-21,
                                                      height: storiesHeight-21,
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Color.fromRGBO(251, 133, 0, 1),
                                                            Color.fromRGBO(255, 183, 3, 1),
                                                            Color.fromRGBO(142, 202, 230, 1),
                                                            Color.fromRGBO(3, 158, 188, 1)
                                                          ],
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                          stops: [0.0, 0.33, 0.66, 1.0], // Adjust stops for each color
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(3),
                                                        child: Container(
                                                          width: storiesHeight-27,
                                                          height: storiesHeight-27,
                                                          decoration: const BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.white
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2.5),
                                                            child: Container(
                                                              width: storiesHeight-32,
                                                              height: storiesHeight-32,
                                                              decoration: const BoxDecoration(
                                                                shape: BoxShape.circle,
                                                              ),
                                                              child: CachedNetworkImage(
                                                                placeholder: (context, url) => Center(
                                                                  child: Container(
                                                                    decoration: const BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: Colors.white
                                                                    ),
                                                                  ),
                                                                ),
                                                                imageUrl: imagePath,
                                                                imageBuilder: (context, imageProvider){
                                                                  return Container(
                                                                    width: storiesHeight-32,
                                                                    height: storiesHeight-32,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        image: DecorationImage(
                                                                          image: imageProvider,
                                                                          fit: BoxFit.cover,
                                                                        )
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 21,
                                                      child: Text(
                                                          text,
                                                          style: const TextStyle(fontSize: 14 , color: Color.fromRGBO(30, 29, 33, 1),fontWeight: FontWeight.w500)
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                        );
                                      }
                                    },
                                  ),
                                ) : const SizedBox()
                            ),
                            //Categories
                            const SizedBox(height: 5,),
                            Padding(
                                padding: EdgeInsets.only(left: width*0.025, right: width*0.025),
                                child: SizedBox(
                                  height: 2*cardHeight+100,
                                  width: width,
                                  child: ListView.builder(
                                      itemCount: 2,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(0),
                                      itemBuilder: (BuildContext context , int index){
                                        if(index == 0){
                                          return SizedBox(
                                            height: 2*cardHeight+100,
                                            child: GridView.builder(
                                              padding: const EdgeInsets.all(0),
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 15.0,
                                              ),
                                              itemCount: categoriesHomePageTitle.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                if(index%2==0){
                                                  return GestureDetector(
                                                    onTap: (){
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (BuildContext context) => SearchCategoryPage(
                                                            categoryId: categoriesHomePageId[index],
                                                            categoryName: categoriesHomePageTitle[index],
                                                          )
                                                      )
                                                      );
                                                    },
                                                    child: SizedBox(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            height: cardHeight,
                                                            decoration: BoxDecoration(
                                                                color: Colors.transparent,
                                                                border: Border.all(
                                                                  color: const Color.fromRGBO(234, 234, 234, 1),
                                                                  width: 1.0, // Adjust the width as needed
                                                                ),
                                                                borderRadius: BorderRadius.circular(10),
                                                                image: DecorationImage(
                                                                    image: assetImagesHome[index],
                                                                    fit: BoxFit.cover,
                                                                    alignment: Alignment.center
                                                                )
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 40,
                                                            child: Text(
                                                                categoriesHomePageTitle[index],textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,
                                                                style: const TextStyle(
                                                                    fontSize: 12 , color: Color.fromRGBO(31, 29, 33, 1),fontWeight: FontWeight.w500
                                                                )
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                                else if(index%2!=0){
                                                  return GestureDetector(
                                                    onTap: (){
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (BuildContext context) => SearchCategoryPage(
                                                            categoryId: categoriesHomePageId[index],
                                                            categoryName: categoriesHomePageTitle[index],
                                                          )
                                                      )
                                                      );
                                                    },
                                                    child: SizedBox(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            height: cardHeight,
                                                            decoration: BoxDecoration(
                                                                color: Colors.transparent,
                                                                border: Border.all(
                                                                  color: const Color.fromRGBO(234, 234, 234, 1),
                                                                  width: 1.0, // Adjust the width as needed
                                                                ),
                                                                borderRadius: BorderRadius.circular(10),
                                                                image: DecorationImage(
                                                                    image: assetImagesHome[index],
                                                                    fit: BoxFit.cover,
                                                                    alignment: Alignment.center
                                                                )
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 40,
                                                            child: Text(
                                                                categoriesHomePageTitle[index],textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,
                                                                style: const TextStyle(
                                                                    fontSize: 12 , color: Color.fromRGBO(31, 29, 33, 1),fontWeight: FontWeight.w500
                                                                )
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return null;
                                              },
                                            ),
                                          );
                                        }
                                        else{
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 15),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const CategoriesPage()),
                                                );
                                              },
                                              child: SizedBox(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 85,
                                                      width: 85,
                                                      decoration: BoxDecoration(
                                                        color: const Color.fromRGBO(142, 202, 230, 1),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: const Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Icon(Icons.circle , color: Color.fromRGBO(30, 29, 33, 1),),
                                                              Icon(Icons.circle , color: Color.fromRGBO(30, 29, 33, 1),)
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Icon(Icons.circle , color: Color.fromRGBO(30, 29, 33, 1),),
                                                              Icon(Icons.circle , color: Color.fromRGBO(30, 29, 33, 1),)
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const Text(
                                                        "Категории", textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12 , color: Color.fromRGBO(31, 29, 33, 1),fontWeight: FontWeight.w500
                                                        )
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                  ),
                                )
                            ),

                            //banners
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: width*0.025),
                              child: showBannerNewImages(width, height),
                            ),
                            //Last advertises word
                            const SizedBox(height: 5,),
                            Padding(
                                padding: EdgeInsets.only(left: width*0.025, right: width*0.025),
                                child: SizedBox(height: 30 , child: Text(lastAdvertises ,
                                  style: const TextStyle(fontSize: 18, color: Colors.black , fontWeight: FontWeight.w400),),
                                )
                            ),
                            //Last advertises
                            SizedBox(
                              width: width*0.95,
                              child: userAdvertiseListChild(width, mainSizedBoxHeightUserNotLogged, context),
                            ),
                            const SizedBox(height: 10,),
                            (isLoading)? const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ) : const SizedBox(),
                          ],
                        ),
                      )
              ))
            ],
          )
        ),
      )
    ): loadingData(width, height);
  }
}

//todo : Story view =>
class StoryScreen extends StatefulWidget{
  final List<Story> stories;
  final String imagePath;
  final String title;
  const StoryScreen({super.key, required this.stories , required this.title , required this.imagePath});

  @override
  StoryScreenState createState ()=> StoryScreenState();
}

class StoryScreenState extends State<StoryScreen> with SingleTickerProviderStateMixin{
  late PageController _pageController;
  late VideoPlayerController _videoPlayerController;
  late AnimationController animationController;
  int currentIndex = 0;

  @override
  void initState(){
    super.initState();
    _pageController = PageController();
    animationController = AnimationController(vsync: this);

    final Story firstStory = widget.stories.first;
    _loadStory(story: firstStory, animateToPage: false);

    animationController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        animationController.stop();
        animationController.reset();
        setState(() {
          if(currentIndex + 1 < widget.stories.length){
            currentIndex += 1;
            _loadStory(story: widget.stories[currentIndex]);
          }
          else{
            currentIndex = 0;
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    animationController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Story storyAnother  = widget.stories[currentIndex];
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 29, 33, 1),
      body: SafeArea(
          child: GestureDetector(
        onTapDown: (details) => _onTapDown(details, storyAnother),
        child: Stack(
          children: [
            PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.stories.length,
                itemBuilder: (context, i){
                  final Story story  = widget.stories[i];
                  switch(story.mediaType){
                    case MediaType.image:
                      return CachedNetworkImage(
                        progressIndicatorBuilder: (context, url, downloadProgress){
                          return Center(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(value: downloadProgress.progress, strokeWidth: 2,),
                            ),
                          );
                        },
                        imageUrl: story.fileUrl , fit: BoxFit.cover,
                      );
                    case MediaType.video:
                      if(_videoPlayerController!=null && _videoPlayerController.value.isInitialized){
                        return FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _videoPlayerController.value.size.width,
                            height: _videoPlayerController.value.size.height,
                            child: VideoPlayer(_videoPlayerController),
                          ),
                        );
                      }
                      else{
                        return FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _videoPlayerController.value.size.width,
                            height: _videoPlayerController.value.size.height,
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      }
                  }
                  return const SizedBox.shrink();
                }
            ),
            Positioned(
              top: 5.0,
              left: 10.0,
              right: 10.0,
              child: Column(
                children: <Widget>[
                  Row(
                    children: widget.stories
                        .asMap()
                        .map((i, e) {
                      return MapEntry(
                        i,
                        AnimatedBar(
                          animController: animationController,
                          position: i,
                          currentIndex: currentIndex,
                        ),
                      );
                    })
                        .values
                        .toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1.5,
                      vertical: 10.0,
                    ),
                    child: UserInfo(imagePath: widget.imagePath , title: widget.title,),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
      ),
    );
  }


  void _onTapDown(TapDownDetails details,Story story){
    final double screenWidth = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;
    if(dx < screenWidth/3){
      setState(() {
        if(currentIndex-1 >= 0){
          currentIndex -= 1;
          _loadStory(story: widget.stories[currentIndex]);
        }
      });
    }
    else if(dx > 2*screenWidth/3){
        setState(() {
          if(currentIndex + 1< widget.stories.length){
            currentIndex += 1;
            _loadStory(story: widget.stories[currentIndex]);
          }
          else{
            currentIndex = 0;
            _loadStory(story: widget.stories[currentIndex]);
          }
        });
    }
    else{
      if(story.mediaType == MediaType.video){
        if(_videoPlayerController.value.isPlaying){
          _videoPlayerController.pause();
          animationController.stop();
        }
        else{
          _videoPlayerController.play();
          animationController.forward();
        }
      }
    }
  }

  void _loadStory({required Story story, bool animateToPage = true}){
      animationController.stop();
      animationController.reset();
      switch (story.mediaType) {
        case MediaType.image:
          animationController.duration = story.duration;
          animationController.forward();
          break;
        case MediaType.video:
          _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(Uri.encodeFull(story.fileUrl)))
            ..initialize().then((_) {
              setState(() {});
              if (_videoPlayerController.value.isInitialized) {
                animationController.duration = _videoPlayerController.value.duration;
                _videoPlayerController.play();
                animationController.forward();
              }
            });
          break;
      }
      if (animateToPage) {
        _pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeInOut,
        );
      }
  }

}

class AnimatedBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBar({super.key, required this.animController , required this.position, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                  animation: animController,
                  builder: (context, child) {
                    return _buildContainer(
                      constraints.maxWidth * animController.value,
                      Colors.white,
                    );
                  },
                )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final String imagePath;
  final String title;

  const UserInfo({super.key, required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.grey[300],
          backgroundImage: CachedNetworkImageProvider(
            imagePath,
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.close,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}