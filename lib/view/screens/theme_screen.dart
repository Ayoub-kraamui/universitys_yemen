import 'package:flutter/material.dart';
import 'package:university/controller/theme_provider.dart';
import 'package:university/view/widgets/maindrawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ThemesScreen extends StatelessWidget {
  static const routeName = '/themes';
  final bool fromOnBoarding;
  ThemesScreen({this.fromOnBoarding = false});
  Widget buildRadioisTile(
      ThemeMode themeVal, String txt, IconData? icon, BuildContext ctx) {
    return RadioListTile(
      secondary: Icon(icon, color: Theme.of(ctx).splashColor),
      value: themeVal,
      groupValue: Provider.of<ThemeProvider>(ctx, listen: true).tm,
      onChanged: (newThemeVal) => Provider.of<ThemeProvider>(ctx, listen: false)
          .themeModeChange(newThemeVal),
      title: Text(txt),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: fromOnBoarding
            ? null
            : AppBar(
                title: Text('الثيم الخاص بالتطبيق',
                    style: Theme.of(context).textTheme.headline5),
              ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Text('ضبط الثيم الخاص بالتطبيق',
                  style: Theme.of(context).textTheme.headline6),
            ),
            Expanded(
                child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text('اختر نوع الثيم',
                      style: Theme.of(context).textTheme.headline6),
                ),
                buildRadioisTile(
                    ThemeMode.system, 'الثيم الافتراضي', null, context),
                buildRadioisTile(ThemeMode.light, 'الوضع النهاري',
                    Icons.wb_sunny_outlined, context),
                buildRadioisTile(ThemeMode.dark, 'الوضع الليلي',
                    Icons.nights_stay_outlined, context),
                buildListTile(context, 'primary'),
                buildListTile(context, 'accent'),
                SizedBox(height: fromOnBoarding ? 80 : 0),
              ],
            ))
          ],
        ),
        drawer: fromOnBoarding ? null : mainDrawer(),
      ),
    );
  }

  ListTile buildListTile(BuildContext context, txt) {
    var primaryColor =
        Provider.of<ThemeProvider>(context, listen: true).primaryColor;
    var accentColor =
        Provider.of<ThemeProvider>(context, listen: true).accentColor;
    return ListTile(
      title: Text(' الخاص بالتطبيق $txt اختر اللون',
          style: Theme.of(context).textTheme.headline6),
      trailing: CircleAvatar(
        backgroundColor: txt == 'primary' ? primaryColor : accentColor,
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                elevation: 4,
                titlePadding: const EdgeInsets.all(0.0),
                contentPadding: const EdgeInsets.all(0.0),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: txt == 'primary'
                        ? Provider.of<ThemeProvider>(ctx, listen: true)
                            .primaryColor
                        : Provider.of<ThemeProvider>(ctx, listen: true)
                            .accentColor,
                    onColorChanged: (newColor) =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .onChanged(newColor, txt == 'primary' ? 1 : 2),
                    colorPickerWidth: 300.0,
                    pickerAreaHeightPercent: 0.7,
                    enableAlpha: false,
                    displayThumbColor: true,
                    showLabel: false,
                  ),
                ),
              );
            });
      },
    );
  }
}
