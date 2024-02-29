import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:zherdeshmobileapplication/Search/search_category_settings.dart';
import '../Advertise/advertise_another_page.dart';
import '../HomeFiles/home_screen.dart';


class Banner{
  final String imagePath;
  final String bannerUrl;

  const Banner({
    required this.imagePath,
    required this.bannerUrl,
  });
}

class SearchResultPage extends StatefulWidget {
  final String searchData;
  const SearchResultPage({super.key , required this.searchData});

  @override
  State<SearchResultPage> createState() => SearchResultPageState();
}

class SearchResultPageState extends State<SearchResultPage> {

  bool dataGet = false;
  bool anyBanner = false;
  bool anyAdvertise = false;
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

  int pageNumber = 1;
  String failureToFetchAdvertises = "";

  String showMessageTitle = "";
  String showMessageDescription = "";

  //search Category Settings =>
  List<int> searchSubcategoriesIndex = [];

  String results = "";

  void setDataKyrgyz(){
    failureToFetchAdvertises = "Жаңы жарнамаларды \nжүктөө мүмкүн эмес";
    showMessageTitle = "Жарыя табылган жок";
    showMessageDescription = "Эмне туура эмес болуп кетти...\nбиз жарнамаларды таба алган жокпуз...";
    results = "Үчүн жыйынтыктар ";
  }

  void setDataRussian(){
    failureToFetchAdvertises = "Не удалось загрузить\nновые объявления";
    showMessageTitle = "Не найдено объявлений";
    showMessageDescription = "Что то пошло не так...\nМы не смогли найти объявлений...";
    results = "Результаты для ";
  }


  Future<void> getBannersCategoryPage() async{
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

  Future<void> getSearchResultAdvertises() async {
    final dio = Dio();
    dio.options.headers['Accept-Language'] = globals.userLanguage;


    try{
      if(globals.chosenValue.isEmpty){
        //todo :=> if user not choose any sub categories :
        if(globals.chosenMetro.isEmpty){
          //todo : => if user isn't choose any metro station :
          final respose = await dio.get("${globals.endpointGetCategoriesAdvertises}?limit=${globals.countNumberOfAdvertises}&page=$pageNumber&title=${widget.searchData}");
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
        else{
          //todo : => if user choose metro station :
          final respose = await dio.get("${globals.endpointGetCategoriesAdvertises}?limit=${globals.countNumberOfAdvertises}&metro=${globals.chosenMetroIndex}&page=$pageNumber&title=${widget.searchData}");
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
      }
      else{
        //todo :=> if user is choose sub categories:
        //we need to convert our data from globals to String =>
        String dataConvertFromList = "";
        for(var item in globals.chosenValueIndex){
          if(dataConvertFromList.isEmpty){
            dataConvertFromList += "$item";
          }
          else{
            dataConvertFromList += ",$item";
          }
        }

        if(globals.chosenMetro.isEmpty){
          //todo : => if user isn't choose any metro station :
          final respose = await dio.get("${globals.endpointGetCategoriesAdvertises}?limit=${globals.countNumberOfAdvertises}&page=$pageNumber&subcategories=$dataConvertFromList&title=${widget.searchData}");
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
        else{
          //todo : => if user choose metro station :
          final respose = await dio.get("${globals.endpointGetCategoriesAdvertises}?limit=${globals.countNumberOfAdvertises}&metro=${globals.chosenMetroIndex}&page=$pageNumber&subcategories=$dataConvertFromList&title=${widget.searchData}");
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
      getSearchResultAdvertises();
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> getStoryPageData() async{
    print("GET DATA STORY PAGE");
    await getBannersCategoryPage();
    await getSearchResultAdvertises();
    if(mounted){
      setState(() {
        dataGet = true;
        if(listBanner.isNotEmpty){
          anyBanner = true;
        }
        if(postIdList.isNotEmpty){
          anyAdvertise = true;
        }
      });
    }
  }

  Widget loadingData(){
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 2,),
    );
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
    return (anyBanner)?
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




  Widget categoryPageData(width, height, context){
    return SizedBox(
        width: width*0.95,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(0),
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Target =>
              (widget.searchData.isNotEmpty)? SizedBox(
                width: width*0.95,
                height: 35 ,
                child: Text("$results${widget.searchData}" , overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 24, color: Colors.black , fontWeight: FontWeight.w600),),
              ) : const SizedBox(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width*0.025),
                child: showBannerNewImages(width, height),
              ),
              (anyBanner)? const SizedBox(height: 10,) : const SizedBox(),
              //Category advertises
              (anyAdvertise)? SizedBox(
                child: Column(
                  children: [
                    SizedBox(
                      width: width*0.95,
                      child: userAdvertiseListChild(width, height, context),
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
                  :
              SizedBox(
                  height: height*0.75 - 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: width*0.75, height: height*0.7 - 120,
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
                  )
              )
            ],
          ),
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
    if(globals.userLanguage!="ru"){setDataKyrgyz();}
    if(globals.userLanguage=="ru"){setDataRussian();}
    getStoryPageData();

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
    double mainSizedBoxHeightUserNotLogged = height- statusBarHeight;


    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pop();
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
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.close, color: Color.fromRGBO(30, 29, 33, 1), size: 30,),
                                ),
                              ),
                            ],
                          ),
                        ),


                        Padding(padding: const EdgeInsets.only(top: 15),
                          child: SizedBox(
                            width: width*0.95,
                            height: mainSizedBoxHeightUserNotLogged-55,
                            child: (dataGet)? categoryPageData(width, mainSizedBoxHeightUserNotLogged, context) : loadingData(),
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
