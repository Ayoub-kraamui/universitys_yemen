import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:university/view/widgets/alertdilog.dart';
import 'package:university/view/widgets/coustombuttom.dart';
import 'package:university/view/widgets/customTextFormFieldAdd.dart';

class EditUniversity extends StatefulWidget {
  static const routeName = 'Edit_University';

  final String docid;
  final String oldname;
  final String oldlocation;
  final String oldtype;

  final String oldurlimage;

  const EditUniversity(
      {super.key,
      required this.docid,
      required this.oldname,
      required this.oldlocation,
      required this.oldtype,
      required this.oldurlimage});

  @override
  State<EditUniversity> createState() => _EditUniversityState();
}

class _EditUniversityState extends State<EditUniversity> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  List<String> locations = ['صنعاء', 'إب', 'تعز', 'عدن']; // Option 2
  List<String> types = ['اهلي', 'حكومي']; // Option 2
  String? selectedType;
  String? selectedLocation;
  String? urlimageUniversity;
  File? file;
  bool isSelected = false;
  CollectionReference universitysitem =
      FirebaseFirestore.instance.collection("universitys");
  bool isloding = false;

  editCategories(context) async {
    // Call the user's CollectionReference to add a new user
    try {
      isloding = true;
      setState(() {});
      if (formstate.currentState!.validate()) {
        var respons = await universitysitem.doc(widget.docid).set({
          "name": name.text,
          "location": selectedLocation,
          "type": selectedType,
          "url": urlimageUniversity ?? "none",
        }, SetOptions(merge: true));
        Navigator.of(context)
            .pushNamedAndRemoveUntil("tabs_screen", (route) => false);
      }
    } catch (e) {
      isloding = false;
      setState(() {});
      print(" Erorr $e");
    }
  }

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
      var refStorgeUplode =
          FirebaseStorage.instance.refFromURL("${widget.oldurlimage}");
      await refStorgeUplode.putFile(file!);
      urlimageUniversity = await refStorgeUplode.getDownloadURL();
      isSelected = true;
      setState(() {});
    }
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.oldname;
    selectedLocation = widget.oldlocation;
    selectedType = widget.oldtype;
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
                    child: TextFormField(
                        decoration: InputDecoration(
                            hintText: selectedLocation == null
                                ? "اختر موقع الجامعة الجديد"
                                : selectedLocation!,
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 0))),
                        autofocus: false,
                        readOnly: true,
                        validator: (val) {
                          if (val == "") {
                            return "لا يمكن ان يكون الحقل فارغ";
                          }
                          return null;
                        })),
                DropdownButton(
                  onChanged: (newValue) {
                    setState(() {
                      selectedLocation = newValue!;
                    });
                  },
                  items: locations.map((location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: const TextStyle(color: Colors.black),
                  underline: Container(height: 0),
                  dropdownColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container newDropDown2() {
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
                    child: TextFormField(
                        decoration: InputDecoration(
                            hintText: selectedType == null
                                ? "اختر نوع الجامعة"
                                : selectedType!,
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 0))),
                        autofocus: false,
                        readOnly: true,
                        validator: (val) {
                          if (val == "") {
                            return "لا يمكن ان يكون الحقل فارغ";
                          }
                          return null;
                        })),
                DropdownButton(
                  onChanged: (newValue) {
                    setState(() {
                      selectedType = newValue!;
                    });
                  },
                  items: types.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: const TextStyle(color: Colors.black),
                  underline: Container(height: 0),
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
      appBar: AppBar(title: Text("تعديل الجامعات")),
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
                          hinttext: "ادخل اسم الجامعة الجديد",
                          labeltext: "اسم الجامعة",
                          mycontroller: name,
                          validator: (val) {
                            if (val == "") {
                              return "لا يمكن ان يكون الحقل فارغ";
                            }
                          }),
                    ),
                    const SizedBox(height: 20),
                    newDropDown(),
                    const SizedBox(height: 20),
                    newDropDown2(),
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
                            Text('إضافة صورة الجامعة'),
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
                            "هل تريد تعديل بيانات الجامعة؟",
                            () {
                              Navigator.of(context).pop();
                            },
                            "الغاء",
                            () async {
                              await editCategories(context);
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
