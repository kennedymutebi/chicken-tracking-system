import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

// Data Models
class ChickBatch {
  final String batchName;
  final int quantity;
  final double purchaseCost;
  final DateTime dateAdded;

  ChickBatch({
    required this.batchName,
    required this.quantity,
    required this.purchaseCost,
    required this.dateAdded,
  });

  Map<String, dynamic> toJson() => {
        'batchName': batchName,
        'quantity': quantity,
        'purchaseCost': purchaseCost,
        'dateAdded': dateAdded.toIso8601String(),
      };

  factory ChickBatch.fromJson(Map<String, dynamic> json) => ChickBatch(
        batchName: json['batchName'] as String,
        quantity: json['quantity'] as int,
        purchaseCost: (json['purchaseCost'] as num).toDouble(),
        dateAdded: DateTime.parse(json['dateAdded'] as String),
      );
}

class FeedRecord {
  final String feedType;
  final double quantity;
  final double cost;
  final DateTime date;

  FeedRecord({
    required this.feedType,
    required this.quantity,
    required this.cost,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'feedType': feedType,
        'quantity': quantity,
        'cost': cost,
        'date': date.toIso8601String(),
      };

  factory FeedRecord.fromJson(Map<String, dynamic> json) => FeedRecord(
        feedType: json['feedType'] as String,
        quantity: (json['quantity'] as num).toDouble(),
        cost: (json['cost'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
      );
}

class SaleRecord {
  final int quantity;
  final double pricePerBird;
  final DateTime date;

  SaleRecord({
    required this.quantity,
    required this.pricePerBird,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'pricePerBird': pricePerBird,
        'date': date.toIso8601String(),
      };

  factory SaleRecord.fromJson(Map<String, dynamic> json) => SaleRecord(
        quantity: json['quantity'] as int,
        pricePerBird: (json['pricePerBird'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
      );
}

class MaterialRecord {
  final String materialName;
  final double quantity;
  final String unit;
  final double cost;
  final DateTime date;

  MaterialRecord({
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.cost,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'materialName': materialName,
        'quantity': quantity,
        'unit': unit,
        'cost': cost,
        'date': date.toIso8601String(),
      };

  factory MaterialRecord.fromJson(Map<String, dynamic> json) => MaterialRecord(
        materialName: json['materialName'] as String,
        quantity: (json['quantity'] as num).toDouble(),
        unit: json['unit'] as String,
        cost: (json['cost'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
      );
}

class MortalityRecord {
  final int quantity;
  final String cause;
  final DateTime date;

  MortalityRecord({
    required this.quantity,
    required this.cause,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'cause': cause,
        'date': date.toIso8601String(),
      };

  factory MortalityRecord.fromJson(Map<String, dynamic> json) => MortalityRecord(
        quantity: json['quantity'] as int,
        cause: json['cause'] as String,
        date: DateTime.parse(json['date'] as String),
      );
}

class VaccineRecord {
  final String vaccineName;
  final double cost;
  final String dosage;
  final DateTime date;

  VaccineRecord({
    required this.vaccineName,
    required this.cost,
    required this.dosage,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'vaccineName': vaccineName,
        'cost': cost,
        'dosage': dosage,
        'date': date.toIso8601String(),
      };

  factory VaccineRecord.fromJson(Map<String, dynamic> json) => VaccineRecord(
        vaccineName: json['vaccineName'] as String,
        cost: (json['cost'] as num).toDouble(),
        dosage: json['dosage'] as String,
        date: DateTime.parse(json['date'] as String),
      );
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Broiler Management',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const BroilersDashboard(),
    );
  }
}

class BroilersDashboard extends StatefulWidget {
  const BroilersDashboard({super.key});

  @override
  State<BroilersDashboard> createState() => _BroilersDashboardState();
}

class _BroilersDashboardState extends State<BroilersDashboard> {
  List<ChickBatch> chickBatches = [];
  List<FeedRecord> feedRecords = [];
  List<SaleRecord> salesRecords = [];
  List<MaterialRecord> materialRecords = [];
  List<MortalityRecord> mortalityRecords = [];
  List<VaccineRecord> vaccineRecords = [];
  bool _isLoading = true;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);

      // Load Chick Batches
      final chickSnapshot = await _firestore.collection('chickBatches').get();
      final chickBatchesData = chickSnapshot.docs
          .map((doc) => ChickBatch.fromJson(doc.data()))
          .toList();

      // Load Feed Records
      final feedSnapshot = await _firestore.collection('feedRecords').get();
      final feedRecordsData = feedSnapshot.docs
          .map((doc) => FeedRecord.fromJson(doc.data()))
          .toList();

      // Load Sales Records
      final salesSnapshot = await _firestore.collection('salesRecords').get();
      final salesRecordsData = salesSnapshot.docs
          .map((doc) => SaleRecord.fromJson(doc.data()))
          .toList();

      // Load Material Records
      final materialSnapshot = await _firestore.collection('materialRecords').get();
      final materialRecordsData = materialSnapshot.docs
          .map((doc) => MaterialRecord.fromJson(doc.data()))
          .toList();

      // Load Mortality Records
      final mortalitySnapshot = await _firestore.collection('mortalityRecords').get();
      final mortalityRecordsData = mortalitySnapshot.docs
          .map((doc) => MortalityRecord.fromJson(doc.data()))
          .toList();

      // Load Vaccine Records
      final vaccineSnapshot = await _firestore.collection('vaccineRecords').get();
      final vaccineRecordsData = vaccineSnapshot.docs
          .map((doc) => VaccineRecord.fromJson(doc.data()))
          .toList();

      setState(() {
        chickBatches = chickBatchesData;
        feedRecords = feedRecordsData;
        salesRecords = salesRecordsData;
        materialRecords = materialRecordsData;
        mortalityRecords = mortalityRecordsData;
        vaccineRecords = vaccineRecordsData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error loading data from Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> _saveData() async {
    try {
      // Create a Firestore batch
      final batch = _firestore.batch();

      // Save Chick Batches
      final chickCollection = _firestore.collection('chickBatches');
      await chickCollection.get().then((snapshot) {
        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
      });
      for (var chick in chickBatches) {
        batch.set(chickCollection.doc(), chick.toJson());
      }

      // Save Feed Records
      final feedCollection = _firestore.collection('feedRecords');
      await feedCollection.get().then((snapshot) {
        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
      });
      for (var feed in feedRecords) {
        batch.set(feedCollection.doc(), feed.toJson());
      }

      // Save Sales Records
      final salesCollection = _firestore.collection('salesRecords');
      await salesCollection.get().then((snapshot) {
        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
      });
      for (var sale in salesRecords) {
        batch.set(salesCollection.doc(), sale.toJson());
      }

      // Save Material Records
      final materialCollection = _firestore.collection('materialRecords');
      await materialCollection.get().then((snapshot) {
        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
      });
      for (var material in materialRecords) {
        batch.set(materialCollection.doc(), material.toJson());
      }

      // Save Mortality Records
      final mortalityCollection = _firestore.collection('mortalityRecords');
      await mortalityCollection.get().then((snapshot) {
        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
      });
      for (var mortality in mortalityRecords) {
        batch.set(mortalityCollection.doc(), mortality.toJson());
      }

      // Save Vaccine Records
      final vaccineCollection = _firestore.collection('vaccineRecords');
      await vaccineCollection.get().then((snapshot) {
        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
      });
      for (var vaccine in vaccineRecords) {
        batch.set(vaccineCollection.doc(), vaccine.toJson());
      }

      // Commit the batch
      await batch.commit();
    } catch (e) {
      debugPrint('Error saving data to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  double get totalExpenses {
    double feedCosts = feedRecords.fold(0.0, (sum, record) => sum + record.cost);
    double chickCosts = chickBatches.fold(0.0, (sum, batch) => sum + batch.purchaseCost);
    double materialCosts = materialRecords.fold(0.0, (sum, record) => sum + record.cost);
    double vaccineCosts = vaccineRecords.fold(0.0, (sum, record) => sum + record.cost);
    return feedCosts + chickCosts + materialCosts + vaccineCosts;
  }

  double get totalRevenue {
    return salesRecords.fold(0.0, (sum, sale) => sum + (sale.quantity * sale.pricePerBird));
  }

  double get totalProfit => totalRevenue - totalExpenses;

  int get totalLiveBirds {
    int totalChicks = chickBatches.fold(0, (sum, batch) => sum + batch.quantity);
    int totalSold = salesRecords.fold(0, (sum, sale) => sum + sale.quantity);
    int totalMortality = mortalityRecords.fold(0, (sum, mortality) => sum + mortality.quantity);
    return totalChicks - totalSold - totalMortality;
  }

  double get mortalityRate {
    int totalChicks = chickBatches.fold(0, (sum, batch) => sum + batch.quantity);
    int totalMortality = mortalityRecords.fold(0, (sum, mortality) => sum + mortality.quantity);
    return totalChicks > 0 ? (totalMortality / totalChicks) * 100 : 0.0;
  }

  void _showAddChickBatchDialog() {
    final formKey = GlobalKey<FormState>();
    final batchNameController = TextEditingController();
    final quantityController = TextEditingController();
    final costController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Chick Batch"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: batchNameController,
                decoration: const InputDecoration(
                  labelText: "Batch Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? "Please enter batch name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: "Number of Chicks",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty == true ? "Please enter quantity" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: costController,
                decoration: const InputDecoration(
                  labelText: "Purchase Cost (UGX)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty == true ? "Please enter cost" : null,
              ),
            ],
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
                  chickBatches.add(ChickBatch(
                    batchName: batchNameController.text,
                    quantity: int.parse(quantityController.text),
                    purchaseCost: double.parse(costController.text),
                    dateAdded: DateTime.now(),
                  ));
                });
                _saveData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Chick batch added successfully!")),
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
    String selectedFeedType = 'Starter';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Record Feeding"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedFeedType,
                  decoration: const InputDecoration(
                    labelText: "Feed Type",
                    border: OutlineInputBorder(),
                  ),
                  items: ['Starter', 'Grower', 'Finisher']
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
              ],
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
                      date: DateTime.now(),
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

  void _showAddMaterialDialog() {
    final formKey = GlobalKey<FormState>();
    final materialNameController = TextEditingController();
    final quantityController = TextEditingController();
    final unitController = TextEditingController();
    final costController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Brooding Material"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  labelText: "Unit (e.g., kg, liters)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? "Please enter unit" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: costController,
                decoration: const InputDecoration(
                  labelText: "Cost (UGX)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty == true ? "Please enter cost" : null,
              ),
            ],
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
                    date: DateTime.now(),
                  ));
                });
                _saveData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Material added successfully!")),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showAddSaleDialog() {
    final formKey = GlobalKey<FormState>();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Record Sale"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: "Number of Birds Sold",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty == true) return "Please enter quantity";
                  final qty = int.tryParse(value!);
                  if (qty == null || qty <= 0) return "Enter a valid number";
                  if (qty > totalLiveBirds) return "Cannot exceed $totalLiveBirds live birds";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: "Price per Bird (UGX)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty == true ? "Please enter price" : null,
              ),
            ],
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
                  salesRecords.add(SaleRecord(
                    quantity: int.parse(quantityController.text),
                    pricePerBird: double.parse(priceController.text),
                    date: DateTime.now(),
                  ));
                });
                _saveData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sale recorded successfully!")),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showAddMortalityDialog() {
    final formKey = GlobalKey<FormState>();
    final quantityController = TextEditingController();
    final causeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Record Mortality"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: "Number of Birds",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty == true) return "Please enter quantity";
                  final qty = int.tryParse(value!);
                  if (qty == null || qty <= 0) return "Enter a valid number";
                  if (qty > totalLiveBirds) return "Cannot exceed $totalLiveBirds live birds";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: causeController,
                decoration: const InputDecoration(
                  labelText: "Cause of Mortality",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? "Please enter cause" : null,
              ),
            ],
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
                  mortalityRecords.add(MortalityRecord(
                    quantity: int.parse(quantityController.text),
                    cause: causeController.text,
                    date: DateTime.now(),
                  ));
                });
                _saveData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mortality recorded successfully!")),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showAddVaccineDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final costController = TextEditingController();
    final dosageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Record Vaccination"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Vaccine Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? "Please enter vaccine name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: costController,
                decoration: const InputDecoration(
                  labelText: "Cost (UGX)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty == true ? "Please enter cost" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dosageController,
                decoration: const InputDecoration(
                  labelText: "Dosage",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? "Please enter dosage" : null,
              ),
            ],
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
                  vaccineRecords.add(VaccineRecord(
                    vaccineName: nameController.text,
                    cost: double.parse(costController.text),
                    dosage: dosageController.text,
                    date: DateTime.now(),
                  ));
                });
                _saveData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Vaccine recorded successfully!")),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showDetailedAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Detailed Analysis"),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Financial Breakdown",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  "Total Chick Costs",
                  "UGX ${chickBatches.fold(0.0, (sum, batch) => sum + batch.purchaseCost).toStringAsFixed(0)}",
                  Colors.blue.shade100,
                  Colors.blue.shade700,
                  Icons.pets,
                ),
                const SizedBox(height: 12),
                _buildSummaryCard(
                  "Total Feed Costs",
                  "UGX ${feedRecords.fold(0.0, (sum, record) => sum + record.cost).toStringAsFixed(0)}",
                  Colors.orange.shade100,
                  Colors.orange.shade700,
                  Icons.restaurant,
                ),
                const SizedBox(height: 12),
                _buildSummaryCard(
                  "Total Material Costs",
                  "UGX ${materialRecords.fold(0.0, (sum, record) => sum + record.cost).toStringAsFixed(0)}",
                  Colors.teal.shade100,
                  Colors.teal.shade400,
                  Icons.inventory,
                ),
                const SizedBox(height: 12),
                _buildSummaryCard(
                  "Total Vaccine Costs",
                  "UGX ${vaccineRecords.fold(0.0, (sum, record) => sum + record.cost).toStringAsFixed(0)}",
                  Colors.indigo.shade100,
                  Colors.indigo.shade700,
                  Icons.medical_services,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Inventory",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text("Active Batches: ${chickBatches.length}"),
                  subtitle: Text("Total Live Birds: $totalLiveBirds"),
                  leading: Icon(Icons.group, color: Colors.purple.shade700),
                ),
                ListTile(
                  title: Text("Mortality Rate: ${mortalityRate.toStringAsFixed(1)}%"),
                  subtitle: Text("Total Mortality: ${mortalityRecords.fold(0, (sum, record) => sum + record.quantity)}"),
                  leading: Icon(Icons.warning, color: Colors.yellow.shade700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHealthRecords() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Health Records"),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...mortalityRecords.map((record) => ListTile(
                      title: Text("Mortality: ${record.quantity} birds"),
                      subtitle: Text(
                          "Cause: ${record.cause} - ${record.date.toString().substring(0, 10)}"),
                      leading: Icon(Icons.warning, color: Colors.red.shade700),
                    )),
                ...vaccineRecords.map((record) => ListTile(
                      title: Text("Vaccine: ${record.vaccineName}"),
                      subtitle: Text(
                          "Dosage: ${record.dosage} - ${record.date.toString().substring(0, 10)}"),
                      leading: Icon(Icons.medical_services, color: Colors.indigo.shade700),
                    )),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear All Data"),
        content: const Text("Are you sure you want to clear all data? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () async {
              try {
                setState(() {
                  chickBatches.clear();
                  feedRecords.clear();
                  salesRecords.clear();
                  materialRecords.clear();
                  mortalityRecords.clear();
                  vaccineRecords.clear();
                });

                // Clear Firestore collections
                final collections = [
                  'chickBatches',
                  'feedRecords',
                  'salesRecords',
                  'materialRecords',
                  'mortalityRecords',
                  'vaccineRecords'
                ];

                final batch = _firestore.batch();
                for (var collection in collections) {
                  final snapshot = await _firestore.collection(collection).get();
                  for (var doc in snapshot.docs) {
                    batch.delete(doc.reference);
                  }
                }
                await batch.commit();

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All data cleared!")),
                );
              } catch (e) {
                debugPrint('Error clearing data: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error clearing data: $e')),
                );
              }
            },
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    final data = {
      'chick_batches': chickBatches.map((e) => e.toJson()).toList(),
      'feed_records': feedRecords.map((e) => e.toJson()).toList(),
      'sales_records': salesRecords.map((e) => e.toJson()).toList(),
      'material_records': materialRecords.map((e) => e.toJson()).toList(),
      'mortality_records': mortalityRecords.map((e) => e.toJson()).toList(),
      'vaccine_records': vaccineRecords.map((e) => e.toJson()).toList(),
    };

    final jsonString = jsonEncode(data);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Export Data"),
        content: SingleChildScrollView(
          child: Text(jsonString),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Broiler Management Dashboard"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'export':
                  _exportData();
                  break;
                case 'clear':
                  _showClearDataDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Export Data'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Clear All Data', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCards(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildChartsSection(),
              const SizedBox(height: 24),
              _buildRecentActivities(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Financial Overview",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                "Total Expenses",
                "UGX ${totalExpenses.toStringAsFixed(0)}",
                Colors.red.shade100,
                Colors.red.shade700,
                Icons.trending_down,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                "Total Revenue",
                "UGX ${totalRevenue.toStringAsFixed(0)}",
                Colors.blue.shade100,
                Colors.blue.shade700,
                Icons.trending_up,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                "Net Profit",
                "UGX ${totalProfit.toStringAsFixed(0)}",
                totalProfit >= 0 ? Colors.green.shade100 : Colors.red.shade100,
                totalProfit >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                totalProfit >= 0 ? Icons.attach_money : Icons.money_off,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                "Live Birds",
                "$totalLiveBirds",
                Colors.orange.shade100,
                Colors.orange.shade700,
                Icons.pets,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                "Active Batches",
                "${chickBatches.length}",
                Colors.purple.shade100,
                Colors.purple.shade700,
                Icons.group,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                "Mortality Rate",
                "${mortalityRate.toStringAsFixed(1)}%",
                Colors.yellow.shade100,
                Colors.yellow.shade700,
                Icons.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      String title, String value, Color bgColor, Color textColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.2,
          children: [
            _buildActionButton(
              "Add Chick Batch",
              Icons.add_circle,
              Colors.green,
              _showAddChickBatchDialog,
            ),
            _buildActionButton(
              "Record Feeding",
              Icons.restaurant,
              Colors.orange,
              _showAddFeedRecordDialog,
            ),
            _buildActionButton(
              "Add Materials",
              Icons.inventory,
              Colors.teal,
              _showAddMaterialDialog,
            ),
            _buildActionButton(
              "Record Sale",
              Icons.sell,
              Colors.blue,
              _showAddSaleDialog,
            ),
            _buildActionButton(
              "Record Mortality",
              Icons.warning,
              Colors.red,
              _showAddMortalityDialog,
            ),
            _buildActionButton(
              "Record Vaccine",
              Icons.medical_services,
              Colors.indigo,
              _showAddVaccineDialog,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                "View Details",
                Icons.analytics,
                Colors.purple,
                _showDetailedAnalysis,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                "Health Records",
                Icons.health_and_safety,
                Colors.pink,
                _showHealthRecords,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection() {
    if (feedRecords.isEmpty && salesRecords.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "No data available for charts\nStart by adding feed records and sales",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Analytics",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(16),
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
                child: _buildProfitChart(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(16),
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
                child: _buildBirdStatusChart(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildProfitChart() {
    if (totalExpenses == 0 && totalRevenue == 0) {
      return const Center(child: Text("No financial data"));
    }

    return Column(
      children: [
        const Text("Financial Overview", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Expanded(
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: Colors.red.shade400,
                  value: totalExpenses,
                  title:
                      'Expenses\n${(totalExpenses / (totalExpenses + totalRevenue) * 100).toStringAsFixed(0)}%',
                  radius: 50,
                  titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                if (totalRevenue > 0)
                  PieChartSectionData(
                    color: Colors.green.shade400,
                    value: totalRevenue,
                    title:
                        'Revenue\n${(totalRevenue / (totalExpenses + totalRevenue) * 100).toStringAsFixed(0)}%',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
              ],
              centerSpaceRadius: 30,
              sectionsSpace: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBirdStatusChart() {
    int totalChicks = chickBatches.fold(0, (sum, batch) => sum + batch.quantity);
    int totalSold = salesRecords.fold(0, (sum, sale) => sum + sale.quantity);
    int totalMortality = mortalityRecords.fold(0, (sum, mortality) => sum + mortality.quantity);

    if (totalChicks == 0) {
      return const Center(child: Text("No bird data"));
    }

    return Column(
      children: [
        const Text("Bird Status", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Expanded(
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: Colors.green.shade400,
                  value: totalLiveBirds.toDouble(),
                  title: 'Live\n$totalLiveBirds',
                  radius: 50,
                  titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                if (totalSold > 0)
                  PieChartSectionData(
                    color: Colors.blue.shade400,
                    value: totalSold.toDouble(),
                    title: 'Sold\n$totalSold',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                if (totalMortality > 0)
                  PieChartSectionData(
                    color: Colors.red.shade400,
                    value: totalMortality.toDouble(),
                    title: 'Mortality\n$totalMortality',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
              ],
              centerSpaceRadius: 30,
              sectionsSpace: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivities() {
    List<Widget> activities = [];
    List<ActivityItem> allActivities = [];

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

    for (var material in materialRecords) {
      allActivities.add(
        ActivityItem(
          title: "Material: ${material.materialName}",
          subtitle: "UGX ${material.cost.toStringAsFixed(0)} - ${material.quantity} ${material.unit}",
          icon: Icons.inventory,
          color: Colors.teal,
          date: material.date,
        ),
      );
    }

    for (var sale in salesRecords) {
      allActivities.add(
        ActivityItem(
          title: "Sale: ${sale.quantity} birds",
          subtitle: "UGX ${(sale.quantity * sale.pricePerBird).toStringAsFixed(0)}",
          icon: Icons.sell,
          color: Colors.blue,
          date: sale.date,
        ),
      );
    }

    for (var mortality in mortalityRecords) {
      allActivities.add(
        ActivityItem(
          title: "Mortality: ${mortality.quantity} birds",
          subtitle: "Cause: ${mortality.cause}",
          icon: Icons.warning,
          color: Colors.red,
          date: mortality.date,
        ),
      );
    }

    for (var vaccine in vaccineRecords) {
      allActivities.add(
        ActivityItem(
          title: "Vaccine: ${vaccine.vaccineName}",
          subtitle: "UGX ${vaccine.cost.toStringAsFixed(0)} - ${vaccine.dosage}",
          icon: Icons.medical_services,
          color: Colors.indigo,
          date: vaccine.date,
        ),
      );
    }

    allActivities.sort((a, b) => b.date.compareTo(a.date));

    for (var activity in allActivities.take(5)) {
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
              "No recent activities\nStart by adding records",
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

  Widget _buildActivityItem(
      String title, String subtitle, IconData icon, Color color, DateTime date) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Text(
        "${date.day}/${date.month}/${date.year}",
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}