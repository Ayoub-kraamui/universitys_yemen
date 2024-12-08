import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:university/controller/onboarding_controller.dart';
import 'package:university/data/datasource/static/static.dart';

class DotControllerOnboarding extends StatelessWidget {
  const DotControllerOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardeingControllerImp>(
        builder: (controller) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                    onBoardingList.length,
                    (index) => AnimatedContainer(
                          margin: const EdgeInsets.only(right: 5),
                          duration: const Duration(milliseconds: 900),
                          width: controller.currentPage == index ? 10 : 6,
                          height: controller.currentPage == index ? 10 : 6,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                        ))
              ],
            ));
  }
}
