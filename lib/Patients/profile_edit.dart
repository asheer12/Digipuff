import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/Doctors/doctor_home.dart';
import 'package:smart_inhaler/Authentication/login.dart';
import 'package:smart_inhaler/main.dart';
import 'package:smart_inhaler/Patients/pateint_home.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:smart_inhaler/Authentication/signup.dart';
import 'package:smart_inhaler/Authentication/forgetpassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Edit_profile extends StatefulWidget {
 final User? user;
 static User? current_user;
Edit_profile({required this.user});
  @override
  _Edit_profileState createState() => _Edit_profileState();
}


class _Edit_profileState extends State<Edit_profile> {
  final _namecontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: Container(
        height: 300,
        width: 500,
        padding: EdgeInsets.all(20),

        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: 300,
            height: 60,
            child: TextFormField(
              controller: _namecontroller,
              validator: (value){
                if(value== null || value.isEmpty){
                  return 'Please enter your name';
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffc8b6ff),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter name here',
                hintStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 260,
            height: 50,
            child:ElevatedButton(
              onPressed:  () {
                FirebaseAuth.instance.currentUser!.updateDisplayName(_namecontroller.text.toString());
                  FirebaseFirestore.instance.collection('Patients').doc(FirebaseAuth.instance.currentUser?.uid).update({"name":_namecontroller.text.toString()});
                AlertDialog alert = AlertDialog(
                  title: Text("Change alert"),
                  content: Text("Your display name is changed"),
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              },
              child:Text("Save",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) =>Colors.black),
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
    );
  }
}
