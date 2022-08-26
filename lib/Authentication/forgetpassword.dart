
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Forget_pass extends StatefulWidget {
  const Forget_pass({Key? key}) : super(key: key);

  @override
  _Forget_passState createState() => _Forget_passState();
}

class _Forget_passState extends State<Forget_pass> {
  final email_controller=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [ Color(0xfffdc5f5), Color(0xffd8c2ff),Color(0xffc8b6ff)]
    ),
    ),
    child:   Scaffold(
      backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        resizeToAvoidBottomInset : true,
        body:SingleChildScrollView(
          child:Form(
            key: _formKey,
            child:Container(
              padding: EdgeInsets.all(30),
              height: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: email_controller,
                      validator: (value){
                        if (value==null || value.isEmpty){
                          return 'Enter your email';
                        }
                        else
                          return null;
                      },

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Enter your existing email',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: ElevatedButton(onPressed: () async{
                      String email = email_controller.text.toString();
                      if (_formKey.currentState!.validate()){
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
                        try {
                          await resetPassword(email);
                          AlertDialog alert = AlertDialog(
                            title: Text("Reset alert"),
                            content: Text("Your reset password link is sended to provided email\n Check your spam folder if mail is not in inbox"),
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        }
                        catch(exception){
                          AlertDialog alert = AlertDialog(
                            title: Text("Reset alert"),
                            content: Text("$exception"),
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

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Reset",
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
                        backgroundColor: MaterialStateProperty.resolveWith((
                            states) =>Colors.black),
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
        ),
    ),
    );
  }
}
