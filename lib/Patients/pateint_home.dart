import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/connection.dart';
import 'package:smart_inhaler/Patients/find_device.dart';
import 'package:smart_inhaler/Authentication/login.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_inhaler/main.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_inhaler/Patients/patient_chat_home.dart';
import 'package:smart_inhaler/Patients/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Chatting_patient.dart';
import 'usage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart ' as tz;
import 'timings.dart';
class Pateint_screen extends StatefulWidget {
final  User? user;
final String type;
static User? _currentUser;
static String current_type="";
Pateint_screen({required this.user, required this.type});
  @override
  _Pateint_screenState createState() => _Pateint_screenState();
}

class _Pateint_screenState extends State<Pateint_screen> {
  // int screen=0;


 @override
 void initState(){
   setState(() {
     Pateint_screen._currentUser=widget.user;
     Pateint_screen.current_type=widget.type;
   });

   super.initState();
 }
 //  late List <Widget> Screens=<Widget>[
 //   Pateint_profile(name:Pateint_screen._currentUser?.displayName.toString()),
 //   Usage(),
 // Settings_patient(),
 //
 //  ];
 //



  // void navigation(int index){
  //  setState(() {
  //    screen=index;
  //  });
  // }




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
            // appBar: AppBar(
            //   foregroundColor:Colors.transparent ,
            //   backgroundColor: Colors.transparent,
            //   elevation: 0.0,
            // ),
            body: Pateint_profile(user:Pateint_screen._currentUser,type:Pateint_screen.current_type),

          ),
        );
      }

      else {
        return Login(usertype: Pateint_screen.current_type,);
      }
    }
    else {
      return Login(usertype: Pateint_screen.current_type,);
    }

  }
  );
  }
}


//pateint home screen
class Pateint_profile extends StatefulWidget {
  static String air_quality="";
  static  int count=0;
final String type;
static String current_type="";
  static Widget btn_bluetooth = Text("Connect",
  style: TextStyle(fontSize: 20),
  );
  static bluetooth? select;
 static User? current_user;
 final User? user;

 Pateint_profile({required this.user,required this.type});

  @override
  _Pateint_profileState createState() => _Pateint_profileState();
}
enum bluetooth{
  disconnect,connect
}
class _Pateint_profileState extends State<Pateint_profile> {

  final Color darkviolet=Color(0xff7835EC);
  final Color lightviolet=Color(0xffc1afe3);
  double today_dose=50;
  double circularbar_value=500;
  bool is_connected=false;
  bool isenable=false;

  List<BluetoothDevice> results=[];
  String address="";
final dailydose_controller=TextEditingController();
final remainingpuffs_controller=TextEditingController();

