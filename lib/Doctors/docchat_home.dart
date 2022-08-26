import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/Authentication/login.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_inhaler/Patients/synced_patients.dart';
import 'doctor_home.dart';


class Doc_chat_home extends StatefulWidget {
  final User? current_user;
  static User? user;
  static List<String> patients=[];

  const Doc_chat_home({required this.current_user});

  @override
  _Doc_chat_homeState createState() => _Doc_chat_homeState();
}



class _Doc_chat_homeState extends State<Doc_chat_home> {
  @override
  void initState(){
    get_patients();
    Doc_chat_home.user=widget.current_user;
super.initState();
  }
  void get_patients()async{
    QuerySnapshot querySnapshot = await  FirebaseFirestore.instance.collection('Doctors').doc(Doc_chat_home.user?.uid).collection('Patients').get();
    final List<Object?> allData =await querySnapshot.docs.map((doc) => doc.id).toList();
    final List<String> patients = await allData.map((data) => data.toString()).toList();
    setState(() {
       Doc_chat_home.patients=patients;
    });
  }

  Future<void> add_patients(String mail) async{
    String email=mail;
    final querySnapshot = await  FirebaseFirestore.instance.collection('Patients').where("email",isEqualTo: email).get();
   String uid_patient = querySnapshot.docs.map((doc) => doc["name"]).toString().replaceAll("(", "").replaceAll(")", "");
  FirebaseFirestore.instance.collection('Doctors').doc(Doc_chat_home.user?.uid).collection('Patients').doc(uid_patient).set({'patient_name':uid_patient});
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
                        onPressed: ()  {
                         String email=_emailcontroller.text;
                          if(_formKey.currentState!.validate())  {
                          add_patients(email);
                            get_patients();
                          }
                        },
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Add Patient",
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
            stream:  FirebaseFirestore.instance.collection('Doctors').doc(Doc_chat_home.user?.uid.toString()).collection('Patients').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index){
                    return Row(
                      children:<Widget>[
                        Container(
                      height: 50,
                      width: 300,
                      child:ElevatedButton(onPressed:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Synced_patients(pateint_uid: Doc_chat_home.patients[index])));
                    },
                      child: Text(Doc_chat_home.patients[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xffc8b6ff)),
                      shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(70)
                          ),
                        ),
                      ),
                    ),
                    ),
                        IconButton(onPressed: () async{
                          await  FirebaseFirestore.instance.collection('Doctors').doc(Doc_chat_home.user?.uid.toString()).collection('Patients').doc(Doc_chat_home.patients[index]).delete();
                            get_patients();
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
                  itemCount: Doc_chat_home.patients.length,
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
