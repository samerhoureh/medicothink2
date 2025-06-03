class MedicalReport {
  final String id;
  final String patientName;
  final int patientAge;
  final String referenceNumber;
  final String content;
  final List<String> insights;
  final double similarityScore;
  final DateTime createdAt;
  final String userId;

  MedicalReport({
    required this.id,
    required this.patientName,
    required this.patientAge,
    required this.referenceNumber,
    required this.content,
    required this.insights,
    required this.similarityScore,
    required this.createdAt,
    required this.userId,
  });

  factory MedicalReport.fromJson(Map<String, dynamic> json) {
    return MedicalReport(
      id: json['id'],
      patientName: json['patient_name'],
      patientAge: json['patient_age'],
      referenceNumber: json['reference_number'],
      content: json['content'],
      insights: List<String>.from(json['insights']),
      similarityScore: json['similarity_score'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_name': patientName,
      'patient_age': patientAge,
      'reference_number': referenceNumber,
      'content': content,
      'insights': insights,
      'similarity_score': similarityScore,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
    };
  }
}