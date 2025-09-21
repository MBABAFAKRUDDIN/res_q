import 'package:flutter/material.dart';

class EarthquakeScreen extends StatelessWidget {
  final List<Tip> beforeTips = [
    Tip('Secure Heavy Items', 'assets/earthquake/1.png',
        'Fasten shelves, mirrors, and large furniture to walls.'),
    Tip('Prepare an Emergency Kit', 'assets/earthquake/2.png',
        'Include water, food, flashlight, and first-aid supplies.'),
    Tip('Know Safe Spots', 'assets/earthquake/3.png',
        'Identify safe places like under sturdy tables or inside door frames.'),
    Tip('Practice Drills', 'assets/earthquake/4.png',
        'Conduct earthquake drills with your family.'),
  ];

  final List<Tip> duringTips = [
    Tip('Drop, Cover, and Hold', 'assets/earthquake/5.jpg',
        'Get under a table or desk and hold on until shaking stops.'),
    Tip('Stay Indoors', 'assets/earthquake/6.jpg',
        'Do not run outside during the shaking.'),
    Tip('Protect Head and Neck', 'assets/earthquake/7.png',
        'Use your arms or a sturdy object to shield yourself.'),
    Tip('Stay Away from Windows', 'assets/earthquake/8.jpg',
        'Glass may shatter, causing injuries.'),
  ];

  final List<Tip> afterTips = [
    Tip('Check for Injuries', 'assets/earthquake/9.png',
        'Provide first aid where necessary.'),
    Tip('Inspect for Damage', 'assets/earthquake/10.jpg',
        'Check your home for structural damage.'),
    Tip('Expect Aftershocks', 'assets/earthquake/11.png',
        'Be prepared for more shaking.'),
    Tip('Use Text or Social Media', 'assets/earthquake/12.png',
        'To communicate when phone lines are overloaded.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earthquake Safety Tips'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle('Before Earthquake'),
            tipsList(beforeTips, context),
            sectionTitle('During Earthquake'),
            tipsList(duringTips, context),
            sectionTitle('After Earthquake'),
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
            leading: Icon(Icons.tips_and_updates, color: Colors.orange, size: 36),
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
                      child: Text('Close', style: TextStyle(color: Colors.orange)),
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
