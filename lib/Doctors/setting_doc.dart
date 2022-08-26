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
import 'package:smart_inhaler/Patients/pateint_home.dart';
import 'package:smart_inhaler/Patients/usage.dart';
class Settings_doc extends StatefulWidget {
  const Settings_doc({Key? key}) : super(key: key);

  @override
  _Settings_docState createState() => _Settings_docState();
}

class _Settings_docState extends State<Settings_doc> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[

          ElevatedButton(onPressed: () async {

    },
        child: Text("Logout")
    ),

        ],
      ),
    );
  }
}
