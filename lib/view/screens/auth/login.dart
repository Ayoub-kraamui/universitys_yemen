import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:university/view/screens/auth/signup.dart';
import 'package:university/view/widgets/alertdilog.dart';
import 'package:university/view/widgets/coustombuttom.dart';
import 'package:university/view/widgets/customTextFormFieldAdd.dart';
import 'package:university/view/widgets/logauth.dart';

class Login extends StatefulWidget {
  static const routeName = 'login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> fromState = GlobalKey<FormState>();

  bool isloding = false;

  Future signInWithGoogle(
      void Function(String errorMessage) errorCallback) async {
    // Trigger the authentication flow
    try {
      isloding = true;
      setState(() {});
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      isloding = false;
      setState(() {});
      Navigator.of(context)
          .pushNamedAndRemoveUntil("tabs_screen", (route) => false);
    } on PlatformException catch (e) {
      if (e.code == GoogleSignIn.kNetworkError) {
        String errorMessage =
            "A network error (such as timeout, interrupted connection or unreachable host) has occurred.";
        errorCallback(errorMessage);
      } else {
        String errorMessage = "Something went wrong.";
        errorCallback(errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              child: ListView(children: [
                Form(
                  key: fromState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 50),
                      const Customlogoauth(),
                      Container(height: 20),
                      const Text("Login",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      const Text("قم بتسجيل الدخول لمواصلة استخدام التطبيق",
                          style: TextStyle(fontSize: 20, color: Colors.grey)),
                      const SizedBox(height: 20),
                      const Text("Email",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Container(height: 10),
                      CustomTextFormFieldAdd(
                        hinttext: 'أدخل بريدك الإلكتروني',
                        labeltext: "اسم الجامعة",
                        mycontroller: email,
                        validator: (val) {
                          if (val == "") {
                            return "Can't to empty";
                          }
                        },
                      ),
                      Container(height: 10),
                      const Text("Password",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Container(height: 10),
                      CustomTextFormFieldAdd(
                        hinttext: 'ادخل رقمك السري',
                        labeltext: "اسم الجامعة",
                        mycontroller: password,
                        validator: (val) {
                          if (val == "") {
                            return "Can't to empty";
                          }
                        },
                      ),
                      InkWell(
                        onTap: () async {
                          if (email.text == "") {
                            print(
                                "الرجاء كتابة البريد الالكتروني ثم الضغط على إعادة تعيين كلمة المرور");
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    title: Text("erorr"),
                                    content: Text("message"),
                                  );
                                });
                          }

                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email.text);
                            print(
                                "الرجاء الذهاب الى البريد الالكتروني لإعادة تعيين كلمة المرور");
                          } catch (e) {
                            print(
                                "الرجاء التأكد من ان البريد الألكتروني الذي ادخلته  صحيح ثم قم بإعادة المحاولة");
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          alignment: Alignment.topRight,
                          child: const Text("Forget Password?",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomButtomAuth(
                    text: 'Login',
                    onPressed: () async {
                      if (fromState.currentState!.validate()) {
                        try {
                          isloding = true;
                          setState(() {});
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email.text, password: password.text);
                          isloding = false;
                          setState(() {});
                          if (credential.user!.emailVerified) {
                            Navigator.of(context)
                                .pushReplacementNamed("tabs_screen");
                          } else {
                            print(
                                "الرجاء التحقق من الحساب في بريدك الالكتروني");
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("erorr"),
                                    content: Text("message"),
                                  );
                                });
                          }
                        } on FirebaseAuthException catch (e) {
                          isloding = false;
                          setState(() {});
                          if (e.code == 'user-not-found') {
                            checkAlert(context, "خطا..",
                                " لم يتم العثور على مستخدم لهذا البريد الإلكتروني.");
                          } else if (e.code == 'wrong-password') {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("erorr"),
                                    content: Text("message"),
                                  );
                                });
                            print(
                                " لم يتم العثور على مستخدم لهذا البريد الإلكتروني. $e");
                          }
                        }
                      } else {
                        print('Not vaild');
                      }
                    }),
                Container(height: 20),
                MaterialButton(
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    signInWithGoogle((errorMessage) {});
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Login With Google'),
                      Icon(Icons.person),
                    ],
                  ),
                ),
                Container(height: 20),
                InkWell(
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed(SignUp.routeName),
                  child: const Center(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                        text: "Don't have An Account ? ",
                      ),
                      TextSpan(
                          text: "Register",
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold)),
                    ])),
                  ),
                ),
              ]),
            ),
    );
  }
}
