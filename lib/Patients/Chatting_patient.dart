import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/Authentication/login.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_inhaler/Doctors/doctor_home.dart';
class Chatting_patient extends StatefulWidget {
  static int count=1;
  static List<String> messages=[];
  final String doctor_uid;
  static String current_uid="";
  const Chatting_patient({required this.doctor_uid});

  @override
  _Chatting_patientState createState() => _Chatting_patientState();
}
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
class _Chatting_patientState extends State<Chatting_patient> {
  final message_controller = TextEditingController();

  @override
  void initState() {
    setState(() {
      Chatting_patient.current_uid=widget.doctor_uid;
    });
      get_messages();
    super.initState();
  }

  Future<FirebaseApp> intializefirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  Future<void> send_message({required String message}) async {
    await FirebaseFirestore.instance.collection('Patients').doc(FirebaseAuth.instance.currentUser?.uid).collection('Doctors').doc(Chatting_patient.current_uid).collection('chatting').doc().set({FirebaseAuth.instance.currentUser!.displayName.toString():message});
    await FirebaseFirestore.instance.collection('Doctors').doc(Chatting_patient.current_uid).collection('Patients').doc(FirebaseAuth.instance.currentUser?.uid).collection('chatting').doc().set({FirebaseAuth.instance.currentUser!.displayName.toString():message});
  }
        Future<void> get_messages() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Patients').doc(FirebaseAuth.instance.currentUser?.uid).collection('Doctors').doc(Chatting_patient.current_uid).collection('chatting').get();
    final List<Object?> allData = await querySnapshot.docs.map((doc) => doc.data()).toList();
    final List<String> messages =await allData.map((data) => data.toString()).toList();
  setState(() {
    Chatting_patient.messages=messages;
  });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: intializefirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return  Scaffold(
              appBar: AppBar(
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
                body:
              SingleChildScrollView(child:
              Column(
            //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(Chatting_patient.current_uid),
              Container(
                height: 600,
                padding: EdgeInsets.all(15),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Patients').doc(FirebaseAuth.instance.currentUser?.uid).collection('Doctors').doc(Chatting_patient.current_uid).collection('chatting').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {

                      return ListView.separated(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        itemBuilder: (BuildContext context, int index){
                          return Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color(0xffc8b6ff),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(
                              Chatting_patient.messages[index].replaceAll(RegExp(r'{'), ' ').replaceAll(RegExp(r'}'), ' '),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          );
                        },
                        separatorBuilder:(BuildContext context, int index) {
                          return SizedBox(
                            height: 25,
                          );
                        },
                        itemCount: Chatting_patient.messages.length,
                      );
                    }
                  },
                ),
              ),
        SizedBox(height: 50,),
             Container(

               padding: EdgeInsets.all(20),
               child:
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children:<Widget> [
                 SizedBox(
                   width: 320,
                   height: 60,
                   child: TextFormField(
                     controller: message_controller,
                     decoration: InputDecoration(
                       filled: true,
                       fillColor: Theme.of(context).primaryColor,
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(20.0),
                         borderSide: BorderSide.none,
                       ),
                       hintText: 'Write your message here',
                       hintStyle: TextStyle(color: Theme.of(context).primaryColorDark),
                     ),
                     style: TextStyle(
                       color: Theme.of(context).primaryColorDark,
                     ),
                   ),
                 ),
                 IconButton(onPressed: (){
                   String message=message_controller.text.toString();
                   send_message(message: message);
                   get_messages();
                 }, icon: Icon(Icons.send)),
               ],
             ),
             ),
                ],
            ),
              ),
            );
          }
          else {
            return CircularProgressIndicator();
          }
        }
    );
  }
}
