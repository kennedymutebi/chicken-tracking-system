import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Enhanced Data models
class EggRecord {
  final double traysCollected;
  final double costPerTray;
  final int eggsPerTray; // Added to track individual eggs
  final DateTime date;
  final String? notes;

  EggRecord({
    required this.traysCollected,
    required this.costPerTray,
    this.eggsPerTray = 30, // Default 30 eggs per tray
    required this.date,
    this.notes,
  });

  double get totalEggs => traysCollected * eggsPerTray;
  double get totalRevenue => traysCollected * costPerTray;
}

class FeedRecord {
  final String feedType;
  final double quantity;
  final double cost;
  final DateTime date;
  final String? supplier;
  final String? notes;

  FeedRecord({
    required this.feedType,
    required this.quantity,
    required this.cost,
    required this.date,
    this.supplier,
    this.notes,
  });
}

class MedicationRecord {
  final String medicationName;
  final String type; // Vaccine, Antibiotic, Supplement, etc.
  final String dosage;
  final double cost;
  final DateTime date;
  final String administrationMethod;
  final String? veterinarian;
  final String? notes;

  MedicationRecord({
    required this.medicationName,
    required this.type,
    required this.dosage,
    required this.cost,
    required this.date,
    required this.administrationMethod,
    this.veterinarian,
    this.notes,
  });
}

class MaterialRecord {
  final String materialName;
  final double quantity;
  final String unit;
  final double cost;
  final DateTime date;
  final String category; // Feed, Equipment, Bedding, etc.
  final String? supplier;

  MaterialRecord({
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.cost,
    required this.date,
    required this.category,
    this.supplier,
  });
}

class FlockInfo {
  final int totalBirds;
  final DateTime dateAcquired;
  final String breed;
  final double costPerBird;
  final int currentAge; // in weeks

  FlockInfo({
    required this.totalBirds,
    required this.dateAcquired,
    required this.breed,
    required this.costPerBird,
    required this.currentAge,
  });
}

class ActivityItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final DateTime date;

  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.date,
  });
}

class LayerFarmDashboard extends StatefulWidget {
  const LayerFarmDashboard({super.key});

  @override
  _LayerFarmDashboardState createState() => _LayerFarmDashboardState();
}

class _LayerFarmDashboardState extends State<LayerFarmDashboard> {
  List<EggRecord> eggRecords = [];
  List<FeedRecord> feedRecords = [];
  List<MedicationRecord> medicationRecords = [];
  List<MaterialRecord> materialRecords = [];
  FlockInfo? flockInfo;

  // Calculated properties
  double get totalEggTrays => eggRecords.fold(0.0, (sum, record) => sum + record.traysCollected);
  double get totalEggs => eggRecords.fold(0.0, (sum, record) => sum + record.totalEggs);
  double get totalEggRevenue => eggRecords.fold(0.0, (sum, record) => sum + record.totalRevenue);
  double get totalFeedCost => feedRecords.fold(0.0, (sum, record) => sum + record.cost);
  double get totalMedicationCost => medicationRecords.fold(0.0, (sum, record) => sum + record.cost);
  double get totalMaterialCost => materialRecords.fold(0.0, (sum, record) => sum + record.cost);
  double get totalOperatingCosts => totalFeedCost + totalMedicationCost + totalMaterialCost;
  double get netProfit => totalEggRevenue - totalOperatingCosts;

  double get averageDailyEggs {
    if (eggRecords.isEmpty) return 0.0;
    final days = eggRecords.map((e) => DateFormat('yyyy-MM-dd').format(e.date)).toSet().length;
    return days > 0 ? totalEggs / days : 0.0;
  }

  double get eggProductionPercentage {
    if (flockInfo == null || flockInfo!.totalBirds == 0) return 0.0;
    return (averageDailyEggs / flockInfo!.totalBirds) * 100;
  }

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  Future<void> _loadSampleData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load flock info
    final flockJson = prefs.getString('flockInfo');
    if (flockJson != null) {
      final flockMap = jsonDecode(flockJson) as Map<String, dynamic>;
      setState(() {
        flockInfo = FlockInfo(
          totalBirds: flockMap['totalBirds'],
          dateAcquired: DateTime.parse(flockMap['dateAcquired']),
          breed: flockMap['breed'],
          costPerBird: flockMap['costPerBird'].toDouble(),
          currentAge: flockMap['currentAge'],
        );
      });
    } else {
      setState(() {
        flockInfo = FlockInfo(
          totalBirds: 100,
          dateAcquired: DateTime.now().subtract(const Duration(days: 140)),
          breed: "Rhode Island Red",
          costPerBird: 15000,
          currentAge: 20,
        );
      });
    }

