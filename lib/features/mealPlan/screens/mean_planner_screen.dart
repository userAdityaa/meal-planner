import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_meal_planner/features/auth/controllers/auth_controller.dart';
import 'package:flutter_meal_planner/features/recipeInfo/screens/recipe_info_screen.dart';

import 'package:flutter_meal_planner/models/meal_model.dart';
import 'package:flutter_meal_planner/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
import 'package:routemaster/routemaster.dart';

class MealPlannerScreen extends ConsumerStatefulWidget {
  const MealPlannerScreen({super.key});

  @override
  _MealPlannerScreenState createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends ConsumerState<MealPlannerScreen> {
  final searchTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String _whichOne = "";

  String changeDietToString(List<Map<String, bool>> diets) {
    String container = "";

    for (Map<String, bool> diet in diets) {
      // Iterate through each key-value pair in the current allergy map
      diet.forEach((key, value) {
        if (value == true) {
          container += "&diet=$key"
              .toLowerCase(); // Append the key to the container string
        }
      });
    }

    return container;
  }

  String changeAllergyToString(List<Map<String, bool>> allergies) {
    String container = "";

    for (Map<String, bool> allergy in allergies) {
      // Iterate through each key-value pair in the current allergy map
      allergy.forEach((key, value) {
        if (value == true) {
          container += "&health=$key"
              .toLowerCase(); // Append the key to the container string
        }
      });
    }

    return container;
  }

  String changeMealTypeToString() {
    if (_whichOne == 'breakfast') {
      return "&mealType=Breakfast";
    } else if (_whichOne == 'lunch') {
      return "&mealType=Lunch";
    } else {
      return "&mealType=Dinner";
    }
  }

  List<Map<String, bool>> allergies = [
    {"Alcohol-Cocktail": false},
    {"Alcohol-Free": false},
    {"Celery-Free": false},
    {"Crustacean-Free": false},
    {"Dairy-Free": false},
    {"DASH": false},
    {"Egg-Free": false},
    {"Fish-Free": false},
    {"FODMAP-Free": false},
    {"Gluten-Free": false},
    {"Immuno-Supportive": false},
    {"Keto-Friendly": false},
    {"Kidney-Friendly": false},
    {"Kosher": false},
  ];
  List<Map<String, bool>> diets = [
    {"Balanced": false},
    {"High-Fiber": false},
    {"High-Protein": false},
    {"Low-Carb": false},
    {"Low-Fat": false},
    {"Low-Sodium": false}
  ];

  bool _toggleSetting = false;
  List<MealModel> recommendedMeals = [];

  List<MealModel> meals = [];

  void clearSearch() {
    setState(() {
      searchTextController.clear();
      meals.clear();
    });
  }

  void searchMeals(
      String searchText, String diet, String allergy, String mealType) async {
    if (searchText != "") {
      var url = Uri.parse(
          'https://api.edamam.com/api/recipes/v2?type=public&q=$searchText&app_id=6dd76169&app_key=%20261cac5cc9785821525536c1c5d7382c$diet$allergy$mealType');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        List<dynamic> hits = jsonResponse['hits'];
        List<MealModel> meals = [];

        for (var hit in hits) {
          var food = hit['recipe'];

          if (food['label'].length > 16) continue;

          var meal = MealModel(
            name: food['label'],
            image: food['image'],
            nutrients: food['totalDaily'],
            contents: food['ingredientLines'],
          );
          meals.add(meal);

          setState(() {
            recommendedMeals.add(meals.first);
            this.meals = meals;
          });
        }
      } else {
        throw ("Request failed with status: ${response.statusCode}");
      }
    } else {
      setState(() {
        meals.clear();
        searchTextController.clear();
      });
    }
  }

