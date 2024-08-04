import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class PrevButton extends StatelessWidget {
  final String _whichPage;
  const PrevButton(this._whichPage, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 220, 220, 220),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      ),
      onPressed: () {
        if (_whichPage == "2") {
          Routemaster.of(context).push('/');
        }
      },
      child: const Text('Previous',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    );
  }
}
