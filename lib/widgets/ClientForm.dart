import 'package:flutter/material.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/validators.dart';

Widget clientForm(clientId, compliances, changeCompliance, changeClient,
    constitution, changeConstitution) {
  print(compliances);
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
            onSaved: (value) => changeClient(clientId, "name", value),
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
            onSaved: (value) => changeClient(clientId, "constitution", value),
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
            value: constitution,
            onChanged: (v) {
              changeConstitution(clientId, v);
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
            onSaved: (value) => changeClient(clientId, "company", value),
            validator: (value) => requiredField(value, "Client's Company Name"),
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
            onSaved: (value) => changeClient(clientId, "email", value),
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
            onSaved: (value) =>
                changeClient(clientId, "natureOfBusiness", value),
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
            onSaved: (value) => changeClient(clientId, "phone", value),
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
        children: compliances.map<Widget>((compliance) {
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Checkbox(
                onChanged: (bool value) {
                  int selectedIndex = compliances.indexOf(compliance);
                  changeCompliance(clientId, selectedIndex);
                },
                value: compliance.checked,
              ),
              Text(compliance.title),
            ],
          );
        }).toList(),
      ),
      SizedBox(
        height: 70.0,
      ),
    ],
  );
}