  @override
  void dispose() {
    searchTextController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<String> getUserAllergies() {
    UserModel userModel = ref.watch(userProvider)!;
    return userModel.allergic;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          height: 90,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => {Routemaster.of(context).push('/final-page')},
                  child: const Column(
                    children: [
                      Icon(
                        Icons.sunny,
                        size: 38,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                const Column(
                  children: [
                    Icon(
                      Icons.dining_rounded,
                      size: 38,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Meal Plan',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const Column(
                  children: [
                    Icon(
                      Icons.local_grocery_store_sharp,
                      size: 38,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Grocery List',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_sharp,
                      size: 38,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Text("What do you want to cook today? ",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  Container(
                    width: 350,
                    height: 88,
                    padding: const EdgeInsets.fromLTRB(18, 18, 5, 18),
                    child: TextField(
                      focusNode: _focusNode,
                      onChanged: (text) {
                        String diet = changeDietToString(diets);
                        String allergy = changeAllergyToString(allergies);
                        String mealType = changeMealTypeToString();
                        searchMeals(text, diet, allergy, mealType);
                      },
                      controller: searchTextController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        hintText: 'Find recipes',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            width: 2.0,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            clearSearch();
                            _focusNode.unfocus();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    // margin: const EdgeInsets.only(right: 2),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _toggleSetting = !_toggleSetting;
                        });
                      },
                      child: const Image(
                        image: AssetImage('assets/images/icon-green.png'),
                        width: 60,
                      ),
                    ),
                  ),
                ],
              ),
              if (_toggleSetting)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Allergies: ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          // padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 8,
                            children: allergies
                                .map(
                                  (e) => InputChip(
                                    label: Text(e.keys.first),
                                    labelStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    backgroundColor: e.values.first
                                        ? Colors.purple
                                        : const Color.fromARGB(
                                            224, 152, 92, 236),
                                    onPressed: () {
                                      setState(() {
                                        e[e.keys.first] = !e.values.first;
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Diet: ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          // padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 8,
                            children: diets
                                .map(
                                  (e) => InputChip(
                                    label: Text(e.keys.first),
                                    labelStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    backgroundColor: e.values.first
                                        ? Colors.purple
                                        : const Color.fromARGB(
                                            224, 152, 92, 236),
                                    onPressed: () {
                                      setState(() {
                                        e[e.keys.first] = !e.values.first;
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: meals.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Material(
                                      color: _whichOne == 'breakfast'
                                          ? const Color.fromRGBO(
                                              153, 39, 223, 0.631)
                                          : const Color.fromARGB(
                                              208, 138, 69, 234),
                                      borderRadius: BorderRadius.circular(10),
                                      child: GestureDetector(
                                        onTap: () => {
                                          setState(() {
                                            if (_whichOne == 'breakfast') {
                                              _whichOne = "";
                                              return;
                                            }
                                            _whichOne = "breakfast";
                                          }),
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(
                                            'Breakfast',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Material(
                                      color: _whichOne == 'lunch'
                                          ? const Color.fromRGBO(
                                              153, 39, 223, 0.631)
                                          : const Color.fromARGB(
                                              208, 138, 69, 234),
                                      borderRadius: BorderRadius.circular(10),
                                      child: GestureDetector(
                                        onTap: () => {
                                          setState(() {
                                            if (_whichOne == 'lunch') {
                                              _whichOne = "";
                                              return;
                                            }
                                            _whichOne = "lunch";
                                          }),
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(
                                            'Lunch',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Material(
                                      color: _whichOne == 'dinner'
                                          ? const Color.fromRGBO(
                                              153, 39, 223, 0.631)
                                          : const Color.fromARGB(
                                              208, 138, 69, 234),
                                      borderRadius: BorderRadius.circular(10),
                                      child: GestureDetector(
                                        onTap: () => {
                                          setState(() {
                                            if (_whichOne == 'dinner') {
                                              _whichOne = "";
                                              return;
                                            }
                                            _whichOne = "dinner";
                                          }),
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(
                                            'Dinner',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Material(
                                      color: _whichOne == 'snacks'
                                          ? const Color.fromRGBO(
                                              153, 39, 223, 0.631)
                                          : const Color.fromARGB(
                                              208, 138, 69, 234),
                                      borderRadius: BorderRadius.circular(10),
                                      child: GestureDetector(
                                        onTap: () => {
                                          setState(() {
                                            if (_whichOne == 'snacks') {
                                              _whichOne = "";
                                              return;
                                            }
                                            _whichOne = "snacks";
                                          }),
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(
                                            'Snacks',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Recommended recipes",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: const Text(
                                      "Show all",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 132, 128, 128),
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 2 / 2.18,
                                  ),
                                  itemCount: recommendedMeals.length,
                                  itemBuilder: (context, index) {
                                    var meal = recommendedMeals[index];
                                    return SizedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                20), // Circular border
                                            child: Image.network(
                                              meal.image!,
                                              width: 180,
                                              height: 150,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            meal.name,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: meals.length,
                          itemBuilder: (context, index) {
                            MealModel meal = meals[index];
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 20),
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: GestureDetector(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RecipeInfoPage(meal: meal)))
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    width: double.infinity,
                                    height: 110,
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 2),
                                          ),
                                          child: Image(
                                            image: NetworkImage(
                                              meal.image!,
                                            ),
                                            width: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              meal.name,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 10),
                                            // Text(meal.contents![1]),
                                            Text(
                                              "Fat: ${meal.nutrients['FAT']!['quantity'].toStringAsFixed(0)} %",
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "Protien: ${meal.nutrients['PROCNT']!['quantity'].toStringAsFixed(0)} %",
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "Carbs: ${meal.nutrients['CHOCDF']!['quantity'].toStringAsFixed(0)} %",
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
