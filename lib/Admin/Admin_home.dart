import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_inhaler/Doctors/doctor_home.dart';

import 'package:smart_inhaler/Authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_inhaler/Admin/login_admin.dart';
import 'package:smart_inhaler/Admin//manage_patients.dart';
import 'manage_doctors.dart';
import 'package:smart_inhaler/Patients/pateint_home.dart';


class Admin_home extends StatefulWidget {
  final String usertype;
  static String type="";
  static User? _currentUser;
  final  User? user;
  Admin_home({required this.usertype,required this.user});

  @override
  _Admin_homeState createState() => _Admin_homeState();
}

class _Admin_homeState extends State<Admin_home> {

  @override
  void initState(){
setState(() {
  Admin_home.type=widget.usertype;
  Admin_home._currentUser=widget.user;
});
    super.initState();
  }

  Future<void> _signOut() async {
    try {
      FirebaseFirestore.instance.collection('Admins').doc(Admin_home._currentUser?.uid).update({'active':false});
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }
  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = ["Settings", "Logout"];
    return ddl.map(
            (value) =>
            DropdownMenuItem(
              value: value,
              child: Text(value),
            )
    ).toList();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user != null) {
              return WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                  body: SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                SizedBox(height: 60,),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                          CircleAvatar(
                          backgroundColor: Colors.deepOrangeAccent,
                          radius: 30,
                          ),
                          SizedBox(width: 20,),
                          DropdownButton(
                          underline: Container() ,
                          icon: Image(
                          image: AssetImage('assets/images/hamburger.png'),
                          width:40,
                          height: 40,
                          color: Theme.of(context).primaryColor,
                    ),
                    items: _dropDownItem(),
                    onChanged: (value){
                    switch(value){
                    case "Settings" :
                    break;
                    case "Logout" :
                    _signOut();
                    break;
                    }
                    },
                    ),

                    ],
                          ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:<Widget>[
                  Container(
                    width: 200 ,
                    height: 220,
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(onPressed: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>Manage_patients(usertype: "patient",)));
                    },
                      child:Text("Manage\nPatient",
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
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>Manage_Doctors(usertype: "doctor",)));
                    },
                      child:Text("Manage\nDoctors",
                        style: TextStyle(
                          fontSize: 20,

                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xff7b8cde)),
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
                  ),
                ),
              );
            }
            else {
              return Admin_login(usertype:Admin_home.type );
            }
          }
          else {
            return Login(usertype:Admin_home.type);
          }
        }
    );
  }
}
