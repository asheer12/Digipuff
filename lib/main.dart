import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_animated_splash/flutter_animated_splash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_inhaler/Doctors/doctor_home.dart';
import 'package:smart_inhaler/Admin/login_admin.dart';
import 'package:smart_inhaler/Authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:animate_gradient/animate_gradient.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:smart_inhaler/Patients/pateint_home.dart';
void main() async{

  runApp (
      const Inhaler(),
  );
}

class Splash_screen extends StatefulWidget {
  const Splash_screen({Key? key}) : super(key: key);

  @override
  _Splash_screenState createState() => _Splash_screenState();
}


class _Splash_screenState extends State<Splash_screen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplash(
      child: Column(
        children: <Widget>[
          SizedBox(height: 380,),
          Image(image: AssetImage('images/inhaler_splash.png'),
          height: 100,
          ),
          SizedBox(height: 300,),

        ],
      ),
      type: Transition.rightToLeftWithFade,
      curve: Curves.fastLinearToSlowEaseIn,
      backgroundColor:Color(0xfffebe86),
      navigator: Who(),
      durationInSeconds: 4,

    );
  }
}

class Inhaler extends StatelessWidget {

  const Inhaler({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
          primaryColorDark:Color(0xffF4F5F9),

scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Color(0xff0D0E10),
        primaryColorDark: Color(0xff16171C),


      ),

      title: "Smart inhaler",
      home: Splash_screen(),
    );
  }
}


class Who extends StatefulWidget {
  const Who({Key? key}) : super(key: key);

  @override
  _WhoState createState() => _WhoState();
}
enum user{
  doctor, patient
}
enum Colorstween { color1,color2}

class _WhoState extends State<Who> with SingleTickerProviderStateMixin{
user? userselect;
late AnimationController animationController;
late Animation animation;
bool is_visible=false;
Future<FirebaseApp> _initializeFirebase() async {
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  return firebaseApp;
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: _initializeFirebase(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
    return WillPopScope(
    onWillPop: () async => false,
    child:AnimateGradient(
      primaryBegin: Alignment.topCenter,
    primaryEnd: Alignment.bottomCenter,
    secondaryBegin: Alignment.bottomCenter,
    secondaryEnd: Alignment.topCenter,
    secondaryColors: [Color(0xffc8b6ff),Color(0xfffdc5f5), Color(0xffd8c2ff)],
    primaryColors: [
      Color(0xfffdc5f5), Color(0xffd8c2ff),Color(0xffc8b6ff),
    ],
    child: Scaffold(
    backgroundColor: Colors.transparent,
    body: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
    Container(
      height:340,
    padding: EdgeInsets.all(25),
    child:Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Image(image: AssetImage('images/inhaler.png')),
        Text("DigiPuff",
        style: GoogleFonts.barlow(
          textStyle: TextStyle(
              fontSize: 80,
            color: Colors.black,
          ),
        ),
        ),
        Text("BREATH SMART BREATH FRESH",
          style: GoogleFonts.barlow(
            textStyle: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
    ),





    //Doctors and patient button container
    Container(
      height: 270,
      padding:EdgeInsets.all(10) ,
    child:Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children:<Widget>[
    //card-1
    Expanded(
    child: GestureDetector(
    child:Customcard(
    height: 200,
    width: 200,
    cardchild:Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Icon(FontAwesomeIcons.user,size: 40,color:  Colors.white,),
    Text("Doctor",
    style: GoogleFonts.ubuntu(
    color:  Colors.white,
    fontSize: 30,
    ),
    ),
    ],
    ),

    cardcolor: userselect == user.doctor? Colors.green : Colors.black87,
    ),
    onTap: (){
    setState(() {
    userselect=user.doctor;
    });
    },
      onLongPress: (){
      setState(() {
        is_visible=true;
      });
      },
    ),
    ),
    //card-2
    Expanded(
    child: GestureDetector(
    child:Customcard(
    height: 200,
    width: 200,
    cardchild: Column(
    mainAxisAlignment: MainAxisAlignment.center,

    children: <Widget>[
    Icon(FontAwesomeIcons.user,size: 40 ,color: Colors.white,),
    Text("Patient",
    style: GoogleFonts.ubuntu(
    color:  Colors.white,
    fontSize: 30,
    ),
    ),
    ],
    ),
    cardcolor: userselect == user.patient?  Colors.green : Colors.black87,
    ),
    onTap: (){
    setState(() {
    userselect=user.patient;
    });
    },
      onLongPress: (){
        setState(() {
          is_visible=false;
        });
      },
    ),
    ),
    ],
    ),
    ),




    Container(
      padding:EdgeInsets.all(10) ,
    child:
    SizedBox(
    width: 300,
    height: 60,
    child:ElevatedButton(onPressed: (){
    if(userselect == user.doctor) {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                Doctor_home(user: FirebaseAuth.instance.currentUser,type:"doctor",)));
      }
      else {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Login(usertype:"doctor")));
      }
    }

    else if(userselect == user.patient) {
    if(FirebaseAuth.instance.currentUser!=null) {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => Pateint_screen(user: FirebaseAuth.instance.currentUser,type:"patient",)));
    }
    else{
    Navigator.push(context, MaterialPageRoute(
    builder: (context) => Login(usertype:"patient")));
     }
    }
    else{
      AlertDialog alert = AlertDialog(
        title: Text("Alert"),
        content: Text("Please Select Any Option"),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    },
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Text("Get started",
    style: GoogleFonts.barlow(
    textStyle: TextStyle(
    color: Colors.white,
    fontSize: 20
    ),
    ),
    ),
    Icon(FontAwesomeIcons.arrowRight),

    ],
    ),
    style: ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith((states) =>  Colors.black ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(70)
    ),
    ),
    ),
    ),
    ),
    ),
    Visibility(
      visible: is_visible,
      child:  TextButton(
        onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin_login(usertype: "admin",)));
      }, child: Text(
        "View Admin panel",

        style: TextStyle(
          color: Colors.lightGreen,
          fontSize: 15
        ),

      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
        shape:  MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(70)
          ),
        ),
      ),
      ),
    ),
    ],
    ),
    ),
    ),
    );
    }
    else return Center(
      child: CircularProgressIndicator(),
    );
    }
    );
  }
}


