class Cat {
  String name;
  DateTime birthday;
  String breed;
  String color;
  String sex;
  List<String> vaccines;
  List<String> characteristics;
  String background;
  String pictureUrl;

  Cat({
    required this.name,
    required this.birthday,
    required this.breed,
    required this.color,
    required this.sex,
    this.vaccines = const [],
    required this.characteristics,
    required this.background,
    required this.pictureUrl,
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      age--;
    }
    return age;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthday': birthday.toIso8601String(),
      'age': age,
      'breed': breed,
      'color': color,
      'vaccines': vaccines,
      'characteristics': characteristics,
      'background': background,
      'pictureUrl': pictureUrl,
    };
  }

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      name: json['name'],
      birthday: DateTime.parse(json['birthday']),
      breed: json['breed'],
      color: json['color'],
      sex: json['sex'],
      vaccines: List<String>.from(json['vaccines'] ?? []),
      characteristics: List<String>.from(json['characteristics'] ?? []),
      background: json['background'],
      pictureUrl: json['pictureUrl'],
    );
  }
}
