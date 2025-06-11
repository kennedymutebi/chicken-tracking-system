import 'package:flutter/material.dart';

// Disease Model
class Disease {
  final String name;
  final List<String> symptoms;
  final List<String> signs;
  final List<String> imagePaths;
  final List<String> medications;
  final String description;

  Disease({
    required this.name,
    required this.symptoms,
    required this.signs,
    required this.imagePaths,
    required this.medications,
    required this.description,
  });
}

// Behavior Model with images
class BehaviorItem {
  final String name;
  final String imagePath;
  final String description;
  final List<String> relatedSymptoms;

  BehaviorItem({
    required this.name,
    required this.imagePath,
    required this.description,
    required this.relatedSymptoms,
  });
}

// Dashboard Test Item
class TestItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  TestItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

// Diagnosis Result Model
class DiagnosisResult {
  final Disease disease;
  final double probability;
  final List<String> matchedSymptoms;

  DiagnosisResult({
    required this.disease,
    required this.probability,
    required this.matchedSymptoms,
  });
}

// Enhanced Database Service
class DiseaseDatabase {
  static List<Disease> diseases = [
    Disease(
      name: "Newcastle Disease",
      symptoms: [
        "Drooping wings",
        "Twisted neck",
        "Paralysis of legs",
        "Watery diarrhea",
        "Difficulty breathing",
        "Coughing",
        "Sneezing",
        "Reduced egg production",
        "Lethargy",
        "Loss of appetite",
        "Head tilting",
        "Circling movements",
        "Tremors"
      ],
      signs: [
        "Greenish watery droppings",
        "Swollen head and neck",
        "Gasping for air",
        "Tremors or convulsions",
        "Circling movements"
      ],
      imagePaths: [
        "assets/images/newcastle_1.jpg",
        "assets/images/newcastle_2.jpg",
        "assets/images/newcastle_3.jpg",
        "assets/images/newcastle_4.jpg",
        "assets/images/newcastle_5.jpg",
        "assets/images/newcastle_6.jpg"
      ],
      medications: [
        "No specific treatment - supportive care",
        "Antibiotics to prevent secondary infections",
        "Vitamin supplements",
        "Electrolyte solutions",
        "Vaccination for prevention"
      ],
      description: "Highly contagious viral disease affecting respiratory, nervous, and digestive systems."
    ),
    Disease(
      name: "Fowl Pox",
      symptoms: [
        "Scabs on comb and wattles",
        "White spots in mouth",
        "Difficulty swallowing",
        "Reduced egg production",
        "Lethargy",
        "Loss of appetite",
        "Breathing difficulties",
        "Swollen eyelids"
      ],
      signs: [
        "Warty growths on skin",
        "Yellow lesions in mouth",
        "Swollen eyelids",
        "Crusty scabs on face"
      ],
      imagePaths: [
        "assets/images/fowl_pox_1.jpg",
        "assets/images/fowl_pox_2.jpg"
      ],
      medications: [
        "No specific treatment",
        "Antiseptic solutions for lesions",
        "Vitamin A supplements",
        "Soft food for affected birds",
        "Vaccination for prevention"
      ],
      description: "Viral disease causing skin lesions and respiratory symptoms."
    ),
    Disease(
      name: "Coccidiosis",
      symptoms: [
        "Bloody diarrhea",
        "Drooping wings",
        "Lethargy",
        "Loss of appetite",
        "Ruffled feathers",
        "Pale comb",
        "Dehydration",
        "Hunched posture",
        "Weakness"
      ],
      signs: [
        "Blood in droppings",
        "Watery droppings",
        "Weakness",
        "Huddling together"
      ],
      imagePaths: [
        "assets/images/coccidiosis_1.jpg",
        "assets/images/coccidiosis_2.jpg"
      ],
      medications: [
        "Anticoccidial drugs (Amprolium)",
        "Sulfonamides",
        "Electrolyte solutions",
        "Vitamin K supplements",
        "Probiotics"
      ],
      description: "Parasitic disease affecting the intestinal tract."
    ),
    Disease(
      name: "Infectious Bronchitis",
      symptoms: [
        "Coughing",
        "Sneezing",
        "Nasal discharge",
        "Watery eyes",
        "Difficulty breathing",
        "Reduced egg production",
        "Soft-shelled eggs",
        "Lethargy",
        "Gasping for air"
      ],
      signs: [
        "Gasping",
        "Head shaking",
        "Mouth breathing",
        "Rattling sounds"
      ],
      imagePaths: [
        "assets/images/infectious_bronchitis_1.jpg",
        "assets/images/infectious_bronchitis_2.jpg"
      ],
      medications: [
        "No specific treatment",
        "Supportive care",
        "Antibiotics for secondary infections",
        "Electrolyte solutions",
        "Vaccination for prevention"
      ],
      description: "Highly contagious respiratory disease caused by coronavirus."
    )
  ];

