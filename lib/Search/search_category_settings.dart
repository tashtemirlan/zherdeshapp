import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zherdeshmobileapplication/Search/search_category.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;

class SearchCategorySettingsPage extends StatefulWidget {
  final int categoryIndex;
  final String categoryName;
  const SearchCategorySettingsPage({super.key , required this.categoryIndex ,required this.categoryName});

  @override
  State<SearchCategorySettingsPage> createState() => SearchCategorySettingsPageState();
}

class SearchCategorySettingsPageState extends State<SearchCategorySettingsPage> {

  String title = "";
  bool dataGet = false;

  String subCategoryDefault = "";
  String submit = "";


  //here we need to work properly with data =>
  List<String> allSubCategories = [];
  List<int> allSubCategoriesIndex = [];
  List<String> chooseSubCategories = [];
  List<int> chooseSubCategoriesIndex = [];
  bool isGetAllSubCategories = false;
  List<String> storedChooseSubCategoriesTitle = [];


  void setDataKyrgyz(){
    title = "Чыпкалар";
    subCategoryDefault = "Субкатегориялар";
    submit = "Колдонуу";
  }

  void setDataRussian(){
    title = "Фильтры";
    subCategoryDefault = "Подкатегории";
    submit = "Применить";
  }

  Widget loadingData(){
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 2,),
    );
  }

  Future<void> getSubcategories() async{
    print("Get subcategories");
    final dio = Dio();
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    try{
      //todo => send data to server : =>
      final respose = await dio.get("${globals.endpointGetCategoriesAdvertisesSettings}?id=${widget.categoryIndex}");
      if(respose.statusCode == 200){
        String dataToParse = respose.toString();
        Map<String, dynamic> jsonData = json.decode(dataToParse);
        List<dynamic> result = jsonData['result'];
        for (var item in result) {
          List<dynamic> subcategories = item['subcategories'];
          for (var subcategory in subcategories) {
            String titleSubCategory = subcategory['title'];
            int indexSubCategory = subcategory['id'];
            allSubCategories.add(titleSubCategory);
            allSubCategoriesIndex.add(indexSubCategory);
          }
        }
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
  }



  Future<void> getDataCategory() async{
    //work with Hive =>
    var box = await Hive.openBox("categorySearch");
    isGetAllSubCategories = box.containsKey("selectedSubCategoriesIndex");
    if(isGetAllSubCategories){
      //if we set search settings before
      print("Working with already haven data");
      storedChooseSubCategoriesTitle = box.get("selectedSubCategoriesTitle");
    }
    else{
      //if we don't set search settings before
      print("Firstly here");
    }


  }

  Future<void> getData() async{
    await getDataCategory();
    await getSubcategories();
    setState(() {
      dataGet = true;

    });
  }


  Widget showSubCategory(width , height){
    chooseSubCategories = storedChooseSubCategoriesTitle;
    return Wrap(
      spacing: 8.0,
      runSpacing: 5.0,
      alignment: WrapAlignment.start,
      children: allSubCategories.map((label) {
        bool touched = false;
        if(chooseSubCategories.contains(label)){
          touched = true;
        }
        return ElevatedButton(
          onPressed: () {
            if(touched){
              chooseSubCategories.remove(label);
              print("Sub categories to choose : $allSubCategories");
              print("Choosen value Inside Search settings : $chooseSubCategories");
            }
            else{
              chooseSubCategories.add(label);
              print("Sub categories to choose : $allSubCategories");
              print("Choosen value Inside Search settings : $chooseSubCategories");
            }
            print("Sub categories to choose: $allSubCategories");
            print("Chosen value Inside Search settings: $chooseSubCategories");
            setState(() {

            });
          },
          style: (touched)?
          ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Border radius
              side: const BorderSide(
                color: Color.fromRGBO(77, 170, 232, 1), // Border color
                width: 2.0, // Border width
              ),
            ),
          ) :
          ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(249, 249, 249, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Text(label, style: TextStyle(fontSize: 12 , color: (touched)? const Color.fromRGBO(77, 170, 232, 1) : const Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500),),
        );
      }).toList(),
    );
  }

  Widget filterSearch(width , height){
    return SizedBox(
      width: width*0.95,
      height:  height,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            SizedBox(
              width: width*0.95,
              child: Text(
                subCategoryDefault , style: const TextStyle(fontSize: 18 , color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 5,),
            SizedBox(
              width: width*0.95,
              child: showSubCategory(width, height),
            ),
            const SizedBox(height: 10,),
            SizedBox(
                width: width*0.95,
                child: ElevatedButton(
                  onPressed: () async {
                    //save our data to local =>
                    for(var value in chooseSubCategories){
                      int idChoseeElemnt = allSubCategories.indexOf(value);
                      chooseSubCategoriesIndex.add(allSubCategoriesIndex[idChoseeElemnt]);
                    }
                    var box = await Hive.openBox("categorySearch");
                    await box.put("selectedSubCategoriesIndex", chooseSubCategoriesIndex);
                    await box.put("selectedSubCategoriesTitle", chooseSubCategories);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => SearchCategoryPage(
                          categoryId: widget.categoryIndex,
                          categoryName: widget.categoryName,
                        )
                    )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Border radius
                      side: const BorderSide(
                        color: Color.fromRGBO(77, 170, 232, 1), // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                  ),
                  child: Text(submit, style: const TextStyle(fontSize: 18 , color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w500),),
                )
            ),
            const SizedBox(height: 20,)
          ],
        ),
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
    print("Inited");
    if(globals.userLanguage!="ru"){setDataKyrgyz();}
    if(globals.userLanguage=="ru"){setDataRussian();}
    getData();
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
            builder: (BuildContext context) => SearchCategoryPage(
              categoryId: widget.categoryIndex,
              categoryName: widget.categoryName,
            )
        )
        );
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
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: IconButton(
                                  onPressed: (){
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (BuildContext context) => SearchCategoryPage(
                                          categoryId: widget.categoryIndex,
                                          categoryName: widget.categoryName,
                                        )
                                    )
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_back_ios, color: Color.fromRGBO(171, 176, 186, 1), size: 30,),
                                ),
                              ),
                              SizedBox(
                                  height: 35,
                                  width: width*0.7,
                                  child: Padding(
                                      padding: const EdgeInsets.only(top: 7.5),
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
                            width: width*0.95,
                            height: mainSizedBoxHeightUserNotLogged-50,
                            child: (dataGet)?  filterSearch(width, mainSizedBoxHeightUserNotLogged-50): loadingData(),
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
