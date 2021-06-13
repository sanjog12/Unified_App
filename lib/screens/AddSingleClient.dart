import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/Compliance.dart';
import 'package:unified_reminder/models/userbasic.dart';
import 'package:unified_reminder/screens/Dashboard.dart';
import 'package:unified_reminder/services/GeneralServices/DocumentPaths.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class AddSingleClient extends StatefulWidget {
  
  final Client client;
  final UserBasic userBasic;
  final List<Client> clientList;
  
  const AddSingleClient({this.userBasic, this.clientList, this.client});
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
  FirebaseMessaging firebaseMessaging  = FirebaseMessaging.instance;
  Razorpay _razorpay;
  List<String> com=[];
  bool willPop = true;
  String successFulCode = "";
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;
  
  
  Future<void> subscribeTopic(String compliance, bool subscribe) async{
    
    if(subscribe){
      firebaseMessaging.subscribeToTopic(compliance.replaceAll(' ', '_f'));
    }
    else if(subscribe){
      firebaseMessaging.unsubscribeFromTopic(compliance);
    }
  }

  Future<void> _getUserCompliances() async {
    String clientEmail = widget.client.email.replaceAll('.', ',');
    var firebaseUserId = FirebaseAuth.instance.currentUser.uid;
    
    dbf = firebaseDatabase
        .reference()
        .child(FsUserCompliances)
        .child(firebaseUserId)
        .child('compliances')
        .child(clientEmail);
  
    await dbf.once().then((DataSnapshot snapshot) async{
      Map<dynamic, dynamic> values = await snapshot.value;
      for(var v in values.entries){
        com.add(v.value['title']);
      }
//      values.forEach((key, values) {
//        Compliance compliance = Compliance(
//            title: values['title'],);
//        com.add(compliance.title);
//
//      });
    });
    setState(() {
      com = com;
      _compliances = [];
    });
  }
  
  // editingComplete(){
  //   return showDialog(context: context, builder: (context){
  //     return SimpleDialog(
  //       title: Text("Alert"),
  //       children: [
  //         Text("You won't be able to change this email address later please check before submitting ");
  //       ],
  //     );
  //   });
  // }
  
  Future<bool> onWillPop() async{
      return await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Alert"),
            content: Text("Are you sure want to go back"),
            actions: [
              TextButton(
                child: Text("No"),
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text("Exit"),
                onPressed: (){
                  Navigator.of(context).pop(true);
                  
                },
              ),
            ],
          );
        }
      )??false;
  }
  
  

  Future<bool> openCheckout() async {
    try {
      var options = {
        'key': 'rzp_test_YHXEshy02jkv2N',
        'amount': 2500,
        'name': 'Tax Reminder',
        'description': 'Fee for adding further clients',
        'external': {
          'wallets': ['paytm']
        }
      };
        _razorpay.open(options);
        
      return true;
    }catch(e){
      debugPrint(e);
      return false;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    PaymentRecordToDataBase().savePaymentDetails(response,_client);
    successFulCode = response.paymentId;
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId);
    saveClients(_client, _compliances);
    willPop = false;
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(
    //     msg: response.message ,
    //     );
    Navigator.pop(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: " + response.walletName);
    Navigator.pop(context);
  }
  
  @override
  void initState() {
    if(widget.client != null){
      _getUserCompliances();
      _client = widget.client;
      print(_client.key);
    }
    
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  

  @override
  Widget build(BuildContext context) {
    
    if(widget.client == null) {
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
    }
    
    else{
      print("here");
      print(com.join(" "));
      _compliances.add(Compliance(title: "Income Tax", value: "income_tax", checked: com.contains("Income Tax")));
      print(com.contains("Income Tax"));
      _compliances.add(Compliance(title: "TDS", value: "tds", checked: com.contains("TDS")));
      print(com.contains("TDS"));
      _compliances.add(Compliance(title: "GST", value: "gst", checked: com.contains("GST")));
      print(com.contains("GST"));
      _compliances.add(Compliance(title: "EPF", value: "epf", checked: com.contains("EPF")));
      print(com.contains("EPF"));
      _compliances.add(Compliance(title: "ESI", value: "esi", checked: com.contains("ESI")));
      _compliances.add(Compliance(title: "ROC", value: "roc", checked: com.contains("ROC")));
      _compliances.add(Compliance(title: "LIC", value: "lic", checked: com.contains("LIC")));
      _compliances.add(Compliance(title: "PPF", value: "ppf", checked: com.contains("PPF")));
      print(com.contains("PPF"));
      _compliances.add(Compliance(title: "MUTUAL FUND", value: "mf", checked: com.contains("MUTUAL FUND")));
      _compliances.add(Compliance(title: "FIXED DEPOSIT", value: "fd", checked: com.contains("FIXED DEPOSIT")));
      setState(() {
        _compliances = _compliances;
      });
    }
    
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Client'),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 15,bottom: 15,left: 15,right: 15),
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
                    child: TextButton(
                      child: buttonLoading
                          ? CircularProgressIndicator(
                            strokeWidth: 3.0,
                            valueColor: AlwaysStoppedAnimation(
                              Colors.white,
                            ),
                          )
                          : widget.clientList != null ?(widget.clientList.length >=5? Text("Pay and Save"):Text("Save")):Text("Update"),
                      onPressed: () async{
                        if(widget.client == null) {
                          if (widget.clientList.length >= 5)
                            await openCheckout();
                          
                          else
                            saveClients(_client, _compliances);
                        }else{
                          if(_clientsFormKey.currentState.validate()) {
                            _clientsFormKey.currentState.save();
                            setState(() {
                              buttonLoading = true;
                            });
                            String firebaseUID = await SharedPrefs.getStringPreference('uid');
                            await FirestoreService().editClientData(_client, firebaseUID, com, _compliances);
                            await flutterToast(message: "Updated Successfully");
                            Navigator.pop(context);
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 70,),
                ],
              ),
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
              await fireStoreService.addClient(clients, compliances, successFulCode);
          this.setState(() {
            buttonLoading = false;
          });
          if (savedClients) {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=>ShowCaseWidget(
                  builder: Builder(
                    builder: (context)=>Dashboard(),
                  ),
                )
            ));
          } else {}
        }
      } catch (e, stack) {
        print(e);
        print(stack);
      }
      
      this.setState(() {
        buttonLoading = false;
      });
    }
  }

  Widget clientForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("Client's Name"),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              initialValue: _client != null?_client.name:"",
              validator: (value) => requiredField(value, "Client's Name"),
              decoration: buildCustomInput(hintText: "Client's Name"),
              onChanged: (value) => _client.name = value,
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
              value: _client.constitution != "" ? _client.constitution : _constitution ,
              onChanged: (v){
                setState(() {
                  _constitution = v;
                });
              },
            ),
          ],
        ),
        // SizedBox(
        //   height: 40.0,
        // ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: <Widget>[
        //     Text("Client's Company Name"),
        //     SizedBox(
        //       height: 10.0,
        //     ),
        //     TextFormField(
        //       initialValue: _client != null?_client.company:"",
        //       onChanged: (value) => _client.company = value,
        //       validator: (value) =>
        //           requiredField(value, "Client's Company Name"),
        //       decoration: buildCustomInput(hintText: "Client's Company Name"),
        //     ),
        //   ],
        // ),
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
              initialValue: _client.email != ""? _client.email:"",
              enabled: _client.email != ""?false:true,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => validateEmail(value),
              onChanged: (value) => _client.email = value,
              // onEditingComplete: (value)=> ,
              decoration: buildCustomInput(hintText: "Client's Email Address"),
            ),
            _client.email != ""?Text("You can't change this Email", style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.red),):Container()
          ],
        ),
        // SizedBox(
        //   height: 40.0,
        // ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: <Widget>[
        //     Text("Client's Nature of Business"),
        //     SizedBox(
        //       height: 10.0,
        //     ),
        //     TextFormField(
        //       initialValue: _client != null?_client.natureOfBusiness:"",
        //       onChanged: (value) => _client.natureOfBusiness = value,
        //       validator: (value) =>
        //           requiredField(value, "Client's Nature of Business"),
        //       decoration:
        //           buildCustomInput(hintText: "Client's Nature of Business"),
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: 40.0,
        // ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: <Widget>[
        //     Text("Client's Mobile Number"),
        //     SizedBox(
        //       height: 10.0,
        //     ),
        //     TextFormField(
        //       maxLength: 10,
        //       initialValue: _client != null?_client.phone:"",
        //       onChanged: (value) => _client.phone = value,
        //       validator: (value) {
        //         if(value.length<10 ){
        //           return "Invalid Mobile Number";
        //         }
        //        return requiredField(value, "Client's Mobile Number");
        //       },
        //       keyboardType: TextInputType.phone,
        //       decoration: buildCustomInput(
        //         hintText: "Client's Mobile Number",
        //       ),
        //     ),
        //   ],
        // ),
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
