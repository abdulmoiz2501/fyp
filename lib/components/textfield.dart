// import 'package:flutter/material.dart';
// import 'package:email_validator/email_validator.dart';
// import '../constants/colors.dart';
//
// class MyTextField extends StatelessWidget {
//   const MyTextField({super.key, this.controlller, required this.hintText, required this.obscureText, required this.emailValidate, required this.passValidate, required this.confirmPassValidate});
//
//   final controlller;
//   final String hintText;
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return  Padding(
//       padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.065),
//       child: TextFormField(
//         obscureText: obscureText,
//         controller: controlller,
//         decoration: InputDecoration(
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: kWhite,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.grey.shade400,
//             ),
//           ),
//           fillColor: kTextBoxColor,
//           filled: true,
//           hintText: hintText,
//           hintStyle: TextStyle(
//             color:kHintTextColor,
//           ),
//         ),
//         validator: (value) {
//
//         },
//       ),
//     );
//   }
// }
