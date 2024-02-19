import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;

class SearchSettingsPage extends StatefulWidget {
  const SearchSettingsPage({super.key});

  @override
  State<SearchSettingsPage> createState() => SearchSettingsPageState();
}

class SearchSettingsPageState extends State<SearchSettingsPage> {

  String title = "";
  bool dataGet = false;

  List<String> categorySubcategory = [];
  List<int> categorySubcategoryID = [];
  List<String> metroNames = [];
  List<int> metroID = [];

  bool recordsGetCategories = false;
  bool recordsGetMetro = false;

  //todo => search :
  final TextEditingController textEditingControllerSearchMetro = TextEditingController();
  String? selectedValueMetro;

  String dataShowChooseMetro = "";
  String searchHintTextInside = "";
  String metroDefault = "";
  String subCategoryDefault = "";
  String submit = "";

  List<String> chosenValueInsideSearchSettings = [];
  String chosenToSearchMetroInsideSearchSettings = "";
  void setDataKyrgyz(){

  }

  void setDataRussian(){
    title = "Фильтры";
    dataShowChooseMetro = "Выберите метро";
    searchHintTextInside = "Поиск";
    subCategoryDefault = "Подкатегории";
    metroDefault = "Метро";
    submit = "Применить";
  }

  Widget loadingData(){
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 2,),
    );
  }

  Future<void> getCategories() async{
    final dio = Dio();
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    try{
      //todo => send data to server : =>
      final respose = await dio.get(globals.endpointGetCategories);
      if(respose.statusCode == 200){
        String dataToParse = respose.toString();
        Map<String, dynamic> jsonData = json.decode(dataToParse);
        List<dynamic> result = jsonData['result'];
        for (var item in result) {
          List<dynamic> subcategories = item['subcategories'];
          for (var subcategory in subcategories) {
            categorySubcategory.add(subcategory['title']);
            categorySubcategoryID.add(subcategory['id']);
          }
        }
        setState(() {
          recordsGetCategories = true;
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
  }

  Future<void> getMetro() async{
    print("Get metro");
    final dio = Dio();
    dio.options.headers['Accept-Language'] = globals.userLanguage;
    try{
      final respose = await dio.get(globals.endpointGetMetros);
      if(respose.statusCode == 200){
        String dataToParse = respose.toString();
        Map<String, dynamic> data = json.decode(dataToParse);
        List<dynamic> citiesData = data['result'];
        for (var cityData in citiesData) {
          var metrosData = cityData['metros'];
          for (var metroData in metrosData) {
            var metroName = metroData['metro_name'];
            metroNames.add(metroName);
            metroID.add(metroData['id']);
          }
        }

        setState(() {
          recordsGetMetro = true;
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
  }

  Future<void> getData() async{
    await getCategories();
    await getMetro();
    if(recordsGetMetro && recordsGetCategories){
      setState(() {
        dataGet = true;
        chosenValueInsideSearchSettings = globals.chosenValue;
      });
    }
  }

  Widget showMetroNew(width , height){
    return Container(
      width: width*0.95,
      height: height*0.07,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(244, 244, 244, 0.93),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromRGBO(221, 221, 221, 1),
          width: 1, // Border width
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: (globals.chosenMetro.isEmpty)?Text(
            dataShowChooseMetro,
            style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400,
              color: Theme.of(context).hintColor,
            ),
          ) : Text(
            globals.chosenMetro,
            style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400,
              color: Theme.of(context).hintColor,
            ),
          ) ,
          items: metroNames.map((item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromRGBO(30, 29, 33, 1)
              ),
            ),
          )).toList(),
          value: selectedValueMetro,
          onChanged: (value) {
            setState(() {
              selectedValueMetro = value;
            });
          },
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.only(left: 10 , right: 20),
            height: height*0.07,
            width: width*0.95,
          ),
          dropdownStyleData: DropdownStyleData(
              maxHeight: height*0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              )
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: textEditingControllerSearchMetro,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                expands: true,
                maxLines: null,
                controller: textEditingControllerSearchMetro,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: searchHintTextInside,
                  hintStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().contains(searchValue);
            },
          ),
          //This to clear the search value when you close the menu
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textEditingControllerSearchMetro.clear();
            }
          },
          iconStyleData: const IconStyleData(icon: FaIcon(FontAwesomeIcons.caretDown, size: 16,)),
        ),
      ),
    );
  }

  Widget showSubCategory(width , height){
    return Wrap(
      spacing: 8.0, // Horizontal spacing between buttons
      runSpacing: 5.0, // Vertical spacing between rows of buttons
      alignment: WrapAlignment.start,
      children: categorySubcategory.map((label) {
        bool touched = false;
        if(chosenValueInsideSearchSettings.contains(label)){
          touched = true;
        }
        return ElevatedButton(
          onPressed: () {
            if(touched){
              chosenValueInsideSearchSettings.remove(label);
              print(globals.chosenValue);
            }
            else{
              chosenValueInsideSearchSettings.add(label);
              print(globals.chosenValue);
            }

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
                metroDefault , style: const TextStyle(fontSize: 18 , color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 5,),
            SizedBox(
              width: width*0.95,
              child: showMetroNew(width, height),
            ),
            const SizedBox(height: 20,),
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
                onPressed: () {
                  //save our data to local =>
                  globals.chosenValue = chosenValueInsideSearchSettings;
                  for( var elem in chosenValueInsideSearchSettings){
                    int posElemInsideChosenValueInsideSearchSettings = categorySubcategory.indexOf(elem);
                    int neededElemOfPos = categorySubcategoryID[posElemInsideChosenValueInsideSearchSettings];
                    globals.chosenValueIndex.add(neededElemOfPos);
                  }
                  if(selectedValueMetro!= null){
                    globals.chosenMetro = selectedValueMetro!;
                    int posElemInsideChosenValueMetro = metroNames.indexOf(selectedValueMetro!);
                    int neededElemOfPos = metroID[posElemInsideChosenValueMetro];
                    globals.chosenMetroIndex = neededElemOfPos;
                  }
                  Navigator.of(context).pop();
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
    textEditingControllerSearchMetro.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: IconButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
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
