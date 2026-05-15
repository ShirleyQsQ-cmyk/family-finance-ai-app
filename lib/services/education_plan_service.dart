import '../models/education_plan.dart';
import '../models/family_info.dart';

class EducationPlanService {
  EducationPlan generatePlan(FamilyInfo info) {
    final yearsTo18 = (18 - info.childAge).clamp(1, 15);

    // Demo 阶段用简化估算：
    // 假设未来教育目标资金 = 当前每月教育支出 × 12 × 距离18岁的年数 × 1.2
    final targetAmount = info.educationExpense * 12 * yearsTo18 * 1.2;

    // 原型里没有让用户输入已有教育金金额，因此：
    // 如果已有教育金，假设已准备目标的 30%；否则为 0。
    final currentPrepared = info.hasEducationFund ? targetAmount * 0.3 : 0;

    final gapAmount = (targetAmount - currentPrepared).clamp(0, targetAmount);

    final suggestedMonthlySaving = gapAmount / (yearsTo18 * 12);

    String summary;

    if (!info.hasEmergencyFund) {
      summary =
          '按照当前家庭情况，建议先建立 3–6 个月应急金，再逐步配置教育储备。之后每月可预留约 ${suggestedMonthlySaving.round()} 元进入教育账户。';
    } else {
      summary =
          '按照当前家庭结余水平，建议每月预留约 ${suggestedMonthlySaving.round()} 元进入教育账户，逐步覆盖未来教育金缺口。';
    }

    return EducationPlan(
      targetAmount: targetAmount,
      gapAmount: gapAmount.toDouble(),
      suggestedMonthlySaving: suggestedMonthlySaving,
      planSummary: summary,
    );
  }
}