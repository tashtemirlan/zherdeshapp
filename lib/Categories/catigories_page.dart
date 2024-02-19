
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;

import '../HomeFiles/home_screen.dart';
import '../Search/search_category.dart';

class Category {
  final int id;
  final String title;
  final List<Subcategory> subcategories;

  Category({
    required this.id,
    required this.title,
    required this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    List<Subcategory> subcategoriesList = List<Subcategory>.from(json['subcategories'].map((subcategory) => Subcategory.fromJson(subcategory)));

    return Category(
      id: json['id'],
      title: json['title'],
      subcategories: subcategoriesList,
    );
  }
}

class Subcategory {
  final int id;
  final String title;

  Subcategory({
    required this.id,
    required this.title,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'],
      title: json['title'],
    );
  }
}

List<Category> parseCategories(String jsonString) {
  final parsed = jsonDecode(jsonString);
  return List<Category>.from(parsed['result'].map((category) => Category.fromJson(category)));
}

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();

}

class _CategoriesPageState extends State<CategoriesPage> {

  bool dataGet = false;
  bool recordsGranted = false;
  String noAnyDataOrInternet = "";
  List<String> categoriesStringDataLine1 = [];
  List<int> categoriesIndexLine1 = [];

  List<String> categoriesStringDataLine2 = [];
  List<int> categoriesIndexLine2 = [];

  List<String> categoriesStringDataLine3 = [];
  List<int> categoriesIndexLine3 = [];

  List<String> categoriesStringDataLine4 = [];
  List<int> categoriesIndexLine4 = [];

  List<String> categoriesStringDataLine5 = [];
  List<int> categoriesIndexLine5 = [];

  List<String> categoriesStringDataLine6 = [];
  List<int> categoriesIndexLine6 = [];

  List<String> categoriesStringDataLine7 = [];
  List<int> categoriesIndexLine7 = [];

  String title = "";
  void setDataKyrgyz(){

  }
  void setDataRussian(){
      title = "Категории";
      noAnyDataOrInternet = "Что то пошло не так...\nНет интернета или у нас проблемы...";
  }


  Future<void> getCategories() async{
    final dio = Dio();

    //set Dio response =>
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    try{
      //todo => send data to server : =>
      final respose = await dio.get(globals.endpointGetCategories);
      if(respose.statusCode == 200){
        String dataToParse = respose.toString();
        List<Category> categories = parseCategories(dataToParse);

        categories.forEach((category) {
          if(category.title=="Авто" || category.title=="Товары из КР" || category.title=="Услуги"){
            categoriesStringDataLine1.add(category.title);
            categoriesIndexLine1.add(category.id);
          }
          if(category.title=="Недвижимость" || category.title=="Работа" || category.title=="Электроника"){
            categoriesStringDataLine2.add(category.title);
            categoriesIndexLine2.add(category.id);
          }
          if(category.title=="Одежда" || category.title=="Гостиницы" || category.title=="Детские вещи"){
            categoriesStringDataLine3.add(category.title);
            categoriesIndexLine3.add(category.id);
          }
          if(category.title=="Продукты" || category.title=="Бытовая техника" || category.title=="Красота и здоровье"){
            categoriesStringDataLine4.add(category.title);
            categoriesIndexLine4.add(category.id);
          }
          if(category.title=="Авиабилеты" || category.title=="Автотовары" || category.title=="Книги и журналы"){
            categoriesStringDataLine5.add(category.title);
            categoriesIndexLine5.add(category.id);
          }
          if(category.title=="Мебель" || category.title=="Спорттовары" || category.title=="Для бизнеса"){
            categoriesStringDataLine6.add(category.title);
            categoriesIndexLine6.add(category.id);
          }
          if(category.title=="Аксессуары" || category.title=="Разное"){
            categoriesStringDataLine7.add(category.title);
            categoriesIndexLine7.add(category.id);
          }
        });

        setState(() {
          dataGet = true;
          recordsGranted = true;
        });
      }
    }
    catch(error){
      if(error is DioException){
        if (error.response != null) {
          String toParseData = error.response.toString();
          print("Error $toParseData");
        }
      }
    }
    //even if we get error on catching data we should show it =>
    setState(() {
      dataGet = true;
    });
  }

