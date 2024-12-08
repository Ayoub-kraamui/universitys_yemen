import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:university/controller/onboarding_controller.dart';
import 'package:university/core/constant/color.dart';
import 'package:university/data/datasource/static/static.dart';

class CustomPageViewOnboarding extends GetView<OnBoardeingControllerImp> {
  const CustomPageViewOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller.pageController,
      onPageChanged: (value) => controller.onPageChange(value),
      itemCount: onBoardingList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            const SizedBox(height: 20),
            Text(
              onBoardingList[index].title!,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColor.black),
            ),
            const SizedBox(height: 80),
            Image.asset(
              onBoardingList[index].image!,
              width: 200,
              height: 230,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 80),
            Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  onBoardingList[index].body!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      height: 2,
                      color: AppColor.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ))
          ],
        );
      },
    );
  }
}
