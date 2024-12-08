import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:university/controller/onboarding_controller.dart';

class CustomButtomOnboarding extends GetView<OnBoardeingControllerImp> {
  const CustomButtomOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 30),
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 0),
        textColor: Colors.white,
        onPressed: () {
          controller.next();
        },
        color: Theme.of(context).primaryColor,
        child: const Text("Continue"),
      ),
    );
  }
}
