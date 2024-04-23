import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:recipe_app/model/recipe.dart';

class APIService {
  APIService._instantiate();
  static final APIService instance = APIService._instantiate();

  final String _baseURL = "api.spoonacular.com";
  static const String API_KEY = "";

  Future<Map<String, dynamic>> getRecipeInformationById(int recipeId, {bool includeNutrition = false}) async {
  // Set default values if parameters are not provided
  includeNutrition ??= false;

  // Create parameters for the request
  Map<String, String> parameters = {
    'includeNutrition': includeNutrition.toString(),
    'apiKey': API_KEY,
  };

  // Create the Uri for the request
  Uri uri = Uri.https(
    _baseURL,
    '/recipes/$recipeId/information',
    parameters,
  );

  // Specify headers
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  try {
    // Make the GET request
    var response = await http.get(uri, headers: headers);

    // Check if the response is successful (status code 200)
    if (response.statusCode == 200) {
      // Decode the body of the response into a map
      Map<String, dynamic> data = json.decode(response.body);

      return data;
    } else {
      // Handle non-successful response
      throw "Failed to get recipe information. Status code: ${response.statusCode}";
    }
  } catch (error) {
    // Handle errors
    throw "Error getting recipe information: $error";
  }
}


  Future<List<Recipe>> findRecipesByIngredients({
    required List<String> ingredients,
    required int number,
    required bool limitLicense,
    required int ranking,
    required bool ignorePantry,
  }) async {
    // Join the list of ingredients into a comma-separated string
    String ingredientsString = ingredients.join(',');

    // Set default values if parameters are not provided
    number ??= 1;
    limitLicense ??= true;
    ranking ??= 1;
    ignorePantry ??= true;

    // Create parameters for the request
    Map<String, String> parameters = {
      'ingredients': ingredientsString,
      'number': number.toString(),
      'limitLicense': limitLicense.toString(),
      'ranking': ranking.toString(),
      'ignorePantry': ignorePantry.toString(),
      'apiKey': API_KEY,
    };

    // Create the Uri for the request
    Uri uri = Uri.https(
      _baseURL,
      '/recipes/findByIngredients',
      parameters,
    );

    // Specify headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      // Make the GET request
      var response = await http.get(uri, headers: headers);
      
      // Decode the body of the response into a list of maps
      List<dynamic> data = json.decode(response.body);

      // Convert the list of maps into a list of Recipe objects
      List<Recipe> recipes = data.map((recipeData) => Recipe.fromMap(recipeData)).toList();

      return recipes;
    } catch (err) {
      // Handle errors
      throw err.toString();
    }
  }

  Future<Map<String, dynamic>> getChatBotResponse(String text, {String? contextId}) async {
    // Set default values if parameters are not provided
    contextId ??= "";

    // Create parameters for the request
    Map<String, String> parameters = {
      'text': text,
      'contextId': contextId,
      'apiKey': API_KEY,
    };

    // Create the Uri for the request
    Uri uri = Uri.https(
      _baseURL,
      '/food/converse',
      parameters,
    );

    // Specify headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      // Make the GET request
      var response = await http.get(uri, headers: headers);

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the body of the response into a map
        Map<String, dynamic> data = json.decode(response.body);

        return data;
      } else {
        // Handle non-successful response
        throw "Failed to get chatbot response. Status code: ${response.statusCode}";
      }
    } catch (error) {
      // Handle errors
      throw "Error getting chatbot response: $error";
    }
  }
}
