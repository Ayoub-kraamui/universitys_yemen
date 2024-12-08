import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:university/view/screens/Collges_contents/edit_collges.dart';
import 'package:university/view/screens/Dept_contents/college_dept_secreen.dart';
import 'package:university/view/widgets/alertdilog.dart';

class CollegeItems extends StatefulWidget {
  final String universityid;
  const CollegeItems({super.key, required this.universityid});

  @override
  State<CollegeItems> createState() => _CollegeItemsState();
}

class _CollegeItemsState extends State<CollegeItems> {
  void selectCollege(BuildContext context, index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DeptDetailScreen(
            universityid: data[index].id, collgeid: data[index].id)));
  }

  List<QueryDocumentSnapshot> data = [];

  bool isloding = true;
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("universitys")
        .doc(widget.universityid)
        .collection("collges")
        .get();
    data.addAll(querySnapshot.docs);
    isloding = false;
    setState(() {});
  }

  deleteDataCollges(int i) async {
    await FirebaseFirestore.instance
        .collection("universitys")
        .doc(widget.universityid)
        .collection("collges")
        .doc(data[i].id)
        .delete();
    isloding = false;
    setState(() {});
    Navigator.of(context).push(MaterialPageRoute(
        builder: (contect) => CollegeItems(universityid: widget.universityid)));
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
                        builder: (context) => EditCollegs(
                            collgedocid: data[index].id,
                            universitydocid: widget.universityid,
                            oldNamecollge: data[index]["name"],
                            oldContcollge: data[index]["contdept"],
                            oldUrlimageCollges: data[index]["url"])));
                  },
                  "تعديل",
                  () async {
                    deleteDataCollges(index);
                    //Navigator.of(context).pushReplacementNamed("tabs_screen");
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
                            child: Image.network(data[index]["url"],
                                height: 240,
                                width: double.infinity,
                                fit: BoxFit.cover)),
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                          child: Container(
                            height: listandscape ? dh * 0.58 : dh * 0.350,
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
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.format_list_numbered_rtl_sharp,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                            SizedBox(width: 6),
                            Text("${data[index]["name"]}",
                                style: Theme.of(context).textTheme.bodyText1)
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Icon(Icons.location_city_outlined,
                        //         color: Theme.of(context)
                        //             .textTheme
                        //             .bodyText1!
                        //             .color),
                        //     SizedBox(width: 6),
                        //     Text('$Cityname',
                        //         style: Theme.of(context).textTheme.bodyText1)
                        //   ],
                        // )
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