  static List<BehaviorItem> behaviorItems = [
    BehaviorItem(
      name: "Drooping wings",
      imagePath: "assets/images/chicken_drop_feather.jpg",
      description: "Wings hanging down, not held close to body",
      relatedSymptoms: ["Lethargy", "Weakness", "Loss of appetite"]
    ),
    BehaviorItem(
      name: "Twisted neck",
      imagePath: "assets/images/newcastle_2.jpg",
      description: "Neck bent or twisted to one side",
      relatedSymptoms: ["Head tilting", "Circling movements", "Paralysis of legs"]
    ),
    BehaviorItem(
      name: "Paralysis of legs",
      imagePath: "assets/images/newcastle_3.jpg",
      description: "Unable to stand or walk properly",
      relatedSymptoms: ["Twisted neck", "Weakness", "Tremors"]
    ),
    BehaviorItem(
      name: "Watery diarrhea",
      imagePath: "assets/images/different_diahoria.jpg",
      description: "Loose, watery droppings",
      relatedSymptoms: ["Dehydration", "Lethargy", "Loss of appetite"]
    ),
    BehaviorItem(
      name: "Bloody diarrhea",
      imagePath: "assets/images/blood_diahoria.jpg",
      description: "Blood visible in droppings",
      relatedSymptoms: ["Pale comb", "Weakness", "Dehydration"]
    ),
    BehaviorItem(
      name: "Difficulty breathing",
      imagePath: "assets/images/difficult_breathing.jpg",
      description: "Labored breathing, mouth breathing",
      relatedSymptoms: ["Coughing", "Gasping for air", "Sneezing"]
    ),
    BehaviorItem(
      name: "Coughing",
      imagePath: "assets/images/sneezing.jpg",
      description: "Repeated coughing sounds",
      relatedSymptoms: ["Sneezing", "Difficulty breathing", "Nasal discharge"]
    ),
    BehaviorItem(
      name: "Sneezing",
      imagePath: "assets/images/coughing.jpg",
      description: "Frequent sneezing",
      relatedSymptoms: ["Coughing", "Nasal discharge", "Watery eyes"]
    ),
    BehaviorItem(
      name: "Lethargy",
      imagePath: "assets/images/lactercy.jpg",
      description: "Inactive, sleepy, less movement",
      relatedSymptoms: ["Loss of appetite", "Ruffled feathers", "Hunched posture"]
    ),
    BehaviorItem(
      name: "Loss of appetite",
      imagePath: "assets/images/loss_apetite.jpg",
      description: "Not eating or drinking normally",
      relatedSymptoms: ["Lethargy", "Weight loss", "Weakness"]
    ),
    BehaviorItem(
      name: "Scabs on comb and wattles",
      imagePath: "assets/images/scab.jpg",
      description: "Crusty scabs on head area",
      relatedSymptoms: ["White spots in mouth", "Swollen eyelids", "Difficulty swallowing"]
    ),
    BehaviorItem(
      name: "Ruffled feathers",
      imagePath: "assets/images/ruffed.jpg",
      description: "Feathers standing up, not smooth",
      relatedSymptoms: ["Lethargy", "Hunched posture", "Loss of appetite"]
    ),
    BehaviorItem(
      name: "Pale comb",
      imagePath: "assets/images/palecomb.jpeg",
      description: "Comb appears pale or white",
      relatedSymptoms: ["Weakness", "Bloody diarrhea", "Dehydration"]
    ),
    BehaviorItem(
      name: "Hunched posture",
      imagePath: "assets/images/hunched.jpg",
      description: "Standing with head down, hunched appearance",
      relatedSymptoms: ["Lethargy", "Ruffled feathers", "Weakness"]
    ),
    BehaviorItem(
      name: "Gasping for air",
      imagePath: "assets/images/gasping.jpg",
      description: "Open mouth breathing, struggling for air",
      relatedSymptoms: ["Difficulty breathing", "Coughing", "Head shaking"]
    ),
    BehaviorItem(
      name: "Tremors",
      imagePath: "assets/images/tremor.jpg",
      description: "Shaking or trembling movements",
      relatedSymptoms: ["Twisted neck", "Circling movements", "Paralysis of legs"]
    )
  ];

