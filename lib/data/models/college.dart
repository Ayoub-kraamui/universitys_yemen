enum CountDept {
  One,
  Tow,
  Three,
  Four,
  Five,
  Six,
  Seven,
}

enum CityName {
  one,
  Ibb,
  Three,
  Four,
  Five,
  Six,
  Seven,
}

class College {
  final String id;
  final List<String> universities;
  final String title;
  final String imageAssets;
  final CountDept countDept;
  final CityName cityName;
  final bool Calculators;
  final bool Engineering_And_Architecture;
  final bool Medicine_And_Health_Sciences;
  final bool Law;
  final bool Commerce;
  final bool Literature;

  College({
    required this.id,
    required this.universities,
    required this.title,
    required this.imageAssets,
    required this.countDept,
    required this.cityName,
    required this.Calculators,
    required this.Engineering_And_Architecture,
    required this.Medicine_And_Health_Sciences,
    required this.Law,
    required this.Commerce,
    required this.Literature,
  });
}