    // Load egg records
    final eggJson = prefs.getString('eggRecords');
    if (eggJson != null) {
      final eggList = jsonDecode(eggJson) as List<dynamic>;
      setState(() {
        eggRecords = eggList
            .map((e) => EggRecord(
                  traysCollected: e['traysCollected'].toDouble(),
                  costPerTray: e['costPerTray'].toDouble(),
                  eggsPerTray: e['eggsPerTray'],
                  date: DateTime.parse(e['date']),
                  notes: e['notes'],
                ))
            .toList();
      });
    }

    // Load feed records
    final feedJson = prefs.getString('feedRecords');
    if (feedJson != null) {
      final feedList = jsonDecode(feedJson) as List<dynamic>;
      setState(() {
        feedRecords = feedList
            .map((e) => FeedRecord(
                  feedType: e['feedType'],
                  quantity: e['quantity'].toDouble(),
                  cost: e['cost'].toDouble(),
                  date: DateTime.parse(e['date']),
                  supplier: e['supplier'],
                  notes: e['notes'],
                ))
            .toList();
      });
    }

    // Load medication records
    final medJson = prefs.getString('medicationRecords');
    if (medJson != null) {
      final medList = jsonDecode(medJson) as List<dynamic>;
      setState(() {
        medicationRecords = medList
            .map((e) => MedicationRecord(
                  medicationName: e['medicationName'],
                  type: e['type'],
                  dosage: e['dosage'],
                  cost: e['cost'].toDouble(),
                  date: DateTime.parse(e['date']),
                  administrationMethod: e['administrationMethod'],
                  veterinarian: e['veterinarian'],
                  notes: e['notes'],
                ))
            .toList();
      });
    }

