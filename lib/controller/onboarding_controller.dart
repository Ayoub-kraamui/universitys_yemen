import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:university/data/datasource/static/static.dart';
import 'package:university/view/screens/auth/login.dart';

abstract class OnBoardeingController extends GetxController {
  next();

  onPageChange(int index);
}

class OnBoardeingControllerImp extends OnBoardeingController {
  int currentPage = 0;
  late PageController pageController;
  @override
  next() {
    currentPage++;
    if (currentPage > onBoardingList.length - 1) {
      Get.offAllNamed("login");
    } else {
      pageController.animateToPage(currentPage,
          duration: Duration(milliseconds: 900), curve: Curves.easeInOut);
    }
  }

  @override
  onPageChange(int index) {
    currentPage = index;
    update();
  }

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }
}