  Widget loadingData(){
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget rowCategoryDataLine1 (width , height ,
      String title1, String title2 , String title3,
      Color background1 , Color background2 , Color background3,
      AssetImage assetImage1, AssetImage assetImage2, AssetImage assetImage3,
      double paddingTop , Color textCol1 , Color textCol2 , Color textCol3,
      double textSize1 , double textSize2 , double textSize3,
      int index1 , int index2 , int index3
      ){
    double heightCategoryImage = height/7;
    double textSize = 14;
    double cardHeight = heightCategoryImage + 20 + textSize*3;
    double cardWidth = width*0.3;
    double imageCardWidth = cardWidth * 0.85;
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: SizedBox(
      width: width,
      height: cardHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SearchCategoryPage(
                    categoryId: index1,
                    categoryName: title1,
                  )
              )
              );
            },
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                  color: background1
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10,  left: 20, right: 20),
                    child: Text(
                        title1, textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: textSize1, color: textCol1, fontWeight: FontWeight.w500
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: imageCardWidth, height: heightCategoryImage,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30)),
                          image: DecorationImage(
                              image: assetImage1,
                              fit: BoxFit.cover,
                              alignment: Alignment.centerLeft
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SearchCategoryPage(
                    categoryId: index2,
                    categoryName: title2,
                  )
              )
              );
            },
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                  color: background2
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10,  left: 20 , right: 20),
                    child: Text(
                        title2, textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: textSize2, color: textCol2, fontWeight: FontWeight.w500
                        )),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: imageCardWidth, height: heightCategoryImage,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30)),
                            image: DecorationImage(
                                image: assetImage2,
                                fit: BoxFit.cover,
                                alignment: Alignment.centerLeft
                            )
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SearchCategoryPage(
                    categoryId: index3,
                    categoryName: title3,
                  )
              )
              );
            },
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                  color: background3
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10,  left: 20 , right: 20),
                    child: Text(
                        title3, textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: textSize3, color: textCol1, fontWeight: FontWeight.w500
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: imageCardWidth, height: heightCategoryImage,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30)),
                          image: DecorationImage(
                              image: assetImage3,
                              fit: BoxFit.cover,
                              alignment: Alignment.centerLeft
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget rowCategoryDataLineEnd (width , height ,
      String title1, String title2 ,
      Color background1 , Color background2 ,
      AssetImage assetImage1, AssetImage assetImage2,
      double paddingTop , Color textCol1 , Color textCol2 ,
      double textSize1 , double textSize2 ,
      int index1 , int index2
      ){
    double heightCategoryImage = height/7;
    double textSize = 14;
    double cardHeight = heightCategoryImage + 20 + textSize*3;
    double cardWidth = width*0.3;
    double imageCardWidth = cardWidth * 0.85;
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: SizedBox(
        width: width,
        height: cardHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SearchCategoryPage(
                      categoryId: index1,
                      categoryName: title1,
                    )
                )
                );
              },
              child: Container(
                width: cardWidth,
                height: cardHeight,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                    color: background1
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10,  left: 20, right: 20),
                      child: Text(
                          title1, textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: textSize1, color: textCol1, fontWeight: FontWeight.w500
                          )),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: imageCardWidth, height: heightCategoryImage,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30)),
                            image: DecorationImage(
                                image: assetImage1,
                                fit: BoxFit.cover,
                                alignment: Alignment.centerLeft
                            )
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SearchCategoryPage(
                      categoryId: index2,
                      categoryName: title2,
                    )
                )
                );
              },
              child: Container(
                width: cardWidth,
                height: cardHeight,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                    color: background2
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10,  left: 20 , right: 20),
                      child: Text(
                          title2, textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: textSize2, color: textCol2, fontWeight: FontWeight.w500
                          )),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: imageCardWidth, height: heightCategoryImage,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30)),
                              image: DecorationImage(
                                  image: assetImage2,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.centerLeft
                              )
                          ),
                        )
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: cardWidth,
              height: cardHeight,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                  color: Color.fromRGBO(250, 250, 250, 1)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryPage(width, height, context){
    Color blueOne = const Color.fromRGBO(142, 202, 230, 1);
    Color blueTwo = const Color.fromRGBO(33, 158, 188, 1);
    Color orangeOne = const Color.fromRGBO(255, 183, 3, 1);
    Color orangeTwo = const Color.fromRGBO(251, 133, 0, 1);
    Color textType1 = const Color.fromRGBO(30, 29, 33, 1);
    Color textType2 = Colors.white;
    return (recordsGranted)?SizedBox(
        width: width,
        height: height-50,
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                rowCategoryDataLine1(width, height,
                categoriesStringDataLine1[0],
                categoriesStringDataLine1[2],
                categoriesStringDataLine1[1],
                blueOne, blueTwo, blueOne,
                const AssetImage('assets/images/auto.png'),
                const AssetImage('assets/images/services.png'),
                const AssetImage('assets/images/mekenim.png'),
                0, textType1, textType2, textType1,
                14, 14, 14,
                categoriesIndexLine1[0],
                categoriesIndexLine1[2],
                categoriesIndexLine1[1],
                ),
                rowCategoryDataLine1(width, height,
                    categoriesStringDataLine2[0],
                    categoriesStringDataLine2[1],
                    categoriesStringDataLine2[2],
                    blueTwo,
                    blueOne,
                    blueTwo,
                    const AssetImage('assets/images/realEstate.png'),
                    const AssetImage('assets/images/work.png'),
                    const AssetImage('assets/images/electronics.png'),
                    10,
                    textType2,
                    textType1,
                    textType2,
                    9,14,9,
                    categoriesIndexLine2[0],
                    categoriesIndexLine2[1],
                    categoriesIndexLine2[2],
                ),
                rowCategoryDataLine1(width, height,
                    categoriesStringDataLine3[1],
                    categoriesStringDataLine3[0],
                    categoriesStringDataLine3[2],
                    orangeOne,
                    orangeTwo,
                    orangeOne,
                    const AssetImage('assets/images/hostek.png'),
                    const AssetImage('assets/images/clothes.png'),
                    const AssetImage('assets/images/childClothes.png'),
                    10,
                    textType1,
                    textType2,
                    textType1,
                    14,14,14,
                    categoriesIndexLine3[1],
                    categoriesIndexLine3[0],
                    categoriesIndexLine3[2],
                ),
                rowCategoryDataLine1(width, height,
                    categoriesStringDataLine4[1],
                    categoriesStringDataLine4[2],
                    categoriesStringDataLine4[0],
                    orangeTwo,
                    orangeOne,
                    orangeTwo,
                    const AssetImage('assets/images/goods.png'),
                    const AssetImage('assets/images/beauty.png'),
                    const AssetImage('assets/images/Appliances.png'),
                    10,
                    textType2,
                    textType1,
                    textType2,
                    14,14,14,
                    categoriesIndexLine4[1],
                    categoriesIndexLine4[2],
                    categoriesIndexLine4[0],
                ),
                rowCategoryDataLine1(width, height,
                    categoriesStringDataLine5[2],
                    categoriesStringDataLine5[0],
                    categoriesStringDataLine5[1],
                    blueOne,
                    blueTwo,
                    blueOne,
                    const AssetImage('assets/images/books.png'),
                    const AssetImage('assets/images/autoGoods.png'),
                    const AssetImage('assets/images/airplane.png'),
                    10,
                    textType1,
                    textType2,
                    textType1,
                    12,
                    12,
                    12,
                    categoriesIndexLine5[2],
                    categoriesIndexLine5[0],
                    categoriesIndexLine5[1],
                ),
                rowCategoryDataLine1(width, height,
                    categoriesStringDataLine6[0],
                    categoriesStringDataLine6[1],
                    categoriesStringDataLine6[2],
                    blueTwo,
                    blueOne,
                    blueTwo,
                    const AssetImage('assets/images/furniture.png'),
                    const AssetImage('assets/images/sportGoods.png'),
                    const AssetImage('assets/images/forBisness.png'),
                    10,
                    textType2,
                    textType1,
                    textType2,
                    14,9,14,
                    categoriesIndexLine6[0],
                    categoriesIndexLine6[1],
                    categoriesIndexLine6[2],
                ),
                rowCategoryDataLineEnd(width, height,
                  categoriesStringDataLine7[1],
                  categoriesStringDataLine7[0],
                  orangeTwo,
                  orangeOne,
                  const AssetImage('assets/images/accessories.png'),
                  const AssetImage('assets/images/others.png'),
                  10,
                  textType2,
                  textType1,
                  14,14,
                  categoriesIndexLine7[1],
                  categoriesIndexLine7[0],
                ),
              ],
            ),
        )
    )
        :SizedBox(
        width: width,
        height: height-50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(noAnyDataOrInternet, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),)
          ],
        )
    ) ;
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
    getCategories();
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
            builder: (BuildContext context) => const HomeScreen(positionBottomNavigationBar: 0)));
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
                  width: width,
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
                                      builder: (BuildContext context) => const HomeScreen(positionBottomNavigationBar: 0)));
                                },
                                icon: const Icon(Icons.close, color: Colors.black, size: 30,),
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
                      Padding(padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          width: width,
                          height: mainSizedBoxHeightUserNotLogged-50,
                          child: (dataGet)? categoryPage(width, mainSizedBoxHeightUserNotLogged, context) : loadingData(),
                        ),
                      )
                    ],
                  ),
                )
            ),
          )
      ),
    );
  }
}
