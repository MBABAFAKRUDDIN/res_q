import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:res_q/screens/login_screen.dart';
import 'package:res_q/screens/earthquake_screen.dart';
import 'package:res_q/screens/flood_screen.dart';
import 'package:res_q/screens/fire_screen.dart';
import 'package:res_q/screens/add_contacts_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  LatLng? _currentPosition;
  Map<String, dynamic>? _weatherData;
  String? _disasterPrediction;
  List<String> emergencyContacts = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((_) => _fetchWeather());
    _loadEmergencyContacts();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _fetchWeather() async {
    if (_currentPosition == null) return;

    final lat = _currentPosition!.latitude;
    final lon = _currentPosition!.longitude;
    final apiKey = "321b1e1768f68025fd9b87e1080d783b";

    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _weatherData = json.decode(response.body);
      });
      _predictDisaster();
    }
  }

  void _predictDisaster() {
    if (_weatherData == null) return;

    final temp = _weatherData!['main']['temp'];
    final humidity = _weatherData!['main']['humidity'];
    final pressure = _weatherData!['main']['pressure'];

    if (humidity > 80 && temp < 25) {
      _disasterPrediction = "🌊 High Risk of Flood";
    } else if (pressure < 1000 && temp > 30) {
      _disasterPrediction = "🌍 Earthquake Warning Possible";
    } else {
      _disasterPrediction = "✅ Safe Weather Conditions";
    }

    setState(() {});
  }

  void _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> _sendSOS() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> numbers = [];
    for (int i = 0; i < 5; i++) {
      String? number = prefs.getString('contact$i');
      if (number != null && number.isNotEmpty) {
        numbers.add(number);
      }
    }
    if (numbers.isEmpty || _currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No contacts added or location unavailable")));
      return;
    }

    final lat = _currentPosition!.latitude;
    final lon = _currentPosition!.longitude;
    final locationUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$lon";
    final message = "🚨 SOS! I need help! Here is my location: $locationUrl";

    // Send SMS to all contacts at once
    final smsRecipients = numbers.join(';');
    final smsUrl = "sms:$smsRecipients?body=${Uri.encodeComponent(message)}";

    if (await canLaunchUrlString(smsUrl)) {
      await launchUrlString(smsUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not launch SMS app")));
    }
  }

  void _shareMyLocation() {
    if (_currentPosition == null) return;

    final lat = _currentPosition!.latitude;
    final lon = _currentPosition!.longitude;
    final url = "https://www.google.com/maps/search/?api=1&query=$lat,$lon";

    Share.share("Here is my current location: $url");
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select the Disaster"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.public, color: Colors.orange),
                title: Text("Earthquake - 108"),
                onTap: () {
                  Navigator.pop(context);
                  _makeCall("tel:108");
                },
              ),
              ListTile(
                leading: Icon(Icons.water_damage, color: Colors.blue),
                title: Text("Flood - 1070"),
                onTap: () {
                  Navigator.pop(context);
                  _makeCall("tel:1070");
                },
              ),
              ListTile(
                leading: Icon(Icons.local_fire_department, color: Colors.red),
                title: Text("Fire - 101"),
                onTap: () {
                  Navigator.pop(context);
                  _makeCall("tel:101");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _makeCall(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _loadEmergencyContacts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> contacts = [];
    for (int i = 0; i < 5; i++) {
      String? number = prefs.getString('contact$i');
      if (number != null && number.isNotEmpty) {
        contacts.add(number);
      }
    }
    setState(() {
      emergencyContacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disaster Safety Management"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddContactsScreen()));
            },
            icon: Icon(Icons.contacts),
          ),
          TextButton(
            onPressed: () => _logout(context),
            child: Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: _currentPosition == null
                  ? Center(child: CircularProgressIndicator())
                  : FlutterMap(
                options: MapOptions(
                  center: _currentPosition!,
                  zoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 50.0,
                        height: 50.0,
                        point: _currentPosition!,
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_weatherData != null) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "🌤 Current Weather",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text("Temperature: ${_weatherData!['main']['temp']} °C"),
                    Text("Humidity: ${_weatherData!['main']['humidity']} %"),
                    Text("Pressure: ${_weatherData!['main']['pressure']} hPa"),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        "📊 Prediction: $_disasterPrediction",
                        style: TextStyle(fontSize: 18, color: Colors.deepOrange),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select a Disaster",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                _buildDisasterButton(context, "Earthquake", "assets/earthquake.jpg", Colors.orange, EarthquakeScreen()),
                _buildDisasterButton(context, "Floods", "assets/flood.jpg", Colors.blue, FloodScreen()),
                _buildDisasterButton(context, "Fire", "assets/fire.png", Colors.red, FireScreen()),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showEmergencyDialog,
                        icon: Icon(Icons.call, color: Colors.white),
                        label: Text("Emergency"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _sendSOS,
                        icon: Icon(Icons.sms, color: Colors.white),
                        label: Text("SOS"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _shareMyLocation,
                        icon: Icon(Icons.location_on, color: Colors.white),
                        label: Text("Share"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisasterButton(BuildContext context, String title, String imagePath,
      Color color, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover),
            SizedBox(width: 15),
            Text(
              title,
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
