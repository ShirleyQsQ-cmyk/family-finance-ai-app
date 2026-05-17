import 'package:flutter/material.dart';

import '../models/diagnosis_result.dart';
import '../models/education_plan.dart';
import '../models/family_info.dart';
import '../services/finance_task_service.dart';
import '../widgets/app_bottom_step_bar.dart';
import '../widgets/app_ui.dart';
import 'parent_child_page.dart';

class PlanningReportPage extends StatelessWidget {
  final FamilyInfo info;
  final DiagnosisResult diagnosis;
  final EducationPlan educationPlan;
  final FinanceTaskService financeTaskService;

  const PlanningReportPage({
    super.key,
    required this.info,
    required this.diagnosis,
    required this.educationPlan,
    required this.financeTaskService,
  });

  int get totalEducationTarget {
  return 250000;
}

int get suggestedMonthlySaving {
  final yearsLeft = (18 - info.childAge).clamp(1, 18);
  return (totalEducationTarget / (yearsLeft * 12)).round();
}

  @override
  Widget build(BuildContext context) {
    final stages = [
      _EducationStage(
        title: '小学',
        ageRange: '6–12 岁',
        description: '基础教育及课外兴趣班',
        amount: 50000,
        yearsLater: (6 - info.childAge).clamp(0, 18),
        active: info.childAge <= 12,
      ),
      _EducationStage(
        title: '初中',
        ageRange: '12–15 岁',
        description: '学科培训与素质拓展',
        amount: 80000,
        yearsLater: (12 - info.childAge).clamp(0, 18),
        active: info.childAge > 12 && info.childAge <= 15,
      ),
      _EducationStage(
        title: '高中',
        ageRange: '15–18 岁',
        description: '升学准备与专业辅导',
        amount: 120000,
        yearsLater: (15 - info.childAge).clamp(0, 18),
        active: info.childAge > 15 && info.childAge <= 18,
      ),
      _EducationStage(
        title: '大学本科',
        ageRange: '18–22 岁',
        description: '学费、住宿及生活费',
        amount: 200000,
        yearsLater: (18 - info.childAge).clamp(0, 18),
        active: info.childAge > 18,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '规划报告',
          style: TextStyle(
            color: AppColors.title,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomStepBar(currentStep: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionTitle(
              title: '分阶段教育支出估算',
              subtitle: '根据孩子年龄和家庭情况生成教育储备路径',
              icon: Icons.school_rounded,
            ),
            const SizedBox(height: 16),
            ...stages.map((stage) {
              return _StageCard(stage: stage);
            }),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.layers_rounded,
                    title: '教育储备总目标',
                    value: '¥$totalEducationTarget',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.savings_rounded,
                    title: '建议每月储蓄',
                    value: '¥$suggestedMonthlySaving',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AppCard(
              color: AppColors.primaryLight,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      AppIconBox(
                        icon: Icons.auto_awesome_rounded,
                        size: 44,
                        iconSize: 22,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'AI 规划建议',
                        style: TextStyle(
                          color: AppColors.title,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _PlanBullet(
                    title: '短期建议',
                    text: '优先建立 3–6 个月家庭应急储备，并控制高波动育儿支出。',
                  ),
                  _PlanBullet(
                    title: '中期建议',
                    text: '按月定额储备教育金，优先覆盖小学到中学阶段教育支出。',
                  ),
                  _PlanBullet(
                    title: '长期建议',
                    text: '逐步完善家庭基础保障，避免未来大额教育支出冲击现金流。',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              text: '进入亲子财商陪伴',
              icon: Icons.family_restroom_rounded,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ParentChildPage(
                      info: info,
                      financeTaskService: financeTaskService,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EducationStage {
  final String title;
  final String ageRange;
  final String description;
  final int amount;
  final int yearsLater;
  final bool active;

  const _EducationStage({
    required this.title,
    required this.ageRange,
    required this.description,
    required this.amount,
    required this.yearsLater,
    required this.active,
  });
}

class _StageCard extends StatelessWidget {
  final _EducationStage stage;

  const _StageCard({
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: stage.active ? AppColors.primaryLight : Colors.white,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      border: Border.all(
        color: stage.active ? AppColors.primary : AppColors.border,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      stage.title,
                      style: const TextStyle(
                        color: AppColors.title,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (stage.active)
                      const AppPill(
                        text: '当前阶段',
                        color: Colors.white,
                        background: AppColors.primary,
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '¥${stage.amount}',
                    style: const TextStyle(
                      color: AppColors.title,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    stage.yearsLater == 0 ? '当前' : '${stage.yearsLater} 年后',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${stage.ageRange} · ${stage.description}',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: stage.active ? 0.65 : 0.18,
              minHeight: 7,
              backgroundColor: const Color(0xFFF7D8D8),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '建议月储蓄：¥${(stage.amount / ((stage.yearsLater + 1) * 12)).round()}',
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBox(icon: icon),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanBullet extends StatelessWidget {
  final String title;
  final String text;

  const _PlanBullet({
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: AppColors.text,
                  height: 1.55,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '$title：',
                    style: const TextStyle(
                      color: AppColors.title,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}