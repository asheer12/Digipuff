import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_inhaler/customwidgets.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart ' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
//add dose screen
class Add_dose extends StatefulWidget {
  static User? _currentUser;
  final  User? user;
  static List<String> scheduled_doses=[];
  static String value="";
 Add_dose({required this.user});
 @override
  _Add_doseState createState() => _Add_doseState();
}
class _Add_doseState extends State<Add_dose> {
   int hours=0;
   int minutes=0;
   int hours_24=0;
   final formatcontroller=TextEditingController();
   final dosecontroller=TextEditingController();
   String format="";
   List<Widget> timecard=[];
   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    @override
   initState(){
     super.initState();
     read_doses();
     Add_dose._currentUser=widget.user;
     _configureLocalTimeZone();
     var intialization_Android=new AndroidInitializationSettings('clock');
     var intialization_settings=new InitializationSettings( android: intialization_Android );
     flutterLocalNotificationsPlugin=new FlutterLocalNotificationsPlugin();
     flutterLocalNotificationsPlugin.initialize(intialization_settings);

   }
   ///configuring time zone
   Future<void> _configureLocalTimeZone() async {
     tz.initializeTimeZones();
     final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
     tz.setLocalLocation(tz.getLocation(timeZone));
   }
   /// Set right date and time for notifications
   tz.TZDateTime _convertTime(int hour, int minutes) {
     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
     tz.TZDateTime scheduletime = tz.TZDateTime(
       tz.local,
       now.year,
       now.month,
       now.day,
       hour,
       minutes,
     );
     return scheduletime;
   }

String scheduled_time="";
   Future scheduled_notification({required String id,}) async{
     print(id);
    tz.TZDateTime datetime= _convertTime(hours_24,minutes);
    setState(() {
      scheduled_time=datetime.toString();
    });
     AndroidNotificationDetails android_notification=AndroidNotificationDetails('your channel id', 'Your channel name',
       channelDescription: 'your channel description',
       playSound: true,
       priority: Priority.high,
       importance: Importance.max,
     );
     NotificationDetails notificationDetails=NotificationDetails(android: android_notification);
     await flutterLocalNotificationsPlugin.zonedSchedule(
         int.parse(id),
         'Dose',
         'Its time to puff',
       datetime,
     notificationDetails,
         uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
         //matchDateTimeComponents: DateTimeComponents.time,
         androidAllowWhileIdle: true
     );
read_doses();
   }

  void read_doses()async {
     QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection('Patients').doc(Add_dose._currentUser?.uid).collection('scheduled_doses').get();
     final List<Object?> allData = querySnapshot.docs.map((doc) => doc.data()).toList();
     final List<String> messages = allData.map((data) => data.toString()).toList();
     setState(() {
       Add_dose.scheduled_doses=messages;
     });
  }
   @override
  Widget build(BuildContext context) {

    return
      Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child:Column(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
      children: <Widget>[
         Simplecard(
              cardchild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:<Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              NumberPicker(minValue: 0, maxValue: 12,value: hours,
                  onChanged: (hvalue){
                setState(() {
                  hours=hvalue;
                });
              },
                textStyle: TextStyle(fontSize: 30),
                selectedTextStyle: TextStyle(fontSize: 40,color: Colors.deepPurpleAccent),
              ),

              Text(":",style: TextStyle(fontSize: 30),),

              NumberPicker(minValue: 0, maxValue: 59, value: minutes,
                onChanged: (mvalue){
                  setState(() {
                    minutes=mvalue;
                  });
                },
                textStyle: TextStyle(fontSize: 30),
                selectedTextStyle: TextStyle(fontSize: 40,color: Colors.deepPurpleAccent),
              ),

              SizedBox(
                height: 50,
              width: 60,
              child:TextFormField(
                controller: formatcontroller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).primaryColorDark,
                    hintText: 'am'
                ),
            style: TextStyle(
                color: Theme.of(context).primaryColor
            )
              ),
              ),
            ],
          ),
                  Container(
                    width: 300,
                     child: TextFormField(
                       controller: dosecontroller,
                       decoration: InputDecoration(
                         filled: true,
                         fillColor: Theme.of(context).primaryColor,
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(30.0),
                           borderSide: BorderSide.none,
                         ),
                         hintText: 'Enter dose.. e.g. 10',
                         hintStyle: TextStyle(color: Theme.of(context).primaryColorDark),
                       ),
                       style: TextStyle(
                         color: Theme.of(context).primaryColorDark,
                       ),
                      ),
                  )
          ],
        ),
              cardcolor: Theme.of(context).primaryColorDark, height: 300, width: 500, padding: EdgeInsets.all(20),
          ),
        Container(
          height: 350,
          padding: EdgeInsets.all(20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Patients').doc(Add_dose._currentUser?.uid).collection('scheduled_doses').snapshots(),
           builder: (context, snapshot) {
               if (!snapshot.hasData) {
                 return Center(
                 child: CircularProgressIndicator(),
                 );
                 } else{
                 read_doses();
                 return ListView.separated(
                   scrollDirection: Axis.vertical,
                   itemBuilder: (BuildContext context, int index){
                     return Container(
                       height: 50,
                       decoration: BoxDecoration(
                           color: Color(0xffc8b6ff),
                           borderRadius: BorderRadius.circular(10),
                       ),
                       child: Text(Add_dose.scheduled_doses[index].replaceAll("{Scheduled time:", "").replaceAll("dose quantity", "").replaceAll("}", "").replaceAll(",", ""),
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
                   itemCount: Add_dose.scheduled_doses.length,
                 );
                 }
               }
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              width: 120,
              height: 50,
              child:
          ElevatedButton(
            onPressed: (){
     Navigator.pop(context);
             // _showNotificationWithoutSound();
          },
            child:Text("Cancel",
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(70)
                ),
              ),
            ),
          ),
     ),
        SizedBox(
          width: 120,
          height: 50,
       child:ElevatedButton(
          onPressed:  (){
          setState(() {
            format=formatcontroller.text.toString();
            if(format=="pm"){
              if(hours==12){
                hours_24=hours;
              }
              else
              hours_24=hours+12;
            }
            else if(format=="am"){
              hours_24=hours;
            }
          });
          tz.TZDateTime now = tz.TZDateTime.now(tz.local);
           scheduled_notification(id:now.year.toString()+now.month.toString()+now.millisecond.toString() );
           String recommended_dose=dosecontroller.text;
          FirebaseFirestore.instance.collection('Patients').doc(Add_dose._currentUser?.uid.toString()).collection('scheduled_doses').doc('$now').set({'dose quantity':recommended_dose,'Scheduled time':scheduled_time});
          AlertDialog alert = AlertDialog(
            title: Text("Dose alert"),
            content: Text("Alert is set for $hours :  $minutes $format "),
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        },
         child:Text("Save",
         style: TextStyle(
           color: Colors.white,
         ),
         ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) =>Colors.deepPurpleAccent ),
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
      ],
      ),
        ),
      );
  }
}

