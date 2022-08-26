
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/Doctors/docchat_home.dart';
import 'package:smart_inhaler/Authentication//login.dart';
import 'chatting_doc.dart';
import 'package:smart_inhaler/Patients/Chatting_patient.dart';
import 'setting_doc.dart';


class Doctor_home extends StatefulWidget {
  final User? user;
  static User? _currentUser;
  final String type;
  static String current_type="";
  Doctor_home({required this.user,required this.type});

  @override
  _Doctor_homeState createState() => _Doctor_homeState();
}

class _Doctor_homeState extends State<Doctor_home> {
 // int screen=0;
  @override
  void initState(){
    setState(() {
      Doctor_home._currentUser=widget.user;
      Doctor_home.current_type=widget.type;
    });

    super.initState();

  }
//   late List <Widget> Screens=<Widget>[
//     Doctor_profile(name:Doctor_home._currentUser?.displayName.toString()),
// feedback(),
//   Settings_doc(),
//   ];
//   void navigation(int index){
//     setState(() {
//       screen=index;
//     });

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

      body:  Doctor_profile(name:Doctor_home._currentUser?.displayName.toString()),
    )
    );
    }
    else {
      return Login(usertype: Doctor_home.current_type,);
    }
    }
    else {
      return Login(usertype: Doctor_home.current_type,);
    }
    }
    );
  }
  }






class Doctor_profile extends StatefulWidget {
final String? name;
Doctor_profile({required this.name});

  @override
  _Doctor_profileState createState() => _Doctor_profileState();
}

class _Doctor_profileState extends State<Doctor_profile> {
  late String? docname;

  void initState(){
    docname=widget.name;

    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    super.initState();

  }

  Future<void> _signOut() async {
    try {
      FirebaseFirestore.instance.collection('Doctors').doc(FirebaseAuth.instance.currentUser?.uid).update({'active':false});
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
    return Scaffold(
      body:Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Settings_doc()),
                        );
                        break;
                      case "Logout" :
                        _signOut();
                        break;
                    }
                  },
                ),

              ],
            ),

            Column(
                children:<Widget>[
                  Text("Good Morning,",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Text('Doctor $docname',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ]
            ),
                  Container(
                  height: 230,
                  child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:<Widget>[
                  Container(
                  width: 180 ,
                  padding: EdgeInsets.only(top: 20,left: 20),
                  child: ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Doc_chat_home(current_user:Doctor_home._currentUser)));
                  },
                  child:Text("Patients",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                  ),
                  style: ButtonStyle(

                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.indigo),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),

                  ),
                  ),
                  ),
                  ),
                  ),
                    ],
                  ),
                  ),
          ],
        ),
    );

  }
}
// ListView(
// children:snapshot.data! .map((DocumentSnapshot document)
// {
// Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
// return Container(
// child: Center(child: Text(data['content'],
// ),
// ),
// );
// }).toList(),
// );