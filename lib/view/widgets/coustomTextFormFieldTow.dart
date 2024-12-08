import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormFieldTow extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  //final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;

  const CustomTextFormFieldTow(
      {super.key,
      required this.hinttext,
      required this.mycontroller,
      this.validator,
      this.onChanged,
      //this.inputFormatters,
      this.textInputAction});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          filled: true,
          fillColor: Color.fromARGB(255, 255, 255, 255),
          border: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 255, 254, 254))),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey))),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      minLines: 5,
      textInputAction: textInputAction,
      //inputFormatters: inputFormatters,
    );
  }
}
