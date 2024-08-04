import 'package:flutter/material.dart';
import 'package:flutter_meal_planner/core/common/next_button.dart';
import 'package:flutter_meal_planner/core/common/prev_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinalPage extends ConsumerWidget {
  const FinalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 45),
            const Padding(
              padding: EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    width: 310,
                    image: AssetImage('assets/images/enjoy01.png'),
                  ),
                  Image(
                    height: 250,
                    fit: BoxFit.contain,
                    image: AssetImage(
                      'assets/images/enjoy02.png',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 44),
            const Center(
              child: Text(
                "Enjoy your lunch time",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              alignment: Alignment.center,
              width: 230,
              child: const Text(
                'Just relax and not overthink what to eat. This is in our side with our personalized meal plans just prepared and adapted to your needs.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  leadingDistribution: TextLeadingDistribution.even,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 200),
            const Padding(
              padding: EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PrevButton("3"),
                  NextButton("3"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
