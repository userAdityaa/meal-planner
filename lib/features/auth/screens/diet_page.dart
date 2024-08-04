import 'package:flutter/material.dart';
import 'package:flutter_meal_planner/core/common/next_button.dart';
import 'package:flutter_meal_planner/core/common/prev_button.dart';

import 'package:flutter_meal_planner/core/utils/diet_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DietPage extends ConsumerStatefulWidget {
  const DietPage({super.key});

  @override
  _DietPageState createState() => _DietPageState();
}

class _DietPageState extends ConsumerState<DietPage> {
  List<String> selectedDiet() {
    final List<Map<String, dynamic>> selectedItems =
        diet.where((element) => element['selected'] == true).toList();

    return selectedItems.map((e) => e['name'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Do you follow any of \nthis diets?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 26, 96, 226),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                  'To offer you the best tailored diet \nexperience we need to know more \ninformation about you.'),
              const SizedBox(height: 40),
              // SizedBox(
              //   height: 150,
              Expanded(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 10.0,
                  children: diet.map((item) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          item['selected'] = !item['selected'];
                        });
                      },
                      child: Chip(
                        label: Text(item['name'],
                            style: TextStyle(
                                color: item['selected']
                                    ? Colors.white
                                    : Colors.black)),
                        backgroundColor: item['selected']
                            ? const Color.fromARGB(255, 125, 68, 224)
                            : Colors.grey.shade300,
                      ),
                    );
                  }).toList(),
                ),
              ),
              // ),
              const SizedBox(height: 300),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const PrevButton("2"),
                  NextButton(
                    "2",
                    selected: selectedDiet(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
