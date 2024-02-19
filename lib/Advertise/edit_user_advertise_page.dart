import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:zherdeshmobileapplication/Advertise/user_advert_full_view_page.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:image_picker/image_picker.dart';
import 'package:zherdeshmobileapplication/UserDatas/userdata_page.dart';



class EditUserAdvertisePage extends StatefulWidget{
  final String name;
  final String surname;
  final String email;
  final String avatarNetworkPath;
  final String phone;
  final bool isUserActivated;
  final int moneyCash;
  final int userID;
  final String userStatus;

  final String postID;
  final String titlePost;
  final String descriptionPost;
  final String metroStationPost;
  final String streetPost;
  final String phonePost;
  final String subcategoryPost;
  final List<String> imageListPost;
  final String userStatusEndDate;
  const EditUserAdvertisePage(
      {super.key,
        required this.name , required this.surname , required this.email,
        required this.avatarNetworkPath , required this.phone,
        required this.isUserActivated , required this.moneyCash , required this.userID,
        required this.userStatus, required this.userStatusEndDate,
        required this.postID , required this.titlePost, required this.descriptionPost, required this.metroStationPost,
        required this.streetPost , required this.phonePost , required this.subcategoryPost, required this.imageListPost
      }
      );

  @override
  EditUserAdvertisePageState createState ()=> EditUserAdvertisePageState();
}

class EditUserAdvertisePageState extends State<EditUserAdvertisePage>{
  String changeImageString = "";
  String titleString = "";
  String descriptionString = "";
  String streetString = "";
  String phoneNumberString = "";

  bool dataGet = false;
  bool userSelectedImage = false;

  String userDataSaveString = "";
  String title = "";
  String userForgetHisPassword = "";

  String errorMessageTextEdit = "";
  String errorMessageImageIsOverweight = "";


  int maxWeight = 12;
  String fileNameUserChoose = "";
  String dataChanged = "";

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController streetController = TextEditingController();

  List<String> metroNames = [];
  List<String> metroID = [];

  String searchHintTextInside = "";
  String noResultOnSearch = "";
  String hintMetroChoose = "";


  bool userClearedPhotoField = false;
  String clearImages = "";
  List<File> docFiles = [];
  List<FileImage> userChoose = [];
  List<XFile> imagesFileList = [];
  List<dynamic>? _documents = [];
  String errorPickImages = "";
  String dataShowCamera1 = "";
  String dataShowCamera2 = "";
  String publicSuccess = "";
  String metroDataDefault = "Метро";

  final TextEditingController textEditingControllerSearchMetro = TextEditingController();
  String? selectedValueMetro;

  String dataShowChooseMetro = "";

  void setDataKyrgyz(){
    title = "Жарнаманы түзөтүү";
    titleString = "Макала";
    descriptionString = "Маалымат";
    streetString = "Дарек";
    phoneNumberString = "Телефон номуру";

    errorMessageImageIsOverweight = "Файл өтө оор!\nМаксималдуу $maxWeight Мб";
    errorPickImages = "Сиз өтө көп \nсүрөттөрдү тандадыңыз!";
    errorMessageTextEdit = "Талаа бош!";


    dataChanged = "Маалыматтар өзгөртүлдү";
    userDataSaveString = "Сактоо";

    hintMetroChoose = "Метро тандаңыз";
    searchHintTextInside = "Издөө";
    noResultOnSearch = "Ой! Биз эч нерсе тапкан жокпуз...";

    clearImages = "Сүрөттөрдү тазалоо";
    dataShowCamera1 = "Сүрөттөрдү жүктөө";
    dataShowCamera2 = "Эң көп дегенде 6 сүрөт кошуңуз.\nСүрөттүн максималдуу өлчөмү 12 Мб";

    publicSuccess = "Жарнама ийгиликтүү өзгөртүлдү!";
  }

  void setDataRussian(){
    title = "Редактирование объявления";
    titleString = "Заголовок";
    descriptionString = "Описание";
    streetString = "Адрес";
    phoneNumberString = "Номер телефона";

    errorMessageImageIsOverweight = "Файл слишком тяжелый!\nМаксимум $maxWeight MB";
    errorPickImages = "Вы слишком много\n выбрали изображений!";
    errorMessageTextEdit = "Поле пустое!";


    dataChanged = "Данные изменены";
    userDataSaveString = "Сохранить";

    hintMetroChoose = "Выберите метро";
    searchHintTextInside = "Поиск";
    noResultOnSearch = "Упс!Мы ничего не нашли...";

    clearImages = "Очистить изображения";
    dataShowCamera1 = "Загрузить фотографии";
    dataShowCamera2 = "Добавить максимум 6 фото.\nМаксимальный размер изображения 12Mb";

    publicSuccess = "Объявление успешно изменено!";
    dataShowChooseMetro = "Выберите метро";
  }

