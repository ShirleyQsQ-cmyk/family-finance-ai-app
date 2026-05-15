class DiagnosisResult {
  final int financialHealthScore;

  final String cashflowStatus;
  final String educationReadiness;
  final String protectionStatus;
  final String pressureLevel;

  final List<String> risks;
  final List<String> suggestions;

  DiagnosisResult({
    required this.financialHealthScore,
    required this.cashflowStatus,
    required this.educationReadiness,
    required this.protectionStatus,
    required this.pressureLevel,
    required this.risks,
    required this.suggestions,
  });
}