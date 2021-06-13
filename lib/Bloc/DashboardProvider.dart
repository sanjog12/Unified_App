import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:unified_reminder/models/Client.dart';


class DashboardProvider extends ChangeNotifier{
	
	List<Client> listClients = [];
	
	
	void readClients() async{
		String uid = FirebaseAuth.instance.currentUser.uid;
		await FirebaseDatabase.instance.reference()
				.child('user_clients')
				.child(uid)
				.child('clients')
				.onValue.forEach((element) async{
					var value = await element.snapshot.value;
					print(value);
					if (element.snapshot != null) {
						listClients.add(Client(
								value["name"],
								value["constitution"],
								value["company"],
								value["natureOfBusiness"],
								value["email"].toString().replaceAll('.', ','),
								value["phone"],
								element.snapshot.key
						),);
						print("change notifier " + listClients.length.toString());
						
						notifyListeners();
					}
				});
	}
}