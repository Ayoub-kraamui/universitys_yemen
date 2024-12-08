import 'package:flutter/material.dart';

class CustomButtomAuth extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const CustomButtomAuth({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).textTheme.headline5!.color,
      child: Text(
        text,
        style: TextStyle(fontSize: 17),
      ),
    );
  }
}
