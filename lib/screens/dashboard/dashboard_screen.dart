import 'package:flutter/material.dart';
import 'package:poultry_farming_app/screens/dashboard/broilers_dashboard.dart';
import 'package:poultry_farming_app/screens/dashboard/layers_dashboard.dart';
import 'package:poultry_farming_app/screens/dashboard/DiseaseDiagnosisScreen.dart';
import 'package:poultry_farming_app/screens/dashboard/farm_makerting.dart';
import 'package:poultry_farming_app/utils/constants.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Chicken Type"),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/chickens_bg.jpeg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // dark overlay for contrast
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _chickCard(context, 'Layers & Kuroilers – Egg Production', Icons.egg, LayerFarmDashboard()),
              _chickCard(context, 'Broilers & Kuroilers – Meat Production', Icons.local_fire_department, const BroilersDashboard()),
              _chickCard(context, 'Farm Health – Diagnose by Symptoms', Icons.healing, const DiseaseDiagnosisScreen()),
              _chickCard(context, 'Access Market for Birds and Eggs', Icons.store,  FarmMarketPage()),

            ],
          ),
        ],
      ),
    );
  }

  Widget _chickCard(BuildContext context, String title, IconData icon, Widget screen) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 36, color: primaryColor),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        ),
      ),
    );
  }
}
