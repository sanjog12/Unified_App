import 'package:flutter/material.dart';
import 'package:unified_reminder/models/personalDetail.dart';
import 'package:unified_reminder/services/AuthRelated/AuthService.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/validators.dart';

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final GlobalKey<FormState> _personalFormKey = GlobalKey<FormState>();
  final PersonalDetail _personalDetail = PersonalDetail();
  final AuthService _auth = AuthService();
  final FirestoreService firestoreService = FirestoreService();
  String firebaseUserId = "";
  bool buttonLoading = false;
  String _constitution;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  void getUserId() async {
    var _firebaseUserId = await SharedPrefs.getStringPreference("uid");
    this.setState(() {
      firebaseUserId = _firebaseUserId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: firestoreService.getUserDetails(firebaseUserId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String name = snapshot.data["fullname"].split(" ")[0];
                return Container(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Welcome $name!",
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
                        "Just a little more setup and we'll be up",
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
                        key: _personalFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: 30.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text("Constitution"),
                                SizedBox(
                                  height: 10.0,
                                ),
                                DropdownButtonFormField(
                                  hint: Text("Constitution"),
                                  validator: (String value) {
                                    return requiredField(value, "Constitution");
                                  },
                                  onSaved: (value) =>
                                      _personalDetail.constitution = value,
                                  decoration: buildCustomInput(),
                                  items: [
                                    DropdownMenuItem(
                                      child: Text("Individual"),
                                      value: "Individual",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Proprietorship"),
                                      value: "Proprietorship",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Partnership"),
                                      value: "Partnership",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Private Limited Company"),
                                      value: "Private",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Limited Company"),
                                      value: "Limited",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("LLP"),
                                      value: "LLP",
                                    )
                                  ],
                                  value: _constitution,
                                  onChanged: (String v) {
                                    this.setState(() {
                                      _constitution = v;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text("Company's Name"),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  validator: (String value) {
                                    return requiredField(
                                        value, "Company's Name");
                                  },
                                  onSaved: (value) =>
                                      _personalDetail.companyName = value,
                                  decoration: buildCustomInput(
                                      hintText: "Company's Name"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text("Nature of Business"),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  onSaved: (value) =>
                                      _personalDetail.natureOfBusiness = value,
                                  validator: (String value) {
                                    return requiredField(
                                        value, "Nature of Business");
                                  },
                                  decoration: buildCustomInput(
                                      hintText: "Nature of Business"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            Container(
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
                                    : Text("Continue"),
                                onPressed: () {
                                  addAdditionalInfo(_personalDetail);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Container(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  Future<void> addAdditionalInfo(PersonalDetail extraInfo) async {
    this.setState(() {
      buttonLoading = true;
    });
    if (_personalFormKey.currentState.validate()) {
      _personalFormKey.currentState.save();
      bool addedData = await _auth.setPersonalInformation(extraInfo);
      this.setState(() {
        buttonLoading = false;
      });
      if (addedData) {
        print('object');
//        Navigator.of(context).pushReplacementNamed(ApplicableCompliancesRoute);
//        if (widget.userType == 1) {
//          Navigator.of(context).pushNamed(SelectClientsRoute);
//        }
      } else {}
    }
  }
}
