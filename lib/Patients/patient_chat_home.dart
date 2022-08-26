import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/Doctors/Synced_Doctors.dart';
import 'package:smart_inhaler/Authentication/login.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_inhaler/Patients/synced_patients.dart';
import 'package:smart_inhaler/Doctors/doctor_home.dart';


class Patient_chat_home extends StatefulWidget {
  final User? current_user;
  static User? user;
  static List<String> doctors=[];
  const Patient_chat_home({required this.current_user});

  @override
  _Patient_chat_homeState createState() => _Patient_chat_homeState();
}



class _Patient_chat_homeState extends State<Patient_chat_home> {
  @override
  void initState(){

    setState(() {
      Patient_chat_home.user=widget.current_user;
    });

    super.initState();
    get_doctors();
  }
  void get_doctors()async{
    QuerySnapshot querySnapshot = await  FirebaseFirestore.instance.collection('Patients').doc(Patient_chat_home.user?.uid).collection('Doctors').get();
    final List<Object?> allData =await querySnapshot.docs.map((doc) => doc.id).toList();
    final List<String> doctors = await allData.map((data) => data.toString()).toList();

    setState(() {
      Patient_chat_home.doctors=doctors;
    });
  }

  Future<void> add_doctors(String mail) async{
    String email=mail;
    final querySnapshot = await  FirebaseFirestore.instance.collection('Doctors').where("email",isEqualTo: email).get();
    String uid_doctor = querySnapshot.docs.map((doc) => doc["name"]).toString().replaceAll("(", "").replaceAll(")", "");
    FirebaseFirestore.instance.collection('Patients').doc(Patient_chat_home.user?.uid).collection('Doctors').doc(uid_doctor).set({'doctor_name':uid_doctor});
  }


  Future<FirebaseApp> intializefirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }
  @override
  Widget build(BuildContext context) {
    final _emailcontroller=TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return FutureBuilder(
        future: intializefirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              body:SingleChildScrollView(child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 140,
                    width: 400,
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
                                fillColor: Theme.of(context).primaryColor,
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
                          SizedBox(
                            width: 160,
                            height: 40,
                            child:ElevatedButton(
                              onPressed: () async {
                                String email=_emailcontroller.text;
                                if(_formKey.currentState!.validate())  {
                                   add_doctors(email);
                                  get_doctors();
                                }
                              },
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Add doctors",
                                    style: GoogleFonts.barlow(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Icon(FontAwesomeIcons.user),
                                ],
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.deepPurpleAccent),
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
                  Container(
                    height: 600,
                    padding: EdgeInsets.all(20),
                    child: StreamBuilder(
                      stream:  FirebaseFirestore.instance.collection('Patients').doc(Patient_chat_home.user?.uid). collection('Doctors').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                         //get_doctors();
                          return ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index){
                              return  Row(
                                children:<Widget>[
                                Container(
                                height: 50,
                                width: 300,
                                child:ElevatedButton(onPressed:(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Synced_doctors(doctor_uid:Patient_chat_home.doctors[index])));
                                },
                                  child: Text(Patient_chat_home.doctors[index],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith((states) =>  Color(0xffc8b6ff)),
                                    shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(70)
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                                  IconButton(onPressed: () async{
                                    await  FirebaseFirestore.instance.collection('Patients').doc(Patient_chat_home.user?.uid.toString()).collection('Doctors').doc(Patient_chat_home.doctors[index]).delete();
                                    get_doctors();
                                  },
                                    icon:Icon(Icons.remove_circle),
                                    iconSize: 40,

                                  ),
                              ],
                              );
                            },
                            separatorBuilder:(BuildContext context, int index) {
                              return SizedBox(
                                height: 25,
                              );
                            },
                            itemCount: Patient_chat_home.doctors.length,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              ),
            );
          }
          else{
            return CircularProgressIndicator();
          }
        }
    );
  }
}
