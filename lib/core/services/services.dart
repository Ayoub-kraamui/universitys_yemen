import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;
  Future<MyServices> init() async {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDM166tpmAj8WIyHjCMzj-LEKG9F7-eFqk",
            appId: "1:401327350311:android:751215cd2a525fdd7c2402",
            messagingSenderId: "401327350311",
            projectId: "ecommerce-889d0",
            storageBucket: "ecommerce-889d0.appspot.com"));
    sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }
}

initServices() async {
  await Get.putAsync(() => MyServices().init());
}
