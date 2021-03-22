import 'package:flutter/material.dart';
// import 'package:unified_reminder/models/client.dart';
// import 'package:unified_reminder/models/client_compliance.dart';
import 'package:unified_reminder/models/compliance.dart';
// import 'package:unified_reminder/router.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/widgets/ClientForm.dart';




class SelectClients extends StatefulWidget {
  final Map arguments;

  SelectClients({this.arguments});
  @override
  _SelectClientsState createState() => _SelectClientsState();
}


class _SelectClientsState extends State<SelectClients> {
  List<String> _constitution = [null];
  bool buttonLoading = false;
  GlobalKey<FormState> _clientsFormKey = GlobalKey<FormState>();
  List _clients = [
    {
      "compliances": [
        Compliance(title: "Income Tax", value: "income_tax", checked: false),
        Compliance(title: "TDS", value: "tds", checked: false),
        Compliance(title: "GST", value: "gst", checked: false),
        Compliance(title: "EPF", value: "epf", checked: false),
        Compliance(title: "ESI", value: "esi", checked: false),
        Compliance(title: "PTAX", value: "ptax", checked: false),
        Compliance(title: "ROC", value: "roc", checked: false),
      ]
    }
  ];

  void changeCompliance(clientIndex, index) {
    this.setState(() {
      _clients[clientIndex]["compliances"][index].checked =
          !_clients[clientIndex]["compliances"][index].checked;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.arguments);
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Clients"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 70.0,
              ),
              Text(
                "Select Clients",
                style: _theme.textTheme.headline6.merge(
                  TextStyle(
                    fontSize: 26.0,
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(
                    "You can add upto 5 clients, ",
                  ),
                  Container(
                    child: Text(
                      "upgrade to add more.",
                      style: TextStyle(
                        color: linkColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50.0,
              ),
              Form(
                key: _clientsFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      children: _clients
                          .asMap()
                          .map((int index, client) {
                            return MapEntry(
                              index,
                              clientForm(
                                  index,
                                  client["compliances"],
                                  changeCompliance,
                                  changeClient,
                                  _constitution[index],
                                  changeConstitution),
                            );
                          })
                          .values
                          .toList(),
                    ),
                    Center(
                      child: ClipOval(
                        child: Container(
                          color: buttonColor,
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              this.setState(() {
                                _clients.add({
//                                  "client": Client(),
                                  "compliances": [
                                    Compliance(
                                        title: "Income Tax",
                                        value: "income_tax",
                                        checked: false),
                                    Compliance(
                                        title: "TDS",
                                        value: "tds",
                                        checked: false),
                                    Compliance(
                                        title: "GST",
                                        value: "gst",
                                        checked: false),
                                    Compliance(
                                        title: "EPF",
                                        value: "epf",
                                        checked: false),
                                    Compliance(
                                        title: "ESI",
                                        value: "esi",
                                        checked: false),
                                    Compliance(
                                        title: "PTAX",
                                        value: "ptax",
                                        checked: false),
                                    Compliance(
                                        title: "ROC",
                                        value: "roc",
                                        checked: false),
                                  ]
                                });
                                _constitution.add(null);
                              });
                            },
                          ),
                        ),
                      ),
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
                            : Text("Save"),
                        onPressed: () {
                          saveClients(_clients);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void changeConstitution(clientId, value) {
    this.setState(() {
      _constitution[clientId] = value;
    });
  }

  void changeClient(clientId, property, value) {
    this.setState(() {
      _clients[clientId]["client"] =
          _clients[clientId]["client"].setDynamicProperty(property, value);
    });
  }

  Future<void> saveClients(List clients) async {
    try {
      if (_clientsFormKey.currentState.validate()) {
        _clientsFormKey.currentState.save();
        print("Yo man");
        this.setState(() {
          buttonLoading = true;
        });

//        bool savedClients = await _firestoreService.saveClients(clients);
        this.setState(() {
          buttonLoading = false;
        });
//        if (savedClients) {
//          Navigator.of(context).pushNamed(DashboardRoute);
//        } else {}
      }
    } catch (e, stack) {
      print(e);
      print(stack);
    }
  }
}
