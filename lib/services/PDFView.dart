import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewer extends StatefulWidget {
	
	final String pdf;
	const PDFViewer({Key key, this.pdf}) : super(key: key);
	
	@override
	_PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
	
	FirebaseStorage firebaseStorage = FirebaseStorage.instance;
	String localFile ;
	
	Future<String> loadPDFurl() async{
		try{
		String pdf = await firebaseStorage.ref().child("files").child(widget.pdf).getDownloadURL();
		return pdf;
		}catch(e){
			try{
				String pdf = await firebaseStorage.ref().child("AdminUse").child(widget.pdf).getDownloadURL();
				return pdf;
			}catch(e){
			
			}
		}
	}
	
	Future<String> getFile() async{
		http.Response response;
		await loadPDFurl().then((value) async{
			response = await http.get(value);
		});
		
		var dir = await getTemporaryDirectory();
		File file = File(dir.path + "/data.pdf");
		await file.writeAsBytes(response.bodyBytes,flush: true);
		return file.path;
	}
	
	@override
	void initState() {
		super.initState();
		getFile().then((value){
			setState(() {
				localFile = value;
			});
		});
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("File View"),
			),
			
			body: Container(
					padding: EdgeInsets.all(20),
					child: localFile != null?
					PDFView(
						filePath: localFile,
					):
					Center(
						child: CircularProgressIndicator(
							valueColor: AlwaysStoppedAnimation<Color>
								(Colors.white),
						),
					)
			),
		);
	}
}
