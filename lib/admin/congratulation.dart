import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:demo/admin/admin_home_page.dart';

class Congratulation extends StatefulWidget {
  const Congratulation({super.key});

  @override
  State<Congratulation> createState() => _CongratulationState();
}

class _CongratulationState extends State<Congratulation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: 500,
        height: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 40),
            // Popup Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Image.asset(
                'assets/images/bgimg8.png', // Replace with the actual image path
                width: 250,
                height: 150,
                fit: BoxFit.fill,
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.only(top: 20,bottom: 30),
              child: Text(
                'Congratulations!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Subtitle
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                'You have successfully Created Police Account.\nThis Account is Ready to Use.\n '
                    'You will be redirected to the \nHome Page',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            // Loading Effect
            Container( height: 50,width: 380, margin: EdgeInsets.only(top: 100),
              child:
              Directionality(textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const Admin_Home_Page(),));
                }, label: Text("Continue",style: TextStyle(fontSize: 20,color: Colors.white),),
                  icon: Icon(Icons.arrow_back,color: Colors.white,),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(HexColor("146c94"),)),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
