import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;
import 'package:zherdeshmobileapplication/Search/search_result.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String searchText = "";
  String closeText = "";
  String youSearched = "";

  TextEditingController searchController = TextEditingController();

  bool dataGet = false;

  List<String> searchDataString = [];

  void setDataKyrgyz(){
    searchText = "Издөө";
    closeText = "Айынуу";
    youSearched = "Сиз издеп жүрдүңүз";
  }
  void setDataRussian(){
    searchText = "Поиск";
    closeText = "Отмена";
    youSearched = "Вы искали";
  }

  Widget searchTextEditField (width){
    return SizedBox(
      width: width*0.75,
      child: TextFormField(
          controller: searchController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          autofocus: true,
          onFieldSubmitted: (value) async{
            //navigate to search result page =>
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SearchResultPage(
                  searchData : value,
                )));
            //add this from hive =>
            var box = await Hive.openBox("SearchHistory");
            setState(() {
              searchDataString.add(value);
              box.put("SearchList", searchDataString);
            });
            //clear search text controller =>
            searchController.clear();
          },
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
            hintStyle: const TextStyle(fontSize: 16 , color: Color.fromRGBO(154, 154, 154, 1) , fontWeight: FontWeight.w400),
            hintText: searchText,
            fillColor: Colors.white,
            filled: true,
            errorStyle:const TextStyle(
              color: Color.fromRGBO(255, 0, 0, 0.5),
              fontSize: 12,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 1,
            prefixIcon: const SizedBox(
              width: 18,
              height: 18,
              child: Align(
                alignment: Alignment.center,
                child: FaIcon(FontAwesomeIcons.magnifyingGlass , size: 16, color: Color.fromRGBO(133, 133, 133, 1),),
              ),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  searchController.clear();
                });
              },
            ),
          ),
          style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
      ),
    );
  }

  Widget historyOfSearch(width){
    return (searchDataString.isNotEmpty)?SizedBox(
      width: width,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: searchDataString.length,
        padding: const EdgeInsets.all(0),
          itemBuilder: (context, index){
            return Card(
              child: ListTile(
                tileColor: const Color.fromRGBO(250, 250, 250, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Color.fromRGBO(188, 188, 188, 0.4), // Border color
                    width: 1.0, // Border width
                  ),
                ),
                leading: const FaIcon(FontAwesomeIcons.clockRotateLeft, size: 16, color: Color.fromRGBO(133, 133, 133, 1),),
                title: Text(searchDataString[index], style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black)),
                trailing: GestureDetector(
                  onTap: () async{
                    //delete this from hive =>
                    var box = await Hive.openBox("SearchHistory");
                    setState(() {
                      searchDataString.remove(searchDataString[index]);
                      box.put("SearchList", searchDataString);
                    });
                  },
                  child: const FaIcon(FontAwesomeIcons.trash, size: 16, color: Color.fromRGBO(30, 29, 33, 1),),
                ),
              ),
            );
          }
      ),
    ) : const SizedBox();
  }

  Future<void> getHistory() async{
    // we need to get history from Hive =>
    var box = await Hive.openBox("SearchHistory");
    bool anyRecordHistory = box.containsKey("SearchList");
    print("HERE IS STORY : $anyRecordHistory");
    if(anyRecordHistory){
      // if we have any search inside =>
      searchDataString = box.get("SearchList");
      print("Here is story");
      print(searchDataString);
    }
    else{
      print("No any story");
    }
  }

  Future<void> getHistorySearch() async{
    print("GET DATA STORY PAGE");
    await getHistory();
    if(mounted){
      setState(() {
        dataGet = true;
      });
    }
  }


  @override
  void dispose() {
    FocusScope.of(context).unfocus();
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //todo => localize data =>
    if(globals.userLanguage!="ru"){setDataKyrgyz();}

    if(globals.userLanguage=="ru"){setDataRussian();}

    getHistorySearch();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double mainSizedBoxHeightUserNotLogged = height- statusBarHeight;

    return WillPopScope(
      onWillPop: () async{
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();
        return true;
      },
      child:  Scaffold(
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
                    //search
                    Padding(
                      padding: EdgeInsets.only(left: width*0.025 , right: width*0.025, top: 10),
                      child: Container(
                        width: width*0.95,
                        height: mainSizedBoxHeightUserNotLogged*0.06,
                        color: const Color.fromRGBO(250, 250, 250, 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: mainSizedBoxHeightUserNotLogged*0.06,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  border: Border.all(
                                    color: const Color.fromRGBO(234, 234, 234, 1),
                                    width: 1.0, // Adjust the width as needed
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: searchTextEditField(width),
                              ),
                            GestureDetector(
                              onTap: ()async{
                                  FocusScope.of(context).unfocus();
                                  Future.delayed(const Duration(milliseconds: 200), () {
                                    Navigator.of(context).pop();
                                  });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  height: mainSizedBoxHeightUserNotLogged*0.06,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        closeText, textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 16 , color: Color.fromRGBO(70, 170, 232, 1))),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // making others to scroll =>
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.025),
                      child: SizedBox(
                        width: width*0.95,
                        height: mainSizedBoxHeightUserNotLogged*0.94-20,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Вы искали =>
                              SizedBox(
                                width: width*0.95,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5 , horizontal: 5),
                                  child: Text(
                                    youSearched , style: const TextStyle(fontSize: 16 , color: Color.fromRGBO(30, 29, 33, 1), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              // история поиска
                              const SizedBox(height: 10,),
                              historyOfSearch(width)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
            ),
          )
      ),
    );
  }
}
