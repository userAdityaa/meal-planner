import 'package:flutter/material.dart';
import 'package:flutter_meal_planner/core/common/next_button.dart';
import 'package:flutter_meal_planner/core/utils/allergic_list.dart';
import 'package:flutter_meal_planner/features/auth/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Allergic extends ConsumerStatefulWidget {
  const Allergic({super.key});

  @override
  _AllergicState createState() => _AllergicState();
}

class _AllergicState extends ConsumerState<Allergic> {
  List<String> selectedAllergies() {
    final List<Map<String, dynamic>> selectedItems =
        allergic.where((element) => element['selected'] == true).toList();

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
                      "Any ingredients\nallergies?",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(authControllerProvider.notifier).signOut();
                      },
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
                  'To offer you the best tailored diet\n experience we need to know more \n information about you.'),
              const SizedBox(height: 40),
              // SizedBox(
              // height: 150,
              Expanded(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 10.0,
                  children: allergic.map((item) {
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
              // const SizedBox(height: 2100),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  NextButton("1", selected: selectedAllergies()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
