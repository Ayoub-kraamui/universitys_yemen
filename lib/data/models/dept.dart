enum Time {
  One,
  Tow,
  Three,
  Four,
  Five,
  Six,
  Seven,
  Eight,
  Nine,
  Ten,
}

enum Rate {
  Fifty_five,
  Sixty,
  Sixty_five,
  Seventy,
  Seventy_five,
  Eighty,
}

class Dept {
  final String id;
  final String title;
  final String imageAssets;
  final List<String> college;
  final Time time;
  final Rate rate;
  final double price;
  final List<String> jobschances;
  final List<String> characteristic;

  Dept({
    required this.id,
    required this.title,
    required this.imageAssets,
    required this.college,
    required this.time,
    required this.rate,
    required this.price,
    required this.jobschances,
    required this.characteristic,
  });
}
