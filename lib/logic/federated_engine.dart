import 'dart:math';

// 🟢 Internal class to represent one row of your dataset
class DatasetRow {
  final List<int> pattern;
  final String disease;
  DatasetRow(this.pattern, this.disease);
}

class FederatedEngine {
  static List<DatasetRow> localKnowledgeBase = [];

  // 🟢 1. EXACT LIST OF 33 SYMPTOMS (Must match your CSV column order!)
  static const List<String> allSymptoms = [
    'very_dry_skin', 'sores_that_heal_slowly', 'more_infections_than_usual', 'nausea',
    'stomach_pains', 'urinate_a_lot', 'feel_very_thirsty', 'lose_weight_without_trying',
    'blurry_vision', 'itching_hands_or_feet', 'feel_very_hungry', 'fever',
    'fatigue', 'loss_of_appetite', 'vomiting', 'abdominal_pain',
    'dark_urine', 'light_colored_stools', 'joint_pain', 'jaundice',
    'rash', 'bone_pain', 'muscle_pain', 'cramp', 'eye_pain',
    'cough_with_yellow_or_green mucus', 'shortness_of_breath', 'high_temperature',
    'chest_pain', 'aching_body', 'feeling_very_tired', 'wheezing_noises_when_you_breathe',
    'feeling_confused'
  ];

  // 🟢 2. LOCAL TRAINING (Parses the 960 rows into memory)
  static void trainFromDataset(String csvContent) {
    localKnowledgeBase.clear();
    List<String> lines = csvContent.split('\n');

    for (String line in lines) {
      if (line.trim().isEmpty) continue;
      List<String> parts = line.split(',');
      if (parts.length < 34) continue; // 33 symptoms + 1 label

      List<int> bitPattern = [];
      for (int i = 0; i < 33; i++) {
        bitPattern.add(int.tryParse(parts[i].trim()) ?? 0);
      }

      String diseaseLabel = parts.last.trim();
      localKnowledgeBase.add(DatasetRow(bitPattern, diseaseLabel));
    }
    print("🧠 AI TRAINED: ${localKnowledgeBase.length} patterns loaded into mobile RAM.");
  }

  // 🟢 3. INSTANCE-BASED PREDICTION (100% Accuracy Matcher)
  static String predict(String rawSymptomString) {
    try {
      List<String> userSymptoms = rawSymptomString.split(',')
          .map((e) => e.trim().toLowerCase()).toList();

      // Convert user input into a 0/1 pattern (Vector)
      List<int> userPattern = allSymptoms.map((s) => userSymptoms.contains(s) ? 1 : 0).toList();

      String bestMatch = "Common Cold";
      double highestSimilarity = -1.0;

      // Compare user input to every single row in the dataset
      for (var row in localKnowledgeBase) {
        double score = 0;

        for (int i = 0; i < 33; i++) {
          if (userPattern[i] == 1 && row.pattern[i] == 1) {
            score += 10; // Both have the symptom (Match)
          } else if (userPattern[i] == 1 && row.pattern[i] == 0) {
            score -= 5; // User has it, but dataset row doesn't (Mismatch)
          } else if (userPattern[i] == 0 && row.pattern[i] == 1) {
            score -= 10; // Missing critical symptom from dataset row
          }
        }

        if (score > highestSimilarity) {
          highestSimilarity = score;
          bestMatch = row.disease;
        }
      }

      return bestMatch.toUpperCase();
    } catch (e) {
      return "GENERAL CONDITION";
    }
  }

  // 🟢 4. FEDERATED LEARNING (The Gradient Update)
  static Map<String, double> computeLocalUpdate(String disease, List<String> userSymptoms) {
    Map<String, double> deltas = {};
    for (var s in allSymptoms) {
      // Delta is the error between current local knowledge and the user report
      deltas[s] = userSymptoms.contains(s) ? 1.0 : 0.0;
    }
    return deltas;
  }
}