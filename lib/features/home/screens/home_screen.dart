import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

const testingData = [
  {'Fat': 0.29},
  {'Pro': 0.65},
  {'Carb': 0.85},
];

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        height: 90,
        color: Colors.white,
        // child: ,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
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
              GestureDetector(
                onTap: () => {
                  Routemaster.of(context).push('/meal-plan'),
                },
                child: const Column(
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
              GestureDetector(
                onTap: () => {
                  Routemaster.of(context).push('/chat-route'),
                },
                child: const Column(
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
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                  ),
                  Icon(
                    Icons.menu,
                    size: 35,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Today\'s Progress',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("View more"),
                          )
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Column(
                            children: [
                              Text(
                                'Calories',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Image(
                                    image: AssetImage('assets/images/fire.png'),
                                    height: 20,
                                  ),
                                  Text('1,284'),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 75),
                          Wrap(
                            spacing: 14,
                            children: testingData
                                .map(
                                  (e) => Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 22),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 17),
                                            child: Text(
                                              // ignore: unnecessary_string_interpolations
                                              "${e.keys.first}",
                                            ),
                                          ),
                                          SizedBox(
                                            height: 62,
                                            width: 62,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 9,
                                              value: e.values.first,
                                              color: Colors.yellow,
                                              backgroundColor: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                          ),
                          SizedBox(width: 20),
                          Stack(
                            children: [
                              Image(
                                image: AssetImage('assets/images/chat01.png'),
                                height: 34,
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 28),
                                  Image(
                                    image:
                                        AssetImage('assets/images/chat02.png'),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                child: Text(
                                    '🎉 Keep the pace! You’re doing great.'),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 32),
              // if (userModel.todayMeals.isNotEmpty)
              //   Expanded(
              //     child: SingleChildScrollView(
              //       scrollDirection: Axis.vertical,
              //       child: Column(
              //           children: userModel.todayMeals.map((meal) {
              //         return Column(
              //           children: [
              //             Padding(
              //               padding: const EdgeInsets.symmetric(horizontal: 5),
              //               child: ClipPath(
              //                 clipper: ShapeBorderClipper(
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(20),
              //                   ),
              //                 ),
              //                 child: Image.network(
              //                   meal.image!,
              //                   width: double.infinity,
              //                   height: 250,
              //                   fit: BoxFit.cover,
              //                 ),
              //               ),
              //             ),
              //             const SizedBox(height: 50),
              //           ],
              //         );
              //       }).toList()),
              //     ),
              //   )
            ],
          ),
        ),
      ),
    );
  }
}
