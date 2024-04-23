import 'package:flutter/material.dart';
import 'dart:math';
import 'package:recipe_app/model/recipe.dart';
import 'package:recipe_app/screens/RecipeDetailsPage.dart';
import 'package:recipe_app/services/apiServices.dart';

class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final TextEditingController controller = TextEditingController();
  final List<String> inputTags = [];
  String response = '';
  bool isLoading = false;
  List<Recipe> selectedRecipes = [];
  bool isGenerateRecipeButtonEnabled = false;

  void _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus(); // Dismiss the keyboard
  }

  String capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : '';

  Future<void> _createRecipe() async {
    try {
      // Set isLoading to true when starting to fetch recipes
      setState(() {
        isLoading = true;
      });

      List<Recipe> recipes = await APIService.instance.findRecipesByIngredients(
        ingredients: inputTags,
        number: 5,
        limitLicense: true,
        ranking: 1,
        ignorePantry: true,
      );

      setState(() {
        isLoading = false;
        selectedRecipes = recipes;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        response = 'Error: $error';
      });
    }
  }

  void _addIngredient(String ingredient) {
    setState(() {
      inputTags.add(ingredient);
      isGenerateRecipeButtonEnabled = true; // Enable button when at least one ingredient is added
    });
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      inputTags.remove(ingredient);
      isGenerateRecipeButtonEnabled = inputTags.isNotEmpty; // Disable button if no ingredients are left
    });
  }

  Widget _buildRecipeCard(BuildContext context, Recipe recipe) {
  return GestureDetector(
    onTap: () {
      _dismissKeyboard(context);
      _navigateToRecipeDetailsPage(context, recipe.id);
    },
    child: Container(
      margin: EdgeInsets.only(right: 16),
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              recipe.image,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Ingredients:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipe.usedIngredients.map((ingredient) {
                    return Text('- ${capitalize(ingredient.name)}');
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void _navigateToRecipeDetailsPage(BuildContext context, int recipeId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RecipeDetailsPage(recipeId: recipeId),
    ),
  );
}


  Widget _buildRecipeList() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: selectedRecipes.map((recipe) {
        return _buildRecipeCard(context, recipe); // Pass context to _buildRecipeCard
      }).toList(),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find the best recipe for cooking!',
              maxLines: 3,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    autocorrect: true,
                    autofocus: true,
                    controller: controller,
                    onSubmitted: (value) {
                      final inputValue = value.trim();
                      if (inputValue.isNotEmpty) {
                        controller.clear();
                        _addIngredient(inputValue);
                      }
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      labelText: "Enter the ingredients...",
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      final inputValue = controller.text.trim();
                      if (inputValue.isNotEmpty) {
                        controller.clear();
                        _addIngredient(inputValue);
                      }
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                for (int i = 0; i < inputTags.length; i++)
                  Chip(
                    backgroundColor:
                        Color((Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onDeleted: () {
                      _dismissKeyboard(context);
                      _removeIngredient(inputTags[i]);
                    },
                    label: Text(inputTags[i]),
                    deleteIcon: Icon(
                      Icons.close,
                      size: 20,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            _buildRecipeList(),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () async {
                  _dismissKeyboard(context);
                  await _createRecipe();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.auto_awesome),
                      SizedBox(width: 8),
                      Text("Create Recipe"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
