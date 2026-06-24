import SwiftUI

struct PopularQuestion: Identifiable {
  let id = UUID()
  let title: String
  let subtitle: String
  let icon: String
  let color: Color
  let why: String
  let normal: String
  let help: String
  let doctor: String
}
 let popularQuestionData: [PopularQuestion] = [
  
  PopularQuestion(
    title: "Irregular periods",
    subtitle: "Cycles may vary due to stress or hormones.",
    icon: "calendar",
    color: .pink,
    why: "Irregular periods can occur due to stress, thyroid imbalance, PCOS, weight changes, or hormonal fluctuations.",
    normal: "It can be normal during teenage years, postpartum recovery, or perimenopause.",
    help: "Track your cycle, manage stress, maintain sleep, and eat balanced meals.",
    doctor: "Consult a doctor if periods stop for 3+ months, become very heavy, or extremely painful."
  ),
  
  PopularQuestion(
    title: "Vaginal discharge before periods",
    subtitle: "Discharge changes naturally during cycle.",
    icon: "drop",
    color: .purple,
    why: "Hormonal shifts before menstruation can increase white or creamy discharge.",
    normal: "Clear, white, or slightly yellow discharge without odor or itching is usually normal.",
    help: "Maintain hygiene, avoid harsh washes, wear breathable cotton underwear.",
    doctor: "Seek medical advice if discharge has strong odor, itching, burning, or unusual color."
  ),
  
  PopularQuestion(
    title: "Why am I feeling low before periods?",
    subtitle: "Hormones can influence mood.",
    icon: "face.smiling",
    color: .blue,
    why: "Estrogen drops before periods which may affect serotonin levels, impacting mood.",
    normal: "Mild mood swings are common during PMS.",
    help: "Light exercise, sunlight exposure, journaling, and magnesium-rich foods may help.",
    doctor: "If mood changes are severe or disruptive, consult a healthcare professional for PMDD evaluation."
  ),
  
  PopularQuestion(
    title: "Painful cramps every month",
    subtitle: "Mild cramps are common.",
    icon: "waveform.path.ecg",
    color: .orange,
    why: "Prostaglandins cause uterine contractions leading to cramps.",
    normal: "Mild to moderate cramps lasting 1–2 days are common.",
    help: "Heat therapy, light stretching, hydration, and anti-inflammatory foods can help.",
    doctor: "If pain is severe, worsening, or affects daily life, consult a doctor to rule out endometriosis."
  )
]
