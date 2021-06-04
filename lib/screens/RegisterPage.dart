
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:unified_reminder/models/userbasic.dart';
import 'package:unified_reminder/screens/Dashboard.dart';
import 'package:unified_reminder/services/AuthRelated/AuthService.dart';
import 'package:unified_reminder/services/GeneralServices/PDFView.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();
  final UserBasic _userBasic = UserBasic();
  bool submitButtonLoading = false;
  bool googleSignInButton = false;
  bool checkBox = false;
  GlobalKey first = GlobalKey();
  GlobalKey second = GlobalKey();
  GlobalKey third = GlobalKey();
  GlobalKey fourth = GlobalKey();
  ScrollController controller = ScrollController();
  
  tutorial() async{
    try {
      String temp = await SharedPrefs.getStringPreference("registerTutorial");
      print(temp);
      if (temp != "done") {
        controller.animateTo(controller.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ShowCaseWidget.of(this.context).startShowCase([first, second]);
          SharedPrefs.setStringPreference("registerTutorial", "done");
        });
      }
    }catch(e){
      debugPrint(e);
    }
  }

  @override
  void initState() {
    super.initState();
    tutorial();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        controller: controller,
        child: Container(
          padding: EdgeInsets.only(top: 24.0, right: 24, left: 24, bottom: 70),
          child: Form(
            key: _registerKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                  Text(
                  "Create Account",
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
                  "Register to own a free account today.",
                  style: _theme.textTheme.bodyText2.merge(
                    TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Full Name"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            decoration: buildCustomInput(hintText: "Full Name"),
                            onSaved: (String value) =>
                            _userBasic.fullName = value,
                            validator: (String value) {
                              return requiredField(value, "Full Name");
                            }),
                      ],
                    ),
                    
                    SizedBox(
                      height: 30.0,
                    ),
  
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Mobile Number"),
      
                        SizedBox(
                          height: 10.0,
                        ),
      
                        TextFormField(
                          maxLength: 10,
                          validator: (String value) {
                            if(value.length<10){
                              return "Invalid length";
                            }
                            return requiredField(value, "Mobile number");
                            },
                          onSaved: (String value) =>
                          _userBasic.phoneNumber = value,
                          decoration:
                          buildCustomInput(hintText: "Mobile Number"),
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                    
                    SizedBox(
                      height: 30.0,
                    ),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Email Address"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          validator: (String value) {
                            return validateEmail(value);
                            },
                          onSaved: (String value) => _userBasic.email = value,
                          decoration: buildCustomInput(hintText: "Email Address"),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Password",),
                        
                        SizedBox(
                          height: 10.0,
                        ),
                        
                        TextFormField(
                          validator: (String value) {
                            return validatePasswordLength(value);
                            },
                          onChanged: (String value) =>
                          _userBasic.password = value,
                          obscureText: true,
                          decoration: buildCustomInput(hintText: "Password"),
                        ),
                      ],
                    ),
                    
                    
                    SizedBox(
                      height: 30.0,
                    ),
                    
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Confirm Password"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          validator: (String value) {
                            return validatePasswordMatch(value, _userBasic.password);},
                          obscureText: true,
                          decoration:
                          buildCustomInput(hintText: "Confirm Password"),
                        ),
                      ],
                    ),
  
                    SizedBox(
                      height: 50.0,
                    ),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilterChip(
                          avatar: CircleAvatar(
                            backgroundColor: buttonColor,
                          ),
                          labelPadding: EdgeInsets.all(5),
                          label: Text("Click to agree with T&C and Privacy Policy"),
                          selected: checkBox,
                          onSelected: (temp){
                            setState(() {
                              checkBox = temp;
                            });
                          },
                        ),
                        
                        // Row(
                        //   children: [
                        //     Checkbox(
                        //       onChanged: (bool temp){
                        //         setState(() {
                        //           checkBox = temp;
                        //         });
                        //       },
                        //       value: checkBox,
                        //     ),
                        //     Text("By clicking on the tab you agree with T&C and Privacy Policy of this app",overflow: TextOverflow.clip,),
                        //   ],
                        // ),
                        
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              child: Text("T&C",style: TextStyle(fontSize: 10, color: Colors.blue),),
                              onTap: (){
                                Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context)=>PDFViewer(
                                        pdf: "apptc.pdf",
                                      )
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              child: Text("Privacy Policy",style: TextStyle(fontSize: 10, color: Colors.blue),),
                              onTap: (){
                                Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context)=>PDFViewer(
                                        pdf: "privacypolicy.pdf",
                                      )
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 30,),
                          ],
                        )
                      ],
                    ),
                    
                    SizedBox(
                      height: 50.0,
                    ),
                    
                    Showcase(
                      key: first,
                      description: "Register your self using above fields",
                      child: Container(
                        decoration: roundedCornerButton,
                        height: 50.0,
                        child: TextButton(
                          child: submitButtonLoading
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
                                : Text(
                                    "Register",style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                            onPressed: () {
                              createUser();
                            },
                          ),
                        ),
                      ),
                      
                      SizedBox(
                        height: 30,
                      ),
                      Text("OR",textAlign: TextAlign.center),
                      SizedBox(
                        height: 20,
                      ),
  
                      Showcase(
                        showArrow: true,
                        key: second,
                        description: "Or register using Google",
                        child: Container(
                          decoration: roundedCornerButton,
                          height: 50,
                          child: TextButton(
                            child: googleSignInButton
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
                                SizedBox(width: 40,),
                                Text(
                                  "Sign up with Google",style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            onPressed: () {
                              googleSignIn();
                            },
                          ),
                        ),
                      ),
                      
                      SizedBox(
                        height: 30.0,
                      ),
                      
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have an account?",
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: linkColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
//
//  Widget dropDownForUserType() {
//    return DropdownButtonFormField(
//      hint: Text('User Type'),
//      validator: (String value) {
//        return requiredField(value, 'User Type');
//      },
//      onSaved: (value) => _userBasic.userType = value,
//      decoration: buildCustomInput(),
//      items: [
//        DropdownMenuItem(
//          child: Text('Profecional'),
//          value: 'Pro',
//        ),
////        DropdownMenuItem(
////          child: Text('Regular'),
////          value: 'Regular',
////        )
//      ],
////      items: [
////        DropdownMenuItem(
////          child: Text('Profecional'),
////          value: 'Profecional',
////        ),
////        DropdownMenuItem(
////          child: Text("Regular"),
////          value: "Regular",
////        )
////      ],
//      value: _userType,
//      onChanged: (String v) {
//        this.setState(() {
//          _userType = v;
//        });
//      },
//    );
////    return DropdownButton<String>(
////      value: userTypes[userTypeIndex],
////      icon: Icon(Icons.arrow_downward),
////      iconSize: 24,
////      elevation: 16,
////      underline: Container(
////        height: 2,
////      ),
////      onChanged: (String newValue) {
////        setState(() {
////          userTypeIndex = userTypes.indexOf(newValue);
////          _userBasic.userType = newValue;
////        });
////      },
////      items: userTypes.map<DropdownMenuItem<String>>((String value) {
////        return DropdownMenuItem<String>(
////          value: value,
////          child: DropDownSingleItem(
////            label: value,
////          ),
////        );
////      }).toList(),
////    );
//  }

//  Widget dropDownForUserConstitution() {
//    return DropdownButton<String>(
//      value: constitutionsTypes[userConstitutionIndex],
//      icon: Icon(Icons.arrow_downward),
//      iconSize: 24,
//      elevation: 16,
//      underline: Container(
//        height: 2,
//      ),
//      onChanged: (String newValue) {
//        setState(() {
//          userConstitutionIndex = constitutionsTypes.indexOf(newValue);
//          _userBasic.userConstitution = newValue;
//        });
//      },
//      items: constitutionsTypes.map<DropdownMenuItem<String>>((String value) {
//        return DropdownMenuItem<String>(
//          value: value,
//          child: DropDownSingleItem(
//            label: value,
//          ),
//        );
//      }).toList(),
//    );
//  }

  Future<void> createUser() async {
    if (_registerKey.currentState.validate()) {
      _registerKey.currentState.save();
      if (checkBox == true) {
        this.setState(() {
          submitButtonLoading = true;
        });
        AuthService _authService = AuthService();
    
        UserBasic user = await _authService.registerProUser(_userBasic);
    
        flutterToast(message: "Log in Successful");
    
        this.setState(() {
          submitButtonLoading = false;
        });
        if (user != null) {
          print(user);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ShowCaseWidget(
                      builder: Builder(
                        builder: (context) =>
                            Dashboard(
                              userBasic: user,
                            ),
                      ),
                    ),
              )
          );

//        Navigator.of(context).pushReplacementNamed(PersonalInfoRoute);
        } else {
          print("Didnt create");
        }
      }
      else{
        flutterToast(message: "Please agree with T&C and Privacy Policy");
      }
    }
  }
  
  Future<void>  googleSignIn() async {
    if (checkBox) {
      this.setState(() {
        googleSignInButton = true;
      });
      AuthService _authService = AuthService();
    
      _userBasic.userType = 'bus';
    
      UserBasic googleUser = await _authService.googleSignup(
          _userBasic.userType);
      this.setState(() {
        googleSignInButton = false;
      });
    
    
      if (googleUser != null) {
        print(googleUser);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ShowCaseWidget(
                  builder: Builder(
                    builder: (context) =>
                        Dashboard(
                          userBasic: googleUser,
                        ),
                  ),
                ),
          ),
        );
      }
    }
    else{
      flutterToast(message: "Please agree with T&C and Privacy Policy");
    }
  }
}
