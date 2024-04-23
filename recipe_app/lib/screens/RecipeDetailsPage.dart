import 'package:flutter/material.dart';
import 'package:recipe_app/services/apiServices.dart';

class RecipeDetailsPage extends StatelessWidget {
  final int recipeId;

  RecipeDetailsPage({required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: APIService.instance.getRecipeInformationById(recipeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('No data available'),
            );
          } else {
            Map<String, dynamic> recipeInfo = snapshot.data!;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      recipeInfo['image'] ?? '',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Recipe Title
                  Text(
                    recipeInfo['title'] ?? '',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Ingredients Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ingredients:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        for (var ingredient in recipeInfo['extendedIngredients'])
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              '- ${ingredient['original'] ?? ''}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Instructions Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Instructions:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        for (var instruction in recipeInfo['analyzedInstructions'][0]['steps'])
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                '${instruction['number'] ?? ''}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              instruction['step'] ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Additional Information
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Additional Information:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Display additional information based on available data
                        // Customize based on your needs
                        buildAdditionalInfoTile('Vegetarian', recipeInfo['vegetarian']),
                        buildAdditionalInfoTile('Vegan', recipeInfo['vegan']),
                        buildAdditionalInfoTile('Gluten-Free', recipeInfo['glutenFree']),
                        buildAdditionalInfoTile('Dairy-Free', recipeInfo['dairyFree']),
                        buildAdditionalInfoTile('Very Healthy', recipeInfo['veryHealthy']),
                        buildAdditionalInfoTile('Cheap', recipeInfo['cheap']),
                        buildAdditionalInfoTile('Very Popular', recipeInfo['veryPopular']),
                        buildAdditionalInfoTile('Sustainable', recipeInfo['sustainable']),
                        buildAdditionalInfoTile('Low FODMAP', recipeInfo['lowFodmap']),
                        // Add more information tiles based on the available data
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildAdditionalInfoTile(String title, bool? value) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        value == true ? Icons.check_circle : Icons.cancel,
        color: value == true ? Colors.green : Colors.red,
      ),
    );
  }
}
