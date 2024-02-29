import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:image_picker/image_picker.dart';
import 'package:zherdeshmobileapplication/UserDatas/userchangepassword_page.dart';
import 'package:zherdeshmobileapplication/UserDatas/userdata_page.dart';

import '../HomeFiles/home_screen.dart';


class EditUserPage extends StatefulWidget{
  final String name;
  final String surname;
  final String email;
  final String avatarNetworkPath;
  final String phone;
  final bool isUserActivated;
  final int moneyCash;
  final int userID;
  final String userStatus;
  final String userStatusEndDate;
  const EditUserPage(
      {super.key,
        required this.name , required this.surname , required this.email,
        required this.avatarNetworkPath , required this.phone,
        required this.isUserActivated , required this.moneyCash , required this.userID,
        required this.userStatus, required this.userStatusEndDate
      }
      );

  @override
  EditUserPageState createState ()=> EditUserPageState();
}

class EditUserPageState extends State<EditUserPage>{

  String changeImageString = "";
  String nameString = "";
  String surnameString = "";
  String emailString = "";
  String phoneNumberString = "";

  bool dataGet = false;

  String userDataSaveString = "";
  String title = "";
  String userForgetHisPassword = "";

  String errorMessageName = "";
  String errorMessageSurname = "";
  String errorMessageEmail = "";
  String errorMessagePhone = "";
  String errorMessageImageIsOverweight = "";
  File? selectedImage;

  int maxWeight = 12;
  String fileNameUserChoose = "";
  String dataChanged = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void setDataKyrgyz(){
    changeImageString = "Сүрөттү өзгөртүү";
    nameString = "Ысым";
    surnameString = "Атасынын аты";
    emailString = "Почта";
    phoneNumberString = "Байланыш";

    userDataSaveString = "Сактоо";
    title = "Профилди түзөтүү";
    userForgetHisPassword = "Сырсөздү өзгөртүү";

    errorMessageName = "Аты талаасы бош!";
    errorMessageSurname = "Талаа фамилиясы бош!";
    errorMessageEmail = "Почта талаасы бош!";
    errorMessagePhone = "Телефон талаасы бош!";
    errorMessageImageIsOverweight = "Файл өтө оор!\nМаксимум $maxWeight MB";

    dataChanged = "Маалыматтар өзгөртүлдү";
  }

  void setDataRussian(){
    changeImageString = "Изменить изображение";
    nameString = "Имя";
    surnameString = "Фамилия";
    emailString = "Почта";
    phoneNumberString = "Телефон";

    userDataSaveString = "Сохранить";
    title = "Редактирование профиля";
    userForgetHisPassword = "Сменить пароль";

    errorMessageName = "Поле имя пустое!";
    errorMessageSurname = "Поле фамилия пустое!";
    errorMessageEmail = "Поле почта пустое!";
    errorMessagePhone = "Поле телефон пустое!";
    errorMessageImageIsOverweight = "Файл слишком тяжелый!\nМаксимум $maxWeight MB";

    dataChanged = "Данные изменены";
  }