  static List<DiagnosisResult> diagnose(List<String> selectedSymptoms) {
    List<DiagnosisResult> results = [];

    for (Disease disease in diseases) {
      List<String> matchedSymptoms = [];

      for (String symptom in selectedSymptoms) {
        if (disease.symptoms.contains(symptom)) {
          matchedSymptoms.add(symptom);
        }
      }

      if (matchedSymptoms.isNotEmpty) {
        double probability = (matchedSymptoms.length / disease.symptoms.length) * 100;
        if (matchedSymptoms.length >= 3) {
          probability = (probability * 1.2).clamp(0, 100);
        }

        results.add(DiagnosisResult(
          disease: disease,
          probability: probability,
          matchedSymptoms: matchedSymptoms,
        ));
      }
    }

    results.sort((a, b) => b.probability.compareTo(a.probability));
    return results;
  }
}

// Main Dashboard Screen
class ChickHealthDashboard extends StatefulWidget {
  const ChickHealthDashboard({super.key});

  @override
  State<ChickHealthDashboard> createState() => _ChickHealthDashboardState();
}

class _ChickHealthDashboardState extends State<ChickHealthDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chick Health Dashboard"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.pets, color: Colors.green, size: 30),
                        SizedBox(width: 12),
                        Text(
                          "Welcome to Chick Health Monitor",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Monitor your chicks' health with our comprehensive diagnostic tools and behavior analysis.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              "Quick Health Assessment",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _buildQuickActionCard(
                  "Visual Diagnosis",
                  "Select behaviors you observe",
                  Icons.visibility,
                  Colors.blue,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DiseaseDiagnosisScreen()),
                  ),
                ),
                _buildQuickActionCard(
                  "Behavior Checker",
                  "Test specific behaviors",
                  Icons.psychology,
                  Colors.orange,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BehaviorTestScreen()),
                  ),
                ),
                _buildQuickActionCard(
                  "Health Timeline",
                  "Track health over time",
                  Icons.timeline,
                  Colors.purple,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HealthTimelineScreen()),
                  ),
                ),
                _buildQuickActionCard(
                  "Emergency Guide",
                  "Quick emergency actions",
                  Icons.medical_services,
                  Colors.red,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EmergencyGuideScreen()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Behavior Testing Tools
            const Text(
              "Behavior Testing Tools",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildTestingCard(
              "Movement Test",
              "Test your chick's mobility and coordination",
              Icons.directions_walk,
              Colors.teal,
              () => _showMovementTest(),
            ),
            const SizedBox(height: 12),

            _buildTestingCard(
              "Appetite Test",
              "Check eating and drinking behaviors",
              Icons.restaurant,
              Colors.amber,
              () => _showAppetiteTest(),
            ),
            const SizedBox(height: 12),

            _buildTestingCard(
              "Respiratory Test",
              "Listen and observe breathing patterns",
              Icons.air,
              Colors.lightBlue,
              () => _showRespiratoryTest(),
            ),
            const SizedBox(height: 12),

            _buildTestingCard(
              "Social Behavior Test",
              "Observe interaction with other chicks",
              Icons.group,
              Colors.indigo,
              () => _showSocialTest(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestingCard(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _showMovementTest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Movement Test"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Test your chick's movement:"),
            SizedBox(height: 12),
            Text("1. Place chick on flat surface"),
            Text("2. Observe walking pattern"),
            Text("3. Check for limping or paralysis"),
            Text("4. Note any circling movements"),
            Text("5. Test response to gentle encouragement"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DiseaseDiagnosisScreen()),
              );
            },
            child: const Text("Start Diagnosis"),
          ),
        ],
      ),
    );
  }

  void _showAppetiteTest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Appetite Test"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Test your chick's appetite:"),
            SizedBox(height: 12),
            Text("1. Offer favorite food"),
            Text("2. Check water consumption"),
            Text("3. Note eating speed and amount"),
            Text("4. Observe swallowing difficulties"),
            Text("5. Check for food refusal"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DiseaseDiagnosisScreen()),
              );
            },
            child: const Text("Start Diagnosis"),
          ),
        ],
      ),
    );
  }

  void _showRespiratoryTest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Respiratory Test"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Test breathing patterns:"),
            SizedBox(height: 12),
            Text("1. Listen for unusual sounds"),
            Text("2. Watch breathing rate"),
            Text("3. Check for mouth breathing"),
            Text("4. Note any discharge from nose"),
            Text("5. Observe gasping or wheezing"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DiseaseDiagnosisScreen()),
              );
            },
            child: const Text("Start Diagnosis"),
          ),
        ],
      ),
    );
  }

  void _showSocialTest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Social Behavior Test"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Observe social interactions:"),
            SizedBox(height: 12),
            Text("1. Watch interaction with other chicks"),
            Text("2. Note isolation or huddling"),
            Text("3. Check response to human presence"),
            Text("4. Observe activity level"),
            Text("5. Test alertness to sounds"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DiseaseDiagnosisScreen()),
              );
            },
            child: const Text("Start Diagnosis"),
          ),
        ],
      ),
    );
  }
}

