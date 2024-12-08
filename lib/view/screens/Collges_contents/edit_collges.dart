import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:university/view/screens/Collges_contents/University_Collges_Secreen.dart';
import 'package:university/view/widgets/alertdilog.dart';
import 'package:university/view/widgets/college_item.dart';
import 'package:university/view/widgets/coustombuttom.dart';
import 'package:university/view/widgets/customTextFormFieldAdd.dart';

class EditCollegs extends StatefulWidget {
  final String collgedocid;
  final String oldNamecollge;
  final String oldContcollge;
  final String oldUrlimageCollges;

  final String universitydocid;

  const EditCollegs(
      {super.key,
      required this.collgedocid,
      required this.universitydocid,
      required this.oldNamecollge,
      required this.oldContcollge,
      required this.oldUrlimageCollges});

  @override
  State<EditCollegs> createState() => _EditCollegsState();
}

class _EditCollegsState extends State<EditCollegs> {
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
          FirebaseStorage.instance.refFromURL("${widget.oldUrlimageCollges}");
      await refStorge.putFile(file!);
      urlimageCollges = await refStorge.getDownloadURL();
      isSelected = true;
      setState(() {});
    }
    setState(() {});
  }

  editCollges(context) async {
    // Call the user's CollectionReference to add a new user
    CollectionReference collectionCollge = FirebaseFirestore.instance
        .collection("universitys")
        .doc(widget.universitydocid)
        .collection("collges");
    if (formstate.currentState!.validate()) {
      try {
        isloding = true;
        setState(() {});

        await collectionCollge.doc(widget.collgedocid).update({
          "name": collgename.text,
          "contdept": contdept.text,
          "url": urlimageCollges ?? "none",
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => UniversityCollgesSecreen(
                universityid: widget.universitydocid)));
      } catch (e) {
        isloding = false;
        setState(() {});
        print(" Erorr $e");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    collgename.text = widget.oldNamecollge;
    contdept.text = widget.oldContcollge;
    super.initState();
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
      appBar: AppBar(title: Text("تعديل الكلية")),
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
                          hinttext: "ادخل اسم الكلية الجديد",
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
                          hinttext: "ادخل عدد الاقسام ",
                          labeltext: "عدد الاقسام",
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
                            Text('إضافة صورة جديدة للكلية '),
                            SizedBox(width: 20),
                            Icon(Icons.camera_alt),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButtomAuth(
                      text: "تعديل",
                      onPressed: () {
                        testAlert(
                            context,
                            "رسالة",
                            "هل تريد تعديل بيانات الكلية؟",
                            () {
                              Navigator.of(context).pop();
                            },
                            "الغاء",
                            () async {
                              editCollges(context);
                              // Navigator.of(context).pushNamedAndRemoveUntil(
                              //     "tabs_screen", (route) => false);
                            },
                            "تحديث");
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