  Widget containerUserData(width , data , TextEditingController controller , TextInputType type , String errorMessage){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
            contentPadding: const EdgeInsets.only(left: 10, right: 20),
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



  Widget containerUserDataPhone(width , data , TextEditingController controller , TextInputType type , String errorMessage){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
            contentPadding: const EdgeInsets.only(left: 10, right: 20),
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
            suffixIcon: IconButton(
              icon: Icon(Icons.task_alt, color: Colors.green.shade400, size: 22,),
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
            ),
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
        print("Data Save");
        String nameNewGetFromController = nameController.text;
        String surnameNewGetFromController = surnameController.text;
        String phoneNewGetFromController = phoneController.text;

        if(nameNewGetFromController.isNotEmpty && surnameNewGetFromController.isNotEmpty
            && phoneNewGetFromController.isNotEmpty
        ){
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
            final selectedImage = this.selectedImage;
            if(selectedImage!=null){
              FormData formData = FormData.fromMap({
                "phone" : phoneNewGetFromController ,
                "first_name" : nameNewGetFromController,
                "last_name" : surnameNewGetFromController,
                "avatar" : await MultipartFile.fromFile(selectedImage.path, filename: fileNameUserChoose),
              });
              final respose = await dio.patch("${globals.endpointSaveUserData}${widget.userID}",
                  data: formData
              );
              if(respose.statusCode == 200){
                Fluttertoast.showToast(
                  msg: dataChanged,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                  backgroundColor: Colors.white, // Background color of the toast
                  textColor: Colors.black,
                );
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen(positionBottomNavigationBar: 2)));
              }
            }
            else{
              final respose = await dio.patch("${globals.endpointSaveUserData}${widget.userID}",
                  data: {
                    "phone" : phoneNewGetFromController ,
                    "first_name" : nameNewGetFromController,
                    "last_name" : surnameNewGetFromController,
                  }
              );
              if(respose.statusCode == 200){
                Fluttertoast.showToast(
                  msg: dataChanged,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                  backgroundColor: Colors.white, // Background color of the toast
                  textColor: Colors.black,
                );
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const HomeScreen(positionBottomNavigationBar: 2)));
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

  Widget userForgetPassword(width, height, context){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => UserChangePassword(
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
              const Icon(Icons.pin, color: Color.fromRGBO(77, 170, 232, 1), size: 16),
              const SizedBox(width: 10,),
              Text(
                  userForgetHisPassword, textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w400 , letterSpacing:0
                  )),
            ],
          )
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File userSelectedFile = File(pickedFile.path);
      if (userSelectedFile.lengthSync() <= maxWeight * 1024 * 1024) {
        setState(() {
          selectedImage = File(pickedFile.path);
          fileNameUserChoose = pickedFile.path.split('/').last;
        });
      } else {
        Fluttertoast.showToast(
          msg: errorMessageImageIsOverweight,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
          backgroundColor: Colors.white, // Background color of the toast
          textColor: Colors.black,
        );
      }
    }
  }


  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if(globals.userLanguage!="ru"){setDataKyrgyz();}

    if(globals.userLanguage=="ru"){setDataRussian();}

    nameController.text = widget.name;
    surnameController.text = widget.surname;
    phoneController.text = widget.phone;
    setState(() {
      dataGet = true;
    });

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
          resizeToAvoidBottomInset: false,
          body:Padding(padding: EdgeInsets.only(top: statusBarHeight),
            child: Container(
                width: width,
                height: mainSizedBoxHeightUserNotLogged,
                color: const Color.fromRGBO(250, 250, 250, 1),
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
                                            fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500
                                        ))
                                )
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        width: width*0.9,
                        child: Align(
                          alignment: Alignment.center,
                          child: InstaImageViewer(
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
                                imageUrl: '${globals.mainPath}${widget.avatarNetworkPath}',
                                imageBuilder: (context, imageProvider){
                                  return Container(
                                    width: mainSizedBoxHeightUserNotLogged*0.2, height: mainSizedBoxHeightUserNotLogged*0.2,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color: const Color.fromRGBO(0, 0, 0, 0.6),
                                        image: selectedImage!=null ? DecorationImage(
                                          //NetworkImage('${globals.mainPath}$avatarNetworkPath')
                                            image: FileImage(selectedImage!),
                                            fit: BoxFit.cover,
                                            opacity: 0.4
                                        )
                                            :
                                        DecorationImage(
                                            image: NetworkImage('${globals.mainPath}${widget.avatarNetworkPath}'),
                                            fit: (widget.avatarNetworkPath=="/media/avatars/df/Zherdesh%20logo-05.png")?BoxFit.contain: BoxFit.cover,
                                            opacity: 0.4
                                        )
                                    ),
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Icon(Icons.camera, color: Colors.white, size: 30),
                                    ),
                                  );
                                },
                              )
                          )
                        ),
                      ),
                      const SizedBox(height: 10,),
                      GestureDetector(
                        onTap: _pickImage,
                        child: SizedBox(
                          width: width*0.9,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                                changeImageString, textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16, color: Color.fromRGBO(77, 170, 232, 1), fontWeight: FontWeight.w500 ,
                                  letterSpacing: 0,
                                )
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      containerUserData(width, nameString, nameController, TextInputType.name, errorMessageName),
                      const SizedBox(height: 10,),
                      containerUserData(width, surnameString, surnameController, TextInputType.name, errorMessageSurname),
                      const SizedBox(height: 10,),
                      containerUserDataPhone(width, phoneNumberString,phoneController, TextInputType.phone, errorMessagePhone),
                      const SizedBox(height: 20,),
                      userDataSave(width, height, context),
                      const SizedBox(height: 20,),
                      userForgetPassword(width, height, context)
                    ],
                  ),
                )
            ),
          )
      ),
    );

  }
}