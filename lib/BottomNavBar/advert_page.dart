
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:zherdeshmobileapplication/Advertise/advertise_completed.dart';
import 'package:zherdeshmobileapplication/Advertise/advertise_moderate.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;

import '../HomeFiles/home_screen.dart';

class AdvertisePage extends StatefulWidget{
  const AdvertisePage({super.key});

  @override
  AdvertisePageState createState ()=> AdvertisePageState();
}
class AdvertisePageState extends State<AdvertisePage>{

  bool dataGet = false;
  String topic = "";
  String hintCategoryChoose = "";
  String hintMetroChoose = "";

  List<String> categorySubcategory = [];
  List<String> categorySubcategoryID = [];
  List<String> subcategoryCost = [];
  List<String> metroNames = [];
  List<String> metroID = [];


  String dataToShow = "";

  String titleHint = "";
  String descriptionHint = "";
  String phoneHint = "";
  String addressHint = "";

  String errorTitle = "";
  String errorDescription = "";
  String errorPhone = "";
  String errorAddress = "";

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String showButton = "";
  String searchHintTextInside = "";
  String noResultOnSearch = "";

  String dataShowCamera1 = "";
  String dataShowCamera2 = "";

  int maxWeight = 12;
  List<XFile> imagesFileList = [];

  bool userSelectedImage = false;
  List<File> docFiles = [];
  List<FileImage> userChoose = [];
  List<dynamic>? _documents = [];

  String publicSuccess = "";
  String clearImages = "";
  String errorPickImages = "";

  String costPay = "";
  String costToPay = "0";

  bool recordsGetCategories = false;
  bool recordsGetMetro = false;

  //todo => search :
  final TextEditingController textEditingControllerSearchMetro = TextEditingController();
  String? selectedValueMetro;

  final TextEditingController textEditingControllerSearchCategory = TextEditingController();
  String? selectedValueCategory;

  String dataShowChooseMetro = "";
  String dataShowChooseCategory = "";

  //todo => methods to setProper data =>
  void setDataKyrgyz(){
    dataToShow = "KG";
  }
  void setDataRussian(){
    dataToShow = "RU";
    topic = "Публикация обьявления";
    hintCategoryChoose = "Выберите категорию";
    hintMetroChoose = "Выберите метро";

    titleHint = "Введите заголовок";
    descriptionHint = "Введите описание";
    phoneHint = "Введите номер телефона";
    addressHint = "Введите адрес";

    errorTitle = "Поле пустое!";
    errorDescription = "Поле пустое!";
    errorPhone = "Поле пустое!";

    showButton = "Опубликовать";
    searchHintTextInside = "Поиск";
    noResultOnSearch = "Упс!Мы ничего не нашли...";

    dataShowCamera1 = "Загрузить фотографии";
    dataShowCamera2 = "Добавить максимум 6 фото.\nМаксимальный размер изображения 12Mb";

    publicSuccess = "Объявление успешно создано!";
    clearImages = "Очистить изображения";

    errorPickImages = "Вы слишком много\n выбрали изображений!";
    costPay = "Стоимость объявления";

    dataShowChooseMetro = "Выберите метро";
    dataShowChooseCategory = "Выберите подкатегорию";

  }

