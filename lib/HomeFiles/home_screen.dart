import 'package:flutter/material.dart';
import 'package:zherdeshmobileapplication/BottomNavBar/advert_page.dart';
import 'package:zherdeshmobileapplication/BottomNavBar/home_page.dart';
import 'package:zherdeshmobileapplication/BottomNavBar/profile_page.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;


class HomeScreen extends StatefulWidget{
  final int positionBottomNavigationBar;
  const HomeScreen({super.key, required this.positionBottomNavigationBar});

  @override
  HomeScreenState createState ()=> HomeScreenState(positionBottomNavigationBar);
}

class HomeScreenState extends State<HomeScreen>{
  final int positionBottomNavigationBar;
  HomeScreenState( this.positionBottomNavigationBar);


  int currentNavBarIndex = 0;
  bool navIndexSet = false;
  Color selectedItemColor = Colors.white;
  Color unselectedColor = const Color.fromRGBO(180, 180, 180, 0.3);
  List<Widget> navBarList = const [
    HomePage(),
    AdvertisePage(),
    ProfilePage()
  ];

  //todo: => bottom navigation elements =>
  String section_1 = "";
  String section_2 = "";
  String section_3 = "";

  //todo => methods to setProper data =>
  void setDataKyrgyz(){
    section_1 = "Башкы бет";
    section_2 = "Жарыялар";
    section_3 = "Профиль";
  }
  void setDataRussian(){
    section_1 = "Главная";
    section_2 = "Объявления";
    section_3 = "Профиль";
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double bottomNavBarHeight = kBottomNavigationBarHeight;
    if(!navIndexSet){
      currentNavBarIndex = positionBottomNavigationBar;
      navIndexSet = true;
    }
    //todo => localize data =>
    if(globals.userLanguage!="ru"){setDataKyrgyz();}

    if(globals.userLanguage=="ru"){setDataRussian();}

    return Scaffold(
      body: navBarList[currentNavBarIndex],
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(250, 250, 250, 1),
        child: Padding(
            padding: EdgeInsets.only(left: width*0.05 , right: width*0.05, bottom: 15),
            child: Container(
              height: bottomNavBarHeight,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(2, 48, 71, 1),
                borderRadius: BorderRadius.circular(15),
              ),
              width: width*0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        currentNavBarIndex = 0;
                      });
                    },
                    child: SizedBox(
                      width: width*0.25,
                      height: 45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/icon/homeicon.png',
                            width: 20, height: 20, color: (currentNavBarIndex==0)?selectedItemColor:unselectedColor,
                          ),
                          const SizedBox(height: 2,),
                          Text(
                              section_1,
                              style: TextStyle(fontSize: 14 ,
                                  color: (currentNavBarIndex==0)?selectedItemColor:unselectedColor,
                                  fontWeight: (currentNavBarIndex==0)?FontWeight.w500 : FontWeight.w300)
                          ),
                        ],
                      ),
                    )
                  ),
                  GestureDetector(
                    onTap: (){
                      if(globals.isUserRegistered){
                        setState(() {
                          currentNavBarIndex = 1;
                        });
                      }
                      else{
                        setState(() {
                          currentNavBarIndex = 2;
                        });
                      }
                    },
                    child: SizedBox(
                      width: width*0.25,
                      height: 45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/icon/adverticon.png',
                            width: 20, height: 20, color: (currentNavBarIndex==1)?selectedItemColor:unselectedColor,
                          ),
                          const SizedBox(height: 2,),
                          Text(
                              section_2,
                              style: TextStyle(fontSize: 14 ,
                                  color: (currentNavBarIndex==1)?selectedItemColor:unselectedColor ,
                                  fontWeight: (currentNavBarIndex==1)?FontWeight.w500 : FontWeight.w300)
                          ),
                        ],
                      ),
                    )
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        currentNavBarIndex = 2;
                      });
                    },
                    child: SizedBox(
                      width: width*0.25,
                      height: 45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/icon/usericon.png',
                            width: 20, height: 20, color: (currentNavBarIndex==2)?selectedItemColor:unselectedColor,
                          ),
                          const SizedBox(height: 2,),
                          Text(
                              section_3,
                              style: TextStyle(fontSize: 14 ,
                                  color: (currentNavBarIndex==2)?selectedItemColor:unselectedColor,
                                  fontWeight: (currentNavBarIndex==2)?FontWeight.w500 : FontWeight.w300)
                          ),
                        ],
                      ),
                    )
                  ),


                ],
              ),
            )
        ),
      ),
    );
  }
}


class CustomRectangularClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height-32);
    path.lineTo(0, size.height-32);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}