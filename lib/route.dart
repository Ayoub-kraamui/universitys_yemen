import 'package:get/get.dart';
import 'package:university/core/constant/approute.dart';
import 'package:university/core/middleware/mymiddleware.dart';
import 'package:university/view/screens/Collges_contents/University_Collges_Secreen.dart';
import 'package:university/view/screens/Collges_contents/addCollges.dart';
import 'package:university/view/screens/Collges_contents/edit_collges.dart';
import 'package:university/view/screens/Dept_contents/addDept.dart';
import 'package:university/view/screens/Dept_contents/college_dept_secreen.dart';
import 'package:university/view/screens/Dept_contents/dept_detail_screen.dart';
import 'package:university/view/screens/Dept_contents/editDept.dart';
import 'package:university/view/screens/University_contents/addUniversity.dart';
import 'package:university/view/screens/University_contents/editUniversity.dart';
import 'package:university/view/screens/auth/login.dart';
import 'package:university/view/screens/auth/signup.dart';
import 'package:university/view/screens/onboardingscreen.dart';
import 'package:university/view/screens/tabs_screen.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
      name: "/",
      page: () => const OnBoardingScreen(),
      middlewares: [MyMiddleWare()]),
  GetPage(name: AppRoute.login, page: () => Login()),
  GetPage(name: AppRoute.signup, page: () => SignUp()),
  // GetPage(name: AppRoute.sucesssignup, page: () =>  suc()),
  GetPage(name: AppRoute.tabsscreen, page: () => TabsScreen()),
  GetPage(name: AppRoute.addUniversity, page: () => Adduniversity()),
//   GetPage(name: AppRoute.editeUniversity, page: () =>  EditUniversity()),
//   GetPage(name: AppRoute.viewCollege, page: () =>  UniversityCollgesSecreen()),
//   GetPage(name: AppRoute.editeCollege, page: () =>  EditCollegs()),
//   GetPage(name: AppRoute.addCollege, page: () =>  AddCollges()),
// GetPage(name: AppRoute.viewDept, page: () =>  DeptDetailScreen()),
//   GetPage(name: AppRoute.editeDept, page: () =>  EditDept()),
//   GetPage(name: AppRoute.addDept, page: () =>  AddDept()),
//     GetPage(name: AppRoute.deptDetail, page: () =>  CollegeDetailScreen()),
];