  Widget loadingData(width , height){
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => UserDataPage(
              name: widget.name,
              surname: widget.surname,
              email: widget.email,
              avatarNetworkPath: widget.avatarNetworkPath,
              phone: widget.phone,
              isUserActivated: widget.isUserActivated,
              moneyCash: widget.moneyCash,
              userID: widget.userID,
              userStatus: widget.userStatus,
              userStatusEndDate: widget.userStatusEndDate,
            )
        )
        );
        return true;
      },
      child: Scaffold(
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

  Future<void> getMetro() async{
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
    await getMetro();
    setState(() {
      selectedValueMetro = widget.metroStationPost;
      titleController.text = widget.titlePost;
      descriptionController.text = widget.descriptionPost;
      phoneController.text = widget.phone;
      streetController.text = widget.streetPost;
      dataGet = true;
    });
  }

  Widget containerUserData(width , data , TextEditingController controller , TextInputType type , String errorMessage, maxLines){
    return SizedBox(
      width: width*0.95,
      child: TextFormField(
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: maxLines,
          keyboardType: type,
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
            contentPadding: const EdgeInsets.only(left: 10, right: 20, top: 5),
            labelText: data,
            fillColor: Colors.white,
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
              return errorMessage;
            }
            return null;
          }
      ),
    );
  }

  Widget userDataSave(width, height, context){
    return GestureDetector(
      onTap: () async {
        String titleGet = titleController.text;
        String phoneGet = phoneController.text;
        String descriptionGet = descriptionController.text;
        if(titleGet.isNotEmpty && phoneGet.isNotEmpty && descriptionGet.isNotEmpty){
          int metroPosName = metroNames.indexOf(selectedValueMetro!);
          int metroPos = int.parse(metroID[metroPosName]);

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

          //if user changed any images =>
          if(userClearedPhotoField){
            //todo :=> user changed images of advertise :
            for(int i=0; i< docFiles!.length; i++ ){
              var path = docFiles![i].path;
              _documents!.add(await MultipartFile.fromFile(path,
                  filename: path.split('/').last));
            }
            try{
              FormData formData = FormData.fromMap({
                "title" : titleGet,
                "description" : descriptionGet,
                "metro" : metroPos,
                "address" : (streetController.text.isEmpty)? "":streetController.text,
                "phone" : phoneController.text,
                "upload_images": (userSelectedImage)? _documents : []
              });
              final respose = await dio.patch(
                  "${globals.endpointEditAdvertise}${widget.postID}",
                  data: formData
              );
              if(respose.statusCode == 200){
                Fluttertoast.showToast(
                  msg: publicSuccess,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                  backgroundColor: Colors.white, // Background color of the toast
                  textColor: Colors.black,
                  fontSize: 12.0,
                );
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => AdvertiseUserPageFullView(
                      name: widget.name,
                      surname: widget.surname,
                      email: widget.email,
                      avatarNetworkPath: widget.avatarNetworkPath,
                      phone: widget.phone,
                      isUserActivated: widget.isUserActivated,
                      moneyCash: widget.moneyCash,
                      userID: widget.userID,
                      userStatus: widget.userStatus,
                      postID: widget.postID,
                      userStatusEndDate: widget.userStatusEndDate,
                    )
                )
                );
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
          else{
            //todo :=> user not changed images of advertise :
            try{
              FormData formData = FormData.fromMap({
                "title" : titleGet,
                "description" : descriptionGet,
                "metro" : metroPos,
                "address" : (streetController.text.isEmpty)? "":streetController.text,
                "phone" : phoneController.text,
              });
              final respose = await dio.patch(
                  "${globals.endpointEditAdvertise}${widget.postID}",
                  data: formData
              );
              if(respose.statusCode == 200){
                Fluttertoast.showToast(
                  msg: publicSuccess,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                  backgroundColor: Colors.white, // Background color of the toast
                  textColor: Colors.black,
                  fontSize: 12.0,
                );
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => AdvertiseUserPageFullView(
                      name: widget.name,
                      surname: widget.surname,
                      email: widget.email,
                      avatarNetworkPath: widget.avatarNetworkPath,
                      phone: widget.phone,
                      isUserActivated: widget.isUserActivated,
                      moneyCash: widget.moneyCash,
                      userID: widget.userID,
                      userStatus: widget.userStatus,
                      postID: widget.postID,
                      userStatusEndDate: widget.userStatusEndDate,
                    )
                )
                );
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
        }
      },
      child: Container(
          width: width*0.85,
          height: height* 0.06,
          decoration: BoxDecoration(
            color: Colors.white, // Set container color
            borderRadius: BorderRadius.circular(10.0), // Set border radius
            border: Border.all(
              color: const Color.fromRGBO(77, 170, 232, 1), // Set border color
              width: 2.0, // Set border width
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.cloudArrowDown, color: Color.fromRGBO(77, 170, 232, 1), size: 16),
              const SizedBox(width: 10,),
              Text(
                  userDataSaveString, textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w400 , letterSpacing:0
                  )),
            ],
          )
      ),
    );
  }

  Widget showMetroNew(width , height){
    return Container(
      width: width*0.95,
      height: height*0.07,
      decoration: BoxDecoration(
        color: Colors.white,
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
            widget.metroStationPost,
            style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500,
              color: Color.fromRGBO(30, 29, 33, 1),
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
                widget.imageListPost.clear();
                setState(() {
                  userClearedPhotoField = true;
                  if(userSelectedImage){
                    userSelectedImage = false;
                  }
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
        child: InstaImageViewer(child: Image(image: userChoose[index], fit: BoxFit.contain,)),
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
          autoPlayInterval: 3000,
          isLoop: false,
          children: imageWidgets,
        )
    );
  }

  Widget showChoseImagesDefault(width , height){
    List<Widget> imageWidgets = List.generate(widget.imageListPost.length, (index) {
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
          imageUrl: widget.imageListPost[index],
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
    phoneController.dispose();
    streetController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double mainSizedBoxHeightUserNotLogged = height - statusBarHeight;

    if(globals.userLanguage!="ru"){setDataKyrgyz();}

    if(globals.userLanguage=="ru"){setDataRussian();}


    return (dataGet)?WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => AdvertiseUserPageFullView(
              name: widget.name,
              surname: widget.surname,
              email: widget.email,
              avatarNetworkPath: widget.avatarNetworkPath,
              phone: widget.phone,
              isUserActivated: widget.isUserActivated,
              moneyCash: widget.moneyCash,
              userID: widget.userID,
              userStatus: widget.userStatus,
              postID: widget.postID,
              userStatusEndDate: widget.userStatusEndDate,
            )
        )
        );
        return true;
      },
      child: Scaffold(
          body:Padding(padding: EdgeInsets.only(top: statusBarHeight),
            child: Container(
                width: width,
                height: mainSizedBoxHeightUserNotLogged,
                color: const Color.fromRGBO(250, 250, 250, 1),
                child: SizedBox(
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
                                        builder: (BuildContext context) => AdvertiseUserPageFullView(
                                          name: widget.name,
                                          surname: widget.surname,
                                          email: widget.email,
                                          avatarNetworkPath: widget.avatarNetworkPath,
                                          phone: widget.phone,
                                          isUserActivated: widget.isUserActivated,
                                          moneyCash: widget.moneyCash,
                                          userID: widget.userID,
                                          userStatus: widget.userStatus,
                                          postID: widget.postID,
                                          userStatusEndDate: widget.userStatusEndDate,
                                        )
                                    )
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_back_ios, color: Color.fromRGBO(171, 176, 186, 1), size: 30,),
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
                                              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500
                                          ))
                                  )
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        (userClearedPhotoField)? uploadImagesContainer(width, mainSizedBoxHeightUserNotLogged) :showChoseImagesDefault(width, mainSizedBoxHeightUserNotLogged),
                        const SizedBox(height: 10,),
                        clearImagesButton(width, mainSizedBoxHeightUserNotLogged),
                        const SizedBox(height: 10,),
                        containerUserData(width, titleString, titleController, TextInputType.text, errorMessageTextEdit,null),
                        const SizedBox(height: 5,),
                        SizedBox(
                          width: width*0.95,
                          child:
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(metroDataDefault ,
                                style: const TextStyle(
                                  color: Color.fromRGBO(2, 48, 71, 1),
                                  fontSize: 14,
                                  letterSpacing: 0.2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                        ),
                        SizedBox(
                          width: width*0.95,
                          child: showMetroNew(width, height)
                        ),
                        const SizedBox(height: 15,),
                        containerUserData(width, streetString, streetController, TextInputType.text, errorMessageTextEdit,null),
                        const SizedBox(height: 10,),
                        containerUserData(width, phoneNumberString,phoneController, TextInputType.phone, errorMessageTextEdit,1),
                        const SizedBox(height: 10,),
                        containerUserData(width, descriptionString, descriptionController, TextInputType.multiline, errorMessageTextEdit,null),
                        const SizedBox(height: 15,),
                        userDataSave(width, height, context),
                        const SizedBox(height: 40,)
                      ],
                    ),
                  ),
                )
            ),
          )
      ),
    ): loadingData(width, height);

  }
}