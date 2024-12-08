import 'package:flutter/material.dart';
import 'package:university/controller/college_provider.dart';
import 'package:university/controller/theme_provider.dart';
import 'package:university/view/widgets/maindrawer.dart';
import 'package:provider/provider.dart';

class FiltersScreen extends StatelessWidget {
  static const routeName = '/filters';
  final bool fromOnBoarding;
  FiltersScreen({this.fromOnBoarding = false});

  Widget buildSwitchisTitle(String title, String description, bool currentValue,
      Function(bool) updatevlaue, BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(description),
      value: currentValue,
      onChanged: updatevlaue,
      inactiveTrackColor:
          Provider.of<ThemeProvider>(context, listen: true).tm ==
                  ThemeMode.light
              ? null
              : Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, bool> currentFilters =
        Provider.of<CollegePovider>(context, listen: true).filters;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: fromOnBoarding
            ? null
            : AppBar(
                title: Text('عوامل التصفية الخاصة بك',
                    style: Theme.of(context).textTheme.headline5),
              ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Text('ضبط اختيارات الجامعات الخاصة بك',
                  style: Theme.of(context).textTheme.headline6),
            ),
            Expanded(
                child: ListView(
              children: [
                buildSwitchisTitle(
                    'كلية الحاسبات',
                    'الجامعات التي تحتوي على كلية الحاسبات',
                    currentFilters['calculators']!, (newValue) {
                  currentFilters['calculators'] = newValue;

                  Provider.of<CollegePovider>(context, listen: false)
                      .setfilters();
                }, context),
                buildSwitchisTitle(
                    'الهندسة والعمارة',
                    'الجامعات التي تحتوي على كلية الهندسة والعمارة',
                    currentFilters['eng_And_Archit']!, (newValue) {
                  currentFilters['eng_And_Archit'] = newValue;

                  Provider.of<CollegePovider>(context, listen: false)
                      .setfilters();
                }, context),
                buildSwitchisTitle(
                    'طب وعلوم صحية',
                    'الجامعات التي تحتوي على كلية الطب والعلوم الصحية',
                    currentFilters['med_And_Health_Sci']!, (newValue) {
                  currentFilters['med_And_Health_Sci'] = newValue;

                  Provider.of<CollegePovider>(context, listen: false)
                      .setfilters();
                }, context),
                buildSwitchisTitle(
                    'القانون',
                    'الجامعات التي تحتوي على كلية القانون',
                    currentFilters['law']!, (newValue) {
                  currentFilters['law'] = newValue;

                  Provider.of<CollegePovider>(context, listen: false)
                      .setfilters();
                }, context),
                buildSwitchisTitle(
                    'التجارة',
                    'الجامعات التي تحتوي على كلية التجارة',
                    currentFilters['commerce']!, (newValue) {
                  currentFilters['commerce'] = newValue;

                  Provider.of<CollegePovider>(context, listen: false)
                      .setfilters();
                }, context),
                buildSwitchisTitle(
                    'الآداب',
                    'الجامعات التي تحتوي على كلية الآداب',
                    currentFilters['literature']!, (newValue) {
                  currentFilters['literature'] = newValue;

                  Provider.of<CollegePovider>(context, listen: false)
                      .setfilters();
                }, context)
              ],
            ))
          ],
        ),
        drawer: fromOnBoarding ? null : mainDrawer(),
      ),
    );
  }
}
