import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:university/view/widgets/alertdilog.dart';
import 'package:university/view/widgets/coustombuttom.dart';
import 'package:university/view/widgets/customTextFormFieldAdd.dart';

class Adduniversity extends StatefulWidget {
  @override
  State<Adduniversity> createState() => _AdduniversityState();
}

class _AdduniversityState extends State<Adduniversity> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  List<String> locations = ['صنعاء', 'إب', 'تعز', 'عدن', 'ذمار']; // Option 2
  String? selectedLocation;
  List<String> types = ['اهلي', 'حكومي']; // Option 2
  String? selectedType;
  File? file;
  String? urlimageUniversity;
  bool isSelected = false;
  bool isFavorite = false;

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
      var refStorge = FirebaseStorage.instance.ref("universitys/$imagename");
      await refStorge.putFile(file!);
      urlimageUniversity = await refStorge.getDownloadURL();
      isSelected = true;
      setState(() {});
    }
    setState(() {});
  }

  bool isloding = false;

  addUniversity(context) async {
    // Call the user's CollectionReference to add a new user
    CollectionReference universitys =
        FirebaseFirestore.instance.collection("universitys");
    try {
      isloding = true;
      setState(() {});
      if (formstate.currentState!.validate()) {
        DocumentReference respons = await universitys.add({
          "name": name.text,
          "location": selectedLocation,
          "type": selectedType,
          "url": urlimageUniversity ?? "none",
          "isfavorite": isFavorite,
          "id": FirebaseAuth.instance.currentUser!.uid
        });
        Navigator.of(context).pushReplacementNamed("tabs_screen");
      }
    } catch (e) {
      isloding = false;
      setState(() {});
      print(" Erorr $e");
    }
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
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
                                ? "اختر موقع الجامعة"
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
    // Option 2
    return Scaffold(
      appBar: AppBar(title: Text("إضافة جامعة")),
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
                          hinttext: "ادخل اسم الجامعة",
                          labeltext: "اسم الجامعة",
                          mycontroller: name,
                          validator: (val) {
                            if (val == "") {
                              return "لا يمكن ان يكون الحقل فارغ";
                            }
                            return null;
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
                              addUniversity(context);
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
