import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddContactsScreen extends StatefulWidget {
  @override
  _AddContactsScreenState createState() => _AddContactsScreenState();
}

class _AddContactsScreenState extends State<AddContactsScreen> {
  List<TextEditingController> controllers = List.generate(5, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].text = prefs.getString('contact$i') ?? '';
    }
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < controllers.length; i++) {
      await prefs.setString('contact$i', controllers[i].text);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Contacts saved!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Emergency Contacts"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView( // <-- Added this
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Enter up to 5 trusted contacts to receive your SOS message.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ...List.generate(5, (index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: controllers[index],
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Contact ${index + 1}",
                    border: OutlineInputBorder(),
                  ),
                ),
              )),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveContacts,
                child: Text("Save Contacts"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}