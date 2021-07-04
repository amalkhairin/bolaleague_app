import 'dart:io';

import 'package:bolalucu_league/config/semifinal_helper.dart';
import 'package:bolalucu_league/constant/colors.dart';
import 'package:bolalucu_league/model/match_model.dart';
import 'package:bolalucu_league/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class SemifinalLegDetailPage extends StatefulWidget {
  final String? title;
  const SemifinalLegDetailPage({ Key? key, this.title }) : super(key: key);

  @override
  _SemifinalLegDetailPageState createState() => _SemifinalLegDetailPageState();
}

class _SemifinalLegDetailPageState extends State<SemifinalLegDetailPage> {
  TextDetector _textDetector = GoogleMlKit.vision.textDetector();
  var _inputImage;
  File? _image;
  final _picker = ImagePicker();
  User _user = User.instance;
  bool _isLoading = false;
  bool _isError = false;
  String _errMessage = "";
  List<MatchModel2> _listMatch = [];

  isValidMatchdayImage(String homeID, String awayID, List<String> result) {
    bool isHomeExist = false;
    bool isAwayExist = false;
    for (String item in result) {
      if (item.contains(homeID.toString())) {
        isHomeExist = true;
      }
      if (item.contains(awayID.toString())) {
        isAwayExist = true;
      }
    }
    if (isHomeExist == true && isAwayExist == true) {
      return true;
    } else {
      return false;
    }
  }

