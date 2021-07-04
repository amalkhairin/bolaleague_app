import 'package:bolalucu_league/config/app_helper.dart';
import 'package:bolalucu_league/constant/colors.dart';
import 'package:bolalucu_league/model/user_model.dart';
import 'package:bolalucu_league/pages/final/final_detail.dart';
import 'package:bolalucu_league/pages/group_stage/group_list.dart';
import 'package:bolalucu_league/pages/list_of_team/list_of_teams_page.dart';
import 'package:bolalucu_league/pages/quarter_final/quarter_list_page.dart';
import 'package:bolalucu_league/pages/round_stage/round_list_page.dart';
import 'package:bolalucu_league/pages/semifinal/semifinal_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = User.instance;
  String message = "Loading...";

  Future<void> getMessage() async {
    var data = await AppHelper.getMessage();
    if(data['success']){
      if(mounted){
        setState(() {
          message = data['data'][0]['message'];
        });
      }
    } else {
      if(mounted){
        setState(() {
          message = "ERR: ${data['message']}";
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessage();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: getMessage,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    child: Image.asset("assets/img/logo.png", fit: BoxFit.fitWidth,),
                  ),
                  SizedBox(height: 18,),
                  Container(
                    width: screenSize.width,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: SelectableLinkify(
                        text: "$message",
                        onOpen: (link) async {
                          print(link.url);
                          if (await canLaunch(link.url)){
                            await launch(link.url);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 36,),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => GroupList())
                      );
                    },
                    child: Ink(
                      width: screenSize.width,
                      height: 185,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: screenSize.width,
                            height: 130,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/img/groupphase_img.png"),
                                fit: BoxFit.fill
                              ),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10),)
                            ),
                          ),
                          SizedBox(height: 14,),
                          Text("Group Stage", style: TextStyle(color: blueColor, fontSize: 18),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => RoundListPage())
                          );
                        },
                        child: Ink(
                          width: screenSize.width/2.4,
                          height: 185,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: screenSize.width/2.4,
                                height: 130,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/img/round16_img.png"),
                                    fit: BoxFit.fill
                                  ),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10),)
                                ),
                              ),
                              SizedBox(height: 14,),
                              Text("Round of 16", style: TextStyle(color: blueColor, fontSize: 18),)
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => QuarterListPage())
                          );
                        },
                        child: Ink(
                          width: screenSize.width/2.4,
                          height: 185,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: screenSize.width/2.4,
                                height: 130,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/img/quarter_img.png"),
                                    fit: BoxFit.fill
                                  ),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10),)
                                ),
                              ),
                              SizedBox(height: 14,),
                              Text("Quarter-finals", style: TextStyle(color: blueColor, fontSize: 18),)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SemifinalListPage())
                          );
                        },
                        child: Ink(
                          width: screenSize.width/2.4,
                          height: 185,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: screenSize.width/2.4,
                                height: 130,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/img/semifinal_img.png"),
                                    fit: BoxFit.fill
                                  ),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10),)
                                ),
                              ),
                              SizedBox(height: 14,),
                              Text("Semi-finals", style: TextStyle(color: blueColor, fontSize: 18),)
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => FinalDetailPage())
                          );
                        },
                        child: Ink(
                          width: screenSize.width/2.4,
                          height: 185,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: screenSize.width/2.4,
                                height: 130,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/img/final_img.png"),
                                    fit: BoxFit.fill
                                  ),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10),)
                                ),
                              ),
                              SizedBox(height: 14,),
                              Text("Final", style: TextStyle(color: blueColor, fontSize: 18),)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24,),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ListOfTeamsPage())
                      );
                    },
                    child: Ink(
                      width: screenSize.width,
                      height: 60,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("List of Registered Teams", textAlign: TextAlign.center, style: TextStyle(color: blueColor, fontSize: 18),)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}