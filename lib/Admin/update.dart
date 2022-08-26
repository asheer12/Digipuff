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
import 'package:smart_inhaler/main.dart';
import 'package:smart_inhaler/Patients/pateint_home.dart';

class Update_user extends StatefulWidget {
  final String usertype;
  static String type="";
  static String? dropdownvalue="enter";
  const Update_user({required this.usertype}) ;

  @override
  _Update_userState createState() => _Update_userState();
}

class _Update_userState extends State<Update_user> {
  @override
  void initState(){
    setState(() {
      Update_user.type=widget.usertype;
    });
    super.initState();
  }
  final _emailcontroller=TextEditingController();
  final _valuecontroller=TextEditingController();
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
                          hintStyle: TextStyle(color: Theme.of(context).primaryColorDark),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),


            DropdownButtonFormField (
                items: <String>["email","name","password","user-id","active","verification"].map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
                  onChanged: (String? newvalue){
                    setState(() {
                      Update_user.dropdownvalue=newvalue;
                    });
                  },
              decoration: InputDecoration(
                hintText: "Choose option to update"
              ),
              ),

                    SizedBox(
                      width: 300,
                      height: 60,
                      child: TextFormField(
                        controller: _valuecontroller,
                        validator: (value){
                          if(value== null || value.isEmpty){
                            return 'Please enter your value';
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xffd6d2d2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Enter new value',
                          hintStyle: TextStyle(color: Theme.of(context).primaryColorDark),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 260,
                      height: 60,
                      child:ElevatedButton(
                        onPressed: () async {
                          String email=_emailcontroller.text.toString();
                          String new_value=_valuecontroller.text.toString();
                          if(_formKey.currentState!.validate()) {
                            if(Update_user.type=="patient"){
                              final querySnapshot = await  FirebaseFirestore.instance.collection('Patients').where("email",isEqualTo: email).get();
                              String uid_patient = querySnapshot.docs.map((doc) => doc.id).toString().replaceAll("(", "").replaceAll(")", "");
                              FirebaseFirestore.instance.collection('Patients').doc(uid_patient).update({Update_user.dropdownvalue.toString():new_value});
                              AlertDialog alert = AlertDialog(
                                content: Text("Value update on cloud"),
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            }
                            else if(Update_user.type=="doctor"){
                              final querySnapshot = await  FirebaseFirestore.instance.collection('Doctors').where("email",isEqualTo: email).get();
                              String uid_doctor = querySnapshot.docs.map((doc) => doc.id).toString().replaceAll("(", "").replaceAll(")", "");
                              FirebaseFirestore.instance.collection('Doctors').doc(uid_doctor).update({Update_user.dropdownvalue.toString():new_value});
                              AlertDialog alert = AlertDialog(
                                content: Text("Value updated on cloud"),
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
                            Text("Update user",
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
