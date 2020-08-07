import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/compliance.dart';
import 'package:unified_reminder/screens/Dashboard.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/validators.dart';


class AddSingleClient extends StatefulWidget {
  final Map arguments;

  const AddSingleClient({this.arguments});
  @override
  _AddSingleClientState createState() => _AddSingleClientState();
}

class _AddSingleClientState extends State<AddSingleClient>{
  String _constitution;
  FirestoreService fireStoreService = FirestoreService();
  bool buttonLoading = false;
  GlobalKey<FormState> _clientsFormKey = GlobalKey<FormState>();
  Client _client = Client('', '', '', '', '', '', '');
  List<Compliance> _compliances = [];
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  
  
  Future<void> subscribeTopic(String compliance, bool subscribe) async{
    if(subscribe){
      firebaseMessaging.subscribeToTopic(compliance.replaceAll(' ', '_f'));
    }
    else if(subscribe){
      firebaseMessaging.unsubscribeFromTopic(compliance);
    }
  }
  

  @override
  Widget build(BuildContext context) {
    _compliances.add(Compliance(title: "Income Tax", value: "income_tax", checked: false));
    _compliances.add(Compliance(title: "TDS", value: "tds", checked: false));
    _compliances.add(Compliance(title: "GST", value: "gst", checked: false));
    _compliances.add(Compliance(title: "EPF", value: "epf", checked: false));
    _compliances.add(Compliance(title: "ESI", value: "esi", checked: false));
    _compliances.add(Compliance(title: "ROC", value: "roc", checked: false));
    _compliances.add(Compliance(title: "LIC", value: "lic", checked: false));
    _compliances.add(Compliance(title: "PPF", value: "ppf", checked: false));
    _compliances.add(Compliance(title: "MUTUAL FUND", value: "mf", checked: false));
    _compliances.add(Compliance(title: "FIXED DEPOSIT", value: "fd", checked: false));
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Client'),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        color: backgroundColor,
        child: Form(
          key: _clientsFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  child: clientForm(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  decoration: roundedCornerButton,
                  child: FlatButton(
                    child: buttonLoading
                        ? CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                        )
                        : Text("Save"),
                    onPressed: () {
                      saveClients(_client, _compliances);
                    },
                    color: buttonColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveClients(Client clients, List<Compliance> compliances) async {
    print(clients.toString());
    if (_clientsFormKey.currentState.validate()) {
      _clientsFormKey.currentState.save();
      print("Yo man");
      this.setState(() {
        buttonLoading = true;
      });
      try {
        if (_clientsFormKey.currentState.validate()) {
          _clientsFormKey.currentState.save();
          print("Yo man");
          this.setState(() {
            buttonLoading = true;
          });

          bool savedClients =
              await fireStoreService.addClient(clients, compliances);
          this.setState(() {
            buttonLoading = false;
          });
          if (savedClients) {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=>Dashboard()
            ));
          } else {}
        }
      } catch (e, stack) {
        print(e);
        print(stack);
      }
//        bool savedClients = await _firestoreService.saveClients(clients);
      this.setState(() {
        buttonLoading = false;
      });
    }
  }

  Widget clientForm() {
//    print(compliances);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
//      Padding(
//        padding: const EdgeInsets.only(bottom: 24.0),
//        child: Text(
//          clientId == -1 ? '' : "Client #${clientId + 1}",
//          style: TextStyle(
//            fontSize: 18.0,
//          ),
//        ),
//      ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("Client's Name"),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              validator: (value) => requiredField(value, "Client's Name"),
              decoration: buildCustomInput(hintText: "Client's Name"),
              onSaved: (value) => _client.name = value,
            ),
          ],
        ),
        SizedBox(
          height: 30.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("Client's Constitution"),
            SizedBox(
              height: 10.0,
            ),
            DropdownButtonFormField(
              hint: Text("Constitution"),
              validator: (value) {
                return requiredField(value, "Constitution");
              },
              onSaved: (value) => _client.constitution = _constitution,
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
              onChanged: (v) {
                setState(() {
                  _constitution = v;
                });
              },
            ),
          ],
        ),
        SizedBox(
          height: 40.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("Client's Company Name"),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              onSaved: (value) => _client.company = value,
              validator: (value) =>
                  requiredField(value, "Client's Company Name"),
              decoration: buildCustomInput(hintText: "Client's Company Name"),
            ),
          ],
        ),
        SizedBox(
          height: 40.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("Client's Email Address"),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator: (value) => validateEmail(value),
              onSaved: (value) => _client.email = value,
              decoration: buildCustomInput(hintText: "Client's Email Address"),
            ),
          ],
        ),
        SizedBox(
          height: 40.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("Client's Nature of Business"),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              onSaved: (value) => _client.natureOfBusiness = value,
              validator: (value) =>
                  requiredField(value, "Client's Nature of Business"),
              decoration:
                  buildCustomInput(hintText: "Client's Nature of Business"),
            ),
          ],
        ),
        SizedBox(
          height: 40.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("Client's Mobile Number"),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              onSaved: (value) => _client.phone = value,
              validator: (value) =>
                  requiredField(value, "Client's Mobile Number"),
              keyboardType: TextInputType.phone,
              decoration: buildCustomInput(
                hintText: "Client's Mobile Number",
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40.0,
        ),
        Wrap(
          children: <Widget>[
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      _compliances[0].checked = value;
                    });
                    subscribeTopic(_compliances[0].title, value);
                  },
                  value: _compliances[0].checked,
                ),
                Text(_compliances[0].title),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      _compliances[1].checked = value;
                    });
                    subscribeTopic(_compliances[1].title, value);
                  },
                  value: _compliances[1].checked,
                ),
                Text(_compliances[1].title),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      _compliances[2].checked = value;
                    });
                    subscribeTopic(_compliances[2].title, value);
                  },
                  value: _compliances[2].checked,
                ),
                Text(_compliances[2].title),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      _compliances[3].checked = value;
                    });
                    subscribeTopic(_compliances[3].title, value);
                  },
                  value: _compliances[3].checked,
                ),
                Text(_compliances[3].title),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      _compliances[4].checked = value;
                    });
                    subscribeTopic(_compliances[4].title, value);
                  },
                  value: _compliances[4].checked,
                ),
                Text(_compliances[4].title),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      _compliances[5].checked = value;
                    });
                    subscribeTopic(_compliances[5].title, value);
                  },
                  value: _compliances[5].checked,
                ),
                Text(_compliances[5].title),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      _compliances[6].checked = value;
                    });
                    subscribeTopic(_compliances[6].title, value);
                  },
                  value: _compliances[6].checked,
                ),
                Text(_compliances[6].title),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      _compliances[7].checked = value;
                    });
                    subscribeTopic(_compliances[7].title, value);
                  },
                  value: _compliances[7].checked,
                ),
                Text(_compliances[7].title),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      _compliances[8].checked = value;
                    });
                    subscribeTopic(_compliances[8].title, value);
                  },
                  value: _compliances[8].checked,
                ),
                Text(_compliances[8].title),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      _compliances[9].checked = value;
                    });
                    subscribeTopic(_compliances[9].title, value);
                  },
                  value: _compliances[9].checked,
                ),
                Text(_compliances[9].title),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
