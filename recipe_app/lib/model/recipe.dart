class Recipe {
  final int id;
  final String title, image, imageType;
  final int likes, missedIngredientCount, usedIngredientCount;
  final List<Ingredient> missedIngredients, usedIngredients;
  final List<Ingredient> unusedIngredients;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.imageType,
    required this.likes,
    required this.missedIngredientCount,
    required this.missedIngredients,
    required this.usedIngredientCount,
    required this.usedIngredients,
    required this.unusedIngredients,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    // Ingredient list for missed ingredients
    List<Ingredient> missedIngredientsList = (map['missedIngredients'] as List? ?? [])
        .map((ingredient) => Ingredient.fromMap(ingredient))
        .toList();

    // Ingredient list for used ingredients
    List<Ingredient> usedIngredientsList = (map['usedIngredients'] as List? ?? [])
        .map((ingredient) => Ingredient.fromMap(ingredient))
        .toList();

    // Ingredient list for unused ingredients
    List<Ingredient> unusedIngredientsList = (map['unusedIngredients'] as List? ?? [])
        .map((ingredient) => Ingredient.fromMap(ingredient))
        .toList();

    // Recipe object
    return Recipe(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      imageType: map['imageType'] ?? '',
      likes: map['likes'] ?? 0,
      missedIngredientCount: map['missedIngredientCount'] ?? 0,
      missedIngredients: missedIngredientsList,
      usedIngredientCount: map['usedIngredientCount'] ?? 0,
      usedIngredients: usedIngredientsList,
      unusedIngredients: unusedIngredientsList,
    );
  }
}

class Ingredient {
  final String aisle, extendedName, image, name, original, originalName, unit, unitLong, unitShort;
  final double amount;
  final List<String> meta;

  Ingredient({
    required this.aisle,
    required this.extendedName,
    required this.image,
    required this.name,
    required this.original,
    required this.originalName,
    required this.unit,
    required this.unitLong,
    required this.unitShort,
    required this.amount,
    required this.meta,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    // Ingredient object
    return Ingredient(
      aisle: map['aisle'] ?? '',
      extendedName: map['extendedName'] ?? '',
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      original: map['original'] ?? '',
      originalName: map['originalName'] ?? '',
      unit: map['unit'] ?? '',
      unitLong: map['unitLong'] ?? '',
      unitShort: map['unitShort'] ?? '',
      amount: map['amount'] ?? 0.0,
      meta: List<String>.from(map['meta'] as List? ?? []),
    );
  }
}
