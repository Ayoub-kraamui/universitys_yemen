import 'package:flutter/material.dart';
import 'package:university/view/screens/University_contents/addUniversity.dart';

import 'package:university/view/widgets/university_item.dart';

class UniversitySecreen extends StatelessWidget {
  static const routeName = 'Category_University';
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: UniversityItem(
          condition: false,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Adduniversity()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
