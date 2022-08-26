import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_inhaler/Doctors/doctor_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/Authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_inhaler/Admin/login_admin.dart';
import 'package:smart_inhaler/Patients/pateint_home.dart';

class Delete_user extends StatefulWidget {
  final String usertype;
  static String type="";
  const Delete_user({required this.usertype}) ;

  @override
  _Delete_userState createState() => _Delete_userState();
}

class _Delete_userState extends State<Delete_user> {
  @override
  void initState(){
    setState(() {
      Delete_user.type=widget.usertype;
    });
    super.initState();
  }
  final _emailcontroller=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body:SingleChildScrollView(
        child: Column(
        children: <Widget>[
        Container(
        padding: EdgeInsets.all(50),
    height: 500,
    width: 600,
    child: Form(
    key: _formKey,
    child:Column(
   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[

    //textfeild 1
    SizedBox(
    width: 300,
    height: 60,
    child: TextFormField(
    controller: _emailcontroller,
    validator: (value){
    if(value== null || value.isEmpty){
    return 'Please enter your email';
    }
    },
    decoration: InputDecoration(
    filled: true,
    fillColor: Color(0xffd6d2d2),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide.none,
    ),
    hintText: 'Example@gmail.com',
    hintStyle: TextStyle(color: Theme.of(context).primaryColor),
    ),
    style: TextStyle(
    color: Theme.of(context).primaryColor,
    ),
    ),
    ),

          SizedBox(
            width: 260,
            height: 60,
            child:ElevatedButton(
              onPressed: () async {
                  String email=_emailcontroller.text.toString();
                  if(_formKey.currentState!.validate()) {
                   if(Delete_user.type=="patient"){
                     final querySnapshot = await  FirebaseFirestore.instance.collection('Patients').where("email",isEqualTo: email).get();
                     String uid_patient = querySnapshot.docs.map((doc) => doc.id).toString().replaceAll("(", "").replaceAll(")", "");
                     FirebaseFirestore.instance.collection('Patients').doc(uid_patient).delete();
                     AlertDialog alert = AlertDialog(
                       content: Text("Pateint deleted from cloud"),
                     );
                     showDialog(
                       context: context,
                       builder: (BuildContext context) {
                         return alert;
                       },
                     );
                   }
                   else if(Delete_user.type=="doctor"){
                     final querySnapshot = await  FirebaseFirestore.instance.collection('Doctors').where("email",isEqualTo: email).get();
                     String uid_doctor = querySnapshot.docs.map((doc) => doc.id).toString().replaceAll("(", "").replaceAll(")", "");
                     FirebaseFirestore.instance.collection('Doctors').doc(uid_doctor).delete();
                     AlertDialog alert = AlertDialog(
                       content: Text("Doctor deleted from cloud"),
                     );
                     showDialog(
                       context: context,
                       builder: (BuildContext context) {
                         return alert;
                       },
                     );
                   }
                  }
    },
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Delete user",
                    style: GoogleFonts.barlow(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                  ),
                  Icon(FontAwesomeIcons.user),
                ],
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
        ],
      ),
      ),
    );
  }
}