    // Load material records
    final matJson = prefs.getString('materialRecords');
    if (matJson != null) {
      final matList = jsonDecode(matJson) as List<dynamic>;
      setState(() {
        materialRecords = matList
            .map((e) => MaterialRecord(
                  materialName: e['materialName'],
                  quantity: e['quantity'].toDouble(),
                  unit: e['unit'],
                  cost: e['cost'].toDouble(),
                  date: DateTime.parse(e['date']),
                  category: e['category'],
                  supplier: e['supplier'],
                ))
            .toList();
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save flock info
    if (flockInfo != null) {
      final flockMap = {
        'totalBirds': flockInfo!.totalBirds,
        'dateAcquired': flockInfo!.dateAcquired.toIso8601String(),
        'breed': flockInfo!.breed,
        'costPerBird': flockInfo!.costPerBird,
        'currentAge': flockInfo!.currentAge,
      };
      await prefs.setString('flockInfo', jsonEncode(flockMap));
    }

    // Save egg records
    final eggList = eggRecords
        .map((e) => {
              'traysCollected': e.traysCollected,
              'costPerTray': e.costPerTray,
              'eggsPerTray': e.eggsPerTray,
              'date': e.date.toIso8601String(),
              'notes': e.notes,
            })
        .toList();
    await prefs.setString('eggRecords', jsonEncode(eggList));

    // Save feed records
    final feedList = feedRecords
        .map((e) => {
              'feedType': e.feedType,
              'quantity': e.quantity,
              'cost': e.cost,
              'date': e.date.toIso8601String(),
              'supplier': e.supplier,
              'notes': e.notes,
            })
        .toList();
    await prefs.setString('feedRecords', jsonEncode(feedList));

    // Save medication records
    final medList = medicationRecords
        .map((e) => {
              'medicationName': e.medicationName,
              'type': e.type,
              'dosage': e.dosage,
              'cost': e.cost,
              'date': e.date.toIso8601String(),
              'administrationMethod': e.administrationMethod,
              'veterinarian': e.veterinarian,
              'notes': e.notes,
            })
        .toList();
    await prefs.setString('medicationRecords', jsonEncode(medList));

    // Save material records
    final matList = materialRecords
        .map((e) => {
              'materialName': e.materialName,
              'quantity': e.quantity,
              'unit': e.unit,
              'cost': e.cost,
              'date': e.date.toIso8601String(),
              'category': e.category,
              'supplier': e.supplier,
            })
        .toList();
    await prefs.setString('materialRecords', jsonEncode(matList));

    print("Data saved successfully!");
  }

  Widget _buildSummaryCard(String title, String value, String subtitle, Color bgColor, Color iconColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.2),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (subtitle.isNotEmpty)
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, IconData icon, Color color, DateTime date) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Text(
        DateFormat('dd/MM/yyyy').format(date),
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }

  Widget _buildRecentActivities() {
    List<ActivityItem> allActivities = [];

    // Add all activities
    for (var egg in eggRecords) {
      allActivities.add(
        ActivityItem(
          title: "Egg Collection",
          subtitle: "${egg.traysCollected.toStringAsFixed(1)} trays (${egg.totalEggs.toStringAsFixed(0)} eggs) - UGX ${egg.totalRevenue.toStringAsFixed(0)}",
          icon: Icons.egg,
          color: Colors.green,
          date: egg.date,
        ),
      );
    }

    for (var feed in feedRecords) {
      allActivities.add(
        ActivityItem(
          title: "Feed: ${feed.feedType}",
          subtitle: "UGX ${feed.cost.toStringAsFixed(0)} - ${feed.quantity}kg",
          icon: Icons.restaurant,
          color: Colors.orange,
          date: feed.date,
        ),
      );
    }

    for (var medication in medicationRecords) {
      allActivities.add(
        ActivityItem(
          title: "${medication.type}: ${medication.medicationName}",
          subtitle: "UGX ${medication.cost.toStringAsFixed(0)} - ${medication.dosage}",
          icon: Icons.medical_services,
          color: Colors.red,
          date: medication.date,
        ),
      );
    }

    for (var material in materialRecords) {
      allActivities.add(
        ActivityItem(
          title: "${material.category}: ${material.materialName}",
          subtitle: "UGX ${material.cost.toStringAsFixed(0)} - ${material.quantity} ${material.unit}",
          icon: Icons.inventory,
          color: Colors.teal,
          date: material.date,
        ),
      );
    }

    allActivities.sort((a, b) => b.date.compareTo(a.date));

    List<Widget> activities = [];
    for (var activity in allActivities.take(8)) {
      activities.add(
        _buildActivityItem(
          activity.title,
          activity.subtitle,
          activity.icon,
          activity.color,
          activity.date,
        ),
      );
    }

    if (activities.isEmpty) {
      activities.add(
        Container(
          padding: const EdgeInsets.all(24),
          child: const Center(
            child: Text(
              "No recent activities\nStart by setting up your flock and adding records",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Activities",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: activities),
        ),
      ],
    );
  }

  void _showSetupFlockDialog() {
    final formKey = GlobalKey<FormState>();
    final totalBirdsController = TextEditingController();
    final breedController = TextEditingController();
    final costPerBirdController = TextEditingController();
    final ageController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    if (flockInfo != null) {
      totalBirdsController.text = flockInfo!.totalBirds.toString();
      breedController.text = flockInfo!.breed;
      costPerBirdController.text = flockInfo!.costPerBird.toString();
      ageController.text = flockInfo!.currentAge.toString();
      selectedDate = flockInfo!.dateAcquired;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(flockInfo == null ? "Setup Flock Information" : "Update Flock Information"),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: totalBirdsController,
                  decoration: const InputDecoration(
                    labelText: "Total Number of Birds",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty == true ? "Please enter number of birds" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: breedController,
                  decoration: const InputDecoration(
                    labelText: "Breed",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty == true ? "Please enter breed" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: costPerBirdController,
                  decoration: const InputDecoration(
                    labelText: "Cost per Bird (UGX)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty == true ? "Please enter cost per bird" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: "Current Age (weeks)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty == true ? "Please enter age" : null,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text("Date Acquired"),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  flockInfo = FlockInfo(
                    totalBirds: int.parse(totalBirdsController.text),
                    breed: breedController.text,
                    costPerBird: double.parse(costPerBirdController.text),
                    currentAge: int.parse(ageController.text),
                    dateAcquired: selectedDate,
                  );
                });
                _saveData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Flock information saved successfully!")),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showAddEggRecordDialog() {
    final formKey = GlobalKey<FormState>();
    final traysController = TextEditingController();
    final costPerTrayController = TextEditingController();
    final eggsPerTrayController = TextEditingController(text: "30");
    final notesController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Record Daily Egg Collection"),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("Collection Date"),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: traysController,
                  decoration: const InputDecoration(
                    labelText: "Trays Collected",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty == true ? "Please enter number of trays" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: eggsPerTrayController,
                  decoration: const InputDecoration(
                    labelText: "Eggs per Tray",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty == true ? "Please enter eggs per tray" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: costPerTrayController,
                  decoration: const InputDecoration(
                    labelText: "Selling Price per Tray (UGX)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty == true ? "Please enter selling price" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: "Notes (optional)",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  eggRecords.add(EggRecord(
                    traysCollected: double.parse(traysController.text),
                    costPerTray: double.parse(costPerTrayController.text),
                    eggsPerTray: int.parse(eggsPerTrayController.text),
                    date: selectedDate,
                    notes: notesController.text.isEmpty ? null : notesController.text,
                  ));
                });
                _saveData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Egg collection recorded successfully!")),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showAddFeedRecordDialog() {
    final formKey = GlobalKey<FormState>();
    final quantityController = TextEditingController();
    final costController = TextEditingController();
    final supplierController = TextEditingController();
    final notesController = TextEditingController();
    String selectedFeedType = 'Layer Mash';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Record Feed Purchase"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text("Purchase Date"),
                    subtitle: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setDialogState(() => selectedDate = date);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedFeedType,
                    decoration: const InputDecoration(
                      labelText: "Feed Type",
                      border: OutlineInputBorder(),
                    ),
                    items: ['Layer Mash', 'Layer Crumble', 'Layer Pellets', 'Grower Feed', 'Starter Feed', 'Concentrate']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) => setDialogState(() => selectedFeedType = value!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      labelText: "Quantity (kg)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty == true ? "Please enter quantity" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: costController,
                    decoration: const InputDecoration(
                      labelText: "Total Cost (UGX)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty == true ? "Please enter cost" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: supplierController,
                    decoration: const InputDecoration(
                      labelText: "Supplier (optional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: "Notes (optional)",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    feedRecords.add(FeedRecord(
                      feedType: selectedFeedType,
                      quantity: double.parse(quantityController.text),
                      cost: double.parse(costController.text),
                      date: selectedDate,
                      supplier: supplierController.text.isEmpty ? null : supplierController.text,
                      notes: notesController.text.isEmpty ? null : notesController.text,
                    ));
                  });
                  _saveData();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Feed record added successfully!")),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMedicationDialog() {
    final formKey = GlobalKey<FormState>();
    final medicationNameController = TextEditingController();
    final dosageController = TextEditingController();
    final costController = TextEditingController();
    final veterinarianController = TextEditingController();
    final notesController = TextEditingController();
    String selectedType = 'Vaccine';
    String selectedMethod = 'Drinking Water';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Record Medication/Vaccination"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text("Administration Date"),
                    subtitle: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setDialogState(() => selectedDate = date);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: const InputDecoration(
                      labelText: "Type",
                      border: OutlineInputBorder(),
                    ),
                    items: ['Vaccine', 'Antibiotic', 'Vitamin/Supplement', 'Deworming', 'Probiotic']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) => setDialogState(() => selectedType = value!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: medicationNameController,
                    decoration: const InputDecoration(
                      labelText: "Medication/Vaccine Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty == true ? "Please enter medication name" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: dosageController,
                    decoration: const InputDecoration(
                      labelText: "Dosage (e.g., 1ml per bird, 1g per liter)",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty == true ? "Please enter dosage" : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedMethod,
                    decoration: const InputDecoration(
                      labelText: "Administration Method",
                      border: OutlineInputBorder(),
                    ),
                    items: ['Drinking Water', 'Feed Mix', 'Injection', 'Spray', 'Eye/Nasal Drop']
                        .map((method) => DropdownMenuItem(value: method, child: Text(method)))
                        .toList(),
                    onChanged: (value) => setDialogState(() => selectedMethod = value!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: costController,
                    decoration: const InputDecoration(
                      labelText: "Total Cost (UGX)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty == true ? "Please enter cost" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: veterinarianController,
                    decoration: const InputDecoration(
                      labelText: "Veterinarian (optional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: "Notes (optional)",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    medicationRecords.add(MedicationRecord(
                      medicationName: medicationNameController.text,
                      type: selectedType,
                      dosage: dosageController.text,
                      cost: double.parse(costController.text),
                      date: selectedDate,
                      administrationMethod: selectedMethod,
                      veterinarian: veterinarianController.text.isEmpty ? null : veterinarianController.text,
                      notes: notesController.text.isEmpty ? null : notesController.text,
                    ));
                  });
                  _saveData();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Medication record added successfully!")),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMaterialDialog() {
    final formKey = GlobalKey<FormState>();
    final materialNameController = TextEditingController();
    final quantityController = TextEditingController();
    final unitController = TextEditingController();
    final costController = TextEditingController();
    final supplierController = TextEditingController();
    String selectedCategory = 'Equipment';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Add Material/Equipment"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text("Purchase Date"),
                    subtitle: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setDialogState(() => selectedDate = date);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),
                    items: ['Equipment', 'Bedding', 'Cleaning Supplies', 'Construction Materials', 'Other']
                        .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                        .toList(),
                    onChanged: (value) => setDialogState(() => selectedCategory = value!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: materialNameController,
                    decoration: const InputDecoration(
                      labelText: "Material Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty == true ? "Please enter material name" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty == true ? "Please enter quantity" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: unitController,
                    decoration: const InputDecoration(
                      labelText: "Unit (e.g., pieces, bags, liters)",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty == true ? "Please enter unit" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: costController,
                    decoration: const InputDecoration(
                      labelText: "Total Cost (UGX)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty == true ? "Please enter cost" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: supplierController,
                    decoration: const InputDecoration(
                      labelText: "Supplier (optional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    materialRecords.add(MaterialRecord(
                      materialName: materialNameController.text,
                      quantity: double.parse(quantityController.text),
                      unit: unitController.text,
                      cost: double.parse(costController.text),
                      date: selectedDate,
                      category: selectedCategory,
                      supplier: supplierController.text.isEmpty ? null : supplierController.text,
                    ));
                  });
                  _saveData();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Material record added successfully!")),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Layer Farm Dashboard"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveData,
            tooltip: "Save Data",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flock Info Section
            const Text(
              "Flock Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              "Flock Size",
              flockInfo != null ? "${flockInfo!.totalBirds} birds" : "Not set",
              flockInfo != null ? "Breed: ${flockInfo!.breed}" : "Tap to setup flock",
              Colors.blue[50]!,
              Colors.blue,
              Icons.group,
            ),
            const SizedBox(height: 16),
            // Summary Cards
            const Text(
              "Performance Summary",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              "Total Egg Trays",
              totalEggTrays.toStringAsFixed(1),
              "${totalEggs.toStringAsFixed(0)} eggs",
              Colors.green[50]!,
              Colors.green,
              Icons.egg,
            ),
            const SizedBox(height: 12),
            _buildSummaryCard(
              "Egg Production Rate",
              "${eggProductionPercentage.toStringAsFixed(1)}%",
              "Avg. ${averageDailyEggs.toStringAsFixed(1)} eggs/day",
              Colors.purple[50]!,
              Colors.purple,
              Icons.trending_up,
            ),
            const SizedBox(height: 12),
            _buildSummaryCard(
              "Total Revenue",
              "UGX ${totalEggRevenue.toStringAsFixed(0)}",
              "From egg sales",
              Colors.teal[50]!,
              Colors.teal,
              Icons.monetization_on,
            ),
            const SizedBox(height: 12),
            _buildSummaryCard(
              "Operating Costs",
              "UGX ${totalOperatingCosts.toStringAsFixed(0)}",
              "Feed: ${totalFeedCost.toStringAsFixed(0)}, Meds: ${totalMedicationCost.toStringAsFixed(0)}",
              Colors.orange[50]!,
              Colors.orange,
              Icons.money_off,
            ),
            const SizedBox(height: 12),
            _buildSummaryCard(
              "Net Profit",
              "UGX ${netProfit.toStringAsFixed(0)}",
              "Revenue - Costs",
              netProfit >= 0 ? Colors.green[50]! : Colors.red[50]!,
              netProfit >= 0 ? Colors.green : Colors.red,
              Icons.account_balance_wallet,
            ),
            const SizedBox(height: 24),
            // Recent Activities
            _buildRecentActivities(),
            const SizedBox(height: 24),
            // Action Buttons
            const Text(
              "Add Records",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _showSetupFlockDialog,
                  icon: const Icon(Icons.group),
                  label: const Text("Setup/Update Flock"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddEggRecordDialog,
                  icon: const Icon(Icons.egg),
                  label: const Text("Add Egg Collection"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddFeedRecordDialog,
                  icon: const Icon(Icons.restaurant),
                  label: const Text("Add Feed Purchase"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddMedicationDialog,
                  icon: const Icon(Icons.medical_services),
                  label: const Text("Add Medication"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddMaterialDialog,
                  icon: const Icon(Icons.inventory),
                  label: const Text("Add Material"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}