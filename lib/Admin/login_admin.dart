import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_inhaler/Admin/Admin_signup.dart';
import 'package:smart_inhaler/Doctors/doctor_home.dart';

import 'package:smart_inhaler/Authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Admin_home.dart';
import 'package:smart_inhaler/Patients/pateint_home.dart';
class Admin_login extends StatefulWidget {
final String usertype;
static String type="";
Admin_login({required this.usertype});

  @override
  _Admin_loginState createState() => _Admin_loginState();
}

class _Admin_loginState extends State<Admin_login> {
  final _emailcontroller=TextEditingController();
  final _passcontroller=TextEditingController();
  final _formKey = GlobalKey<FormState>();
bool _passwordvisible=false;
  @override
  void initState(){
    _passwordvisible=false;
    Admin_login.type=widget.usertype;
    super.initState();
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }
  static Future<User?> loginusingemailpassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user=userCredential.user;
    }
    on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }
    catch(e){
      print("Separate : $e");
    }
    return user;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeFirebase(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
    return Scaffold(
    appBar: AppBar(
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    foregroundColor: Theme
        .of(context)
        .primaryColor,
    ),
    body: SingleChildScrollView(
    child: Column(
    children: <Widget>[
    Container(
    height: 250,
    width: 400,
    padding: EdgeInsets.all(20),
    child: Image(image: AssetImage('images/admin_logo.png')),
    ),
    Container(
    height: 500,
    padding: EdgeInsets.all(10),
    child: Form(
    key: _formKey,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
    //textfeild 1
    SizedBox(
    width: 300,
    height: 60,
    child: TextFormField(
    controller: _emailcontroller,
    validator: (value) {
    if (value == null || value.isEmpty) {
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
    //textfeild 2
    SizedBox(
    width: 300,
    height: 60,
    child: TextFormField(
    controller: _passcontroller,
    validator: (value) {
    if ((value.toString()).length <= 8 &&
    value != null && value.isNotEmpty) {
    return 'Enter password more then 8 characters';
    }
    else if (value == null || value.isEmpty) {
    return 'Enter your password';
    }
    else
    return null;
    },
    obscureText: !_passwordvisible,
    decoration: InputDecoration(
    filled: true,
    fillColor:  Color(0xffd6d2d2),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide.none,

    ),
    hintText: 'Password',
    suffixIcon:IconButton(
      icon:Icon(
        _passwordvisible? Icons.visibility: Icons.visibility_off,
        color: Colors.black,
      ),
      onPressed: () {
        setState(() {
          _passwordvisible=!_passwordvisible;
        });
      },
    ) ,
    hintStyle: TextStyle(color: Theme.of(context).primaryColorDark),
    ),
    style: TextStyle(
    color: Theme.of(context).primaryColorDark,
    ),

    ),
    ),

    TextButton(onPressed: () {
    //  Navigator.push(context, MaterialPageRoute(builder: (context)=>Forget_pass()));

    }, child: Text("Forget password?",
    style: TextStyle(
    color: Theme.of(context).primaryColor,
    fontSize: 20,
    ),
    ),
    ),
    //login button
    Container(
    child: Column(
    children: <Widget>[
    SizedBox(
    width: 260,
    height: 60,
    child: ElevatedButton(
    onPressed: () async {
    String email = _emailcontroller.text
        .toString();
    String password = _passcontroller.text
        .toString();
    try {
    if (_formKey.currentState!.validate()) {
    AlertDialog alert = new AlertDialog(
    content: SizedBox(
    width: 200,
    height: 200,
    child: Column(
    mainAxisAlignment: MainAxisAlignment
        .center,
    children: <Widget>[
    CircularProgressIndicator()
    ]),
    ),
    );
    showDialog(context: context,
    builder: (context) {
    Future.delayed(Duration(
    milliseconds: 200), () {
    Navigator.of(context).pop();
    });
    return alert;
    });
    User? user = await loginusingemailpassword(
    email: email,
    password: password,
    context: context
    );
    if (user != null) {
    if (user.emailVerified) {
    if (Admin_login.type == "admin") {
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance.collection(
    'Admins')
        .doc(user.uid)
        .collection('type')
        .get();
    final String type = querySnapshot
        .docs.map((doc) => doc.data())
        .toString();
    if (type.contains("admin")) {
    FirebaseFirestore.instance
        .collection(
    'Admins')
        .doc(user.uid)
        .update({
    'Verification': user
        .emailVerified,
    'active': true
    });
    Navigator.push(
    context, MaterialPageRoute(
    builder: (context) =>
    Admin_home(
    user: user,
    usertype: Admin_login.type,)));
    }
    else {
    FirebaseAuth.instance.signOut();
    AlertDialog alert = AlertDialog(
    title: Text("Login alert"),
    content: Text(
    "You are not admin"),
    );
    showDialog(
    context: context,
    builder: (
    BuildContext context) {
    return alert;
    },
    );
    }
    }
    }
    else {
    AlertDialog alert = AlertDialog(
    title: Text("Login alert"),
    content: Text(
    "Email is not verified"),
    );
    showDialog(
    context: context,
    builder: (BuildContext context) {
    return alert;
    },
    );
    }
    }
    else {
    AlertDialog alert = AlertDialog(
    title: Text("Login alert"),
    content: Text(" User not found"),
    );
    showDialog(
    context: context,
    builder: (BuildContext context) {
    return alert;
    },
    );
    }
    }
    }
    catch (exception) {
    print("Exception is: $exception");
    }
    },
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Text("Login",
    style: GoogleFonts.barlow(
    textStyle: TextStyle(
    color: Colors.white,
    fontSize: 20
    ),
    ),
    ),
    Icon(FontAwesomeIcons.arrowRight),
    ],
    ),
    style: ButtonStyle(
    backgroundColor: MaterialStateProperty
        .resolveWith((states) => Color(0xff6ede8a)),
    shape: MaterialStateProperty.all<
    RoundedRectangleBorder>(
    RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(
    70)
    ),
    ),
    ),
    ),
    ),
    SizedBox(height: 10,),
    SizedBox(
      width: 260,
      height: 60,
      child: ElevatedButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Admin_signup(usertype:Admin_login.type,)));
      },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Sign up",
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
          backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xff2a6f97)),
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
    ],
    ),
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
