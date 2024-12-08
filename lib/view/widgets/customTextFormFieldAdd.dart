import 'package:flutter/material.dart';

class CustomTextFormFieldAdd extends StatelessWidget {
  final String hinttext;
  final String labeltext;
  final TextEditingController? mycontroller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  const CustomTextFormFieldAdd(
      {super.key,
      required this.hinttext,
      required this.labeltext,
      this.mycontroller,
      this.validator,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      decoration: InputDecoration(
        hintText: hinttext,
        labelText: labeltext,
      ),
      keyboardType: keyboardType,
    );
  }
}
