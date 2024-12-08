import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:university/view/screens/Dept_contents/college_dept_secreen.dart';
import 'package:university/view/widgets/alertdilog.dart';
import 'package:university/view/widgets/coustomTextFormFieldTow.dart';
import 'package:university/view/widgets/coustombuttom.dart';
import 'package:university/view/widgets/customTextFormFieldAdd.dart';

class EditDept extends StatefulWidget {
  final String deptdocid;
  final String collgedocid;
  final String universitydocid;

  final String oldname;
  final int oldtimes;

  final String oldrate;
  final String oldprice;
  final List oldjobschances;
  final List oldcharacteristic;
  final String oldUrlimageDepts;

  const EditDept(
      {super.key,
      required this.deptdocid,
      required this.collgedocid,
      required this.universitydocid,
      required this.oldname,
      required this.oldtimes,
      required this.oldrate,
      required this.oldprice,
      required this.oldjobschances,
      required this.oldcharacteristic,
      required this.oldUrlimageDepts});

  @override
  State<EditDept> createState() => _EditDeptState();
}

class _EditDeptState extends State<EditDept> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController deptename = TextEditingController();
  List<int> times = [2, 3, 4, 5, 6, 7]; // Option 2
  int? selectedTime;
  TextEditingController rate = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController jobschances = TextEditingController();
  TextEditingController characteristic = TextEditingController();
  File? file;
  String? urlimageDepts;
  bool isSelected = false;
  bool isloding = false;
  List<String>? lines;
  List<String>? linestow;
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
          FirebaseStorage.instance.refFromURL("${widget.oldUrlimageDepts}");
      await refStorge.putFile(file!);
      urlimageDepts = await refStorge.getDownloadURL();
      isSelected = true;
      setState(() {});
    }
    setState(() {});
  }

  editDept(context) async {
    // Call the user's CollectionReference to add a new user
    CollectionReference collectionNote = FirebaseFirestore.instance
        .collection("universitys")
        .doc(widget.universitydocid)
        .collection("collges")
        .doc(widget.collgedocid)
        .collection("depts");
    if (formstate.currentState!.validate()) {
      try {
        isloding = true;
        setState(() {});

        await collectionNote.doc(widget.deptdocid).update({
          "name": deptename.text,
          "time": selectedTime,
          "rate": rate.text,
          "price": price.text,
          "jobschances": lines,
          "characteristic": linestow,
          "url": urlimageDepts ?? "none",
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DeptDetailScreen(
                universityid: widget.universitydocid,
                collgeid: widget.collgedocid)));
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
    deptename.text = widget.oldname;
    selectedTime = widget.oldtimes;
    rate.text = widget.oldrate;
    price.text = widget.oldprice;
    jobschances.text = widget.oldjobschances.join('\n');
    characteristic.text = widget.oldcharacteristic.join('\n');
    lines = jobschances.text.split('\n');
    linestow = characteristic.text.split('\n');
    super.initState();
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    deptename.dispose();
    rate.dispose();
    price.dispose();
    jobschances.dispose();
    characteristic.dispose();
  }

  Container newDropDown() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                      hintText: selectedTime == null
                          ? 'اختر عدد السنوات'
                          : selectedTime!.toString(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 0))),
                  autofocus: false,
                  readOnly: true,
                )),
                DropdownButton(
                  onChanged: (newValue) {
                    setState(() {
                      selectedTime = newValue!;
                    });
                  },
                  items: times.map((time) {
                    return DropdownMenuItem<int>(
                      value: time,
                      child: Text("${time}"),
                    );
                  }).toList(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: const TextStyle(color: Colors.black),
                  underline: Container(height: 2, color: Colors.white),
                  dropdownColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تعديل الاقسام")),
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
                          hinttext: "ادخل اسم القسم الجديد",
                          labeltext: "اسم القسم",
                          mycontroller: deptename,
                          validator: (val) {
                            if (val == "") {
                              return "لايمكن ان يكون الحقل فارغ";
                            }
                          }),
                    ),
                    const SizedBox(height: 20),
                    newDropDown(),
                    const SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                      child: CustomTextFormFieldAdd(
                          hinttext: "ادخل المعدل القبول الجديد  ",
                          labeltext: "معدل القبول",
                          mycontroller: rate,
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
                          hinttext: "ادخل الرسوم الدراسية الجديدة  ",
                          labeltext: "الرسوم الدراسية",
                          mycontroller: price,
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
                      child: CustomTextFormFieldTow(
                        hinttext: "ادخل فرص العمل المتاحة  ",
                        mycontroller: jobschances,
                        validator: (val) {
                          if (val == "") {
                            return "لايمكن ان يكون الحقل فارغ";
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            lines = jobschances.text.split('\n');
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                      child: CustomTextFormFieldTow(
                        hinttext: "ادخل مميزات هذا التخصص  ",
                        mycontroller: characteristic,
                        validator: (val) {
                          if (val == "") {
                            return "لايمكن ان يكون الحقل فارغ";
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            linestow = characteristic.text.split('\n');
                          });
                        },
                      ),
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
                            Text('إضافة صورة جديدة للتخصص'),
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
                              editDept(context);
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
