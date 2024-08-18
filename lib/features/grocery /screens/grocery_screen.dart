import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_meal_planner/core/utils/location_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routemaster/routemaster.dart';
import 'package:http/http.dart' as http;

class GroceryScreen extends ConsumerStatefulWidget {
  const GroceryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends ConsumerState<GroceryScreen> {
  String? _currentAddress;
  Position? _currentPosition;
  TextEditingController groceryController = TextEditingController();

  List<String>? parts;
  String? cityAndCounty;

  List<Map<String, dynamic>> gorceryList = [];

  void _getCurrentLocation() async {
    _currentPosition = await LocationHandler.getCurrentPosition();
    _currentAddress =
        await LocationHandler.getAddressFromLatLng(_currentPosition!);
    parts = _currentAddress?.split(',');
    if (parts != null && parts!.length > 2) {
      cityAndCounty = parts![1].trim() + ', ' + parts![2].trim();
    } else {
      cityAndCounty = "Unknown location";
    }
    // print(cityAndCounty);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
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
              GestureDetector(
                onTap: () => {
                  Routemaster.of(context).push('/grocery-list'),
                },
                child: const Column(
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
      backgroundColor: const Color.fromARGB(255, 125, 68, 224),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 75),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  "Hey, Aditya",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              cityAndCounty ?? "Fetching address...",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: groceryController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    hintText: 'Search Groceries',
                    border: InputBorder.none,
                    prefixIcon: GestureDetector(
                      onTap: () async {
                        var response = await http.get(Uri.parse(
                            'https://www.fruityvice.com/api/fruit/${groceryController.text}'));
                        var data = jsonDecode(response.body);

                        // gorceryList = List<Map<String, dynamic>>.from(data);
                        var stringText = groceryController.text;
                        Map<String, dynamic> nutritions =
                            Map<String, dynamic>.from(data['nutritions']);
                        nutritions['quantity'] = 1;

                        Map<String, dynamic> toAdd = {
                          stringText: nutritions,
                        };

                        gorceryList!.add(toAdd);
                        groceryController.text = "";
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.grey,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        groceryController.text = "";
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  cursorColor: Colors.grey,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            height: 580,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: gorceryList.map((map) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: map.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          "assets/images/fruits-${map.entries.first.key.toString().toLowerCase()}.png"),
                                      height: 95,
                                      width: 120,
                                      fit: BoxFit
                                          .cover, // Ensure the image covers the space properly
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            map.entries.first.key.toUpperCase(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            "Calories: ${map.entries.first.value['calories']}",
                                          ),
                                          Text(
                                            "Protein: ${map.entries.first.value['protein']}",
                                          ),
                                          Text(
                                            "Fat: ${map.entries.first.value['fat']}",
                                          ),
                                          Text(
                                              "Quantity: ${map.entries.first.value['quantity']}")
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          20, 14, 0, 0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // const SizedBox(height: 10),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 125, 68, 224),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    minimumSize:
                                                        const Size(30, 30),
                                                  ),
                                                  onPressed: () async {
                                                    var response = await http
                                                        .get(Uri.parse(
                                                            'https://www.fruityvice.com/api/fruit/${map.entries.first.key}'));
                                                    var data = jsonDecode(
                                                        response.body);

                                                    Map<String, dynamic>
                                                        nutritions = Map<String,
                                                                dynamic>.from(
                                                            data['nutritions']);
                                                    var calories =
                                                        nutritions['calories'];
                                                    var protein =
                                                        nutritions['protein'];
                                                    var fat = nutritions['fat'];

                                                    var entry =
                                                        map.entries.first.value;
                                                    entry['quantity'] =
                                                        entry['quantity'] - 1;
                                                    entry['calories'] =
                                                        (entry['calories'] ??
                                                                0) -
                                                            calories;
                                                    entry['protein'] =
                                                        (entry['protein'] ??
                                                                0) -
                                                            protein;
                                                    entry['fat'] = double.parse(
                                                        ((entry['fat'] ?? 0) -
                                                                fat)
                                                            .toStringAsFixed(
                                                                1));

                                                    setState(() {});
                                                  },
                                                  child: const Icon(
                                                    Icons.remove,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 125, 68, 224),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    minimumSize:
                                                        const Size(30, 30),
                                                  ),
                                                  onPressed: () async {
                                                    var response = await http
                                                        .get(Uri.parse(
                                                            'https://www.fruityvice.com/api/fruit/${map.entries.first.key}'));
                                                    var data = jsonDecode(
                                                        response.body);

                                                    Map<String, dynamic>
                                                        nutritions = Map<String,
                                                                dynamic>.from(
                                                            data['nutritions']);
                                                    var calories =
                                                        nutritions['calories'];
                                                    var protein =
                                                        nutritions['protein'];
                                                    var fat = nutritions['fat'];

                                                    var entry =
                                                        map.entries.first.value;
                                                    entry['quantity'] =
                                                        entry['quantity'] + 1;
                                                    entry['calories'] =
                                                        calories +
                                                            (entry['calories'] ??
                                                                0);
                                                    entry['protein'] = protein +
                                                        (entry['protein'] ?? 0);
                                                    entry['fat'] = double.parse(
                                                        (fat +
                                                                (entry['fat'] ??
                                                                    0))
                                                            .toStringAsFixed(
                                                                1));

                                                    setState(() {});
                                                  },
                                                  child: const Icon(
                                                    Icons.add,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 125, 68, 224),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                minimumSize: const Size(30, 30),
                                              ),
                                              onPressed: () {
                                                gorceryList.remove(map);
                                                setState(() {});
                                              },
                                              child: const Icon(
                                                Icons.delete,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          final ImagePicker _picker = ImagePicker();
          String _prediction = "";
          Future<void> _pickAndUploadImage() async {
            // Pick image from gallery
            final XFile? imageFile =
                await _picker.pickImage(source: ImageSource.gallery);

            if (imageFile == null) {
              return;
            }

            final File image = File(imageFile.path);

            // Create a multipart request
            final uri = Uri.parse('http://localhost:6000/predict');
            final request = http.MultipartRequest('POST', uri)
              ..files
                  .add(await http.MultipartFile.fromPath('file', image.path));

            // Send the request
            final response = await request.send();

            // Process the response
            if (response.statusCode == 200) {
              final responseData = await response.stream.bytesToString();
              var data = (jsonDecode(responseData)['predicted_fruit']);
              if (data == 'Grapes') data = 'grape';
              var apiCall = await http
                  .get(Uri.parse('https://www.fruityvice.com/api/fruit/$data'));
              var apiData = jsonDecode(apiCall.body);
              if (data == 'chickoo') print('something');
              // print(apiData['nutritions']);
              // print(jsonDecode(apiCall.body));
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Container(
                      height: 345,
                      width: 400,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    width: 1.0,
                                    color: Colors.black), // Upper line
                                bottom:
                                    BorderSide(width: 1.0, color: Colors.black),
                                // Lower line
                              ),
                            ),
                            child: Text(
                              "Prediction Time",
                              style: TextStyle(
                                fontSize:
                                    20.0, // Adjust the font size as needed
                                fontWeight: FontWeight
                                    .bold, // Optional: makes the text bold
                              ),
                              textAlign: TextAlign
                                  .center, // Optional: centers the text
                            ),
                          ),
                          const SizedBox(height: 10),

                          Container(
                            width: double.infinity,
                            height: 200,
                            child: Image(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'assets/images/${data.toString().toLowerCase()}.jpg',
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Image.network('https://path/to/predicted/fruit/image'),
                          Text(
                            '${data.toString().toUpperCase()}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                              "Calories: ${apiData['nutritions']['calories']}"),
                          Text("Protein: ${apiData['nutritions']['protein']}"),
                          Text("Fat: ${apiData['nutritions']['fat']}"),
                          Text(
                              "Carbohydrates: ${apiData['nutritions']['carbohydrates']}"),
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            } else {
              setState(() {
                _prediction = 'Error: ${response.statusCode}';
              });
            }
          }

          _pickAndUploadImage();
        },
        child: const SizedBox(
          height: 80,
          width: 80,
          child: Material(
            color: Color.fromARGB(255, 125, 68, 224),
            elevation: 10,
            shape: CircleBorder(), // Makes the button round
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
