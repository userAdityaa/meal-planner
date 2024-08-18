import 'package:flutter/material.dart';

import 'package:flutter_meal_planner/features/auth/screens/allergic.dart';
import 'package:flutter_meal_planner/features/auth/screens/diet_page.dart';

// import 'package:flutter_meal_planner/features/auth/screens/final_page.dart';

import 'package:flutter_meal_planner/features/auth/screens/login_email_screen.dart';
import 'package:flutter_meal_planner/features/auth/screens/login_screen.dart';

import 'package:flutter_meal_planner/features/auth/screens/sign_in_email_screen.dart';
import 'package:flutter_meal_planner/features/chat/screens/chat_screen.dart';
import 'package:flutter_meal_planner/features/grocery%20/screens/grocery_screen.dart';
import 'package:flutter_meal_planner/features/grocery%20/screens/predict_screen.dart';
import 'package:flutter_meal_planner/features/home/screens/home_screen.dart';
// import 'package:flutter_meal_planner/features/home/screens/home_screen.dart';
import 'package:flutter_meal_planner/features/mealPlan/screens/mean_planner_screen.dart';

// import 'package:flutter_meal_planner/features/mealPlan/screens/mean_planner_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
  '/email-signup': (_) => const MaterialPage(child: EmailScreen()),
  '/email-login': (_) => const MaterialPage(child: SignInEmailScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: Allergic(),
      ),
  '/diet-page': (_) => const MaterialPage(
        child: DietPage(),
      ),
  '/final-page': (_) => const MaterialPage(child: HomePage()),
  '/meal-plan': (_) => const MaterialPage(child: MealPlannerScreen()),
  '/chat-route': (_) => const MaterialPage(child: ChatScreen()),
  '/grocery-list': (_) => const MaterialPage(child: GroceryScreen()),
  '/predict-page': (_) => const MaterialPage(child: PredictPage()),
});
