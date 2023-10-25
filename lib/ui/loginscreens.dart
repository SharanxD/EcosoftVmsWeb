// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:ecosoftvmsgate/ui/homescreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../modals/classes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailcontroller= TextEditingController();
  final pwdcontroller= TextEditingController();
  final email2controller= TextEditingController();
  final pwd2controller= TextEditingController();
  final usernamecontroller= TextEditingController();
  final phonecontroller= TextEditingController();
  final cnfpwdcontroller = TextEditingController();
  final pagecontroller= PageController(initialPage: 0);
  bool emailvalid= false;
  bool pwdgiven= false;
  bool usernamegiven= false;
  bool numbervalid = false;
  bool cnfpwd= false;
  bool loading=false;
  bool showpwd=false;
  bool showpwd2=false;
  bool showpwdcnf=false;
  bool signinloading=false;

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size.width*0.3,
            height: size.height,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/vmspic.jpeg",width: 300,),
                const SizedBox(height: 50,),
                Text("Welcome to VMS",style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold),),
                Text("Make ur visitor manegement easy",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),)

              ],
            ),
          ),
          Container(
            width: size.width*0.7,
            height: size.height,
            color: Colors.grey.shade300,
            child: 
            Center(
              child: Container(
                width: size.width*0.4,
                height: size.height*0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black38,
                        blurRadius: 15,
                        offset: Offset(10,10)
                    ),
                    BoxShadow(
                        color: Colors.white,
                        blurRadius: 15,
                        offset: Offset(-10,-10)
                    )
                  ]
                ),
                child: SizedBox(
                  width: size.width*0.4,
                  height: size.height*0.7,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pagecontroller,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("LOGIN",style: GoogleFonts.questrial(fontSize: 40,fontWeight: FontWeight.bold),),
                          Container(
                            width: size.width*0.25,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0,right: 20),
                              child: TextField(
                                  controller: emailcontroller,
                                  onChanged: (value){
                                    setState(() {
                                      emailvalid=EmailValidator.validate(emailcontroller.text);
                                    });
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(Icons.mail_outline,color: emailvalid?Colors.green:Colors.blueGrey,size: 30,),
                                      hintText: "Email address",
                                      hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),
                                  ),
                                  style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54)
                              ),
                            ),
                          ),
                          Container(
                            width: size.width*0.25,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width*0.2,
                                    child: TextField(
                                        obscureText: !showpwd,
                                        controller: pwdcontroller,
                                        onChanged: (value){
                                          setState(() {
                                            pwdgiven= (pwdcontroller.text.length>=8);
                                          });
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(Icons.lock_outline,color: pwdgiven?Colors.green:Colors.blueGrey,size: 30,),
                                            hintText: "Password",
                                            hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                        ),
                                        style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54)
                                    ),
                                  ),
                                  IconButton(onPressed: (){
                                    setState(() {
                                      showpwd=!showpwd;
                                    });
                                  }, icon: Icon(showpwd?Icons.visibility_off:Icons.visibility,color: Colors.blueGrey,))
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                child: Text("Forgot Password?",style: GoogleFonts.questrial(fontSize: 28,color: Colors.blue),),
                                onPressed: (){
                                  setState(() {
                                    emailcontroller.clear();
                                    pwdcontroller.clear();
                                    emailvalid=false;
                                    pwdgiven=false;
                                  });
                                  pagecontroller.jumpToPage(2);

                                },
                              ),
                              SizedBox(width: size.width*0.05,)
                            ],
                          ),
                          GestureDetector(
                            onTap: ()async{
                              setState(() {
                                signinloading=true;
                              });

                              if(emailvalid && pwdgiven){
                                String url = "http://127.0.0.1:5000/staff/"+emailcontroller.text;
                                final response= await http.get(Uri.parse(url));
                                final Map obj= json.decode(response.body);
                                if(obj["password"]==pwdcontroller.text){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(mode: "Staff")));
                                }else{
                                  FloatingSnackBar(message: "Please verify The Details", context: context,textStyle: GoogleFonts.questrial(fontSize: 24));
                                }


                              }else{
                                FloatingSnackBar(message: "Please fill all the details", context: context,textStyle: GoogleFonts.questrial(fontSize: 24));
                              }
                              setState(() {
                                signinloading=false;
                              });
                            },
                            child: Container(
                              width: size.width*0.25,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(child:
                              signinloading?const SpinKitThreeBounce(
                                color: Colors.white,
                                size: 30,
                              )
                              :Text("Sign-In",style: GoogleFonts.questrial(fontSize: 32,color: Colors.white),)
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomePage(mode: "Gate")));
                            },
                            child: Container(
                              width: size.width*0.25,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(child: Text("Gate Login",style: GoogleFonts.questrial(fontSize: 32,color: Colors.white),)),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Dont have an account?",style: GoogleFonts.questrial(fontSize: 28),),
                              TextButton(onPressed: (){
                                pagecontroller.jumpToPage(1);
                              }, child: Text("Register",style: GoogleFonts.questrial(fontSize: 28,color: Colors.blue),))

                            ],
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(icon: const Icon(Icons.keyboard_arrow_left,size: 40,),onPressed: ()=>pagecontroller.jumpToPage(0),),
                            ],
                          ),
                          Text("REGISTER",style: GoogleFonts.questrial(fontSize: 30,fontWeight: FontWeight.bold),),
                          Container(
                            width: size.width*0.25,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0,right: 20),
                              child: TextField(
                                  controller: usernamecontroller,
                                  onChanged: (value){
                                    setState(() {
                                      usernamegiven=(usernamecontroller.text.isNotEmpty);
                                    });
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(Icons.person_outline,color: usernamegiven?Colors.green:Colors.blueGrey,size: 30,),
                                      hintText: "UserName",
                                      hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                  ),
                                  style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54)
                              ),
                            ),
                          ),
                          Container(
                            width: size.width*0.25,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0,right: 20),
                              child: TextField(
                                  controller: email2controller,
                                  onChanged: (value){
                                    setState(() {
                                      emailvalid=EmailValidator.validate(email2controller.text);
                                    });
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(Icons.mail_outline,color: emailvalid?Colors.green:Colors.blueGrey,size: 30,),
                                      hintText: "Email address",
                                      hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                  ),
                                  style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54)
                              ),
                            ),
                          ),
                          Container(
                            width: size.width*0.25,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0,right: 20),
                              child: TextField(
                                  controller: phonecontroller,
                                  onChanged: (value){
                                    setState(() {
                                      numbervalid=(phonecontroller.text.length>=10);
                                    });
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(Icons.phone_outlined,color: numbervalid?Colors.green:Colors.blueGrey,size: 30,),
                                      hintText: "Phone Number",
                                      hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                  ),
                                  style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54)
                              ),
                            ),
                          ),
                          Container(
                            width: size.width*0.25,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width*0.2,
                                    child: TextField(
                                        obscureText: !showpwd2,
                                        controller: pwd2controller,
                                        onChanged: (value){
                                          setState(() {
                                            pwdgiven=(pwd2controller.text.length>=8);
                                          });
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(Icons.lock_outline,color: pwdgiven?Colors.green:Colors.blueGrey,size: 30,),
                                            hintText: "Password",
                                            hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                        ),
                                        style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54)
                                    ),
                                  ),
                                  IconButton(onPressed: (){
                                    setState(() {
                                      showpwd2=!showpwd2;
                                    });
                                  }, icon: Icon(showpwd2?Icons.visibility_off:Icons.visibility,color: Colors.blueGrey,))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: size.width*0.25,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width*0.2,
                                    child: TextField(
                                        obscureText: !showpwdcnf,
                                        controller: cnfpwdcontroller,
                                        onChanged: (value){
                                          setState(() {
                                            cnfpwd=(cnfpwdcontroller.text==pwd2controller.text);
                                          });
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(Icons.lock_outline,color: cnfpwd?Colors.green:Colors.blueGrey,size: 30,),
                                            hintText: "Confirm Password",
                                            hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                        ),
                                        style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54)
                                    ),
                                  ),
                                  IconButton(onPressed: (){
                                    setState(() {
                                      showpwdcnf=!showpwdcnf;
                                    });
                                  }, icon: Icon(showpwdcnf?Icons.visibility_off:Icons.visibility,color: Colors.blueGrey,))
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async{
                              setState(() {
                                loading=true;
                              });
                              Staff s = Staff(EmailId: email2controller.text, UserName: usernamecontroller.text,phoneno: phonecontroller.text,ProfileLink: "");
                              if(emailvalid && usernamegiven && numbervalid && pwdgiven && cnfpwd){
                                String url="http://127.0.0.1:5000/staff/${email2controller.text}\$${usernamecontroller.text}\$${phonecontroller.text}\$\$${pwd2controller.text}}";
                                var response= await http.put(Uri.parse(url));
                                if(response.body.toLowerCase().contains("added")){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                                  FloatingSnackBar(message: "User Created", context: context,textStyle: GoogleFonts.questrial(fontSize: 24));
                                }else{
                                  FloatingSnackBar(message: "An Error Has Occurred", context: context,textStyle: GoogleFonts.questrial(fontSize: 24));
                                }
                                /*
                                FirebaseAuth.instance.createUserWithEmailAndPassword(email: email2controller.text, password: pwd2controller.text).then((value)async{
                                  await FirebaseAuth.instance.currentUser?.updateDisplayName(s.UserName);
                                  await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                                  setState(() {
                                    usernamecontroller.clear();
                                    email2controller.clear();
                                    phonecontroller.clear();
                                    pwd2controller.clear();
                                    cnfpwdcontroller.clear();
                                    usernamegiven=false;
                                    emailvalid=false;
                                    numbervalid=false;
                                    pwdgiven=false;
                                    cnfpwd=false;
                                  });
                                  pagecontroller.jumpToPage(0);
                                  FloatingSnackBar(message: "Verification mail sent", context: context,textStyle: GoogleFonts.questrial(fontSize: 24));
                                }).catchError((error){
                                  if (kDebugMode) {
                                    print(error.toString());
                                  }
                                });*/
                                }
                              else if(usernamegiven && emailvalid && pwdgiven && numbervalid){
                                FloatingSnackBar(message: "Re-Type the correct password", context: context,textStyle: GoogleFonts.questrial(fontSize: 18));
                              }
                              else if(usernamegiven && emailvalid && pwdgiven){
                                FloatingSnackBar(message: "Please enter the correct Phone number", context: context,textStyle: GoogleFonts.questrial(fontSize: 18));
                              }
                              else if(usernamegiven && emailvalid){
                                FloatingSnackBar(message: "Make sure the password has atleast 8 characters", context: context,textStyle: GoogleFonts.questrial(fontSize: 14 ));
                              }else if(usernamegiven){
                                FloatingSnackBar(message: "Type a valid Email address", context: context,textStyle: GoogleFonts.questrial(fontSize: 18));
                              }else{
                                FloatingSnackBar(message: "Enter all the details", context: context,textStyle: GoogleFonts.questrial(fontSize: 18));
                              }
                              setState(() {
                                loading=false;
                              });

                            },
                            child: Container(
                              width: size.width*0.25,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(child: loading?const SpinKitThreeBounce(color: Colors.white,
                                size: 30,):Text("Register",style: GoogleFonts.questrial(fontSize: 32,color: Colors.white),)),
                            ),
                          ),

                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(icon: const Icon(Icons.keyboard_arrow_left,size: 50,),onPressed: ()=>pagecontroller.jumpToPage(0),),
                            ],
                          ),
                          Text("Forgot Password?",style: GoogleFonts.questrial(fontWeight: FontWeight.bold,fontSize: 40),),
                          Text("If you need help resetting you password\n we can help by sending a link to reset it",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),),
                          SizedBox(height: size.height*0.025,),
                          Container(
                            width: size.width*0.25,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0,right: 20),
                              child: TextField(

                                  controller: email2controller,
                                  onChanged: (value){
                                    setState(() {
                                      emailvalid=EmailValidator.validate(email2controller.text);
                                    });
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(Icons.mail_outline,color: emailvalid?Colors.green:Colors.blueGrey,size: 30,),
                                      hintText: "Email Address",
                                      hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                  ),
                                  style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54)
                              ),
                            ),
                          ),
                          SizedBox(height: size.height*0.2,),
                          GestureDetector(
                            onTap: (){
                              if(emailvalid){
                                pagecontroller.jumpToPage(0);
                                setState(() {
                                  emailvalid=false;
                                  email2controller.clear();
                                });
                                FloatingSnackBar(message: "Link sent", context: context,textStyle: GoogleFonts.questrial(fontSize: 24));
                              }else{
                                FloatingSnackBar(message: "Invalid Email", context: context,textStyle: GoogleFonts.questrial(fontSize: 24));
                              }

                            },
                            child: Container(
                              width: size.width*0.25,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(child: Text("Send Link",style: GoogleFonts.questrial(fontSize: 32,color: Colors.white),)),
                            ),
                          ),
                          SizedBox(height: size.height*0.025,),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],

      ),
    );
  }
}
