import 'package:flutter/material.dart';

class FitnessRecommendations extends StatelessWidget {
  final double height; // in feet
  final double weight; // in kg
  final int age;

  FitnessRecommendations({
    required this.height,
    required this.weight,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    // Convert height to centimeters
    double heightInCm = height * 30.48;

    // Calculate BMI
    double bmi = weight / ((heightInCm / 100) * (heightInCm / 100));

    // Calculate BMR (Basal Metabolic Rate)
    double bmr = 10 * weight + 6.25 * heightInCm - 5 * age + 5;

    // Calculate Ideal Body Weight (Devine Formula)
    double idealWeightMale = (50 + 2.3 * (heightInCm - 152.4) / 2.54) + 8;
    double idealWeightFemale = (45.5 + 2.3 * (heightInCm - 152.4) / 2.54) + 8;

    // Define BMI status
    String bmiStatus = '';
    if (bmi < 18.5) {
      bmiStatus = 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      bmiStatus = 'Normal';
    } else if (bmi >= 25 && bmi < 30) {
      bmiStatus = 'Overweight';
    } else {
      bmiStatus = 'Obese';
    }

    // Define BMR status
    String bmrStatus = '';
    if (bmr < 1500) {
      bmrStatus = 'Low';
    } else if (bmr >= 1500 && bmr < 2000) {
      bmrStatus = 'Moderate';
    } else {
      bmrStatus = 'High';
    }

    // Define diet and exercise recommendations based on BMI and BMR
    String recommendations = '';
    if (bmi < 18.5) {
      recommendations = '''
      Diet and Exercise Recommendations:
      - You are underweight. Focus on increasing your calorie intake with nutritious foods and consider strength training exercises to build muscle mass.
      - Consume a balanced diet with a variety of foods from all food groups, including lentils, beans, chickpeas, whole grains, fruits, and vegetables.
      - Incorporate protein-rich foods such as paneer, tofu, lentils, and pulses into your diet.
      - Engage in strength training exercises to build muscle mass and increase overall body weight.
      - Aim for at least 3 days of strength training per week, with a focus on progressive overload to stimulate muscle growth.
      - Consult with a registered dietitian or nutritionist to develop a personalized meal plan that promotes healthy weight gain.
      ''';
    } else if (bmi >= 18.5 && bmi < 25) {
      recommendations = '''
      BMI: ${bmi.toStringAsFixed(2)} (${bmiStatus})
      BMR: ${bmr.toStringAsFixed(2)} calories/day (${bmrStatus})

      Diet and Exercise Recommendations:
      - Your BMI is normal. Maintain a balanced diet and regular exercise routine to stay healthy.
      - Consume a balanced diet with a variety of nutrient-rich foods, including lentils, beans, chickpeas, whole grains, fruits, and vegetables.
      - Engage in regular aerobic exercise such as walking, jogging, swimming, or cycling to maintain cardiovascular health.
      - Incorporate strength training exercises to improve muscle strength and endurance.
      - Aim for at least 150 minutes of moderate-intensity aerobic activity or 75 minutes of vigorous-intensity aerobic activity per week, along with muscle-strengthening activities on 2 or more days per week.
      ''';
    } else if (bmi >= 25 && bmi < 30) {
      recommendations = '''
     Diet and Exercise Recommendations:
      - You are overweight. Focus on a balanced diet with portion control and regular aerobic exercise to lose weight.
      - Limit intake of processed foods, sugary beverages, and high-calorie snacks.
      - Consume a balanced diet with a variety of nutrient-rich foods, including lentils, beans, chickpeas, whole grains, fruits, and vegetables.
      - Engage in regular aerobic exercise such as brisk walking, running, cycling, or swimming to burn calories and promote weight loss.
      - Incorporate high-intensity interval training (HIIT) to boost metabolism and improve cardiovascular fitness.
      - Aim for at least 150 minutes of moderate-intensity aerobic activity or 75 minutes of vigorous-intensity aerobic activity per week, along with muscle-strengthening activities on 2 or more days per week.
      ''';
    } else {
      recommendations = '''
      Diet and Exercise Recommendations:
      - You are obese. Consult with a healthcare professional to develop a comprehensive plan for weight loss, including diet modifications and increased physical activity.
      - Work with a registered dietitian or nutritionist to develop a personalized meal plan that promotes weight loss and overall health.
      - Start with low-impact exercises such as walking, swimming, or cycling to improve cardiovascular health and gradually increase intensity as fitness levels improve.
      - Incorporate strength training exercises to build lean muscle mass and boost metabolism.
      - Aim for at least 150 minutes of moderate-intensity aerobic activity or 75 minutes of vigorous-intensity aerobic activity per week, along with muscle-strengthening activities on 2 or more days per week.
      ''';
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Fitness Recommendations'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BMI: ${bmi.toStringAsFixed(2)} (${bmiStatus})',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'BMR: ${bmr.toStringAsFixed(2)} calories/day (${bmrStatus})',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Ideal Weight (Male): ${idealWeightMale.toStringAsFixed(2)} kg',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Ideal Weight (Female): ${idealWeightFemale.toStringAsFixed(2)} kg',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Diet and Exercise Recommendations:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              recommendations,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
