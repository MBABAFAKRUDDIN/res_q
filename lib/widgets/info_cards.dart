import 'package:flutter/material.dart';

// Widget for displaying safety tips
class TipCard extends StatelessWidget {
  final String text;
  const TipCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// Widget for displaying emergency contacts
class ContactCard extends StatelessWidget {
  final String name;
  final String number;

  const ContactCard({required this.name, required this.number});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(Icons.phone, color: Colors.blue),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(number),
        trailing: IconButton(
          icon: Icon(Icons.call, color: Colors.green),
          onPressed: () {
            // TODO: Implement call functionality
          },
        ),
      ),
    );
  }
}
