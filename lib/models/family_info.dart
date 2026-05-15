class FamilyInfo {
  final String familyStructure;
  final List<int> childAges;
  final double monthlyIncome;
  final double monthlyExpense;
  final double educationExpense;
  final bool hasEmergencyFund;
  final bool hasEducationFund;
  final bool hasBasicInsurance;
  final String mainGoal;

  FamilyInfo({
    required this.familyStructure,
    required this.childAges,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.educationExpense,
    required this.hasEmergencyFund,
    required this.hasEducationFund,
    required this.hasBasicInsurance,
    required this.mainGoal,
  });

  int get childCount => childAges.length;

  // 模型目前只接收一个 child_age 特征。
  // 多孩家庭时，用最大年龄作为代表值，更适合估算教育金压力。
  int get childAge {
    if (childAges.isEmpty) return 8;
    return childAges.reduce((a, b) => a > b ? a : b);
  }

  String get childAgeSummary {
    if (childAges.isEmpty) return '未填写';
    return childAges.map((age) => '$age 岁').join('、');
  }

  double get savingRate {
    if (monthlyIncome <= 0) return 0;
    return (monthlyIncome - monthlyExpense) / monthlyIncome;
  }

  double get educationRate {
    if (monthlyIncome <= 0) return 0;
    return educationExpense / monthlyIncome;
  }

  Map<String, double> toModelFeatures() {
    return {
      'child_age': childAge.toDouble(),
      'monthly_income': monthlyIncome,
      'monthly_expense': monthlyExpense,
      'education_expense': educationExpense,
      'saving_rate': savingRate,
      'education_rate': educationRate,
      'has_emergency_fund': hasEmergencyFund ? 1.0 : 0.0,
      'has_education_fund': hasEducationFund ? 1.0 : 0.0,
      'has_basic_insurance': hasBasicInsurance ? 1.0 : 0.0,
    };
  }
}