  Future<void> getCategories() async{
    print("Categories");
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
            categorySubcategoryID.add(subcategory['id'].toString());
            if(subcategory['price']!=null){
              subcategoryCost.add(subcategory['price'].toString());
            }
            else{
              subcategoryCost.add("0");
            }
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
            metroID.add(metroData['id'].toString());
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
        });
      }
  }

  Widget showCategoriesNew(width , height){
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
          hint: Text(
            dataShowChooseCategory,
            style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: categorySubcategory.map((item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 16, color: Color.fromRGBO(30, 29, 33, 1)
              ),
            ),
          )).toList(),
          value: selectedValueCategory,
          onChanged: (value) {
            setState(() {
              selectedValueCategory = value;
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
            height: 60,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: textEditingControllerSearchCategory,
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
                controller: textEditingControllerSearchCategory,
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
              textEditingControllerSearchCategory.clear();
            }
          },
          iconStyleData: const IconStyleData(icon: FaIcon(FontAwesomeIcons.caretDown, size: 16,)),
        ),
      ),
    );
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
          hint: Text(
            dataShowChooseMetro,
            style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400,
              color: Theme.of(context).hintColor,
            ),
          ),
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

  Widget advertiseCreationTitleTextFormField (width){
    return SizedBox(
      width: width*0.95,
      child: TextFormField(
          controller: titleController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.text,
          maxLines: null,
          decoration:  InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(221, 221, 221, 1)),
                borderRadius: BorderRadius.circular(8)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(70, 170, 232, 1)),
                borderRadius: BorderRadius.circular(8)
            ),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(255, 0, 0, 0.5)),
                borderRadius: BorderRadius.circular(8)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(255, 0, 0, 0.5)),
                borderRadius: BorderRadius.circular(8)
            ),
            contentPadding: const EdgeInsets.only(left: 10, right: 20),
            hintStyle:  TextStyle(fontSize: 16 , color: Theme.of(context).hintColor , fontWeight: FontWeight.w400),
            hintText: titleHint,
            fillColor: const Color.fromRGBO(244, 244, 244, 0.93),
            filled: true,
            errorStyle:const TextStyle(
              color: Color.fromRGBO(255, 0, 0, 0.5),
              fontSize: 12,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 1,
          ),
          style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
          validator: (String?value){
            if(value!.isEmpty){
              return errorTitle;
            }
            return null;
          }
      ),
    );
  }

  Widget advertiseCreationDescriptionTextFormField (width){
    return SizedBox(
      width: width*0.95,
      child: TextFormField(
          controller: descriptionController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration:  InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(221, 221, 221, 1)),
                borderRadius: BorderRadius.circular(8)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(70, 170, 232, 1)),
                borderRadius: BorderRadius.circular(8)
            ),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(255, 0, 0, 0.5)),
                borderRadius: BorderRadius.circular(8)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(255, 0, 0, 0.5)),
                borderRadius: BorderRadius.circular(8)
            ),
            contentPadding: const EdgeInsets.only(left: 10, right: 20),
            hintStyle: TextStyle(fontSize: 16 , color: Theme.of(context).hintColor , fontWeight: FontWeight.w400),
            hintText: descriptionHint,
            fillColor: const Color.fromRGBO(244, 244, 244, 0.93),
            filled: true,
            errorStyle:const TextStyle(
              color: Color.fromRGBO(255, 0, 0, 0.5),
              fontSize: 12,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 1,
          ),
          style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
          validator: (String?value){
            if(value!.isEmpty){
              return errorDescription;
            }
            return null;
          }
      ),
    );
  }

  Widget advertiseCreationPhoneTextFormField (width){
    return SizedBox(
      width: width*0.95,
      child: TextFormField(
          controller: phoneController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.phone,
          decoration:  InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(221, 221, 221, 1)),
                borderRadius: BorderRadius.circular(8)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(70, 170, 232, 1)),
                borderRadius: BorderRadius.circular(8)
            ),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(255, 0, 0, 0.5)),
                borderRadius: BorderRadius.circular(8)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(255, 0, 0, 0.5)),
                borderRadius: BorderRadius.circular(8)
            ),
            contentPadding: const EdgeInsets.only(left: 10, right: 20),
            hintStyle: TextStyle(fontSize: 16 , color: Theme.of(context).hintColor , fontWeight: FontWeight.w400),
            hintText: phoneHint,
            fillColor: const Color.fromRGBO(244, 244, 244, 0.93),
            filled: true,
            errorStyle:const TextStyle(
              color: Color.fromRGBO(255, 0, 0, 0.5),
              fontSize: 12,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 1,
          ),
          style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
          validator: (String?value){
            if(value!.isEmpty){
              return errorPhone;
            }
            return null;
          }
      ),
    );
  }

  Widget advertiseCreationAddressTextFormField (width){
    return SizedBox(
      width: width*0.95,
      child: TextFormField(
          controller: addressController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.text,
          maxLines: null,
          decoration:  InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(221, 221, 221, 1)),
                borderRadius: BorderRadius.circular(8)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(70, 170, 232, 1)),
                borderRadius: BorderRadius.circular(8)
            ),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(255, 0, 0, 0.5)),
                borderRadius: BorderRadius.circular(8)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(255, 0, 0, 0.5)),
                borderRadius: BorderRadius.circular(8)
            ),
            contentPadding: const EdgeInsets.only(left: 10, right: 20),
            hintStyle: TextStyle(fontSize: 16 , color: Theme.of(context).hintColor , fontWeight: FontWeight.w400),
            hintText: addressHint,
            fillColor: const Color.fromRGBO(244, 244, 244, 0.93),
            filled: true,
            errorStyle:const TextStyle(
              color: Color.fromRGBO(255, 0, 0, 0.5),
              fontSize: 12,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 1,
          ),
          style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
      ),
    );
  }

  Widget containerCostCategory(width , height , data , dataValue){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            data, textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 14, color: Color.fromRGBO(148, 148, 148, 1), fontWeight: FontWeight.w400 ,
              letterSpacing: 0,
            )
        ),
        Container(
          width: width*0.95,
          height: height * 0.06,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromRGBO(245, 245, 245, 1),
              border: Border.all(
                color: const Color.fromRGBO(221, 221, 221, 1), // Set border color
                width: 1.0, // Set border width
              ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const  EdgeInsets.only(left: 10),
              child: Text(
                  dataValue, textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400 ,
                    letterSpacing: 0,
                  )
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget submitButton(width, mainSizedBoxHeightUserNotLogged){
    return Container(
        width: width*0.95,
        height: mainSizedBoxHeightUserNotLogged*0.07-4,
        decoration: BoxDecoration(
          color: Colors.white, // Set container color
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: const Color.fromRGBO(77, 170, 232, 1), // Set border color
            width: 2.0, // Set border width
          ),// Set border radius
        ),
        child: ElevatedButton(
            onPressed: ()async{
              if(titleController.text.isNotEmpty && descriptionController.text.isNotEmpty
                  && phoneController.text.isNotEmpty && selectedValueCategory!.isNotEmpty
                  && selectedValueMetro!.isNotEmpty
              ){
                print("TOUCH");
                int metroPosName = metroNames.indexOf(selectedValueMetro!);
                int categoryPosName = categorySubcategory.indexOf(selectedValueCategory!);

                int metroPos = int.parse(metroID[metroPosName]);
                int categoryPos = int.parse(categorySubcategoryID[categoryPosName]);

                for(int i=0; i< docFiles!.length; i++ ){
                  var path = docFiles![i].path;
                  _documents!.add(await MultipartFile.fromFile(path,
                      filename: path.split('/').last));
                }
                //todo: => get data from dropdown menu =>
                final dio = Dio();
                //get access and refresh token from Hive =>
                var box = await Hive.openBox("logins");
                String refresh = await box.get("refresh");
                String access = await box.get("access");
                //set Dio response =>
                dio.options.headers['Accept-Language'] = globals.userLanguage;
                dio.options.headers['Authorization'] = "Bearer $refresh";
                dio.options.headers['Authorization'] = "Bearer $access";
                try{
                  FormData formData = FormData.fromMap({
                    "title" : titleController.text ,
                    "description" : descriptionController.text,
                    "metro" : metroPos,
                    "subcategory" : categoryPos,
                    "address" : (addressController.text.isEmpty)? "":addressController.text,
                    "phone" : phoneController.text,
                    "upload_images": (userSelectedImage)? _documents : []
                  });
                  final respose = await dio.post(
                      globals.endpointPublishAdvertise,
                      data: formData
                  );
                  if(respose.statusCode == 200){
                    Map<String, dynamic> jsonData = jsonDecode(respose.toString());
                    String status = jsonData['data']['status'];
                    if(status == "published"){
                      Fluttertoast.showToast(
                        msg: publicSuccess,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                        backgroundColor: Colors.white, // Background color of the toast
                        textColor: Colors.black,
                        fontSize: 12.0,
                      );
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => const AdvertiseCompletedPage()));
                    }
                    else{
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => const AdvertiseModeratePage()));
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
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    showButton,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w500 , letterSpacing: 0.2
                    )),
                const SizedBox(width: 10,),
                const  FaIcon(FontAwesomeIcons.solidPaperPlane, color: Color.fromRGBO(77, 170, 232, 1), size: 16),
              ],
            )
        )
    );
  }

  Widget clearImagesButton(width, mainSizedBoxHeightUserNotLogged){
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
          width: width*0.95,
          height: mainSizedBoxHeightUserNotLogged*0.07,
          decoration: BoxDecoration(
            color: Colors.white, // Set container color
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: const Color.fromRGBO(253, 93, 93, 1), // Set border color
              width: 2.0, // Set border width
            ),// Set border radius
          ),
          child: ElevatedButton(
              onPressed: ()async{
                docFiles.clear();
                imagesFileList.clear();
                userChoose.clear();
                setState(() {
                  userSelectedImage = false;
                });
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      clearImages,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, color: Color.fromRGBO(253, 93, 93, 1), fontWeight: FontWeight.w500 , letterSpacing: 0.2
                      )),
                  const SizedBox(width: 10,),
                  const  FaIcon(FontAwesomeIcons.trash, color: Color.fromRGBO(253, 93, 93, 1), size: 16),
                ],
              )
          )
      ),
    );
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if(pickedFiles!.isNotEmpty){
      if(pickedFiles.length<=6){
        pickedFiles.forEach((element) {
          File userSelectedFile = File(element.path);
          if (userSelectedFile.lengthSync() <= maxWeight * 1024 * 1024) {
            imagesFileList.add(element);
            userChoose.add(FileImage(File(userSelectedFile.path)));
            docFiles.add(File(userSelectedFile.path));
            userSelectedImage = true;
          }
        });
      }
      else{
        Fluttertoast.showToast(
          msg: errorPickImages,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
          backgroundColor: Colors.white, // Background color of the toast
          textColor: Colors.black,
          fontSize: 12.0,
        );
      }
    }
    setState(() {

    });
  }

  Widget showChoseImages(width , height){
    List<Widget> imageWidgets = List.generate(userChoose.length, (index) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: InstaImageViewer(child: Image(image: userChoose[index], fit: BoxFit.cover,)),
      );
    });
    return Container(
      width: width*0.95,
      height: height*0.4,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(245, 245, 245, 1), // Set container color
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ImageSlideshow(
        initialPage: 0,
        indicatorColor: const Color.fromRGBO(77, 170, 232, 1),
        autoPlayInterval: 5000,
        isLoop: false,
        children: imageWidgets,
      )
    );
  }

  Widget uploadImagesContainer(width , height){
    return (userSelectedImage)? showChoseImages(width , height) : GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: width*0.95,
        height: height*0.4,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(245, 245, 245, 1), // Set container color
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: const Color.fromRGBO(221, 221, 221, 1), // Set border color
            width: 1.0, // Set border width
          ),// Set border radius
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.cameraRetro, color: Color.fromRGBO(77, 170, 232, 1), size: 30),
              const SizedBox(height: 5,),
              Text(
                dataShowCamera1 ,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 5,),
              Text(
                  dataShowCamera2 ,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromRGBO(154, 154, 154, 1),
                    fontSize: 12,
                    letterSpacing: 0.2,
                    fontWeight: FontWeight.w400,
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textEditingControllerSearchMetro.dispose();
    titleController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    phoneController.dispose();
    textEditingControllerSearchCategory.dispose();
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
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomNavBarHeight = kBottomNavigationBarHeight;
    double mainSizedBoxHeightUserNotLogged = height- statusBarHeight-bottomNavBarHeight;

    return (dataGet)? Scaffold(
        resizeToAvoidBottomInset: false,
        body:Padding(padding: EdgeInsets.only(top: statusBarHeight),
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
                          const SizedBox(height: 10,),
                          SizedBox(
                            width: width*0.95,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                  topic, textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20, color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500 ,
                                    letterSpacing: 0,
                                  )
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                              width: width*0.95,
                              child: showCategoriesNew(width, height),
                          ),
                          const SizedBox(height: 10,),
                          advertiseCreationTitleTextFormField(width),
                          const SizedBox(height: 10,),
                          advertiseCreationDescriptionTextFormField(width),
                          const SizedBox(height: 10,),
                          SizedBox(
                            width: width*0.95,
                            child: showMetroNew(width, height),
                          ),
                          const SizedBox(height: 10,),
                          advertiseCreationAddressTextFormField(width),
                          const SizedBox(height: 10,),
                          advertiseCreationPhoneTextFormField(width),

                          const SizedBox(height: 10,),
                          uploadImagesContainer(width, mainSizedBoxHeightUserNotLogged),
                          (userSelectedImage)? clearImagesButton(width, mainSizedBoxHeightUserNotLogged) : const SizedBox(),

                          const SizedBox(height: 10,),
                          containerCostCategory(width, mainSizedBoxHeightUserNotLogged, costPay, costToPay),
                          const SizedBox(height: 10,),
                          submitButton(width, mainSizedBoxHeightUserNotLogged),
                          const SizedBox(height: 10,)
                        ],
                      ),
                    )
                )
            )
        )
    ) : loadingData(width, height);
  }
}