import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:smart_inhaler/Authentication/login.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_inhaler/Patients/profile_edit.dart';
import 'pateint_home.dart';
import 'usage.dart';
class Settings_patient extends StatefulWidget {
  static User? _currentUser;
  final  User? user;
  Settings_patient({required this.user});

  @override
  _Settings_patientState createState() => _Settings_patientState();
}

class _Settings_patientState extends State<Settings_patient> {
  @override
  initState() {
    super.initState();
    Settings_patient._currentUser=widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
      ),
      body:Container(
        height: 600,
        padding: EdgeInsets.all(20),
        child:Column(
        children: <Widget>[
         SizedBox(
           height: 50,
           width: 400,
           child: ElevatedButton(
             onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>Edit_profile(user: Settings_patient._currentUser)));
             },
             child:  Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Text("Edit profile",
                   style: GoogleFonts.barlow(
                     textStyle: TextStyle(
                         color: Color(0xffc8b6ff),
                         fontSize: 20
                     ),
                   ),
                 ),
                 Icon(FontAwesomeIcons.edit,
                 color: Color(0xffc8b6ff),
                 ),
               ],
             ),

             style: ButtonStyle(
                 backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.black),
                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                   RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(70),
                   ),
                 ),

           ),
           ),
         ),
        ],
      ),
      ),
    );
  }
}
