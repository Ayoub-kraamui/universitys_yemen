import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:university/view/screens/Dept_contents/addDept.dart';
import 'package:university/view/screens/Dept_contents/dept_detail_screen.dart';
import 'package:university/view/screens/Dept_contents/editDept.dart';
import 'package:university/view/widgets/alertdilog.dart';

class DeptDetailScreen extends StatefulWidget {
  final String universityid;
  final String collgeid;
  final String? universitytype;

  const DeptDetailScreen(
      {super.key,
      required this.universityid,
      required this.collgeid,
      this.universitytype});
  @override
  State<DeptDetailScreen> createState() => _DeptDetailScreenState();
}

class _DeptDetailScreenState extends State<DeptDetailScreen> {
  void selectDept(BuildContext context, index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CollegeDetailScreen(
              deptdocid: data[index].id,
              collgedocid: widget.collgeid,
              universitydocid: widget.universityid,
              //name: data[index]["name"],
              // times: data[index]["time"],
              // rate: data[index]["rate"],
              // price: data[index]["price"],
              // jobschances: data[index]["jobschances"],
              // characteristic: data[index]["characteristic"],
              // UrlimageDepts: data[index]["url"],
            )));
  }
  // void selectDept(BuildContext context, index) {
  //   Navigator.of(context).pushNamed(
  //     CollegeDetailScreen.routeName,
  //     arguments: data[index].id,
  //   );
  // }

  List<QueryDocumentSnapshot> data = [];
  List jobschances = [];
  List characteristic = [];
  bool isloding = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("universitys")
        .doc(widget.universityid)
        .collection("collges")
        .doc(widget.collgeid)
        .collection("depts")
        .get();

    data.addAll(querySnapshot.docs);
    isloding = false;
    setState(() {});
  }

  deleteDataDepts(index) async {
    await FirebaseFirestore.instance
        .collection("universitys")
        .doc(widget.universityid)
        .collection("collges")
        .doc(widget.collgeid)
        .collection("depts")
        .doc(data[index].id);
    if (data[index]["url"] != "none") {
      FirebaseStorage.instance.refFromURL(data[index]["url"]).delete();
    }
    isloding = false;
    setState(() {});
    Navigator.of(context).push(MaterialPageRoute(
        builder: (contect) => DeptDetailScreen(
            universityid: widget.universityid, collgeid: widget.collgeid)));
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool listandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var dw = MediaQuery.of(context).size.width;
    var dh = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("التخصصات", style: Theme.of(context).textTheme.headline5),
        ),
        body: isloding
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: dw <= 400 ? 400 : 500,
                    childAspectRatio:
                        listandscape ? dw / (dw * 0.8) : dw / (dw * 0.75),
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => selectDept(context, index),
                    onLongPress: () {
                      testAlert(
                          context,
                          "رسالة",
                          "اختر احد العمليات التالية",
                          () async {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditDept(
                                      deptdocid: data[index].id,
                                      collgedocid: widget.collgeid,
                                      universitydocid: widget.universityid,
                                      oldname: data[index]["name"],
                                      oldtimes: data[index]["time"],
                                      oldrate: data[index]["rate"],
                                      oldprice: data[index]["price"],
                                      oldjobschances: data[index]
                                          ["jobschances"],
                                      oldcharacteristic: data[index]
                                          ["characteristic"],
                                      oldUrlimageDepts: data[index]["url"],
                                    )));
                          },
                          "تعديل",
                          () async {
                            deleteDataDepts(index);
                          },
                          "حذف");
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: Hero(
                                      tag: data[index].id,
                                      child: Image.network(data[index]["url"],
                                          height: 240,
                                          width: double.infinity,
                                          fit: BoxFit.cover),
                                    )),
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  child: Container(
                                    height:
                                        listandscape ? dh * 0.58 : dh * 0.350,
                                    width: listandscape ? (dw * 0.5 * 30) : dw,
                                    color: Colors.black26,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${data[index]["name"]}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.schedule,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color),
                                    SizedBox(width: 6),
                                    Text("${data[index]["time"]}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.percent_outlined,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color),
                                    SizedBox(width: 6),
                                    Text("${data[index]["rate"]}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("${data[index]["price"]}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.attach_money,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddDept(
                    docUnid: widget.universityid,
                    docCoid: widget.collgeid,
                    universitytype: widget.universitytype)));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
