import 'package:ecosoftvmsgate/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_snackbar/floating_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../modals/classes.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  bool areSameDay(DateTime dateTime1, DateTime dateTime2) {
    return dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day;
  }
  DateTime parseDateTimeFromString(String dateTimeString) {
    List<String> parts = dateTimeString.split('&');
    if (parts.length != 2) {
      throw FormatException("Invalid format: $dateTimeString");
    }
    String datePart = parts[0];
    String timePart = parts[1];
    List<String> dateComponents = datePart.split('-');
    List<String> timeComponents = timePart.split(':');
    if (dateComponents.length != 3 || timeComponents.length != 2) {
      throw FormatException("Invalid format: $dateTimeString");
    }
    int day = int.parse(dateComponents[0]);
    int month = int.parse(dateComponents[1]);
    int year = int.parse(dateComponents[2]);
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);

    // Create a DateTime object
    return DateTime(year, month, day, hour, minute);
  }
  List<LogBook> alldata=[];
  List<LogBook> historytoday=[
    //LogBook(VisitorName: "Loading..", Purpose: "Loading..", Checkedin: "Loading.&.", Checkedout: "Loading.&.", id: "Loading..", CompanyName: "Loading..", emailId: "Loading..", Phoneno: "Loading..", Staff: "Loading..")
  ];
  List<Requests> req=[];
  List<LogBook> checkin=[];
  Services services = Services();
  Future<void> getreq() async{
    List<Requests> temp= await services.getstaffreq(FirebaseAuth.instance.currentUser!.displayName!) as List<Requests>;
    if(mounted){
      setState(() {
        req=temp;
        req.sort((a,b)=> b.ReqTime.compareTo(a.ReqTime));

      });
    }

  }
  Future<void> getdata() async{
    List<LogBook> temp2=[];
    List<LogBook> temp3=[];
    List<LogBook> temp = await services.getlog(FirebaseAuth.instance.currentUser!.displayName as String);
    List<LogBook> tempcheck= await services.gecheckin() as List<LogBook>;
    setState(() {
      alldata= temp;
      checkin=tempcheck;
    });
    for(LogBook a in temp){
      if(a.Checkedin!="" && a.Checkedout!="Still In"){
        if(areSameDay(DateTime.now(), parseDateTimeFromString(a.Checkedin))){
          temp2.add(a);
        }

      }
      if(a.Checkedin!="" && a.Checkedout==""){
        temp3.add(a);
      }
    }
    setState(() {
      historytoday=temp2;
    });
  }
  @override
  void initState() {
    getdata();
    getreq();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(color: Colors.black38,blurRadius: 15,offset: Offset(10, 10)),

                      BoxShadow(color: Colors.white,blurRadius: 15,offset: Offset(-10, -10)),
                    ]
                  ),
                  width: size.width*0.15,
                  height: size.height*0.23,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("20",style: GoogleFonts.questrial(fontSize: 80,color: Colors.black54,fontWeight: FontWeight.bold),),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.person_outline,size: 30,color: Colors.blueGrey,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Visitors Expected",style: GoogleFonts.questrial(fontSize: 24,),),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(color: Colors.black38,blurRadius: 15,offset: Offset(10, 10)),

                        BoxShadow(color: Colors.white,blurRadius: 15,offset: Offset(-10, -10)),
                      ]
                  ),
                  width: size.width*0.15,
                  height: size.height*0.23,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(req.length.toString(),style: GoogleFonts.questrial(fontSize: 80,color: Colors.black54,fontWeight: FontWeight.bold),),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.person_add_outlined,size: 30,color: Colors.blueGrey,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Requests Pending",style: GoogleFonts.questrial(fontSize: 24,),),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(color: Colors.black38,blurRadius: 15,offset: Offset(10, 10)),

                        BoxShadow(color: Colors.white,blurRadius: 15,offset: Offset(-10, -10)),
                      ]
                  ),
                  width: size.width*0.15,
                  height: size.height*0.23,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(checkin.length.toString(),style: GoogleFonts.questrial(fontSize: 80,color: Colors.black54,fontWeight: FontWeight.bold),),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.people_alt_outlined,size: 30,color: Colors.blueGrey,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Visitors In",style: GoogleFonts.questrial(fontSize: 24,),),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(color: Colors.black38,blurRadius: 15,offset: Offset(10, 10)),

                        BoxShadow(color: Colors.white,blurRadius: 15,offset: Offset(-10, -10)),
                      ]
                  ),
                  width: size.width*0.15,
                  height: size.height*0.23,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(historytoday.length.toString(),style: GoogleFonts.questrial(fontSize: 80,color: Colors.black54,fontWeight: FontWeight.bold),),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.groups_outlined,size: 40,color: Colors.blueGrey,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Completed Meetings",style: GoogleFonts.questrial(fontSize: 24,),),
                      )
                    ],
                  ),
                ),
              ],

            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: SizedBox(
                width:size.width*0.7,
                child: const Divider()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width*0.5,
                height: size.height*0.55,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(color: Colors.black38,blurRadius: 15,offset: Offset(10, 10)),

                      BoxShadow(color: Colors.white,blurRadius: 15,offset: Offset(-10, -10)),
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Visitation History",style: GoogleFonts.questrial(fontSize: 24,fontWeight: FontWeight.bold),),
                          GestureDetector(
                            onTap: (){
                              getdata();
                              getreq();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black
                              ),
                              width: size.width*0.1,
                              height: 40,
                              child: Center(child: Text("Refresh",style: GoogleFonts.questrial(fontSize: 28,color: Colors.white),)),
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: size.width*0.1,
                            height: 50,
                            child: Row(
                              children: [
                                const Icon(Icons.person),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Visitor Name",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width*0.1,
                            height: 50,
                            child: Row(
                              children: [
                                const Icon(Icons.phone),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Phone no",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width*0.1,
                            height: 50,
                            child: Row(
                              children: [
                                const Icon(Icons.timer_outlined),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("In-Time",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width*0.1,
                            height: 50,
                            child: Row(
                              children: [
                                const Icon(Icons.timer_outlined),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Out-Time",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: size.height*0.025,),
                      SizedBox(
                        width: size.width*0.55,
                        height: size.height*0.37,
                        child: historytoday.length==0?Center(child: Text("No Visits Today...",style: GoogleFonts.questrial(fontSize: 40,color: Colors.black54),),):ListView.builder(
                            itemCount: historytoday.length,
                            itemBuilder: (BuildContext context,int index){
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: size.width*0.1,
                                height: 80,
                                child: Text(historytoday[index].VisitorName,style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),),
                              ),

                              SizedBox(
                                width: size.width*0.1,
                                height: 80,
                                child: Text(historytoday[index].Phoneno,style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),),
                              ),

                              SizedBox(
                                width: size.width*0.1,
                                height: 80,
                                child: Column(
                                  children: [
                                    Text(historytoday[index].Checkedin=="Loading?"?historytoday[index].Checkedin:historytoday[index].Checkedin.split('&')[0],style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),),
                                    Text(historytoday[index].Checkedin=="Loading?"?historytoday[index].Checkedin:"@ ${historytoday[index].Checkedin.split('&')[1]}",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),),
                                  ],
                                ),
                              ),

                              SizedBox(
                                width: size.width*0.1,
                                height: 80,
                                child: Column(
                                  children: [
                                    Text(historytoday[index].Checkedout=="Loading?"?historytoday[index].Checkedout:historytoday[index].Checkedout.split('&')[0],style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),),
                                    Text(historytoday[index].Checkedout=="Loading?"?historytoday[index].Checkedout:"@ ${historytoday[index].Checkedout.split('&')[1]}",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),),
                                  ],
                                ),
                              )

                            ],
                          );
                        }),

                      )

                    ],
                  ),
                ),
              ),

              SizedBox(
                height: size.height*0.55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: size.width*0.2,
                      height: size.height*0.25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(color: Colors.black38,blurRadius: 15,offset: Offset(10, 10)),

                            BoxShadow(color: Colors.white,blurRadius: 15,offset: Offset(-10, -10)),
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("Requests",style: GoogleFonts.questrial(fontSize: 24,fontWeight: FontWeight.bold),),
                            const Divider(),
                            SizedBox(
                              width: size.width*0.2,
                              height: size.height*0.14,
                              child: req.length==0?Center(child: Text("No Requests Pending",style: GoogleFonts.questrial(color: Colors.black54,fontSize: 24),),):
                                  ListView.builder(
                                      itemCount: req.length,
                                      itemBuilder: (BuildContext context,int index){
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: size.width*0.18,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(req[index].Name,style: GoogleFonts.questrial(fontSize: 18,fontWeight: FontWeight.bold),),
                                                  Text(req[index].Purpose,style: GoogleFonts.questrial(fontSize: 16,color: Colors.black54),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  IconButton(onPressed: ()async{
                                                    await services.checkin(req[index]).then((value){
                                                      FloatingSnackBar(message: "Request accepted", context: context,textStyle: GoogleFonts.questrial(fontSize: 24));
                                                      getreq();
                                                    }).catchError((error){
                                                      FloatingSnackBar(message: "An error has occurred", context: context,textStyle: GoogleFonts.questrial(fontSize: 24));
                                                    });

                                                  }, icon: Icon(Icons.check_circle_outline,size: 30,),),
                                                  IconButton(onPressed: (){

                                                  }, icon: Icon(Icons.highlight_off,size: 30,)),

                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: size.width*0.2,
                      height: size.height*0.25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(color: Colors.black38,blurRadius: 15,offset: Offset(10, 10)),

                            BoxShadow(color: Colors.white,blurRadius: 15,offset: Offset(-10, -10)),
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("Visitors-In",style: GoogleFonts.questrial(fontSize: 24,fontWeight: FontWeight.bold),),
                            const Divider(),
                            SizedBox(
                                width: size.width*0.2,
                                height: size.height*0.12,
                                child: checkin.length==0?Center(child: Text("No-one In",style: GoogleFonts.questrial(color: Colors.black54,fontSize: 24),),):
                                ListView.builder(
                                    itemCount: checkin.length,
                                    itemBuilder: (BuildContext context,int index){
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: size.width*0.18,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(checkin[index].VisitorName,style: GoogleFonts.questrial(fontSize: 18,fontWeight: FontWeight.bold),),
                                                    Text(checkin[index].Purpose,style: GoogleFonts.questrial(fontSize: 16,color: Colors.black54),),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment:CrossAxisAlignment.end,
                                                  children: [
                                                    Text(checkin[index].Checkedin.split('&')[0],style: GoogleFonts.questrial(fontSize: 16,color: Colors.black54,),),
                                                    Text("@ "+checkin[index].Checkedin.split('&')[1],style: GoogleFonts.questrial(fontSize: 16,color: Colors.black54,)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],

          )

        ],

      )
    );
  }
}
