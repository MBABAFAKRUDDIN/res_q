import 'package:flutter/material.dart';

class FireScreen extends StatelessWidget {
  final List<Tip> beforeTips = [
    Tip('Install Smoke Alarms', 'assets/fire/1.png',
        'Place smoke alarms on every level of your home.'),
    Tip('Create an Escape Plan', 'assets/fire/2.png',
        'Practice evacuation routes with family.'),
    Tip('Keep Extinguishers Ready', 'assets/fire/3.png',
        'Have fire extinguishers and know how to use them.'),
    Tip('Safe Electrical Setup', 'assets/fire/4.png',
        'Avoid overloading power outlets and wires.'),
  ];

  final List<Tip> duringTips = [
    Tip('Stay Low', 'assets/fire/5.png',
        'Crawl low under smoke to avoid inhaling it.'),
    Tip('Use Wet Cloth', 'assets/fire/6.png',
        'Cover your nose and mouth with a wet cloth.'),
    Tip('Stop, Drop, and Roll', 'assets/fire/7.png',
        'If clothes catch fire, stop, drop, and roll.'),
    Tip('Exit Immediately', 'assets/fire/8.png',
        'Leave the building quickly and never go back inside.'),
  ];

  final List<Tip> afterTips = [
    Tip('Check for Gas Leaks', 'assets/fire/9.png',
        'Be careful of embers and hotspots even after fire is out.'),
    Tip('Contact Authorities', 'assets/fire/10.png',
        'Report the fire to local fire department.'),
    Tip('Do Not Re-Enter', 'assets/fire/11.png',
        'Only return when officials declare it safe. '),
    Tip('Seek Medical Help', 'assets/fire/12.png',
        'Get treatment for burns or smoke inhalation.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fire Safety Tips'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle('Before Fire'),
            tipsList(beforeTips, context),
            sectionTitle('During Fire'),
            tipsList(duringTips, context),
            sectionTitle('After Fire'),
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
            leading: Icon(Icons.local_fire_department, color: Colors.red, size: 36),
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
                      child: Text('Close', style: TextStyle(color: Colors.red)),
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
