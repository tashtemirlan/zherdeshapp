import 'package:flutter/material.dart';
import 'package:zherdeshmobileapplication/GlobalVariables/global_variables.dart' as globals;


class PrivacyPage extends StatefulWidget{
  const PrivacyPage({super.key});

  @override
  PrivacyPageState createState ()=> PrivacyPageState();
}
class PrivacyPageState extends State<PrivacyPage>{

  String topic = "";
  String data1 = "";
  String topic1 = "";
  String data2 = "";
  String data3 = "";
  String topic3 = "";
  String data4 = "";
  String topic5 ="";
  String data5 = "";
  String topic6 ="";
  String data6 = "";
  String topic7 ="";
  String data7 = "";
  String data8 = "";
  void setDataRussian(){
    topic = "Правила размещения";
    data1 = "При регистрации на zherdesh.ru - Пользователь соглашается с настоящими правилами и несет полную ответственность за ее содержание и возможные последствия его публикации. Zherdesh.ru уважает ваше право и соблюдает конфиденциальность при заполнении, передачи и хранении ваших конфиденциальных сведений."
        "\n\nВнимание! Нарушение правил публикации может привести к ограничению доступа на длительный срок.";
    topic1 = "Общие условия";
    data2 = "Содержание рекламных объявлений не должно противоречить Федеральному закону «О рекламе» № 38-ФЗ от 13.03.2006 г.\nНедобросовестная, недостоверная, неэтичная реклама недопустима.\nПользователь может иметь только одну учетную запись на сайте.\nЗапрещено размещение дублирующих объявлений или нескольких объявлений одного и того же товара/услуги с разных email.\nЗапрещаются к размещению объявления, содержащие в себе призывы к насилию и противоправным действиям; дискриминацию по национальному, расовому, религиозному, половому и другим признакам; ненормативную лексику; оскорбительные высказывания различного характера; мошенничество и вымогательство.\nРаздел должен максимально соответствовать тематике Вашего объявления. Размещение объявления в неверный раздел может привести перемещению в более подходящий раздел или вовсе к удалению.\nК публикации принимаются объявления на: русском языке, кыргызском языке, транслите.";
    topic3 = "Правила пользования";
    data3 = "Для подачи объявления, необходимо зарегистрироваться. После авторизации Пользователю доступны Личный кабинет и опции:\n   Добавления нового объявления;\n   Удаления добавленного объявления;\n   Обновления добавленного объявления (Пользователь имеет возможность обновить свое объявление);";
    data4 = "Ограничений по количеству не будет, если они будут разными по содержанию.\nПри добавлении дублирующего объявления, имеющиеся объявления со схожим смыслом будут удалены. Для экономии времени и во избежание лишних кликов рекомендуется отредактировать объявление.\nСрок размещения объявления неограничен.";
    topic5 = "Фотографии:";
    data5 = "Фотография должна максимально подходить к тексту и разделу объявления.";
    topic6 = "Заголовок:";
    data6 = "Заголовок объявления должен соответствовать его содержанию;\nОбъявления в заголовке не должно содержать номер телефона, E-mail, адрес сайта, информацию о цене товара/услуги, станцию метро (любую другую информацию о месте расположения);\nВ заголовке объявления не допускается использование верхнего регистра, за исключением первых заглавных букв и имен собственных (целиком в верхнем регистре могут быть написаны только аббревиатуры), слов - псевдографики, разделения букв пробелами.";
    topic7 = "Текст объявления:";
    data7 = "Текст объявления должен содержать максимально подробную информацию о товаре/услуге, которые Вы предлагаете/ищите;\nВ тексте объявления не допускается использование верхнего регистра, за исключением первых заглавных букв и имен собственных (целиком в верхнем регистре могут быть написаны только аббревиатуры), слов - псевдографики, разделения букв пробелами";
    data8 = "Аккаунты пользователей, нарушивших правила размещения, будут заблокированы, а объявления не будут опубликованы.";
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //todo => localize data =>
    if(globals.userLanguage!="ru"){setDataRussian();}

    if(globals.userLanguage=="ru"){setDataRussian();}
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:Padding(padding: EdgeInsets.only(top: statusBarHeight, left: width*0.025, right: width*0.025),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close, color: Colors.black, size: 30,),
                      ),
                    ],
                  ),
                const SizedBox(height: 10,),
                SizedBox(
                    height: 36 ,
                    width: width*0.95,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        topic ,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                ),
                const SizedBox(height: 5,),
                SizedBox(
                    width: width*0.95,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        data1 ,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300,
                        ),
                      ),
                    )
                ),
                const SizedBox(height: 5,),
                SizedBox(
                    width: width*0.95,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        topic1 ,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                ),
                const SizedBox(height: 5,),
                SizedBox(
                    width: width*0.95,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        data2,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300,
                        ),
                      )
                    )
                ),
                const SizedBox(height: 5,),
                SizedBox(
                    width: width*0.95,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        topic3 ,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                ),
                const SizedBox(height: 5,),
                SizedBox(
                    width: width*0.95,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          data3,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300,
                          ),
                        )
                    )
                ),
                const SizedBox(height: 15,),
                SizedBox(
                    width: width*0.95,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          data4,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300,
                          ),
                        )
                    )
                ),

                const SizedBox(height: 5,),
                SizedBox(
                    width: width*0.95,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        topic5 ,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                ),
                const SizedBox(height: 5,),
                SizedBox(
                    width: width*0.95,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          data5,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300,
                          ),
                        )
                    )
                ),

                const SizedBox(height: 5,),
                SizedBox(
                    width: width*0.95,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        topic6 ,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                ),
                const SizedBox(height: 5,),
                SizedBox(
                    width: width*0.95,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          data6,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300,
                          ),
                        )
                    )
                ),

                const SizedBox(height: 5,),
                SizedBox(
                    width: width*0.95,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        topic7 ,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                ),
                const SizedBox(height: 5,),
                SizedBox(
                    width: width*0.95,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          data7,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300,
                          ),
                        )
                    )
                ),
                const SizedBox(height: 15,),
                SizedBox(
                    width: width*0.95,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          data8,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300,
                          ),
                        )
                    )
                ),
              ]
            ),
          ),
        )
    );
  }
}