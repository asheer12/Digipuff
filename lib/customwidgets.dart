import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_inhaler/Authentication/login.dart';
//Custom widget
class Customcard extends StatelessWidget {
  final Color cardcolor;
  final Widget cardchild;
  final double? width;
  final double? height;
  Customcard({required this.cardchild,required this.cardcolor,required this.height,required this.width});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child:Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: cardcolor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black87.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 8,
              ),
            ]
        ),
        child: cardchild,
      ),
    );
  }
}

class Simplecard extends StatelessWidget {
  final Color cardcolor;
  final Widget cardchild;
  final double? width;
  final double? height;
final EdgeInsetsGeometry padding;
  Simplecard({required this.cardchild,required this.cardcolor,required this.height,required this.width,required this.padding});
  @override
  Widget build(BuildContext context) {

    return Padding(padding:padding,
        child:Container(
      height: height,
        width: width,
        decoration: BoxDecoration(
            color: cardcolor,
            borderRadius: BorderRadius.circular(25),
        ),
        child: cardchild,
      ),
    );
  }
}
class Capsule extends StatelessWidget {
 late final Color capsule_color;
 late final Widget capsule_child;
 late final double height;
 late final double width;
 Capsule({required this.capsule_child,required this.capsule_color,required this.width,required this.height});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:capsule_color,
        borderRadius: BorderRadius.circular(30),
      ),
      child:capsule_child,
      height: height,
      width: width,
    );
  }
}
class Alert extends StatelessWidget {
  final Text title;
  final Text content;
Alert({required this.title,required this.content});
  @override
  Widget build(BuildContext context) {
    return    AlertDialog(
      title: Text("$title"),
      content: Text("$content"),
    );
  }
}



//