import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:university/controller/onboarding_controller.dart';
import 'package:university/view/widgets/onboarding/custombuttom.dart';
import 'package:university/view/widgets/onboarding/custompageview.dart';
import 'package:university/view/widgets/onboarding/dotcontroller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnBoardeingControllerImp());
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: CustomPageViewOnboarding(),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    DotControllerOnboarding(),
                    Spacer(flex: 2),
                    CustomButtomOnboarding(),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