// Enhanced Disease Diagnosis Screen
class DiseaseDiagnosisScreen extends StatefulWidget {
  const DiseaseDiagnosisScreen({super.key});

  @override
  State<DiseaseDiagnosisScreen> createState() => _DiseaseDiagnosisScreenState();
}

class _DiseaseDiagnosisScreenState extends State<DiseaseDiagnosisScreen> {
  List<String> selectedSymptoms = [];
  List<DiagnosisResult> diagnosisResults = [];
  bool showResults = false;

  void toggleSymptom(String symptom) {
    setState(() {
      if (selectedSymptoms.contains(symptom)) {
        selectedSymptoms.remove(symptom);
      } else {
        selectedSymptoms.add(symptom);
      }
    });
  }

  void performDiagnosis() {
    if (selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one behavior")),
      );
      return;
    }

    setState(() {
      diagnosisResults = DiseaseDatabase.diagnose(selectedSymptoms);
      showResults = true;
    });
  }

  void resetDiagnosis() {
    setState(() {
      selectedSymptoms.clear();
      diagnosisResults.clear();
      showResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visual Behavior Diagnosis"),
        backgroundColor: Colors.blue,
        actions: [
          if (showResults)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: resetDiagnosis,
            ),
        ],
      ),
      body: showResults ? buildResultsView() : buildBehaviorSelectionView(),
    );
  }

  Widget buildBehaviorSelectionView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Behaviors You Observe",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Look at each image and select behaviors that match what you see in your chick:",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                "Selected: ${selectedSymptoms.length} behaviors",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: DiseaseDatabase.behaviorItems.length,
            itemBuilder: (context, index) {
              BehaviorItem behavior = DiseaseDatabase.behaviorItems[index];
              bool isSelected = selectedSymptoms.contains(behavior.name);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                child: Column(
                  children: [
                    // Image Section
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Stack(
                          children: [
                            Image.asset(
                              behavior.imagePath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.image_not_supported, size: 50),
                                      const SizedBox(height: 8),
                                      Text(
                                        behavior.name,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Content Section
                    CheckboxListTile(
                      title: Text(
                        behavior.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            behavior.description,
                            style: const TextStyle(fontSize: 14),
                          ),
                          if (behavior.relatedSymptoms.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            const Text(
                              "Often seen with:",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              behavior.relatedSymptoms.join(", "),
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ],
                      ),
                      value: isSelected,
                      onChanged: (value) => toggleSymptom(behavior.name),
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: performDiagnosis,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                "Diagnose Disease (${selectedSymptoms.length} selected)",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildResultsView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Diagnosis Results",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Based on ${selectedSymptoms.length} selected behaviors",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (diagnosisResults.isEmpty)
          const Center(
            child: Text(
              "No matching diseases found",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        else
          ...diagnosisResults.map((result) => buildDiseaseCard(result)),
      ],
    );
  }

  Widget buildDiseaseCard(DiagnosisResult result) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiseaseDetailScreen(disease: result.disease),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disease Name and Probability
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      result.disease.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Text(
                    "${result.probability.toStringAsFixed(1)}% Match",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Preview Image
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: result.disease.imagePaths.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          result.disease.imagePaths[index],
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 150,
                              height: 150,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(Icons.image_not_supported, size: 50),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Matched Symptoms
              const Text(
                "Matched Behaviors:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: result.matchedSymptoms.map((symptom) {
                  return Chip(
                    label: Text(
                      symptom,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.blue.shade50,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Brief Description
              Text(
                result.disease.description,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // View Details Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiseaseDetailScreen(disease: result.disease),
                      ),
                    );
                  },
                  child: const Text(
                    "View Details",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Disease Detail Screen
class DiseaseDetailScreen extends StatelessWidget {
  final Disease disease;

  const DiseaseDetailScreen({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(disease.name),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disease Images
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: disease.imagePaths.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        disease.imagePaths[index],
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 200,
                            height: 200,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 50),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Description
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              disease.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Symptoms
            const Text(
              "Symptoms",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: disease.symptoms.map((symptom) {
                return Chip(
                  label: Text(symptom),
                  backgroundColor: Colors.blue.shade50,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Signs
            const Text(
              "Signs",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: disease.signs.map((sign) {
                return Chip(
                  label: Text(sign),
                  backgroundColor: Colors.green.shade50,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Medications
            const Text(
              "Medications/Treatment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: disease.medications.map((medication) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          medication,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder screens
class BehaviorTestScreen extends StatelessWidget {
  const BehaviorTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Behavior Checker")),
      body: const Center(child: Text("Behavior Checker Screen")),
    );
  }
}

class HealthTimelineScreen extends StatelessWidget {
  const HealthTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Health Timeline")),
      body: const Center(child: Text("Health Timeline Screen")),
    );
  }
}

class EmergencyGuideScreen extends StatelessWidget {
  const EmergencyGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Guide")),
      body: const Center(child: Text("Emergency Guide Screen")),
    );
  }
}

// Main function to run the app
void main() {
  runApp(const MaterialApp(
    home: ChickHealthDashboard(),
    debugShowCheckedModeBanner: false,
  ));
}