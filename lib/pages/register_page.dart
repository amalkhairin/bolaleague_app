import 'package:bolalucu_league/config/user_helper.dart';
import 'package:bolalucu_league/constant/colors.dart';
import 'package:bolalucu_league/pages/login_page.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({ Key? key }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isSecure = true;
  bool _isLoading = false;
  TextEditingController _ownerIdController = TextEditingController();
  TextEditingController _teamNameController = TextEditingController();
  TextEditingController _waNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    Size screenSize = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 100,
                    child: Image.asset("assets/img/logo.png"),
                  ),
                  SizedBox(height: 24,),
                  TextFormField(
                    controller: _ownerIdController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter your Owner ID",
                      filled: true,
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _teamNameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "Enter your Team Name",
                      filled: true,
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _waNumberController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter your Whatsapp Number",
                      filled: true,
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isSecure,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      filled: true,
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      suffixIcon: InkWell(
                        onTap: (){
                          setState(() {
                            _isSecure = !_isSecure;
                          });
                        },
                        child: _isSecure? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                      ),
                    ),
                  ),
                  SizedBox(height: 64,),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: blueColor,
                        onPrimary: whiteColor
                      ),
                      onPressed: _isLoading? (){} : (_ownerIdController.text.isEmpty || _passwordController.text.isEmpty || _teamNameController.text.isEmpty || _waNumberController.text.isEmpty)? null : () async {
                        if (_ownerIdController.text.isNotEmpty || _passwordController.text.isNotEmpty || _teamNameController.text.isNotEmpty || _waNumberController.text.isNotEmpty) {
                          setState(() {
                            _isLoading = true;
                          });
                          var data = await UserHelper.signUp(
                            ownerId: _ownerIdController.text,
                            teamName: _teamNameController.text,
                            noWa: _waNumberController.text,
                            password: _passwordController.text
                          );
                          if(data['success']){
                            setState(() {
                              _isLoading = false;
                            });
                            if(data['data'][0]['status'] == 0){
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Register successfully"),
                                  content: Text("Please contact Admin to complete the registration"),
                                  actions: [
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Ok"),
                                    )
                                  ],
                                )
                              );
                            }
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Register failed!"),
                                content: Text("${data['message']}"),
                                actions: [
                                  TextButton(
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Ok"),
                                  )
                                ],
                              )
                            );
                          }
                        }
                      },
                      child: _isLoading? CircularProgressIndicator(color: whiteColor,) : Text("Register"),
                    ),
                  ),
                  SizedBox(height: 14,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => LoginPage())
                          );
                        },
                        child: Text("Login here"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}