  loadSemifinalData() async {
    setState(() {
      _isLoading = true;
    });
    List<MatchModel2> _temp = [];
    var data = await SemifinalHelper.getSemifinalMatches(leg: widget.title);
    if (data['success']) {
      for (Map<String, dynamic> match in data['data']) {
        _temp.add(MatchModel2.fromJson(match));
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = false;
          _listMatch = _temp;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = true;
          _errMessage = data['message'];
        });
      }
    }
  }

  getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _inputImage = InputImage.fromFile(_image!);
      } else {
        print("No image selected");
      }
    });
  }

  extractText(String text) {
    List<String> _temp = text.split("\n");
    return _temp;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSemifinalData();
  }
  
  @override
  Widget build(BuildContext context) {
    Size screenSize = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    if(_isLoading){
      return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Center(
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(Icons.emoji_events, color: Colors.white, size: 64,),
                  ),
                  SizedBox(height: 14,),
                  CircularProgressIndicator(color: whiteColor,),
                ],
              )
            ),
          ),
        ),
      );
    } else {
      if (!_isError) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: backgroundColor,
            leading: IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back, color: blackColor,),
            ),
            title: Text("SemiFinal - Leg ${widget.title}", style: TextStyle(color: blackColor),),
            actions: [
              TextButton(
                onPressed: () async {
                  loadSemifinalData();
                },
                child: Text("Refresh"),
              )
            ],
          ),
          body: SafeArea(
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              child: ListView.builder(
                itemCount: _listMatch.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 14, left: 24, right: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (_listMatch[index].homeTeamID == _user.ownerId || _listMatch[index].awayTeamID == _user.ownerId) && _listMatch[index].isFinished != 1
                        ? ExpansionTile(
                          collapsedBackgroundColor: Color(0xFFFBFBFB),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(backgroundColor: Colors.blue, child: Text("${_listMatch[index].homeTeamName!.substring(0,1)}"),),
                                  Container(
                                    width: 80,
                                    child: Center(child: Text("${_listMatch[index].homeTeamName}", overflow: TextOverflow.ellipsis,))
                                  ),
                                ],
                              ),
                              Text("${_listMatch[index].homeScore} - ${_listMatch[index].awayScore}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                              Column(
                                children: [
                                  CircleAvatar(backgroundColor: Colors.orange, child: Text("${_listMatch[index].awayTeamName!.substring(0,1)}"),),
                                  Container(
                                    width: 80,
                                    child: Center(child: Text("${_listMatch[index].awayTeamName}", overflow: TextOverflow.ellipsis,))
                                  ),
                                ],
                              ),
                            ],
                          ),
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: InkWell(
                                    onTap: () async {
                                      await getImage();
                                    },
                                    child: Container(
                                      height: 180,
                                      width: screenSize.width,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: _image == null
                                          ? Center(child: Text("Upload Image"))
                                          : Image.file(_image!)
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                  child: SizedBox(
                                    width: screenSize.width,
                                    child: ElevatedButton(
                                      onPressed: () async{
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        RecognisedText recognisedText = await _textDetector.processImage(_inputImage);
                                        List<String> _tmp = extractText(recognisedText.text);
                                        bool isValid = isValidMatchdayImage(_listMatch[index].homeTeamName!, _listMatch[index].awayTeamName!, _tmp);
                                        print(isValid);
                                        if (isValid) {
                                          String homeTeam = "";
                                          for (String item in _tmp) {
                                            if (item == _listMatch[index].homeTeamName!){
                                              homeTeam = item;
                                              break;
                                            }
                                            if (item == _listMatch[index].awayTeamName!){
                                              homeTeam = item;
                                              break;
                                            }
                                          }
                                          var data = Map<String, dynamic>();
                                          if (homeTeam == _listMatch[index].homeTeamName!) {
                                            var home = _tmp[2];
                                            var away = _tmp[3];
                                            print("Score: $home - $away");
                                            data = await SemifinalHelper.updateSemifinalMatches(
                                              matchID: "${_listMatch[index].matchID}",
                                              leg: "${widget.title}",
                                              homeTeamId: "${_listMatch[index].homeTeamID}",
                                              awayTeamId: "${_listMatch[index].awayTeamID}",
                                              homeScore: home,
                                              awayScore: away,
                                            );
                                          } else if (homeTeam == _listMatch[index].awayTeamName!){
                                            var home = _tmp[3];
                                            var away = _tmp[2];
                                            print("Score: $home - $away");
                                            data = await SemifinalHelper.updateSemifinalMatches(
                                              matchID: "${_listMatch[index].matchID}",
                                              leg: "${widget.title}",
                                              homeTeamId: "${_listMatch[index].homeTeamID}",
                                              awayTeamId: "${_listMatch[index].awayTeamID}",
                                              homeScore: home,
                                              awayScore: away,
                                            );
                                          } else {
                                            data['success'] = false;
                                            data['message'] = "Invalid match result";
                                          }
                                          if (data['success']) {
                                            loadSemifinalData();
                                            setState(() {
                                              _image = null;
                                              _inputImage = null;
                                            });
                                          } else {
                                            setState(() {
                                              _image = null;
                                              _inputImage = null;
                                              _isLoading = false;
                                            });
                                            showDialog(
                                              context: this.context, 
                                              builder: (context) => AlertDialog(
                                                title: Text("ERR"),
                                                content: Text("${data['message']}"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: (){
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text("Ok"),
                                                  ),
                                                ],
                                              )
                                            );
                                          }
                                        } else {
                                          setState(() {
                                            _isLoading = false;
                                            _image = null;
                                            _inputImage = null;
                                          });
                                          showDialog(
                                            context: this.context, 
                                            builder: (BuildContext context) => AlertDialog(
                                              title: Text("ERR"),
                                              content: Text("Invalid match result"),
                                              actions: [
                                                TextButton(
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Ok"),
                                                ),
                                              ],
                                            )
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: blueColor,
                                        elevation: 0.0,
                                      ),
                                      child: Text("Save"),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(backgroundColor: Colors.blue, child: Text("${_listMatch[index].homeTeamName!.substring(0,1)}"),),
                                Container(
                                    width: 80,
                                    child: Center(child: Text("${_listMatch[index].homeTeamName}", overflow: TextOverflow.ellipsis,))
                                  ),
                              ],
                            ),
                            Text("${_listMatch[index].homeScore} - ${_listMatch[index].awayScore}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                            Column(
                              children: [
                                CircleAvatar(backgroundColor: Colors.orange, child: Text("${_listMatch[index].awayTeamName!.substring(0,1)}"),),
                                Container(
                                    width: 80,
                                    child: Center(child: Text("${_listMatch[index].awayTeamName}", overflow: TextOverflow.ellipsis,))
                                  ),
                              ],
                            ),
                          ],
                        )
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: Container(
              child: Center(
                child: Text("ERR: $_errMessage"),
              ),
            ),
          ),
        );
      }
    }
  }
}