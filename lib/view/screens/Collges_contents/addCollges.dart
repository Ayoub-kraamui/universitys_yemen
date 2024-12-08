import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:university/view/screens/Collges_contents/University_Collges_Secreen.dart';

import 'package:university/view/widgets/alertdilog.dart';
import 'package:university/view/widgets/college_item.dart';
import 'package:university/view/widgets/coustombuttom.dart';
import 'package:university/view/widgets/customTextFormFieldAdd.dart';

class AddCollges extends StatefulWidget {
  final String docid;
  const AddCollges({super.key, required this.docid});

  @override
  State<AddCollges> createState() => _AddCollgesState();
}

class _AddCollgesState extends State<AddCollges> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController collgename = TextEditingController();
  TextEditingController contdept = TextEditingController();
  File? file;
  String? urlimageCollges;
  bool isSelected = false;
  bool isloding = false;

  getImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
//final XFile? imagegallery = await picker.pickImage(source: ImageSource.gallery);
// Capture a photo.
    final XFile? imagecamera =
        await picker.pickImage(source: ImageSource.camera);
    if (imagecamera != null) {
      file = File(imagecamera!.path);
      var imagename = basename(imagecamera!.path);
      var refStorge =
          FirebaseStorage.instance.ref("universitys/collges/$imagename");
      await refStorge.putFile(file!);
      urlimageCollges = await refStorge.getDownloadURL();
      isSelected = true;
      setState(() {});
    }
    setState(() {});
  }

  addCollges(context) async {
    // Call the user's CollectionReference to add a new user
    CollectionReference collectionCollge = FirebaseFirestore.instance
        .collection("universitys")
        .doc(widget.docid)
        .collection("collges");
    if (formstate.currentState!.validate()) {
      try {
        isloding = true;
        setState(() {});
        DocumentReference respons = await collectionCollge.add({
          "name": collgename.text,
          "contdept": contdept.text,
          "url": urlimageCollges ?? "none",
          "id": FirebaseAuth.instance.currentUser!.uid
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                UniversityCollgesSecreen(universityid: widget.docid)));
      } catch (e) {
        isloding = false;
        setState(() {});
        print(" Erorr $e");
      }
    }
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    collgename.dispose();
    contdept.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة كلية")),
      body: Form(
        key: formstate,
        child: isloding
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                      child: CustomTextFormFieldAdd(
                          hinttext: "ادخل اسم الكلية",
                          labeltext: "اسم الكلية",
                          mycontroller: collgename,
                          validator: (val) {
                            if (val == "") {
                              return "لايمكن ان يكون الحقل فارغ";
                            }
                          }),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                      child: CustomTextFormFieldAdd(
                          hinttext: "ادخل عدد التخصصات",
                          labeltext: "عدد التخصصات",
                          mycontroller: contdept,
                          validator: (val) {
                            if (val == "") {
                              return "لايمكن ان يكون الحقل فارغ";
                            }
                          }),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                      child: MaterialButton(
                        height: 40,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        onPressed: () async {
                          await getImage();
                        },
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.red,
                        textColor: Theme.of(context).textTheme.headline5!.color,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('إضافة صورة الكلية'),
                            SizedBox(width: 20),
                            Icon(Icons.camera_alt),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButtomAuth(
                      text: "إضافة",
                      onPressed: () {
                        testAlert(
                            context,
                            "رسالة",
                            "هل تريد اضفافة هذة الكلية؟",
                            () {
                              Navigator.of(context).pop();
                            },
                            "الغاء",
                            () async {
                              addCollges(context);
                            },
                            "حفظ");
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
