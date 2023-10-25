import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:ecosoftvmsgate/modals/classes.dart';
import 'package:ecosoftvmsgate/modals/example.dart';
import 'package:ecosoftvmsgate/services/exportmodal.dart';
import 'package:ecosoftvmsgate/services/services.dart';
import 'package:file_saver/file_saver.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

String splitdatetime(String dt){
  if(dt.contains('&')){
    final l = dt.split('&');
    return ("${l[0]} @ ${l[1]}");
  }
  return "";

}

class VisitorLogBook extends StatefulWidget {
  const VisitorLogBook({super.key,required this.Staffname});
  final String Staffname;
  @override
  State<VisitorLogBook> createState() => _VisitorLogBookState();
}

class _VisitorLogBookState extends State<VisitorLogBook> {
  bool loaded=false;
  int page=0;
  int filterselcted=0;
  int detailsindex=0;
  List<LogBook> filtered=[LogBook(VisitorName: "", Purpose: "", Checkedin: "", Checkedout: "", id: "", CompanyName: "", emailId: "", Phoneno: "", Staff: "")];
  List<LogBook> logreports= [LogBook(VisitorName: "", Purpose: "", Checkedin: "", Checkedout: "", id: "", CompanyName: "", emailId: "", Phoneno: "", Staff: "")];
  Services services= Services();
  final _pagecontroller = PageController(initialPage: 0);
  final _searchcontroller = TextEditingController();
  int checkinindex=-1;
  List headers=[
    ["Visitor",Icons.person],
    ["Staff",Icons.people_alt_outlined],
    ["Phoneno",Icons.phone],
    ["Check-in",Icons.timer],
    ["Check-out",Icons.timer],
    ["Details",Icons.visibility]
  ];
  String search="";
  final example = exampledata();

