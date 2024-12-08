import 'package:flutter/material.dart';
import 'package:university/view/screens/tabs_screen.dart';
import 'package:university/view/screens/theme_screen.dart';
import '../screens/filters_screen.dart';

class mainDrawer extends StatefulWidget {
  @override
  State<mainDrawer> createState() => _mainDrawerState();
}

class _mainDrawerState extends State<mainDrawer> {
  Widget buildListTile(
      String title, IconData icon, Function() tapHandler, BuildContext ctx) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: Theme.of(ctx).splashColor,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: Theme.of(ctx).textTheme.bodyText1!.color,
            fontSize: 24,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Theme.of(context).colorScheme.secondary,
              alignment: Alignment.bottomRight,
              child: const Text(
                'إختر قائمة !',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildListTile('الجامعات', Icons.home, () {
              Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
            }, context),
            buildListTile('الاعدادات', Icons.settings, () {
              Navigator.of(context)
                  .pushReplacementNamed(FiltersScreen.routeName);
            }, context),
            buildListTile('الثيم', Icons.color_lens, () {
              Navigator.of(context)
                  .pushReplacementNamed(ThemesScreen.routeName);
            }, context),
          ],
        ),
      ),
    );
  }
}
