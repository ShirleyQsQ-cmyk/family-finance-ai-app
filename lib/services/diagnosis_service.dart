import '../models/diagnosis_result.dart';
import '../models/family_info.dart';
import 'linear_model_service.dart';

class DiagnosisService {
  final LinearModelService modelService;

  DiagnosisService(this.modelService);

  DiagnosisResult diagnose(FamilyInfo info) {
    final score = modelService
        .predictFinancialHealthScore(info.toModelFeatures())
        .round();

    final cashflowStatus = _getCashflowStatus(info);
    final educationReadiness = _getEducationReadiness(info);
    final protectionStatus = _getProtectionStatus(info);
    final pressureLevel = _getPressureLevel(info, score);

    final risks = _generateRisks(info);
    final suggestions = _generateSuggestions(info);

    return DiagnosisResult(
      financialHealthScore: score,
      cashflowStatus: cashflowStatus,
      educationReadiness: educationReadiness,
      protectionStatus: protectionStatus,
      pressureLevel: pressureLevel,
      risks: risks,
      suggestions: suggestions,
    );
  }

  String _getCashflowStatus(FamilyInfo info) {
    final savingRate = info.savingRate;

    if (savingRate >= 0.25) {
      return '健康';
    } else if (savingRate >= 0.1) {
      return '基本稳定';
    } else if (savingRate >= 0) {
      return '偏紧张';
    } else {
      return '高压力';
    }
  }

  String _getEducationReadiness(FamilyInfo info) {
    if (info.hasEducationFund && info.savingRate >= 0.15) {
      return '准备较充分';
    } else if (info.hasEducationFund || info.savingRate >= 0.15) {
      return '有一定准备';
    } else {
      return '需要加强';
    }
  }

  String _getProtectionStatus(FamilyInfo info) {
    if (info.hasEmergencyFund && info.hasBasicInsurance) {
      return '较完整';
    } else if (info.hasEmergencyFund || info.hasBasicInsurance) {
      return '部分缺口';
    } else {
      return '明显不足';
    }
  }

  String _getPressureLevel(FamilyInfo info, int score) {
    if (score >= 80 && info.savingRate >= 0.2) {
      return '低';
    } else if (score >= 60 && info.savingRate >= 0.05) {
      return '中';
    } else {
      return '高';
    }
  }

  List<String> _generateRisks(FamilyInfo info) {
    final risks = <String>[];

    if (info.savingRate < 0.1) {
      risks.add('家庭每月结余偏低，现金流抗风险能力较弱。');
    }

    if (info.educationRate > 0.3) {
      risks.add('教育/兴趣班支出占收入比例偏高，可能挤压储蓄和保障预算。');
    }

    if (!info.hasEmergencyFund) {
      risks.add('家庭缺少应急金，面对突发支出时缓冲能力不足。');
    }

    if (!info.hasEducationFund) {
      risks.add('尚未建立教育金储备，未来教育支出可能带来压力。');
    }

    if (!info.hasBasicInsurance) {
      risks.add('家庭基础保障配置存在空缺。');
    }

    if (risks.isEmpty) {
      risks.add('当前家庭财务结构整体较稳定，但仍建议定期复盘。');
    }

    return risks;
  }

  List<String> _generateSuggestions(FamilyInfo info) {
    final suggestions = <String>[];

    if (!info.hasEmergencyFund) {
      suggestions.add('短期优先建立 3–6 个月家庭应急储备。');
    }

    if (info.educationRate > 0.3) {
      suggestions.add('将教育支出分为必要支出、成长支出和可选支出，避免焦虑型消费。');
    }

    if (!info.hasEducationFund) {
      suggestions.add('中期建议按月定额储备教育金，优先覆盖小学到中学阶段教育支出。');
    }

    if (!info.hasBasicInsurance) {
      suggestions.add('长期建议逐步补齐家庭基础保障，避免突发风险影响教育规划。');
    }

    if (info.savingRate < 0.1) {
      suggestions.add('建议先控制高波动育儿支出，提高每月结余比例。');
    }

    if (suggestions.isEmpty) {
      suggestions.add('继续保持稳定储蓄，并每月复盘教育支出和家庭保障情况。');
    }

    return suggestions;
  }
}