import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:unified_reminder/models/userauth.dart';
import 'package:unified_reminder/models/userbasic.dart';
import 'package:unified_reminder/router.dart';
import 'package:unified_reminder/screens/Dashboard.dart';
import 'package:unified_reminder/services/AuthService.dart';
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
  
  
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      key: _loginScaffold,
      appBar: AppBar(
        title: Text("Log In"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Text(
                "Welcome Back, ",
                style: _theme.textTheme.headline.merge(
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
                style: _theme.textTheme.subtitle.merge(
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
                        Text("Email Address"),
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
                        Text("Password"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          validator: (value) => validatePasswordLength(value),
                          onSaved: (value) => userAuth.password = value,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "Password",
                            suffixIcon: GestureDetector(child: Icon(Icons.remove_red_eye,color: Colors.white,),onTap: (){
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal: 16.0,
                            ),
  
                            fillColor: textboxColor,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.0,
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      decoration: roundedCornerButton,
                      height: 50.0,
                      child: FlatButton(
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
                            : Text("Login"),
                        onPressed: () {
                          loginUser(userAuth);
                        },
                      ),
                    ),
	                  
	                  SizedBox(height:30),
	                  Text("OR",textAlign: TextAlign.center,),
	                  SizedBox(
                      height: 20,
                    ),
	
	                  Container(
                      decoration: roundedCornerButton,
		                  height: 50.0,
		                  child: FlatButton(
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
			                  )
					                  : Row(
				                  mainAxisAlignment: MainAxisAlignment.start,
				                  children: <Widget>[
					
					                  Image.asset("assets/images/google_logo0_5p.png", height:50 ),
					                  SizedBox(width: 40),
					                  Text(
						                  "Login Using Google",
					                  ),
				                  ],
			                  ),
			                  onPressed: () async{
			                    try {
                            setState(() {
                              gButtonLoading = true;
                            });
                            UserBasic userBasic = await _auth.googleLogIn();
                            print("userbasic check" +userBasic.email);
                            if (userBasic != null) {
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context)=> ShowCaseWidget(
                                    builder: Builder(
                                      builder: (context)=>Dashboard(),
                                    ),
                                  ),
                                )
                              );
                            } else {}
                          }on PlatformException catch (e) {
                            flutterToast(message: "Something went Wrong");
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
                    
                    SizedBox(
                      height: 50.0,
                    ),
  
                    
                    
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(
                          "Dont have an account?",
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(RegisterTypeRoute);
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: linkColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
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
            padding: const EdgeInsets.all(8.0),
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
            padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
            child: Container(
              height: 50,
              child: FlatButton(
                color: buttonColor,
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
                  }
                  catch(e){
                    Fluttertoast.showToast(
                        msg: e.message,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 2,
                        backgroundColor: Color(0xff666666),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }finally{
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
  
  

  Future<void> loginUser(UserAuth authDetails) async {
    try {
      if (_loginFormKey.currentState.validate()) {
        _loginFormKey.currentState.save();
        this.setState(() {
          buttonLoading = true;
        });

        UserBasic userBasic = await _auth.loginUser(authDetails,context);
        print(userBasic.fullName);
        if (userBasic != null) {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ShowCaseWidget(
                builder: Builder(
                  builder: (context)=>Dashboard(),
                ),
              ),
            )
          );
        } else {}
      }
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      flutterToast(message: "Unable to login at the moment");
    } finally {
      this.setState(() {
        buttonLoading = false;
      });
    }
  }
  
  
}
