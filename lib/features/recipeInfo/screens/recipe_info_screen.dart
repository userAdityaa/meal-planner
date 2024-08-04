import 'package:flutter/material.dart';
import 'package:flutter_meal_planner/features/auth/controllers/auth_controller.dart';
import 'package:flutter_meal_planner/models/meal_model.dart';
import 'package:flutter_meal_planner/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class RecipeInfoPage extends ConsumerStatefulWidget {
  MealModel meal;
  RecipeInfoPage({super.key, required this.meal});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecipeInfoPageState();
}

class _RecipeInfoPageState extends ConsumerState<RecipeInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image(
                  image: NetworkImage(widget.meal.image as String),
                  width: double.infinity,
                  fit: BoxFit.contain),
              Column(
                children: [
                  const SizedBox(
                    height: 410,
                  ),
                  Material(
                    elevation: 12,
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        width: double.infinity,
                        height: 460,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.meal.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 35),
                            Container(
                              width: double.infinity,
                              height: 55,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(94, 169, 168, 168),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(widget.meal
                                              .nutrients['FAT']!['quantity']
                                              .toStringAsFixed(0) +
                                          " g"),
                                      const SizedBox(height: 5),
                                      const Text('Fat',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(widget.meal
                                              .nutrients['PROCNT']!['quantity']
                                              .toStringAsFixed(0) +
                                          " g"),
                                      const SizedBox(height: 5),
                                      const Text('Protien',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(widget.meal
                                              .nutrients['CHOCDF']!['quantity']
                                              .toStringAsFixed(0) +
                                          " g"),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Carbs',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Row(
                              children: [
                                Text(
                                  'Ingredients',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            if (widget.meal.contents != null)
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: widget.meal.contents!.map(
                                      (content) {
                                        return Column(
                                          children: [
                                            Text(content),
                                            const SizedBox(height: 20),
                                          ],
                                        ); // Replace with appropriate widgets for each content item
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 125, 68, 224),
                                ),
                                onPressed: () {
                                  ref
                                      .read(authControllerProvider.notifier)
                                      .updateUserTodayMeals(widget.meal);
                                },
                                child: const Text(
                                  'Add for today',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
