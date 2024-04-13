import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:demo/admin/police_signup.dart';
import 'package:demo/admin/report_fetch.dart';


class Admin_Home_Page extends StatefulWidget {
  const Admin_Home_Page({super.key});

  @override
  State<Admin_Home_Page> createState() => _Admin_Home_PageState();
}

class _Admin_Home_PageState extends State<Admin_Home_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
                children: [ Image.asset("assets/images/adhome.png",height: 205,),
                  Container(width: double.infinity,decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),bottomLeft: Radius.circular(50))),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50,left: 20,right: 20),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        Lottie.asset("assets/lottie/logout1.json",width: 40,height: 40),
                        Container( height: 40,width: 140,
                          child:
                          Directionality(textDirection: TextDirection.ltr,
                            child: ElevatedButton.icon(onPressed: (){}, icon: CircleAvatar(),
                              label: Text("Admin",style: TextStyle(fontSize: 16,color: Colors.white,),),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(HexColor("008DDF"),)),
                            ),
                          ),
                        ),
                      ],),

                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [ Padding(
                      padding: const EdgeInsets.only(left: 20,top: 10),
                      child: Text("Welcome to \nSecure India App",style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),Container( height: 40,width: 230, margin: EdgeInsets.only(top: 20),
                      child:
                      ElevatedButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Police_Signup(),));
                      },child: Center(child: Text("Sign Up for Employee",style: TextStyle(fontSize: 16,color: Colors.white),)),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(HexColor("008DDF"),)),
                      ),
                    ),],),

                    Padding(
                      padding: const EdgeInsets.only(left: 20,top: 10),
                      child: Text("Admin_Name",style: TextStyle(fontSize: 17,color: Colors.white),),
                    ),

                  ],),),]
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Recently Fraud",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                  Gap(10),
                  PhysicalModel(shape: BoxShape.rectangle,
                    color: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 3,
                    child: Stack( children: [
                      Container(height: 200,width: 250,color: Colors.white,child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Text("Digital Fraud Aware " , style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                        Text("Dgital fraud shall therefore be defined as all fraudulent activities perpetrated by external parties through digital ",style: TextStyle(fontSize: 15),), SizedBox(height: 10,),
                        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: HexColor("008DDF")),onPressed: (){}, child: Text("Read More",style: TextStyle(color: Colors.white),))
                      ],),),Positioned(child: Container(child: Image.asset("assets/images/pay_fraud.jpeg",height: 150,fit: BoxFit.none),height: 200,width:150,color: Colors.white,margin: EdgeInsets.only(left: 250),))
                    ],),
                  ),
                  Gap(10),
                  PhysicalModel(shape: BoxShape.rectangle,
                    color: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 3,
                    child: Stack( children: [
                      Container(height: 200,width: 250,color: Colors.white,child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Text("Digital Fraud Aware " , style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                        Text("Dgital fraud shall therefore be defined as all fraudulent activities perpetrated by external parties through digital ",style: TextStyle(fontSize: 15),), SizedBox(height: 10,),
                        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: HexColor("008DDF")),onPressed: (){}, child: Text("Read More",style: TextStyle(color: Colors.white),))
                      ],),),Positioned(child: Container(child: Image.asset("assets/images/pay_fraud.jpeg",height: 150,fit: BoxFit.none),height: 200,width:150,color: Colors.white,margin: EdgeInsets.only(left: 250),))
                    ],),
                  ),
                  Gap(10),
                  PhysicalModel(shape: BoxShape.rectangle,
                    color: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 3,
                    child: Stack( children: [
                      Container(height: 200,width: 250,color: Colors.white,child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Text("Digital Fraud Aware " , style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                        Text("Dgital fraud shall therefore be defined as all fraudulent activities perpetrated by external parties through digital ",style: TextStyle(fontSize: 15),), SizedBox(height: 10,),
                        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: HexColor("008DDF")),onPressed: (){}, child: Text("Read More",style: TextStyle(color: Colors.white),))
                      ],),),Positioned(child: Container(child: Image.asset("assets/images/pay_fraud.jpeg",height: 150,fit: BoxFit.none),height: 200,width:150,color: Colors.white,margin: EdgeInsets.only(left: 250),))
                    ],),
                  ),
                  Container(width: 300,height: 50,margin: EdgeInsets.only(left: 39,top: 20),
                    child: ElevatedButton(style: ElevatedButton.styleFrom(elevation: 3,shadowColor:Colors.black,backgroundColor: HexColor("008FDC")),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminComplaintsPage(),));
                      },
                      child: Text('View Complains',style: TextStyle(color: Colors.white,fontSize: 19)),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}