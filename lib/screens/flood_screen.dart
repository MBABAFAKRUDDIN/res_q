import 'package:flutter/material.dart';

class FloodScreen extends StatelessWidget {
  final List<Tip> beforeTips = [
    Tip('Know Your Risk', 'assets/flood/1.png',
        'Find out if your home is in a flood-prone area.'),
    Tip('Prepare Sandbags to Block water', 'assets/flood/2.png',
        'Include food, water, torch, batteries, and medicines.'),
    Tip('Install Waterproof seals & Barriers', 'assets/flood/3.png',
        'Know where to go if evacuation is needed.'),
    Tip('Pack an Emergency kit', 'assets/flood/4.png',
        'Keep important documents and valuables above flood level.'),
  ];

  final List<Tip> duringTips = [
    Tip('Move to Higher Ground', 'assets/flood/5.png',
        'Immediately move to higher floors or elevated areas.'),
    Tip('Avoid Flood Waters', 'assets/flood/6.png',
        'Never walk or drive through flooded areas.'),
    Tip('Disconnect Electrical Appliances', 'assets/flood/7.png',
        'Prevent electrocution risks.'),
    Tip('Stay Tuned', 'assets/flood/8.png',
        'Listen to local radio or alerts for emergency updates.'),
  ];

  final List<Tip> afterTips = [
    Tip('Turn off the Power before re-entering', 'assets/flood/9.png',
        'Only return home when authorities declare it safe.'),
    Tip('Avoid Contaminated Water', 'assets/flood/10.png',
        'Flood water may be unsafe to touch or drink.'),
    Tip('Clean and Disinfect', 'assets/flood/11.png',
        'Clean your house thoroughly to avoid infections.'),
    Tip('Document Damages', 'assets/flood/12.png',
        'Take pictures for insurance and assistance claims.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flood Safety Tips'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle('Before Flood'),
            tipsList(beforeTips, context),
            sectionTitle('During Flood'),
            tipsList(duringTips, context),
            sectionTitle('After Flood'),
            tipsList(afterTips, context),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget tipsList(List<Tip> tips, BuildContext context) {
    return Column(
      children: tips.map((tip) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Icon(Icons.water_drop, color: Colors.blue, size: 36),
            title: Text(
              tip.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: Text(tip.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(tip.image, height: 150),
                      SizedBox(height: 10),
                      Text(tip.description, textAlign: TextAlign.center),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}

class Tip {
  final String title;
  final String image;
  final String description;

  Tip(this.title, this.image, this.description);
}
