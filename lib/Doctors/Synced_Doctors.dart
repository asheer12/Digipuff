import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/Patients//Chatting_patient.dart';
import 'package:smart_inhaler/Patients//Pateints_usage.dart';
import 'package:smart_inhaler/Doctors/chatting_doc.dart';
import 'package:smart_inhaler/Authentication/login.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_home.dart';

class Synced_doctors extends StatefulWidget {
  final String doctor_uid;
  static String current_uid="";
  Synced_doctors({required this.doctor_uid});

  @override
  _Synced_doctorsState createState() => _Synced_doctorsState();
}

class _Synced_doctorsState extends State<Synced_doctors> {
  @override
  void initState(){
    Synced_doctors.current_uid=widget.doctor_uid;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 200,
            child:ListView(
            scrollDirection: Axis.horizontal,
        children:[
          Container(
            width: 180 ,
            height: 180,
            padding: EdgeInsets.only(top: 20,left: 20),
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Chatting_patient(doctor_uid:Synced_doctors.current_uid )));
            },
              child:Text("chatting"),
              style: ButtonStyle(

                backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.deepPurpleAccent),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),

                ),
                ),
              ),
            ),
          ),

      ],
          ),
          ),
        ],
      ),
    );
  }
}
