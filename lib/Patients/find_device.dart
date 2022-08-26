import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/connection.dart';
import 'package:smart_inhaler/Authentication/login.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_inhaler/main.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_inhaler/Patients/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Chatting_patient.dart';
import 'usage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart ' as tz;
import 'timings.dart';


class Find_device extends StatefulWidget {
  static String location="";
  const Find_device({Key? key}) : super(key: key);

  @override
  _Find_deviceState createState() => _Find_deviceState();
}

class _Find_deviceState extends State<Find_device> {
  @override
  void initState(){

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
        body:Column(
          children: <Widget>[
            Container(
              width: 400 ,
              height: 220,
              padding: EdgeInsets.all(20),
              child: ElevatedButton(onPressed: (){
                //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Connect_to_bluetooth()));
              },
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:<Widget>[

                      Text("GPS-Location",
                        style: TextStyle(
                          fontSize: 20,

                        ),
                      ),
                      Text(Find_device.location.replaceAll("location:", "Latitude").replaceAll(",", " Longitude "),
                        style: TextStyle(
                          fontSize: 20,

                        ),
                      ),
                    ]
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xffff7477)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
