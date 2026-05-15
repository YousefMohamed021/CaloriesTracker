class FoodItemModel {
  final String barcode;
  final String name;
  final double baseCalories;
  final double baseProtein;
  final double baseCarbs;
  final double baseFat;

  FoodItemModel({
    required this.barcode,
    required this.name,
    required this.baseCalories,
    required this.baseProtein,
    required this.baseCarbs,
    required this.baseFat,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json, String barcode) {
    var nutriments = json['nutriments'] ?? {};
    return FoodItemModel(
      barcode: barcode,
      name: json['product_name'] ?? 'Unknown Food',
      baseCalories: (nutriments['energy-kcal_100g'] ?? 0).toDouble(),
      baseProtein: (nutriments['proteins_100g'] ?? 0).toDouble(),
      baseCarbs: (nutriments['carbohydrates_100g'] ?? 0).toDouble(),
      baseFat: (nutriments['fat_100g'] ?? 0).toDouble(),
    );
  }

  factory FoodItemModel.fromFirestore(Map<String, dynamic> map) {
    return FoodItemModel(
      barcode: map['barcode'] ?? '',
      name: map['name'] ?? 'Unknown Food',
      baseCalories: (map['baseCalories'] ?? 0).toDouble(),
      baseProtein: (map['baseProtein'] ?? 0).toDouble(),
      baseCarbs: (map['baseCarbs'] ?? 0).toDouble(),
      baseFat: (map['baseFat'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'barcode': barcode,
      'baseCalories': baseCalories,
      'baseProtein': baseProtein,
      'baseCarbs': baseCarbs,
      'baseFat': baseFat,
    };
  }
}
