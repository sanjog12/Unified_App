import 'package:flutter/material.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';

class AccountActivation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Activate Account"),
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
                        decoration: buildCustomInput(hintText: "Email Address"),
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
                        decoration: buildCustomInput(hintText: "Password"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    height: 50.0,
                    child: FlatButton(
                      child: Text("Login"),
                      onPressed: () {},
                      color: buttonColor,
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
                          onTap: () {},
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
    );
  }
}
