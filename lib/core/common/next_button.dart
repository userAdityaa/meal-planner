import 'package:flutter/material.dart';
import 'package:flutter_meal_planner/features/auth/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class NextButton extends ConsumerWidget {
  final String _whichPage;
  final List<String>? selected;
  const NextButton(this._whichPage, {super.key, this.selected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 125, 68, 224),
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 20),
      ),
      onPressed: () {
        if (_whichPage == "1") {
          ref
              .read(authControllerProvider.notifier)
              .updateUserAllergies(selected!);
          Routemaster.of(context).push('/diet-page');
        } else {
          ref.read(authControllerProvider.notifier).updateUserDiets(selected!);
          Routemaster.of(context).push('/final-page');
        }
      },
      child: const Text(
        'Next',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
