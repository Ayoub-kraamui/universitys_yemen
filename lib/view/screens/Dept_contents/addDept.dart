import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:university/view/screens/Dept_contents/college_dept_secreen.dart';
import 'package:university/view/widgets/alertdilog.dart';
import 'package:university/view/widgets/coustomTextFormFieldTow.dart';
import 'package:university/view/widgets/coustombuttom.dart';
import 'package:university/view/widgets/customTextFormFieldAdd.dart';

class AddDept extends StatefulWidget {
  final String docUnid;
  final String docCoid;
  final String? universitytype;
  const AddDept(
      {super.key,
      required this.docUnid,
      required this.docCoid,
      this.universitytype});
  @override
  State<AddDept> createState() => _AddDeptState();
}

class _AddDeptState extends State<AddDept> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController namedept = TextEditingController();
  List<int> times = [2, 3, 4, 5, 6, 7]; // Option 2
  int? selectedTime;
  TextEditingController ratedept = TextEditingController();
  TextEditingController pricedept = TextEditingController();
  TextEditingController jobschances = TextEditingController();
  TextEditingController characteristic = TextEditingController();
  File? file;
  String? urlimageDepts;
  bool isSelected = false;
  bool isloding = false;
  bool isFavorite = false;
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
          FirebaseStorage.instance.ref("universitys/depts/$imagename");
      await refStorge.putFile(file!);
      urlimageDepts = await refStorge.getDownloadURL();
      isSelected = true;
      setState(() {});
    }
    setState(() {});
  }

  addDept(context) async {
    // Call the user's CollectionReference to add a new user
    CollectionReference collectionNote = FirebaseFirestore.instance
        .collection("universitys")
        .doc(widget.docUnid)
        .collection("collges")
        .doc(widget.docCoid)
        .collection("depts");
    if (formstate.currentState!.validate()) {
      try {
        isloding = true;
        setState(() {});
        DocumentReference respons = await collectionNote.add({
          "name": namedept.text,
          "time": selectedTime,
          "rate": ratedept.text,
          "price": pricedept.text,
          "jobschances": lines,
          "characteristic": linestow,
          "url": urlimageDepts ?? "none",
          "isfavorite": isFavorite,
          "id": FirebaseAuth.instance.currentUser!.uid
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DeptDetailScreen(
                universityid: widget.docUnid, collgeid: widget.docCoid)));
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
    namedept.dispose();
    ratedept.dispose();
    pricedept.dispose();
    jobschances.dispose();
    characteristic.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    lines = jobschances.text.split('\n');
    linestow = jobschances.text.split('\n');
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
      appBar: AppBar(title: Text("إضافة تخصص")),
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
                          hinttext: "ادخل اسم التخصص",
                          labeltext: "اسم التخصص",
                          mycontroller: namedept,
                          validator: (val) {
                            if (val == "") {
                              return "لا يمكن ان يكون الحقل فارغ";
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
                          hinttext: "ادخل المعدل المقبول",
                          labeltext: "معدل القبول",
                          mycontroller: ratedept,
                          validator: (val) {
                            if (val == "") {
                              return "لا يمكن ان يكون الحقل فارغ";
                            }
                          }),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                      child: CustomTextFormFieldAdd(
                          hinttext: "ادخل الرسوم الدراسية",
                          labeltext: "الرسوم الدراسية",
                          mycontroller: pricedept,
                          validator: (val) {
                            if (val == "") {
                              return "لا يمكن ان يكون الحقل فارغ";
                            }
                          }),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                      child: CustomTextFormFieldTow(
                        hinttext: "ادخل فرص العمل المتاحة للتخصص",
                        mycontroller: jobschances,
                        validator: (val) {
                          if (val == "") {
                            return "لا يمكن ان يكون الحقل فارغ";
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
                        hinttext: "ادخل مميزات هذا التخصص في هذة الجامعة",
                        mycontroller: characteristic,
                        validator: (val) {
                          if (val == "") {
                            return "لا يمكن ان يكون الحقل فارغ";
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
                            Text('إضافة صورة التخصص'),
                            SizedBox(width: 20),
                            Icon(Icons.camera_alt),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButtomAuth(
                      text: "حفظ",
                      onPressed: () {
                        testAlert(
                            context,
                            "رسالة",
                            "هل تريد اضافة جامعة جديدة",
                            () {
                              Navigator.of(context).pop();
                            },
                            "الغاء",
                            () async {
                              addDept(context);
                            },
                            "حفظ");
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
