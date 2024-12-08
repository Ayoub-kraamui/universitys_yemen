//import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:university/view/screens/auth/login.dart';
import 'package:university/view/widgets/coustombuttom.dart';
import 'package:university/view/widgets/customTextFormFieldAdd.dart';
import 'package:university/view/widgets/logauth.dart';

class SignUp extends StatefulWidget {
  static const routeName = 'signup';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> fromState = GlobalKey<FormState>();
  bool isloding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key: fromState,
            child: isloding
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 50),
                      const Customlogoauth(),
                      Container(height: 20),
                      const Text("SignUp",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      const Text("قم بالتسجيل لمواصلة استخدام التطبيق",
                          style: TextStyle(fontSize: 20, color: Colors.grey)),
                      const SizedBox(height: 20),
                      const Text("UserName",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Container(height: 10),
                      CustomTextFormFieldAdd(
                        hinttext: 'أدخل اسم المستخدم الخاص بك',
                        labeltext: "اسم الجامعة",
                        mycontroller: username,
                        validator: (val) {
                          if (val == "") {
                            return "Can't to empty";
                          }
                        },
                      ),
                      Container(height: 10),
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
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        alignment: Alignment.topRight,
                        child: const Text("Forget Password ?",
                            style: TextStyle(fontSize: 17)),
                      ),
                    ],
                  ),
          ),
          CustomButtomAuth(
              text: 'SignUp',
              onPressed: () async {
                if (fromState.currentState!.validate()) {
                  try {
                    isloding = true;
                    setState(() {});
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );

                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    isloding = false;
                    setState(() {});
                    Navigator.of(context).pushReplacementNamed(Login.routeName);
                  } on FirebaseAuthException catch (e) {
                    isloding = false;
                    setState(() {});
                    if (e.code == 'weak-password') {
                      print("كلمة المرور المقدمة ضعيفة جدًا.");
                    } else if (e.code == 'email-already-in-use') {
                      print("البريد الإلكتروني المقدم ضعيف جدًا.");
                    }
                  } catch (e) {
                    print(e);
                  }
                } else {
                  print('Not vaild');
                }
              }),
          Container(height: 20),
          Container(height: 20),
          InkWell(
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(Login.routeName),
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Have An Account ? ",
                ),
                TextSpan(
                    text: "Login",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold)),
              ])),
            ),
          ),
        ]),
      ),
    );
  }
}
