import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/Doctors/chatting_doc.dart';
import 'package:smart_inhaler/Authentication/login.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_inhaler/Doctors/doctor_home.dart';
import 'Pateints_usage.dart';
class Synced_patients extends StatefulWidget {
  final String pateint_uid;
  static String current_uid="";
  Synced_patients({required this.pateint_uid});

  @override
  _Synced_patientsState createState() => _Synced_patientsState();
}

class _Synced_patientsState extends State<Synced_patients> {
  @override
  void initState(){
    Synced_patients.current_uid=widget.pateint_uid;
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
      body:Column(
        children: <Widget>[
          Container(
      height: 200,
      child:
      ListView(
      scrollDirection: Axis.horizontal,
        children:[
          Container(
            width: 180 ,
            height: 180,
            padding: EdgeInsets.only(top: 20,left: 20),
            child:  ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Chatting_doc(patient_uid:Synced_patients.current_uid )));
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

          Container(
            width: 180 ,
            height: 180,
            padding: EdgeInsets.only(top: 20,left: 20),
            child:  ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Patient_usage(Patient_uid: Synced_patients.current_uid)));
            },
              child:Text("Usage"),
              style: ButtonStyle(

                backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green),
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

class Patient_Usage {
}