  @override
  void didChangeDependencies() {
    read_dose();
    read_puff();
    super.didChangeDependencies();
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
  Future<void> _signOut() async {
    try {
      FirebaseFirestore.instance.collection('Patients').doc(Pateint_profile.current_user?.uid).update({'active':false});
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }
  @override
  void initState(){

    setState(() {
      Pateint_profile.current_user=widget.user;
      Pateint_profile.current_type=widget.type;
    });
read_puff();
read_dose();
    super.initState();

  }

  FlutterBluetoothSerial flutterbluetoothserial = FlutterBluetoothSerial.instance;

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices=[];
    // To get the list of paired devices
    try {
      devices = await flutterbluetoothserial.getBondedDevices();
    } catch(exception) {
      print("Error");
    }
    setState(() {
      results=devices;
    });

  }

  //bluetooth scanning function
  Future<void> startscan()async {
    results=[];
    address="";
    isenable=false;
    //obtain instance
    isenable = await flutterbluetoothserial.requestEnable() as bool;
    //start scaninng devices
    if (isenable == true) {
      Pateint_profile.btn_bluetooth=CircularProgressIndicator();

      await getPairedDevices();
      final ids = results.map((e) => e.address).toSet();
      results.retainWhere((x) => ids.remove(x.address));
      //Do something when the discovery process ends
      //removing duplicated
      for (int i = 0; i < results.length; i++) {
        if (results.elementAt(i).name == "digipuff") {
          print(results.elementAt(i).name);
          print(results.elementAt(i).address);
          String device_address = results.elementAt(i).address.toString();
          setState(() {
            address = device_address;
          });

        }
      }
      if(address==""){
        AlertDialog alert = AlertDialog(
          title: Text("Pairing alert"),
          content: Text(" Your device is not paired "),
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
        Pateint_profile.btn_bluetooth=Text("Connect",
          style: TextStyle(fontSize: 20),
        );
      }
      else
        connect_bluetooth(address);
    }
    else {
      AlertDialog alert = AlertDialog(
        title: Text(" alert"),
        content: Text(" bluetooth not enabled "),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
      Pateint_profile.btn_bluetooth=Text("Connect",
        style: TextStyle(fontSize: 20),
      );
    }
  }
  Stopwatch stopwatch=new Stopwatch();
  void watch()async{
    DateTime now = DateTime.now();
    stopwatch.start();
    print(stopwatch.isRunning);
    await Future.delayed(const Duration(seconds: 30));
    stopwatch.stop();
    print(stopwatch.isRunning); // false
    Duration elapsed = stopwatch.elapsed;
    print(elapsed);
    print(Pateint_profile.count);
    FirebaseFirestore.instance.collection('Patients').doc(Pateint_profile.current_user!.uid.toString()).collection('intake-doses').doc(now.toString()).set({'intake time':now.toString(),'intake doses':Pateint_profile.count});
    setState(() {
      Pateint_profile.count=0;
    });

  }
  Future<void> connect_bluetooth(String address) async {
    BluetoothConnection connection;

    try {
      connection = await BluetoothConnection.toAddress(address);
      if (connection.isConnected) {
        setState(() {
          is_connected = true;
          Pateint_profile.btn_bluetooth = Text("Disconnect",
            style: TextStyle(fontSize: 20),
          );
          Pateint_profile.select = bluetooth.connect;
        });

        print('Connected to the device');
      }


      connection.input?.listen((Uint8List data) async{
        print(ascii.decode(data));
        //Data entry point
        if (ascii.decode(data).toString() == "1") {
          await circularbar_value--;
          await    FirebaseFirestore.instance.collection('Patients').doc(Pateint_profile.current_user?.uid).collection('remaining-puffs').doc(Pateint_profile.current_user?.uid).update({'remaining-puffs':circularbar_value.toString()});
          read_puff();
          if(Pateint_profile.count==0) {
            watch();
          }
          setState(() {
            Pateint_profile.count++;
          });

            if(today_dose>0) {
             await today_dose--;
              await FirebaseFirestore.instance.collection('Patients').doc(Pateint_profile.current_user?.uid).collection('today-dose').doc(Pateint_profile.current_user?.uid).update({'total-dose-today':today_dose.toString()});
              read_dose();
            }
            else{
              today_dose--;
              FirebaseFirestore.instance.collection('Patients').doc(Pateint_profile.current_user?.uid).collection('today-dose').doc(Pateint_profile.current_user?.uid).update({'total-dose-today':today_dose.toString()});
              read_dose();
              AlertDialog alert=new AlertDialog(
                title: Text("Over dosage alert"),
                content: Text("You took over dose today"),
              );

              showDialog(context: context, builder: (context){
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.of(context).pop();
                });
              return alert;
              });
            }

        }
        else if(ascii.decode(data).toString().contains("location")){
          setState(() {
            Find_device.location=ascii.decode(data).toString();
          });
        }
        else if(ascii.decode(data).toString().contains("PPM")){
          setState(() {
            Pateint_profile.air_quality=((ascii.decode(data)).toString());
          });
        }
      });

    } catch (exception) {

      setState(() {
       Pateint_profile.btn_bluetooth = Text("Connect",
         style: TextStyle(fontSize: 20),
       );
        Pateint_profile.select = bluetooth.disconnect;
      });
      print('Cannot connect, exception occured $exception');
    }

    }


  Future<String> getremaining_puffs() async {
    // Get docs from collection reference b
    final querySnapshot = await FirebaseFirestore.instance.collection('Patients').doc(Pateint_profile.current_user?.uid).collection('remaining-puffs').where("remaining-puffs").get();
    //Get data from docs and convert map to List
    final String remaining_puffs = querySnapshot.docs.map((doc) => doc.data()).toString();
    return remaining_puffs;
  }

  void read_puff()async{
    Future<String> stringFuture = getremaining_puffs();
  String remaining_puffs =  await stringFuture as String;
    setState(() {
circularbar_value=double.parse(remaining_puffs.substring(19,22));
    });
  }
  Future<String> getdaily_dose() async {
    // Get docs from collection reference b
    final querySnapshot = await FirebaseFirestore.instance.collection('Patients').doc(Pateint_profile.current_user?.uid).collection('today-dose').where("total-dose-today").get();
    //Get data from docs and convert map to List
    final String remaining_dose = querySnapshot.docs.map((doc) => doc.data()).toString();

    return remaining_dose;
  }

  void read_dose()async{
    Future<String> stringFuture = getdaily_dose();
    String remaining_dose =  await stringFuture as String;
    setState(() {
      today_dose=double.parse(remaining_dose.substring(19,22));
    });
  }

  @override
  Widget build(BuildContext context) {

    return  SingleChildScrollView(
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Settings_patient(user: Pateint_profile.current_user,)),
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
                Text("Welcome",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                Text(FirebaseAuth.instance.currentUser!.displayName.toString(),
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ]
          ),

Container(
  padding: EdgeInsets.all(10),
  height: 220,
     child: ListView(
       scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            height: 200,
            width: 180,
            padding: EdgeInsets.only(top: 20,left: 10),
            child: ElevatedButton(onPressed: (){
              AlertDialog alert=new AlertDialog(
                title: Text("Refill your device"),
                content: SizedBox(
                  height: 250,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextFormField(
                        controller: remainingpuffs_controller,
                        decoration: InputDecoration(
                          hintText: 'e.g. Enter refilling amount according to your inhaler',
                        ),
                      ),
                      ElevatedButton(onPressed: (){
                        setState(() {
                FirebaseFirestore.instance.collection('Patients').doc(Pateint_profile.current_user?.uid).collection('remaining-puffs').doc(Pateint_profile.current_user?.uid).set({'remaining-puffs':remainingpuffs_controller.text});
                read_puff();
                        });
                        Navigator.of(context).pop();
                      }, child: Text("Refill"))
                    ],
                  ),
                ),
              );
              showDialog(context: context, builder: (context){
                return alert;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Puffs",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                SleekCircularSlider(
                  appearance: CircularSliderAppearance(
                    //spinnerMode: true,

                    animationEnabled: true,

                    customWidths: CustomSliderWidths(
                      progressBarWidth: 15,
                      trackWidth: 12,
                      handlerSize: 5,
                    ),
                    customColors: CustomSliderColors(
                      trackColor: Theme.of(context).primaryColor,

                    ),
                    infoProperties: InfoProperties(
                      mainLabelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 27,
                      ),
                    ),
                  ),
                  min: 0,
                  max: 1000,
                  initialValue: circularbar_value,
                ),
              ],
            ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColorDark),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                ),
              ),
            ),
          ),



          Container(
            height: 200,
            width: 180,
            padding: EdgeInsets.only(top: 20,left: 10),
            child:ElevatedButton(
              onPressed: (){
                AlertDialog alert=new AlertDialog(
                  title: Text("Add your today's dose"),
                  content: SizedBox(
                    height: 250,
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextFormField(
                          controller: dailydose_controller,
                          decoration: InputDecoration(
                            hintText: 'Enter dose here',
                          ),
                        ),
                        ElevatedButton(onPressed: (){
                          FirebaseFirestore.instance.collection('Patients').doc(Pateint_profile.current_user?.uid).collection('today-dose').doc(Pateint_profile.current_user?.uid).set({'total-dose-today':dailydose_controller.text});
                          read_dose();
                          Navigator.of(context).pop();
                        }, child: Text("Add"))
                      ],
                    ),
                  ),
                );
                showDialog(context: context, builder: (context){
                  return alert;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Daily dose",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text(today_dose.toString(),
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white
                    ),
                  ),
                  Text("Puffs",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xffdbb42c)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                ),
              ),
            ),
          ),
          Container(
            height: 200,
            width: 180,
            padding: EdgeInsets.only(top: 20,left: 10),
            child:ElevatedButton(
              onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Usage(user: Pateint_profile.current_user,)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Usage",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xffc19bff)),
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
            Container(
              height: 230,
              child: ListView(
              scrollDirection: Axis.horizontal,
              children:<Widget>[
              Container(
              width: 180 ,
              padding: EdgeInsets.only(top: 20,left: 20),
              child: ElevatedButton(onPressed: (){
                    startscan();
              },
                child:Pateint_profile.btn_bluetooth,
                style: ButtonStyle(

                  backgroundColor: MaterialStateProperty.resolveWith((states) => Pateint_profile.select==bluetooth.connect? Color(0xffb5e48c):Color(0xffc71f37)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),

                  ),
                  ),
                ),
              ),
            ),
                Container(
                  width: 180 ,
                  padding: EdgeInsets.only(top: 20,left: 20),

                  child: ElevatedButton(onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (context)=>Patient_chat_home(current_user: Pateint_profile.current_user)));
                  },
                    child:Text("Doctors",


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

                Container(
                  width: 180 ,
                  padding: EdgeInsets.only(top: 20,left: 20),
                  child: ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_dose(user: Pateint_profile.current_user,)));
                  },
                    child:Text("Timer",
                      style: TextStyle(
                        fontSize: 20,

                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xffee6055)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 180 ,
                  padding: EdgeInsets.only(top: 20,left: 20),

                  child: ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Find_device()));
                  },
                    child:Text("Find\nmy\ndevice",


                      style: TextStyle(
                        fontSize: 20,

                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xff72ddf7)),
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
              Container(
                width: 400 ,
                height: 220,
                padding: EdgeInsets.all(20),
                child: ElevatedButton(onPressed: (){
                  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Connect_to_bluetooth()));
                },
                  child:Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget>[

                        Text("Air quality",
                          style: TextStyle(
                            fontSize: 20,

                          ),
                        ),
                        Text(Pateint_profile.air_quality,
                          style: TextStyle(
                            fontSize: 20,

                          ),
                        ),
                      ]
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xff68edc6)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    ),
                  ),
                ),
              ),

        ],
      ),
      );
  }
}
