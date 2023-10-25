

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecosoftvmsgate/modals/classes.dart';
import 'package:intl/intl.dart';

const apiKey='AIzaSyBfC0EgRqJo8fAM4xY7VexEHezVBtQt9YM';
const projectId='fir-test-1ed02';
class Services{
  final firestore = FirebaseFirestore.instance;
  Future<List<LogBook>> getlog(String staff) async{
    List<LogBook> temp=[];
    final snapshot = await firestore.collection("LogBook").get();
    final List<DocumentSnapshot> documents=snapshot.docs;
    for(DocumentSnapshot a in documents){
      if(a["Staff"].toString().toLowerCase().contains(staff.toLowerCase())){
        temp.add(LogBook(VisitorName: a["VisitorName"], Purpose: a["Purpose"], Checkedin: a["checkedindatetime"], Checkedout: a["checkedoutdatetime"]==""?"Still In":a["checkedoutdatetime"], id: a["id"], CompanyName: a["CompanyName"], emailId: a["Emailid"], Phoneno: a["Phoneno"], Staff: a["Staff"]));
      }
    }
    return temp;
  }
  Future<List> getallstaff() async{
    List<Staff> staffs=[];
    final snapshot=await firestore.collection("Staff").get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    for(DocumentSnapshot element in documents){
      staffs.add(Staff(EmailId: element["EmailId"], UserName: element["UserName"],phoneno: element["Phoneno"],ProfileLink: element["ProfileLink"]));
    }
    return staffs;
  }
  Future<void> addStaff(Staff s) async{
    Map<String,dynamic> obj={
      "UserName": s.UserName,
      "EmailId": s.EmailId,
      "Phoneno": s.phoneno,
      "ProfileLink": s.ProfileLink
    };
    String docId= s.UserName;
    final DocumentReference tasksRef=firestore.collection("Staff").doc(docId);
    await tasksRef.set(obj);
  }
  Future<Staff> getprofile(String email) async{
    Staff s = Staff(EmailId: "Loading..", UserName: "loading..", phoneno: "Loading..",ProfileLink: "");
    final snapshot = await firestore.collection("Staff").get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    for(DocumentSnapshot element in documents){
      if(element["EmailId"]==email){
        s= Staff(EmailId: element["EmailId"], UserName: element["UserName"], phoneno: element["Phoneno"],ProfileLink: element["ProfileLink"]);

      }
    }
    return s;
  }

  Future<List> getstaffreq(String StaffName) async{
    List<Requests> v= [];
    final snapshot = await firestore.collection("Requested").get();
    final List<DocumentSnapshot> documents=snapshot.docs;
    for(DocumentSnapshot s in documents){
      if(s["Staff"]==StaffName){
        v.add(Requests(ReqTime: s["requesteddatetime"],Name: s["VisitorName"], CompanyName: s["CompanyName"], phoneno: s["Phoneno"], EmailId: s["Emailid"], Purpose: s["Purpose"], id: s["id"], staff: s["Staff"], aadharnumber: s["aadharnumber"],assets: s["Assets"]));}
    }
    return v;
  }

  Future<void> addVisitor(Visitor newVisitor) async{

    var currentdate= DateFormat("dd-MM-yyyy").format(DateTime.now());
    var currenttime = DateFormat.Hm().format(DateTime.now());
    Map<String,dynamic> obj={
      "VisitorName": newVisitor.Name,
      "CompanyName": newVisitor.CompanyName,
      "Phoneno": newVisitor.phoneno,
      "Emailid": newVisitor.EmailId,
      "Purpose": newVisitor.Purpose,
      "id": newVisitor.id,
      "aadharnumber": newVisitor.aadharnumber,
      "requesteddatetime": currentdate+"&"+currenttime,
      "Staff": newVisitor.staff,
      "Assets": newVisitor.assets
    };
    Map<String,dynamic> obj2={
      "VisitorName": newVisitor.Name,
      "CompanyName": newVisitor.CompanyName,
      "Phoneno": newVisitor.phoneno,
      "Emailid": newVisitor.EmailId,
      "aadharnumber": newVisitor.aadharnumber,
      "id": newVisitor.id,
      "lastvisit": currentdate
    };

    String docId= newVisitor.id;
    final DocumentReference tasksRef=firestore.collection("Requested").doc(docId);
    final DocumentReference tasksRef2=firestore.collection("AllVisitors").doc(docId);
    await tasksRef.set(obj);
    await tasksRef2.set(obj2);
    print("Added");
  }
  Future<List> readVisitors() async{
    List<Visitor> visitors=[];
    final snapshot=await firestore.collection("AllVisitors").get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    for(DocumentSnapshot element in documents){
      visitors.add(Visitor(Name: element["VisitorName"],aadharnumber: element["aadharnumber"], CompanyName: element["CompanyName"], phoneno: element["Phoneno"], EmailId: element["Emailid"], Purpose:"", id: element["id"],staff: "", assets:""));
    }
    return visitors;
  }
  Future<void> denyreq(Requests visitor) async{
    String docId= visitor.Name+visitor.phoneno;
    await FirebaseFirestore.instance.collection("Requested").doc(docId).delete();
  }
  Future<void> checkin(Requests newVisitor) async{

    var currentdate= DateFormat("dd-MM-yyyy").format(DateTime.now());
    var currenttime = DateFormat.Hm().format(DateTime.now());
    Map<String,dynamic> obj={
      "VisitorName": newVisitor.Name,
      "CompanyName": newVisitor.CompanyName,
      "Phoneno": newVisitor.phoneno,
      "Emailid": newVisitor.EmailId,
      "Purpose": newVisitor.Purpose,
      "aadharnumber": newVisitor.aadharnumber,
      "assets": newVisitor.assets,
      "id": newVisitor.id,
      "checkedindatetime": "$currentdate&$currenttime",
      "Staff": newVisitor.staff
    };
    String docId= newVisitor.id;
    Map<String,dynamic> obj2={
      "VisitorName": newVisitor.Name,
      "CompanyName": newVisitor.CompanyName,
      "Phoneno": newVisitor.phoneno,
      "Emailid": newVisitor.EmailId,
      "Purpose": newVisitor.Purpose,
      "id": newVisitor.id,
      "checkedindatetime": "$currentdate&$currenttime",
      "checkedoutdatetime": "",
      "Staff": newVisitor.staff
    };
    final DocumentReference tasksRef=firestore.collection("Checked-In").doc(docId);
    await tasksRef.set(obj);

    final DocumentReference tasksRef2=firestore.collection("LogBook").doc(docId+obj2["checkedindatetime"]);
    await tasksRef2.set(obj2);
    await FirebaseFirestore.instance.collection("Requested").doc(docId).delete();
  }
  Future<List> gecheckin() async{
    List<LogBook> temp= [];
    final snapshot = await firestore.collection("Checked-In").get();
    final List<DocumentSnapshot> documents= snapshot.docs;
    for(DocumentSnapshot s in documents){
      temp.add(LogBook(VisitorName: s["VisitorName"], Purpose: s["Purpose"],Checkedin: s["checkedindatetime"], Checkedout: "Still in", id: s["id"], CompanyName: s["CompanyName"], emailId:s["Emailid"], Phoneno: s["Phoneno"], Staff: s["Staff"],));
    }
    return temp;
  }

  Future<void> startlink() async{
    final currentDatetime =  DateTime.now();
    await firestore.collection("hosting").doc("hosttime").update(
        {"timestamp": currentDatetime}
    );
  }

}