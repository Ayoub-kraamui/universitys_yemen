// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:university/view/screens/Collges_contents/University_Collges_Secreen.dart';
import 'package:university/view/screens/University_contents/editUniversity.dart';
import 'package:university/view/widgets/alertdilog.dart';

class UniversityItem extends StatefulWidget {
  final bool condition;

  UniversityItem({
    Key? key,
    this.condition = false,
  }) : super(key: key);

  @override
  State<UniversityItem> createState() => _UniversityItemState();
}

class _UniversityItemState extends State<UniversityItem> {
  void selectUniversity(BuildContext ctx, int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UniversityCollgesSecreen(
            universityid: data[index].id,
            universitytype: data[index]["type"])));
  }

  List<QueryDocumentSnapshot> data = [];
  bool isloding = true;
  bool isfavorite = false;
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("universitys")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    isloding = false;
    setState(() {});
  }

  getDataisfavorite() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("universitys")
        .where("isfavorite", isEqualTo: true)
        .get();
    data.addAll(querySnapshot.docs);
    isloding = false;
    setState(() {});
  }

  deleteData(int i) async {
    await FirebaseFirestore.instance
        .collection("universitys")
        .doc(data[i].id)
        .delete();
    if (data[i]["url"] != "none") {
      FirebaseStorage.instance.refFromURL(data[i]["url"]).delete();
    }
    isloding = false;
    setState(() {});
    Navigator.of(context).pushReplacementNamed("tabs_screen");
  }

  editFavorite(context, index) async {
    // Call the user's CollectionReference to add a new user
    CollectionReference collectionNote =
        FirebaseFirestore.instance.collection("universitys");
    try {
      setState(() {
        isfavorite = !isfavorite;
      });
      await collectionNote
          .doc(data[index].id)
          .update({"isfavorite": isfavorite});
    } catch (e) {
      setState(() {
        isfavorite = false;
      });
      print(" Erorr $e");
    }
  }

  @override
  void initState() {
    widget.condition ? getData() : getDataisfavorite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            childAspectRatio: 2.2 / 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => selectUniversity(context, index),
            onLongPress: () {
              testAlert(
                  context,
                  "رسالة",
                  "اختر احد العمليات التالية",
                  () async {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditUniversity(
                              docid: data[index].id,
                              oldname: data[index]["name"],
                              oldlocation: data[index]["location"],
                              oldtype: data[index]["type"],
                              oldurlimage: data[index]["url"],
                            )));
                  },
                  "تعديل",
                  () async {
                    deleteData(index);
                  },
                  "حذف");
            },
            splashColor: Colors.green[400],
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    child: Image.network(
                      data[index]["url"],
                      height: 400,
                      width: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 10,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(top: 8, right: 10),
                        width: 320,
                        height: 50,
                        color: Colors.black54,
                        child: Text(
                          "${data[index]["name"]}",
                          style: Theme.of(context).textTheme.headline5,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .color),
                                SizedBox(width: 6),
                                Text("${data[index]["location"]}",
                                    style:
                                        Theme.of(context).textTheme.headline5)
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_city_rounded,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .color),
                                SizedBox(width: 6),
                                Text("${data[index]["type"]}",
                                    style:
                                        Theme.of(context).textTheme.headline5)
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await editFavorite(context, index);
                                  },
                                  icon: const Icon(Icons.favorite),
                                  color: isfavorite ? Colors.red : Colors.white,
                                  iconSize: 40,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
