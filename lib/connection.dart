// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:smart_inhaler/pateintlogin.dart';
// import 'package:smart_inhaler/customwidgets.dart';
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';
// import 'package:smart_inhaler/main.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:smart_inhaler/settings.dart';
// import 'pateint_home.dart';
// class Connect_to_bluetooth extends StatefulWidget {
//    Connect_to_bluetooth();
//   @override
//   _Connect_to_bluetoothState createState() => _Connect_to_bluetoothState();
// }
//
// class _Connect_to_bluetoothState extends State<Connect_to_bluetooth> {
//
//   final Color darkviolet=Color(0xff7835EC);
//   final Color lightviolet=Color(0xffc1afe3);
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//
//     @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//         appBar: AppBar(
//           foregroundColor: Theme.of(context).primaryColor,
//           backgroundColor: Colors.transparent,
//           elevation: 0.0,
//         ),
//       body:SingleChildScrollView(
//           child: Column(
//         children:<Widget>[
//
//   ElevatedButton(onPressed: (){
//   startscan();
// },
//   child:Connect_to_bluetooth.btn_bluetooth,
//   style: ButtonStyle(
//       shape: MaterialStateProperty.resolveWith((states) => CircleBorder(),
//       ),
//       padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.all(65)),
//       backgroundColor: MaterialStateProperty.resolveWith((states) => Connect_to_bluetooth.select == bluetooth.connect? Colors.green : Theme.of(context).primaryColorDark)
//   ),
//       ),
//       ],
//       ),
//       ),
//     );
//   }
// }
