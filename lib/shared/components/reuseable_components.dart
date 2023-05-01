
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


Widget myDivider() => Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );
/// Toast Methods
void showToast({required String text, required ToastStates state, String? runiCode ='' }) =>
    Fluttertoast.showToast(
        msg: text+runiCode.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { Success, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.Success:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

///////////////////////////////////////////////////////
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void printFullText(String text) {
  final pattren = RegExp('.{1,800}');
  pattren.allMatches(text).forEach((match) => print(match.group(0)));
}
List<Color> kListBackGroundColors = [
  const Color.fromRGBO(248, 225, 244, 1),//0
  const Color.fromRGBO(251, 214, 210, 1),//1
  const Color.fromRGBO(239, 169, 228, 1),//2

  const Color.fromRGBO(241, 144, 183, 1),//4
  const Color.fromRGBO(206, 73, 191, 1),//5
  const Color.fromRGBO(166, 62, 197, 1),//6
  const Color.fromRGBO(240,128,128, 1),//7
  const Color.fromRGBO(233,150,122, 1),//8
  const Color.fromRGBO(250,128,114, 1),//9
  const Color.fromRGBO(238,232,170, 1),//10
  const Color.fromRGBO(189,183,107, 1),//11
  const Color.fromRGBO(255,228,181, 1),//12
  const Color.fromRGBO(255,222,173, 1),//13
  const Color.fromRGBO(255,218,185, 1),//14
  const Color.fromRGBO(176,196,222, 1),//15
  const Color.fromRGBO(230,230,250, 1),//16
  const Color.fromRGBO(255,250,240, 1),//17
  const Color.fromRGBO(240,248,255, 1),//18
  const Color.fromRGBO(248,248,255, 1),//19
  const Color.fromRGBO(240,255,255, 1),//20
  const Color.fromRGBO(5, 30, 62, 1),//20
];

String token = '';
String? uId= '' ;
String? relatedBranchID= '' ;
bool? isAdmin ;
