import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dummy_data.dart';
import '../data/models/college.dart';
import '../data/models/dept.dart';

class CollegePovider with ChangeNotifier {
  Map<String, bool> filters = {
    'calculators': false,
    'eng_And_Archit': false,
    'med_And_Health_Sci': false,
    'law': false,
    'commerce': false,
    'literature': false,
  };
  List<College> availableCollege = DUMMY_COLLOGE;
  //List<College> favoriteCollege = [];
  List<Dept> favoriteDept = [];
  List<Dept> availableDept = DUMMY_DEPT;
  List<String> prefsCollegeId = [];

  void setfilters() async {
    availableCollege = DUMMY_COLLOGE.where((college) {
      if (filters['calculators']! && !college.Calculators) {
        return false;
      }
      if (filters['eng_And_Archit']! && !college.Engineering_And_Architecture) {
        return false;
      }
      if (filters['med_And_Health_Sci']! &&
          !college.Medicine_And_Health_Sciences) {
        return false;
      }
      if (filters['law']! && !college.Law) {
        return false;
      }
      if (filters['commerce']! && !college.Commerce) {
        return false;
      }
      if (filters['literature']! && !college.Literature) {
        return false;
      }
      return true;
    }).toList();

/*     List<University> ac = [];
    availableCollege.forEach((college) {
      college.universities.forEach((uniId) {
        DUMMY_UNIVRSITY.forEach((uni) {
          if (uni.id == uniId) {
            if (ac.any((uni) => uni.id == uniId)) ac.add(uni);
          }
        });
      });
    });
    availableUniversity = ac; */
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('calculators', filters['calculators']!);
    prefs.setBool('eng_And_Archit', filters['eng_And_Archit']!);
    prefs.setBool('med_And_Health_Sci', filters['med_And_Health_Sci']!);
    prefs.setBool('law', filters['law']!);
    prefs.setBool('commerce', filters['commerce']!);
    prefs.setBool('literature', filters['literature']!);
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    filters['calculators'] = prefs.getBool('calculators') ?? false;
    filters['eng_And_Archit'] = prefs.getBool('eng_And_Archit') ?? false;
    filters['med_And_Health_Sci'] =
        prefs.getBool('med_And_Health_Sci') ?? false;
    filters['law'] = prefs.getBool('law') ?? false;
    filters['commerce'] = prefs.getBool('commerce') ?? false;
    filters['literature'] = prefs.getBool('literature') ?? false;
    prefsCollegeId = prefs.getStringList('prefsCollegeId') ?? [];
    for (var collegeId in prefsCollegeId) {
      final existingIndex =
          favoriteDept.indexWhere((college) => college.id == collegeId);
      if (existingIndex < 0) {
        favoriteDept
            .add(DUMMY_DEPT.firstWhere((college) => college.id == collegeId));
      }
    }
/*     List<Dept> fm = [];
    favoriteDept.forEach((favCollege) {
      favoriteDept.forEach((avCollege) {
        if (favCollege.id == avCollege.id) fm.add(favCollege);
      });
    });
    favoriteDept = fm; */
    notifyListeners();
  }

  void toggleFavorite(String collegeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final existingIndex =
        favoriteDept.indexWhere((college) => college.id == collegeId);
    if (existingIndex >= 0) {
      favoriteDept.removeAt(existingIndex);
      prefsCollegeId.remove(collegeId);
    } else {
      favoriteDept
          .add(DUMMY_DEPT.firstWhere((college) => college.id == collegeId));
      prefsCollegeId.add(collegeId);
    }

    notifyListeners();
    prefs.setStringList('prefsId', prefsCollegeId);
  }

  bool isFavorite(String collegeId) {
    return favoriteDept.any((college) => college.id == collegeId);
  }
}
