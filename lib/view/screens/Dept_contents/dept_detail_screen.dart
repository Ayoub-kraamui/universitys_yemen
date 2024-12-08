import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CollegeDetailScreen extends StatefulWidget {
  final String deptdocid;
  final String universitydocid;
  final String collgedocid;
  //final String name;
  //  final int times;
  //  final String rate;
  //  final String price;
  //  final String jobschances;
  //  final String characteristic;
  //  final String UrlimageDepts;
  const CollegeDetailScreen({
    super.key,
    required this.deptdocid,
    required this.universitydocid,
    required this.collgedocid,
    //required this.name,
  });
  //  required this.times,
  //  required this.rate,
  //  required this.price,
  //  required this.jobschances,
  //  required this.characteristic,
  //  required this.UrlimageDepts});
  @override
  State<CollegeDetailScreen> createState() => _CollegeDetailScreenState();
}

class _CollegeDetailScreenState extends State<CollegeDetailScreen> {
  Widget bulidSectionTitle(String text, BuildContext context) {
    return Container(
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget bulidContainer(Widget child) {
    bool listandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var dw = MediaQuery.of(context).size.width;
    var dh = MediaQuery.of(context).size.height;
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        //height: 170,
        //width: 370,
        height: listandscape ? dh * 0.5 : dh * 0.25,
        width: listandscape ? (dw * 0.5 - 30) : dw,
        child: child);
  }

  List<DocumentSnapshot> data = [];
  List jobschances = [];
  List characteristic = [];
  bool isloding = true;
  bool isfavorite = false;
  String deptId = '';
  getData() async {
    var depts = await FirebaseFirestore.instance
        .collection("universitys")
        .doc(widget.universitydocid)
        .collection("collges")
        .doc(widget.collgedocid)
        .collection("depts")
        .doc(widget.deptdocid)
        .get();

    jobschances = depts["jobschances"];
    characteristic = depts["characteristic"];
    data.add(depts);
    isloding = false;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool listandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    var accentColor = Theme.of(context).colorScheme.secondary;
    var liSteps = ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (ctx, index) => Card(
        color: accentColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
          child: jobschances.length < index
              ? Text("")
              : Text(
                  "${jobschances[index]}",
                  style: TextStyle(color: Colors.black),
                ),
        ),
      ),
      itemCount: jobschances.length, //selectedDept["jobschances"].length,
    );
    var liIngredient = ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (ctx, index) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text(
                '#${index + 1}',
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            title: characteristic.length <= index
                ? Text("")
                : Text(
                    "${characteristic[index]}",
                    style: TextStyle(color: Colors.black),
                  ),
          ),
          Divider(),
        ],
      ),
      itemCount: characteristic.length,
    );
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: isloding
            ? Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(data[0]["name"],
                          style: Theme.of(context).textTheme.headline5),
                      background: Container(
                        height: 300,
                        width: double.infinity,
                        child: Hero(
                          tag: data[0].id,
                          child: Image.network(
                            data[0]["url"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    if (listandscape)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              bulidSectionTitle('فرص العمل', context),
                              bulidContainer(liSteps),
                            ],
                          ),
                          Column(
                            children: [
                              bulidSectionTitle(
                                  'مميزات التخصص في هذة الجامعة', context),
                              bulidContainer(liIngredient),
                            ],
                          ),
                        ],
                      ),
                    if (!listandscape) bulidSectionTitle('فرص العمل', context),
                    if (!listandscape) bulidContainer(liSteps),
                    if (!listandscape)
                      bulidSectionTitle(
                          'مميزات التخصص في هذة الجامعة', context),
                    if (!listandscape) bulidContainer(liIngredient),
                  ]))
                ],
              ),
      ),
    );
  }
}
