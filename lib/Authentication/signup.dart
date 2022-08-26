import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/Authentication//login.dart';
import 'package:smart_inhaler/Patients/pateint_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Signup extends StatefulWidget {
  final String usertype;
  static String type="";
   Signup({required this.usertype});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final Color maincolor=Color(0xfff27059);
  final Color primarycolor=Color(0xffFFC6A4);
  final _emailcontroller=TextEditingController();
  final _passcontroller=TextEditingController();
  final _namecontroller=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordvisible=false;
@override
void initState(){
  _passwordvisible=false;
  setState(() {
    Signup.type=widget.usertype;
  });
  super.initState();
}
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }
  Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child:
  FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [ Color(0xfffdc5f5), Color(0xffd8c2ff),Color(0xffc8b6ff)]
                  ),
                ),
                child:Scaffold(
                  backgroundColor: Colors.transparent,
              appBar: AppBar(
                foregroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              resizeToAvoidBottomInset : true,
              body:SingleChildScrollView(
                child: Column(
                children:<Widget>[
                  Row(
                    children:<Widget>[
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(FontAwesomeIcons.arrowLeft),
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 120,
                      ),
                      Text("Signup",
                        style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50,),
                  Image(image: AssetImage('images/inahler_icon.png')),
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
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Example@gmail.com',
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      //textfeild 2
                      SizedBox(
                        width: 300,
                        height: 60,
                        child: TextFormField(
                          controller: _passcontroller,
                          validator: (value){
                            if ((value.toString()).length < 8 && value!=null && value.isNotEmpty){
                              return 'Enter password more then 8 characters';
                            }
                         else   if (value==null || value.isEmpty){
                              return 'Enter your password';
                            }
                            else
                              return null;
                          },
                          obscureText: !_passwordvisible,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.black),
                            suffixIcon: IconButton(
                              icon:Icon(
                                _passwordvisible? Icons.visibility: Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordvisible=!_passwordvisible;
                                });
                              },
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          ),

                        ),
                      ),
            //textfeild 3
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
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Name',
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          ),

                        ),
                      ),





                      //signup button
                      SizedBox(
                        width: 260,
                        height: 60,
                        child:ElevatedButton(
                          onPressed: () async {
                            String email=_emailcontroller.text.toString();
                            String password=_passcontroller.text.toString();
                            String name=_namecontroller.text.toString();
                            if(_formKey.currentState!.validate()) {
                              AlertDialog alert=new AlertDialog(
                                content:SizedBox(
                                  width: 200,
                                  height: 200,
                                  child:Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:<Widget>[CircularProgressIndicator()]),
                                ),
                              );
                              showDialog(context: context, builder: (context){
                                Future.delayed(Duration(milliseconds: 200), () {
                                  Navigator.of(context).pop();
                                });
                                return alert;
                              });
                              User? user =await registerUsingEmailPassword(
                                  name: name, email: email, password: password);
                              if (user != null) {
                                try {
                                  await user.sendEmailVerification();
                                } catch (e) {
                                  print("An error occured while trying to send email  verification");
                                  print(e);
                                }
                                if(Signup.type=="patient") {
                                  FirebaseFirestore.instance.collection(
                                      'Patients').doc(user.uid).set({
                                    'email': user.email,
                                    'name': user.displayName,
                                    'user-id': user.uid,
                                    'Verification': user.emailVerified,
                                    'password': password,
                                    'active': false
                                  });
                                  FirebaseFirestore.instance.collection(
                                      'Patients').doc(user.uid).collection('type').doc(user.uid).set({'usertype':Signup.type});

                                }
                                else if(Signup.type=="doctor"){
                                  FirebaseFirestore.instance.collection(
                                      'Doctors').doc(user.uid).set({
                                    'email': user.email,
                                    'name': user.displayName,
                                    'user-id': user.uid,
                                    'Verification': user.emailVerified,
                                    'password': password,
                                    'active': false
                                  });
                                  FirebaseFirestore.instance.collection(
                                      'Doctors').doc(user.uid).collection('type').doc(user.uid).set({'usertype':Signup.type});
                                }
                                AlertDialog alert = AlertDialog(
                                  title:  Text(" Go back to Login page"),
                                  content: Text(" check your inbox or spam folder\nand verify your email"),
                                );
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              }
                              else {
                                AlertDialog alert = AlertDialog(
                                  title: Text("Signup alert"),
                                  content: Text(" User not added "),
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
                          child:  Row(
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
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.black),
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
              ),
            );
          }
          else return Center(
            child: CircularProgressIndicator(),
          );
        }
    ),
    );
  }
}
