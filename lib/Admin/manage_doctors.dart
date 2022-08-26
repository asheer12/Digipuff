import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_inhaler/Admin/Add.dart';
import 'package:smart_inhaler/Doctors/doctor_home.dart';

import 'package:smart_inhaler/Authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_inhaler/Admin/login_admin.dart';
import 'package:smart_inhaler/Admin/update.dart';
import 'package:smart_inhaler/Patients/pateint_home.dart';

class Manage_Doctors extends StatefulWidget {
  final String usertype;
  static String type="";
  Manage_Doctors({required this.usertype});

  @override
  _Manage_DoctorsState createState() => _Manage_DoctorsState();
}

class _Manage_DoctorsState extends State<Manage_Doctors> {

  @override
  void initState(){
    setState(() {
      Manage_Doctors.type=widget.usertype;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 200 ,
                height: 220,
                padding: EdgeInsets.all(20),
                child: ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_user(usertype: Manage_Doctors.type,)));
                },
                  child: Text("Add Doctor",
                    style: TextStyle(
                      fontSize: 20,

                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 200 ,
                height: 220,
                padding: EdgeInsets.all(20),
                child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Update_user(usertype: Manage_Doctors.type)));
                },
                  child:Text("Update Doctor",
                    style: TextStyle(
                      fontSize: 20,

                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.blue),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    ),
                  ),
                ),
              ),
            ],),
          Row(children: <Widget>[
            Container(
              width: 200 ,
              height: 220,
              padding: EdgeInsets.all(20),
              child: ElevatedButton(onPressed: (){
       Navigator.push(context, MaterialPageRoute(builder: (context)=>Update_user(usertype: Manage_Doctors.type)));
              },
                child:Text("Delete Doctor",
                  style: TextStyle(
                    fontSize: 20,

                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  ),
                ),
              ),
            ),
            Container(
              width: 200 ,
              height: 220,
              padding: EdgeInsets.all(20),
              child: ElevatedButton(onPressed: (){
                //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Connect_to_bluetooth()));
              },
                child:Text("Read Doctor",
                  style: TextStyle(
                    fontSize: 20,

                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.deepOrangeAccent),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  ),
                ),
              ),
            ),
          ],
          ),
        ],
      ),
    );
  }
}
