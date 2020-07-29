import 'package:flutter/material.dart';
import 'package:unified_reminder/router.dart';
import 'package:unified_reminder/styles/colors.dart';
import '../screens/RegisterPage.dart';



class RegisterType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 70.0,
            ),
            Text(
              "Register",
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
              "Select an account type",
              style: _theme.textTheme.subtitle.merge(
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => RegisterPage(
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 170.0,
                          color: buttonColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.work,
                                size: 32.0,
                              ),
                              Text("Professional")
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => RegisterPage(
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 170.0,
                          color: buttonColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.trending_up,
                                size: 32.0,
                              ),
                              Text("Businessman")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.0,
                ),
                
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already have an account?",
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(LoginPageRoute);
                      },
                      child: Container(
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
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
