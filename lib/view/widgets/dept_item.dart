import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:university/view/screens/Dept_contents/editDept.dart';
import 'package:university/view/widgets/alertdilog.dart';

class DeptItem extends StatefulWidget {
  final String collgeid;
  DeptItem({super.key, required this.collgeid});

  @override
  State<DeptItem> createState() => _DeptItemState();
}

class _DeptItemState extends State<DeptItem> {
  void selectCollege(BuildContext context, index) {
    // Navigator.of(context)
    //     .pushNamed(
    //   CollegeDetailScreen.routeName,
    //   arguments: data[index].id,
    // )
    //     .then((result) {
    //   // if (result != null) removeItem(result);
    // });
  }

  List<QueryDocumentSnapshot> data = [];

  bool isloding = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("collges")
        .doc(widget.collgeid)
        .collection("depts")
        .get();
    data.addAll(querySnapshot.docs);
    isloding = false;
    setState(() {});
  }

  deleteDataCollges(int i) async {
    await FirebaseFirestore.instance
        .collection("collges")
        .doc(widget.collgeid)
        .collection("depts")
        .doc(data[i].id)
        .delete();
    isloding = false;
    setState(() {});
    Navigator.of(context).push(MaterialPageRoute(
        builder: (contect) => DeptItem(collgeid: widget.collgeid)));
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
    return GridView.builder(
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: dw <= 400 ? 400 : 500,
            childAspectRatio: listandscape ? dw / (dw * 0.8) : dw / (dw * 0.75),
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => selectCollege(context, index),
            onLongPress: () {
              testAlert(
                  context,
                  "رسالة",
                  "اختر احد العمليات التالية",
                  () async {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditDept(
                              deptdocid: "deptdocid",
                              collgedocid: "collgedocid",
                              universitydocid: "universitydocid",
                              oldtimes: 4,
                              oldname: "oldname",
                              oldrate: "oldrate",
                              oldprice: "oldprice",
                              oldjobschances: ["oldjobschances"],
                              oldcharacteristic: ["oldcharacteristic"],
                              oldUrlimageDepts: "url",
                            )));
                  },
                  "تعديل",
                  () async {
                    //deleteDataCollegs(index);
                    Navigator.of(context).pushReplacementNamed("tabs_screen");
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
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
                            height: listandscape ? dh * 0.58 : dh * 0.276,
                            width: listandscape ? (dw * 0.5 * 30) : dw,
                            color: Colors.black26,
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "${data[index]["name"]}",
                                  style: Theme.of(context).textTheme.headline3,
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
                    padding: const EdgeInsets.only(top: 15.0),
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
                            Text("${data[index]["itemnumber"]}",
                                style: Theme.of(context).textTheme.bodyText1)
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
                            Text("${data[index]["ratenumber"]}",
                                style: Theme.of(context).textTheme.bodyText1)
                          ],
                        ),
                        Row(
                          children: [
                            Text("${data[index]["price"]}",
                                style: Theme.of(context).textTheme.bodyText1),
                            SizedBox(width: 6),
                            Icon(
                              Icons.attach_money,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
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
        });
  }
}
