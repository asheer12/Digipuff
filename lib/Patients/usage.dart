import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'pateint_home.dart';
import 'settings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Usage extends StatefulWidget {
  static List<String> messages=[];
  static User? _currentUser;
  final  User? user;
  Usage({required this.user});

  @override
  _UsageState createState() => _UsageState();
}

class _UsageState extends State<Usage> {


  @override
  initState(){
    super.initState();
Usage._currentUser=widget.user;
  }
  Future<List> getData() async {
    // Get docs from collection reference b
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Patients').doc(Usage._currentUser?.uid.toString()).collection('intake-doses').get();
    // Get data from docs and convert map to List
    final List<Object?> allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final List<String> messages = allData.map((data) => data.toString()).toList();
    return messages;
  }

  void convert()async{
    Future<List> listFuture = getData();
    List<String> list =  await listFuture as List<String>;
    setState(() {
      Usage.messages=list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 600,
            padding: EdgeInsets.all(15),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Patients').doc(Usage._currentUser?.uid.toString()).collection('intake-doses').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                convert();
                return ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index){
                 return Container(
                        height: 50,
                    decoration: BoxDecoration(
                      color:Color(0xffc8b6ff),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(Usage.messages[index].replaceAll(RegExp(r'{'), ' ').replaceAll(RegExp(r'}'), ' '),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    ),
                  );
                },
                  separatorBuilder:(BuildContext context, int index) {
                    return SizedBox(
                      height: 25,
                    );
                  },
                  itemCount: Usage.messages.length,
                );
                }
              },
            ),
          ),



        ],
      ),

    );
  }
}