  Future<void> getalllog() async{
    List<LogBook> temp = await services.getlog(widget.Staffname=="Gate"?"":widget.Staffname);
    List<LogBook> temp2=[];
    if(mounted){
      setState(() {
        for(var a in temp.reversed.toList()){
          if(a.Checkedin==""){
            temp2.add(a);
          }
        }
        for(var a in temp.reversed.toList()){
          if(a.Checkedout ==""){
            temp2.add(a);
          }
        }
        for(var a in temp.reversed.toList()){
          if(!temp2.contains(a)){
            temp2.add(a);
          }
        }
        logreports=temp2;
        filtered=logreports;
      });
    }

  }
  @override
  void initState(){
    getalllog();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    Size size= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: PageView(
        controller: _pagecontroller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height*0.08,child: Center(
              child: Text("Visitors Log Reports",style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold),),
            ),),
            SizedBox(
              height: 150,
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: size.width*0.24,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow:[
                        BoxShadow(
                          color: Colors.black38,blurRadius: 3
                        )
                      ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width:size.width*0.14,
                            child: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),
                              controller: _searchcontroller,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap:(){
                            setState(() {
                              search=_searchcontroller.text;
                              filtered= logreports.where((item) => item.VisitorName.toLowerCase().contains(_searchcontroller.text)).toList();
                            });
                          },
                          child: Container(
                            width: size.width*0.08,
                            height: 60,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
                              color: Colors.black87
                            ),
                            child: Center(child: Text("Search",style: GoogleFonts.questrial(fontSize: 24,color: Colors.white),)),
                          ),
                        )
                      ],
                    ),

                  ),
                  GestureDetector(
                    onTap: (){
                      exportdata(filtered, context);
                      FloatingSnackBar(message: "Data Downloaded", context: context);
                    },
                    child: Container(
                      width: size.width*0.08,
                      height: 60,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.black87
                      ),
                      child: Center(child: Text("Export Data",style: GoogleFonts.questrial(fontSize: 24,color: Colors.white),)),
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      getalllog();
                    },
                    child: Container(
                      width: size.width*0.08,
                      height: 60,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.black87
                      ),
                      child: Center(child: Text("Refresh",style: GoogleFonts.questrial(fontSize: 24,color: Colors.white),)),
                    ),
                  ),
                  SizedBox(
                    width: size.width*0.08,
                    height: 60,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.date_range),
                        Text("Today",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black),),
                        const Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: size.width*0.8,
                height: size.height*0.6 ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width*0.15,
                      height: size.height*.55,
                      decoration: const BoxDecoration(
                        border: Border(right: BorderSide(color: Colors.grey))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.filter_alt,size: 50,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text("Filters",style: GoogleFonts.questrial(fontSize: 32,color: Colors.black,fontWeight: FontWeight.bold),),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: size.height*0.1,),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap:(){
                                      setState(() {
                                        filterselcted=0;
                                      });
                                    },
                                    child: Icon(filterselcted==0?Icons.check_box:Icons.check_box_outline_blank,size: 30,)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text("All",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black,),),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap:(){
                                      setState(() {
                                        filterselcted=1;
                                      });
                                    },
                                    child: Icon(filterselcted==1?Icons.check_box:Icons.check_box_outline_blank,size: 30,)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text("Expected",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black),),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap:(){
                                      setState(() {
                                        filterselcted=2;
                                      });
                                    },
                                    child: Icon(filterselcted==2?Icons.check_box:Icons.check_box_outline_blank,size: 30,)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text("Checked in",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black),),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap:(){
                                      setState(() {
                                        filterselcted=3;
                                      });
                                    },
                                    child: Icon(filterselcted==3?Icons.check_box:Icons.check_box_outline_blank,size: 30,)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text("Checked out",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black),),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width*0.6,
                          height: 80,
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              headerwidget(size: size, headers: headers,index: 0,),
                              Visibility(
                                  visible: (widget.Staffname=="Gate"),
                                  child: headerwidget(size: size, headers: headers,index: 1,)),
                              headerwidget(size: size, headers: headers,index: 2,),
                              headerwidget(size: size, headers: headers,index: 3,),
                              headerwidget(size: size, headers: headers,index: 4,),
                              headerwidget(size: size, headers: headers,index: 5,)
                            ],
                          ),

                        ),
                        SizedBox(
                          width: size.width*0.6,
                          height: size.height*0.6-80,
                          child: filtered.isEmpty?
                          Center(
                            child: Text("No Such Reports..",style: GoogleFonts.questrial(fontSize: 32,color: Colors.black54),),
                          )
                          :ListView.builder(
                              itemCount: filtered.sublist(page*6,filtered.length<(page+1)*6?filtered.length:(page+1)*6).length>6?6:filtered.sublist(page*6,filtered.length<(page+1)*6?filtered.length:(page+1)*6).length,
                              itemBuilder: (BuildContext context,int index){
                                List<LogBook> pagelist = filtered.sublist(page*6,filtered.length<(page+1)*6?filtered.length:(page+1)*6);
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: SizedBox(
                                width: size.width,
                                height: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    logdisplay(size: size, text: pagelist[index].VisitorName),
                                    Visibility(
                                        visible: (widget.Staffname=="Gate"),
                                        child: logdisplay(size: size, text: pagelist[index].Staff)),
                                    logdisplay(size: size, text: pagelist[index].Phoneno),
                                    SizedBox(width: size.width*0.09,
                                      child: pagelist[index].Checkedin==""?
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: GestureDetector(
                                          onTap: (){
                                            _pagecontroller.jumpToPage(1);
                                            setState(() {
                                              checkinindex=index;
                                            });

                                          },
                                          child: Container(width: size.width*0.04,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(child: Text("Check In",style: GoogleFonts.questrial(fontSize: 24,color: Colors.white),)),),
                                        ),
                                      ):Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(pagelist[index].Checkedin.split('&')[0],style: GoogleFonts.questrial(fontSize: 20,color: Colors.black54),),
                                          Text("@ ${pagelist[index].Checkedin.split('&')[1]}",style: GoogleFonts.questrial(fontSize: 20,color: Colors.black54))

                                        ],
                                      )
                                    ),
                                    SizedBox(width: size.width*0.09,
                                        child: pagelist[index].Checkedin==""?Center(child: Text("--",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),),):pagelist[index].Checkedout=="Still In"?
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(width: size.width*0.04,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(child: Text("Check Out",style: GoogleFonts.questrial(fontSize: 24,color: Colors.white),)),),
                                        ):Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(pagelist[index].Checkedout.split('&')[0],style: GoogleFonts.questrial(fontSize: 20,color: Colors.black54),),
                                            Text("@ ${pagelist[index].Checkedout.split('&')[1]}",style: GoogleFonts.questrial(fontSize: 20,color: Colors.black54))

                                          ],
                                        )
                                    ),
                                    SizedBox(width: size.width*0.09,child: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            detailsindex=(page*6)+index;
                                            _pagecontroller.jumpToPage(3);
                                          });
                                        },
                                        child: const Icon(Icons.visibility,color: Colors.grey,size: 30,)),),
                                  ],
                                ),

                              ),
                            );
                          }),
                        )
                      ],
                    )
                  ],
                ),
              ),

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: size.width*0.45,),
                Text("Showing ${(page*6)+1}-${filtered.length<(page+1)*6?filtered.length:(page+1)*6} /${filtered.length} entries",style:
                  GoogleFonts.questrial(fontSize: 24),),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Visibility(
                      visible: page!=0,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            page=page-1;
                          });
                        },
                        child: Container(width: 100,height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black
                          ),
                          child: Center(child: Text("Previous",style: GoogleFonts.questrial(fontSize: 24,color: Colors.white),)),),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Visibility(
                      visible: filtered.length>6 && (filtered.length>(page+1)*6),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            page=page+1;
                          });
                        },
                        child: Container(width: 100,height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black
                          ),
                          child: Center(child: Text("Next",style: GoogleFonts.questrial(fontSize: 24,color: Colors.white),)),),
                      )),
                )
              ],
            )
          ],
        ),
            checkinindex==-1?Container():SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height*0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: size.width*0.7,),
                        GestureDetector(
                            onTap: (){
                              _pagecontroller.jumpToPage(-1);
                            },
                            child: const Icon(Icons.highlight_off,size: 50,color: Colors.black,))

                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height*0.05),
                    child: Text("Check in Visitor",style: GoogleFonts.questrial(fontSize: 60,fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,bottom: 40),
                    child: Text("Please verify all the details",style: GoogleFonts.questrial(fontSize: 30,color: Colors.black38),),
                  ),
                  SizedBox(
                    width: size.width*0.8,
                    height: size.height*0.55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: size.width*0.3,
                          height: size.height*0.55,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.person_outline,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 72),
                                    child: Text("ID",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  ),
                                  Text(filtered[(page*6)+checkinindex].id,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.person_outline,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20),
                                    child: Text("Name",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  ),
                                  Text(filtered[(page*6)+checkinindex].VisitorName,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.mail_outline,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 30),
                                    child: Text("Email",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  ),
                                  Text(filtered[(page*6)+checkinindex].emailId,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.phone_outlined,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20),
                                    child: Text("Phone",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  ),
                                  Text(filtered[(page*6)+checkinindex].Phoneno,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),)
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: size.width*0.3,
                          height: size.height*0.55,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.credit_card,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 45),
                                    child: Text("Aadhar",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  ),
                                  Text("876587658765",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.apartment,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20),
                                    child: Text("Company",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  ),
                                  Text(filtered[(page*6)+checkinindex].CompanyName,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.people_alt_outlined,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 85),
                                    child: Text("Staff",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  ),
                                  Text(filtered[(page*6)+checkinindex].Staff,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.dashboard_outlined,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 40),
                                    child: Text("Purpose",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  ),
                                  Text(filtered[(page*6)+checkinindex].Purpose,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: size.width*0.65,),
                      GestureDetector(
                        onTap: (){
                          _pagecontroller.jumpToPage(-1);

                        },
                        child: Container(width: size.width*0.08,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Center(child: Text("Check In",style: GoogleFonts.questrial(fontSize: 24,color: Colors.white),)),),
                      ),
                    ],
                  )
                ],
              ),
            ),
            filtered.isEmpty?Container():SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: size.width*0.05,top: size.height*0.02,bottom: size.height*0.02),
                    child: IconButton(onPressed: (){
                      _pagecontroller.jumpToPage(-1);
                    }, icon: const Icon(Icons.keyboard_arrow_left,size: 50,) ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width*0.12.toDouble(),bottom: size.height*0.05),
                    child: Row(
                      children: [
                        Text("Visitor's Profile:   ",style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold),),
                        Text(filtered[detailsindex].id,style: GoogleFonts.questrial(fontSize: 32,color: Colors.black54),)
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: size.width*0.12),
                        child: SizedBox(
                          width: size.width*0.17,
                          height: size.height*0.65,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person_outline,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text("ID",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.person_outline,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text("Full Name",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.mail_outline,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text("Email Address",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.phone_outlined,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text("Phone Number",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.apartment,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text("Company Name",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.people_alt_outlined,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text("Staff",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.dashboard_outlined,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text("Purpose of Visit",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text("Check-in Time",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined,size: 40,color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text("Check-out Time",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black),),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:size.width*0.08),
                        child: SizedBox(
                          width: size.width*0.4,
                          height: size.height*0.65,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(filtered[detailsindex].id,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),),

                              Text(filtered[detailsindex].VisitorName,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),),

                              Text(filtered[detailsindex].emailId,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),),

                              Text(filtered[detailsindex].Phoneno,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),),

                              Text(filtered[detailsindex].CompanyName,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),),

                              Text(filtered[detailsindex].Staff,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),),

                              Text(filtered[detailsindex].Purpose,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),),

                              filtered[detailsindex].Checkedin==""?
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(width: size.width*0.06,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(child: Text("Check In",style: GoogleFonts.questrial(fontSize: 24,color: Colors.white),)),),
                              ):Text("${filtered[detailsindex].Checkedin.split('&')[0]} @ ${filtered[detailsindex].Checkedin.split('&')[1]}" ,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),),

                              filtered[detailsindex].Checkedin==""?Text("Still In",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),):filtered[detailsindex].Checkedout=="Still In"?
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(width: size.width*0.08,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(child: Text("Check Out",style: GoogleFonts.questrial(fontSize: 24,color: Colors.white),)),),
                              ):Text("${filtered[detailsindex].Checkedout.split('&')[0]} @ ${filtered[detailsindex].Checkedout.split('&')[1]}",style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),)
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                  ],
              ),
            )

      ]),
    );
  }
}
class logdisplay extends StatelessWidget {
  const logdisplay({
    super.key,
    required this.size,
    required this.text
  });

  final Size size;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: size.width*0.09,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text(text.length>10?"${text.substring(0,9)}..":text,style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),),
            )
          ],
        ),

      ),
    );
  }
}
class headerwidget extends StatelessWidget {
  const headerwidget({
    super.key,
    required this.size,
    required this.headers,
    required this.index
  });

  final Size size;
  final List headers;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: size.width*0.09,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(headers[index][1],size: 30,),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text(headers[index][0],style: GoogleFonts.questrial(fontSize: 24,color: Colors.black,fontWeight: FontWeight.bold),),
            )
          ],
        ),

      ),
    );
  }
}

