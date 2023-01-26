// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:project_in_progress/bluetooth_screen.dart';
import 'package:project_in_progress/styles.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
  MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: MainScreen(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class MainScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

enum Pages { main, recommendations, history, aboutUs }

class _MainScreenState extends State<MainScreen> {
  Pages _currentPage = Pages.main;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NPK Sensor'),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            GestureDetector(
              child: ListTile(
                leading: Icon(Icons.home),
                title: Text('Main'),
              ),
              onTap: () {
                setState(() {
                  _currentPage = Pages.main;
                });
                Navigator.of(context).pop();
              },
            ),
            GestureDetector(
              child: ListTile(
                leading: Icon(Icons.list),
                title: Text('Recommendations'),
              ),
              onTap: () {
                setState(() {
                  _currentPage = Pages.recommendations;
                });
                Navigator.of(context).pop();
              },
            ),
            GestureDetector(
              child: ListTile(
                leading: Icon(Icons.history),
                title: Text('History'),
              ),
              onTap: () {
                setState(() {
                  _currentPage = Pages.history;
                });
                Navigator.of(context).pop();
              },
            ),
            GestureDetector(
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text('About Us'),
              ),
              onTap: () {
                setState(() {
                  _currentPage = Pages.aboutUs;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: _getBody(),
    );
  }

  _getBody() {
    final pages = {
      Pages.main: MainPage(),
      Pages.recommendations: RecommendationPage(
        selectedPlant: '',
        soilArea: '',
        soilName: '',
      ),
      Pages.history: HistoryPage(),
      Pages.aboutUs: AboutUsPage(),
    };

    return pages[_currentPage];
  }
}

// ignore: use_key_in_widget_constructors
class MainPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  String _npkValue = "0.0";
  String _timeStamp = "--/--/---- --:--";
  late String _soilName;
  late String _soilArea;
  late String _selectedPlant = 'Tomato';
  List<String> _plants = ["Tomato", "Cabbage", "Carrot", "Onion"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NPK Values'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Table(
              children: [
                TableRow(children: [
                  Text('N'),
                  Text(_npkValue),
                ]),
                TableRow(children: [
                  Text('P'),
                  Text(_npkValue),
                ]),
                TableRow(children: [
                  Text('K'),
                  Text(_npkValue),
                ]),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Time Stamp: $_timeStamp'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  child: Text('Start'),
                  onPressed: () {
                    // Start receiving data from the device
                  },
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    // Save the current NPK values and time stamp to the app's history
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Soil Name'),
                  onChanged: (value) {
                    setState(() {
                      _soilName = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Soil Area'),
                  onChanged: (value) {
                    setState(() {
                      _soilArea = value;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: _selectedPlant,
                  onChanged: (value) {
                    setState(() {
                      _selectedPlant = value!;
                    });
                  },
                  items: _plants.map((String plant) {
                    return DropdownMenuItem<String>(
                      value: plant,
                      child: Text(plant),
                    );
                  }).toList(),
                ),
                TextButton(
                  child: Text('Recommend Me'),
                  onPressed: () {
                    if (_soilName != null &&
                        _soilArea != null &&
                        _selectedPlant != "Select Plant") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecommendationPage(
                            soilName: _soilName,
                            soilArea: _soilArea,
                            selectedPlant: _selectedPlant,
                          ),
                        ),
                      );
                    } else {
                      // Show an error message to the user if any of the fields are empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill out all fields')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class RecommendationPage extends StatelessWidget {
  final String soilName;
  final String soilArea;
  final String selectedPlant;

  // ignore: use_key_in_widget_constructors
  const RecommendationPage(
      {required this.soilName,
      required this.soilArea,
      required this.selectedPlant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recommendations')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Soil Name: $soilName'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Soil Area: $soilArea'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Plant: $selectedPlant'),
          ),
          // Add any additional widgets or logic for displaying recommendations
        ],
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('History Page'),
    );
  }
}

// ignore: use_key_in_widget_constructors
class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('About Us Page'),
    );
  }
}
