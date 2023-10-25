import 'package:ecosoftvmsgate/ui/loginscreens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../modals/classes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key,required this.staff});
  final Staff staff;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(200),child: Image.network(widget.staff.ProfileLink,width: 200,height: 200,fit: BoxFit.cover,),),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.staff.UserName,style: GoogleFonts.questrial(fontSize: 40,fontWeight: FontWeight.bold),),

                      Text(widget.staff.phoneno,style: GoogleFonts.questrial(fontSize: 26,color: Colors.black54),)
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: SizedBox(
                    width: size.width*0.25,
                    height: size.height*0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("UserName",style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold),),
                        Text("Email Address",style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold),),
                        Text("Phone number",style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold),),

                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width*0.25,
                  height: size.height*0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.staff.UserName,style: GoogleFonts.questrial(fontSize: 26,color: Colors.black54),),
                      Text(widget.staff.EmailId,style: GoogleFonts.questrial(fontSize: 26,color: Colors.black54),),
                      Text(widget.staff.phoneno,style: GoogleFonts.questrial(fontSize: 26,color: Colors.black54),),
                    ],
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: (){
                showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text("Alert",style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold),),
                    content: SizedBox(
                        width: size.width*0.3,
                        child: Text("Are you sure to sign out?",style: GoogleFonts.questrial(fontSize: 20,),)),
                    actions: [
                      GestureDetector(
                        onTap: ()async{
                          await FirebaseAuth.instance.signOut().then((value){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                            FloatingSnackBar(message: "Successfully Signed out", context: context,textStyle: GoogleFonts.questrial(fontSize: 18));
                          }).catchError((error){
                            if (kDebugMode) {
                              print(error.toString());
                            }
                            FloatingSnackBar(message: "Some Error has occured", context: context,textStyle: GoogleFonts.questrial(fontSize: 18));
                          });
                        },
                        child: Container(
                          width: size.width*0.05,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Center(child: Text("Yes",style: GoogleFonts.questrial(fontSize: 18,color: Colors.white),)),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: size.width*0.05,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Center(child: Text("No",style: GoogleFonts.questrial(fontSize: 18),)),
                        ),
                      ),

                    ],
                  );
                });
              },
              child: Container(
                width: size.width*0.25,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Text("Sign Out",style: GoogleFonts.questrial(fontSize: 32,color: Colors.white),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left:size.width*0.2,right: size.width*0.1),
                  child: Text("Phone number",style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold),),
                ),

              ],
            )
*/
