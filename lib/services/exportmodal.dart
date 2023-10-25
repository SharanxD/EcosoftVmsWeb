
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:ecosoftvmsgate/services/services.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';

import '../modals/classes.dart';

void exportdata(List<LogBook> listdata,context) async{

  List<List<dynamic>> data = List<List<dynamic>>.empty(growable: true);

  data.add(["Visitor Name","Company Name","Contact Details","Email Id","Purpose of Visit","In Time","Out Time"]);

  for(var a in listdata){
    String intime="";
    String outtime="";
    if(a.Checkedout==""){
      outtime="Still In";
    }else{
      List l = a.Checkedout.split('&');
      outtime=l[0]+" "+l[1];
    }
    List l1= a.Checkedin.split('&');
    intime=l1[0]+" "+l1[1];
    data.add([a.VisitorName,a.CompanyName,a.Phoneno,a.emailId,a.Purpose,intime,outtime]);
  }
  String csv =ListToCsvConverter().convert(data);
  Uint8List bytes = Uint8List.fromList(utf8.encode(csv));
  await FileSaver.instance.saveFile(
    name: 'Logreports',
    bytes: bytes,
    ext: 'csv',
    mimeType: MimeType.csv,
  );


}