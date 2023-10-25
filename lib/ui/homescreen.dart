// ignore_for_file: unused_local_variable

import 'dart:ui';

import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:ecosoftvmsgate/services/services.dart';
import 'package:ecosoftvmsgate/ui/Home.dart';
import 'package:ecosoftvmsgate/ui/NewVisitor.dart';
import 'package:ecosoftvmsgate/ui/VisitorLog.dart';
import 'package:ecosoftvmsgate/ui/profilepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../modals/classes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key,required this.mode});

  final String mode;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool emailgiven=false;
  bool dategiven=false;
  final emailcontroller= TextEditingController();
  final datecontroller = TextEditingController();
  Staff staff= Staff(EmailId: "Loading..", UserName:"Loading..", phoneno: "Loading..",ProfileLink: "");
  Services services = Services();
  Future<void> signin() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: "sharanprakash2003@gmail.com", password: "12345678");
  }
  Future<void> profile() async{
    Staff temp = await services.getprofile("sharanprakash2003@gmail.com");
    setState(() {
      staff= temp;
    });
  }
  int selectedindex =0;
  late List sidebaritems=[
    ["Overview",Icons.home,Overview()],
    ["Visitor Log Reports",Icons.list,VisitorLogBook(Staffname: widget.mode=="Staff"?"Sharan" as String:"Gate")],
    ["New Visitor",Icons.add_circle,NewVisitor()],
  ];
  @override
  void initState(){
    signin();
    if(widget.mode=="Staff"){
      profile();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(

        children: [
          SizedBox(
              width:size.width,
              height:size.height,
              child: Row(
                children: [
                  SafeArea(
                      child: Container(
                    width: 350,
                    height: size.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(color: Colors.black,blurRadius: 10)
                      ]
                      ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: size.height*0.05,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ClipRRect(borderRadius: BorderRadius.circular(30),child: Image.asset("assets/vmspic.jpeg",width: 100,)),
                                Text("Ecosoft VMS",style: GoogleFonts.questrial(fontSize: 32,color: Colors.black,fontWeight: FontWeight.bold),)
                              ],
                            ),
                            SizedBox(height: size.height*0.1),
                            SizedBox(
                              height: size.height*0.6,
                              width: 400,
                              child: ListView.builder(
                                  itemCount: sidebaritems.length,
                                  itemBuilder: (BuildContext context,int index){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          selectedindex=index;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 250,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              color: index!=selectedindex?Colors.white:Colors.grey.shade200,
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(sidebaritems[index][1],color: index==selectedindex?Colors.black:Colors.grey,size: 30,),
                                                SizedBox(width:20,),
                                                Text(sidebaritems[index][0],style: GoogleFonts.questrial(fontSize: 26,color: index==selectedindex?Colors.black:Colors.grey),)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );

                              }),
                            )
                          ],
                        ),
                  )),
                  Expanded(child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          color: Colors.grey.shade100,
                          height: 100,width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width*0.2,
                            height: 100,
                          ),

                          Container(
                            width: size.width*0.2,
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    showDialog(context: context, builder: (BuildContext context){
                                      return StatefulBuilder(builder: (context,setState){
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: Text("New Visitor",style: GoogleFonts.questrial(fontWeight: FontWeight.bold,fontSize: 32),),
                                          content: SizedBox(
                                            width: size.width*0.4,
                                            height: size.height*0.24,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Material(
                                                  elevation: 4.0,
                                                  shadowColor: Colors.black,
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                                    child: TextField(
                                                      onChanged: (value){

                                                        setState(() {
                                                          emailgiven=true;
                                                        });
                                                      },
                                                      controller: emailcontroller,
                                                      style: GoogleFonts.questrial(fontSize: 24),
                                                      decoration: InputDecoration(
                                                          hintText: 'Email-Id',
                                                          hintStyle: GoogleFonts.questrial(fontSize: 24),
                                                          border: InputBorder.none,
                                                          icon: const Icon(Icons.email_outlined,color: Colors.black,)

                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Material(
                                                  elevation: 4.0,
                                                  shadowColor: Colors.black,
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                                    child: TextField(

                                                      readOnly: true,
                                                      onTap: ()async{
                                                        DateTime? pickedDate = await showDatePicker(

                                                            context: context,
                                                            initialDate: DateTime.now(),
                                                            firstDate: DateTime.now(),
                                                            lastDate: DateTime(2030));
                                                        if(pickedDate!=null){
                                                          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                                          setState(() {
                                                            datecontroller.text=formattedDate;
                                                          });
                                                        }

                                                      },
                                                      onChanged: (value){
                                                      },
                                                      controller: datecontroller,
                                                      style: GoogleFonts.questrial(fontSize: 24),
                                                      decoration: InputDecoration(
                                                          hintText: "Schedule Date",
                                                          hintStyle: GoogleFonts.questrial(fontSize: 24),
                                                          border: InputBorder.none,
                                                          icon: const Icon(Icons.calendar_today,color: Colors.black,)

                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text("Send Link to the Visitor?",style: GoogleFonts.questrial(fontSize: 28),)
                                              ],

                                            ),
                                          ),
                                          actions: [
                                            GestureDetector(
                                              onTap: () async{
                                                final Staffname = "Sharan";
                                                String token="wbzu hfiq oyad sftv";
                                                final smtpServer = gmail('testsptest223@gmail.com',token);

                                                final message = Message()
                                                  ..from = Address("sharanprakash2003@gmail.com")
                                                  ..recipients.add(emailcontroller.text)
                                                  ..subject = 'Appointment Registration'
                                                  ..text= ""
                                                  ..html = "Hello\n, Your invited for an appointment with $Staffname on ${datecontroller.text}.Please register in this link. <a href='https://fir-test-1ed02.web.app/'>https://fir-test-1ed02.web.app/</a>\nThe session wil end in 30 minutes.";

                                                try {
                                                  await send(message, smtpServer).then((value)async{

                                                    await services.startlink();
                                                    //notificationApi.sendNotification("Invitation", "The Invitation has been successfully sent");
                                                    //FloatingSnackBar(message: "Invitation Sent", context: context,textStyle: GoogleFonts.questrial(fontSize: 18));
                                                    emailcontroller.clear();
                                                    datecontroller.clear();
                                                    FloatingSnackBar(message: "Invitation Sent", context: context,textStyle: GoogleFonts.questrial(fontSize: 24));
                                                    Navigator.pop(context);

                                                  });
                                                } on MailerException catch (e) {
                                                  if (kDebugMode) {
                                                    print(e.toString());
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width: size.width * 0.2,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.blueGrey,
                                                    borderRadius:
                                                    const BorderRadius.all(Radius.circular(20)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey[500]!,
                                                          blurRadius: 10,
                                                          offset: const Offset(4, 4),
                                                          spreadRadius: 0.5),
                                                      const BoxShadow(
                                                          color: Colors.white,
                                                          blurRadius: 10,
                                                          offset: Offset(-5, -5),
                                                          spreadRadius: 1)
                                                    ]),
                                                child: Center(
                                                    child: Text(
                                                      "Yes",
                                                      style: GoogleFonts.questrial(
                                                          fontSize: 24,
                                                          color: Colors.grey.shade200,
                                                          fontWeight: FontWeight.bold),
                                                    )),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                //FloatingSnackBar(message: "message", context: context);
                                              },
                                              child: Container(
                                                width: size.width * 0.2,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                    const BorderRadius.all(Radius.circular(20)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey[500]!,
                                                          blurRadius: 10,
                                                          offset: const Offset(4, 4),
                                                          spreadRadius: 0.5),
                                                      const BoxShadow(
                                                          color: Colors.white,
                                                          blurRadius: 10,
                                                          offset: Offset(-5, -5),
                                                          spreadRadius: 1)
                                                    ]),
                                                child: Center(
                                                    child: Text(
                                                      "No",
                                                      style: GoogleFonts.questrial(
                                                          fontSize: 24,
                                                          color: Colors.blueGrey,
                                                          fontWeight: FontWeight.bold),
                                                    )),
                                              ),
                                            ),

                                          ],
                                        );

                                      });

                                    });

                                  },
                                  child: Container(
                                    width: size.width*0.12,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.add,size: 40,color: Colors.white,),
                                        Text("Create Invite",style: GoogleFonts.questrial(fontSize: 28,color: Colors.white),),
                                      ],
                                    )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: size.width*0.2,
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(child: widget.mode=="Staff"?(staff.ProfileLink=="")?Center(child: Text("Loading..")):Image.network(staff.ProfileLink,width: 80,height: 80,fit: BoxFit.cover,):Image.asset("assets/profile.png",width: 80,),borderRadius: BorderRadius.circular(80),),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0,right: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.mode=="Staff"?staff.UserName:"Gate",style: GoogleFonts.questrial(fontSize: 24,fontWeight: FontWeight.bold),),
                                      widget.mode=="Staff"?GestureDetector(child: Text("View Profile",style: GoogleFonts.questrial(fontSize: 18,color: Colors.black54)),onTap: (){
                                        setState(() {
                                          selectedindex=3;
                                        });
                                      },):
                                      Text(widget.mode+" account",style: GoogleFonts.questrial(fontSize: 18,color: Colors.black54),)
                                    ],
                                  ),
                                )
                                
                              ],
                            ),
                          )
                        ],
                      )
                      ),
                      Container(height: size.height-100,width: size.width,

                      child:
                      selectedindex==3?ProfilePage(staff: staff,):sidebaritems[selectedindex][2],),

                    ],
                  ))
                ],
              )
          )
        ],
      ),
    );
  }
}
