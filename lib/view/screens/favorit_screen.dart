import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:university/view/screens/Dept_contents/dept_detail_screen.dart';

class FavoritScreen extends StatefulWidget {
  final String? universityid;
  final String? collgeid;
  const FavoritScreen({super.key, this.universityid, this.collgeid});
  @override
  State<FavoritScreen> createState() => _FavoritScreenState();
}

class _FavoritScreenState extends State<FavoritScreen> {
  @override
  void selectDept(BuildContext context, index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CollegeDetailScreen(
              deptdocid: data[index].id,
              collgedocid: widget.collgeid!,
              universitydocid: widget.universityid!,
              //name: data[index]["name"],
              // times: data[index]["time"],
              // rate: data[index]["rate"],
              // price: data[index]["price"],
              // jobschances: data[index]["jobschances"],
              // characteristic: data[index]["characteristic"],
              // UrlimageDepts: data[index]["url"],
            )));
  }

  List<QueryDocumentSnapshot> data = [];
  bool isloding = true;
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("depts")
        .where("isfavorite", isEqualTo: true)
        .get();
    data.addAll(querySnapshot.docs);
    isloding = false;
    setState(() {});
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
    if (data.isEmpty) {
      return Center(
        child: Text('لايوجد أي تخصص مفضل لديك'),
      );
    } else {
      return GridView.builder(
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
                                    style:
                                        Theme.of(context).textTheme.headline3,
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
                              Text("${data[index]["rate"]}",
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
          });
    }
  }
}
