import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'const.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType textInputType,
  required String labelText,
  required IconData prefixIcon,
  IconData? suffixIcon,
  bool isPasswordHidden = false,
  VoidCallback? togglePassword,
  required String? Function(String?)? validator,


})
=>TextFormField(
controller: controller,
obscureText: isPasswordHidden,
keyboardType: textInputType,
cursorColor: green,

decoration: InputDecoration(
labelText: labelText,
labelStyle: TextStyle(color: gray2),

prefixIcon: Icon(prefixIcon, color: gray2),

suffixIcon:IconButton(
  onPressed: togglePassword,
  icon: Icon(
    suffixIcon,
    color: gray2,
  ),
),



),

validator: validator,
);


Widget defaultMaterialButton({
  required VoidCallback? onPressed,
  Color color= green,
  Color splashColor= green1,
  Color textColor= white,
  double height = 50,
  double minWidth=double.infinity,
  required String label,
  double? fontSize=18,
  FontWeight? fontWeight=FontWeight.bold,

}) =>
MaterialButton(
onPressed: onPressed,

minWidth: minWidth,
color: color,
textColor: textColor,
splashColor: splashColor,
height: height,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20),
),

child:  Text(
label,
style: TextStyle(
fontSize:fontSize,
fontWeight: fontWeight
),
),
);

Widget defaultTextButton({
  required VoidCallback? onPressed,
  required String label,
})
=> TextButton(onPressed: onPressed, child: Text(
  label,
style: TextStyle(
fontSize:16,
),
),);