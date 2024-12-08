import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:university/controller/college_provider.dart';
import 'package:university/controller/theme_provider.dart';
import 'package:university/view/screens/University_contents/University-secreen.dart';

import 'package:provider/provider.dart';
import '../screens/favorit_screen.dart';
import '../widgets/maindrawer.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = 'tabs_screen';
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages = [];
  @override
  void initState() {
    Provider.of<CollegePovider>(context, listen: false).getData();
    Provider.of<ThemeProvider>(context, listen: false).getThemeMode();
    Provider.of<ThemeProvider>(context, listen: false).getThemeColors();
    _pages = [
      {
        'page': UniversitySecreen(),
        'title': 'الجامعات اليمنية',
      },
      {
        'page': FavoritScreen(),
        'title': 'تخصصاتك المفضلة',
      },
    ];
    super.initState();
  }

  int _selectPageIndex = 0;
  void _selectPage(int value) {
    setState(() {
      _selectPageIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _pages[_selectPageIndex]['title'].toString(),
            style: Theme.of(context).textTheme.headline5,
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("login", (route) => false);
                },
                icon: Icon(Icons.exit_to_app)),
          ],
        ),
        body: _pages[_selectPageIndex]['page'] as Widget,
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'جامعاتك',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'مفضلاتك',
            )
          ],
        ),
        drawer: mainDrawer(),
      ),
    );
  }
}
