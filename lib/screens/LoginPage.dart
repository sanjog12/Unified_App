import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:unified_reminder/models/userauth.dart';
import 'package:unified_reminder/models/userbasic.dart';
import 'package:unified_reminder/screens/Dashboard.dart';
import 'package:unified_reminder/screens/RegisterPage.dart';
import 'package:unified_reminder/services/AuthRelated/AuthService.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';
import 'package:unified_reminder/services/NotificationWork.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';
import 'package:fluttertoast/fluttertoast.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage>{
  
  bool buttonLoading = false;
  bool gButtonLoading = false;
  AuthService _auth = AuthService();
  UserAuth userAuth = UserAuth();
  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _loginScaffold = GlobalKey<ScaffoldState>();
  bool obscureText = true;
  GlobalKey key = GlobalKey();
  GlobalKey first = GlobalKey();
  GlobalKey second = GlobalKey();
  GlobalKey third = GlobalKey();
  
  Future<void> tutorialFirst() async{
    try {
      String temp = await SharedPrefs.getStringPreference("loginTutorial");
      print(temp);
      if (temp != "done") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ShowCaseWidget.of(this.context).startShowCase([first]);
          SharedPrefs.setStringPreference("loginTutorial", "done");
        });
      }
    }on MissingPluginException catch(e){
      debugPrint(e.message);
    }catch(e){
      print(e);
    }
  }


  Future<void> tutorialSecond() async{
    try {
      String temp = await SharedPrefs.getStringPreference("loginTutorial");
      String temp2 = await SharedPrefs.getStringPreference("login2Tutorial");
      print(temp);
      if (temp == "done") {
        if(temp2 != "done"){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ShowCaseWidget.of(this.context).startShowCase([second, third]);
            SharedPrefs.setStringPreference("login2Tutorial", "done");
          });
        }
      }
    }catch(e){
      debugPrint(e);
    }
  }
  
  @override
  void initState() {
    super.initState();
    tutorialFirst();
    tutorialSecond();
  }
  
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      key: _loginScaffold,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Tax Reminder",style: _theme.textTheme.headline6,),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              Text(
                "Welcome Back, ",
                style: _theme.textTheme.headline6.merge(
                  TextStyle(
                    fontSize: 26.0,
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Sign In to Continue",
                style: _theme.textTheme.bodyText2.merge(
                  TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Form(
                key: _loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Email Address", style: _theme.textTheme.bodyText2,),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          validator: (value) => validateEmail(value),
                          onSaved: (value) => userAuth.email = value,
                          decoration:
                              buildCustomInput(hintText: "Email Address"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Password", style: _theme.textTheme.bodyText2,),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          validator: (value) => validatePasswordLength(value),
                          onSaved: (value) => userAuth.password = value,
                          obscureText: obscureText,
                          decoration: buildCustomInput(hintText: "Password").copyWith(
                            suffixIcon: GestureDetector(
                              child: Icon(obscureText?Icons.remove_red_eye:Icons.visibility_off,color: Colors.white,),
                              onTap: (){
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },),
                          ),
                        ),
                      ],
                    ),
  
                    SizedBox(
                      height: 5,
                    ),
  
                    Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          enterEmailDialog();
                        },
                        child: Text(
                          "Forgot Password?",
                          style: _theme.textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ),
                    ),
                    
                    SizedBox(
                      height: 40.0,
                    ),
                    Showcase(
                      key: second,
                      description: "Login using your credentials",
                      child: Container(
                        decoration: roundedCornerButton,
                        height: 50.0,
                        child: TextButton(
                          child: buttonLoading
                              ? Container(
                                  height: 30.0,
                                  width: 30.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3.0,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text("Login", style: _theme.textTheme.bodyText2.copyWith(color: Colors.white)),
                          onPressed: () {
                            loginUser(userAuth, context);
                          },
                        ),
                      ),
                    ),
	                  
	                  SizedBox(height:30),
	                  Text("OR",textAlign: TextAlign.center,),
	                  SizedBox(
                      height: 20,
                    ),
	
	                  Showcase(
                      key: third,
	                    description: "Continue with google login",
	                    child: Container(
                      decoration: roundedCornerButton,
		                  height: 50.0,
		                  child: TextButton(
			                  child: gButtonLoading
					                  ? Container(
				                  height: 30.0,
				                  width: 30.0,
				                  child: CircularProgressIndicator(
					                  strokeWidth: 3.0,
					                  valueColor: AlwaysStoppedAnimation(
						                  Colors.white,
					                  ),
				                  ),
			                  ) :
                        Stack(
				                  children: <Widget>[
					                  Image.asset("assets/images/google_logo0_5p.png", height:50 ),
					                  SizedBox(width: 40),
					                  Center(
					                    child: Text(
						                  "Login Using Google", style: _theme.textTheme.bodyText2.copyWith(color: Colors.white),
					                    ),
					                  ),
				                  ],
			                  ),
			                  onPressed: () async{
			                    try {
                            setState(() {
                              gButtonLoading = true;
                            });
                            UserBasic userBasic = await _auth.googleLogIn();
                            if (userBasic != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Login Successful, Welcome ${userBasic.fullName?? "User"}",
                                      textAlign: TextAlign.center,
                                    ),
                                    duration: Duration(seconds: 7),
                                  )
                              );
                              NotificationServices.firebaseMessagingFCM();
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ShowCaseWidget( builder: Builder(
                                      builder: (context) => Dashboard(userBasic: userBasic,),),
                                    ),
                                  )
                              );
                            }
                          }on PlatformException catch (e) {
                            flutterToast(message: e.message);
                          } catch(e){
                            flutterToast(message: "Can't Sign In at this Moment");
                          } finally {
                            this.setState(() {
                              gButtonLoading = false;
                            });
                          }
			                  },
		                  ),
	                    ),
	                  ),
                    
                    SizedBox(
                      height: 50.0,
                    ),
                    
                    Showcase(
                      key: first,
                      description: "New to Tax Reminder? Click here to join now",
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Text(
                            "Dont have an account?", style: _theme.textTheme.bodyText2,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                  MaterialPageRoute(
                                    builder: (context)=>ShowCaseWidget(builder: Builder(
                                      builder: (context)=>RegisterPage(),
                                    ))
                                  )
                                );
                              },
                              child: Text(
                                "Sign Up",
                                style: _theme.textTheme.bodyText2.copyWith(
                                  color: linkColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
  
  
  Future<void> enterEmailDialog() async{
    
    String st;
    bool loading = false;
    showDialog(
        context: context,
        builder: (BuildContext context){
      return SimpleDialog(
        title: Text('Reset your passward'),
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) => validateEmail(value),
              
              onChanged: (value) {
                setState(() {
                  st=value;
                });
              },
              decoration:
              buildCustomInput(hintText: "Email Address"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
            child: Container(
              height: 50,
              child: TextButton(
                child: loading ? Container(
                  height: 30,
                    width: 30,
                    child:CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation(
                    Colors.white,
                  ),
                )
                )
                    :Text('Reset'),
                onPressed: (){
                  setState(() {
                    loading = true;
                  });
                  print(st);
                  try{
                    _auth.resetPassword(st,context);
                  } on PlatformException catch(e){
                    flutterToast(message: e.message);
                  } finally{
                    loading= false;
                  }
                },
              ),
            ),
          ),
        ],
      );
    }
    );
  }
  
  

  Future<void> loginUser(UserAuth authDetails, BuildContext context) async {
    try {
      if (_loginFormKey.currentState.validate()) {
        _loginFormKey.currentState.save();
        this.setState(() {
          buttonLoading = true;
        });

        UserBasic userBasic = await _auth.loginUser(authDetails,context);
        if (userBasic != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login Successful, Welcome ${userBasic.fullName?? "User"}",
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 7),
            )
          );
          NotificationServices.firebaseMessagingFCM();
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ShowCaseWidget(
                builder: Builder(
                  builder: (context)=>Dashboard(
                    userBasic: userBasic,
                  ),
                ),
              ),
            )
          );
        } else {}
      }
    } on PlatformException catch (e) {
      flutterToast(message: e.message);
    } catch (e) {
      print(e);
      flutterToast(message: "Unable to login at the moment");
    } finally {
      this.setState(() {
        buttonLoading = false;
      });
    }
  }
  
  
}
