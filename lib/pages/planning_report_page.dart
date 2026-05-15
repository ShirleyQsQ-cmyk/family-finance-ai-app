import 'package:flutter/material.dart';

import '../models/diagnosis_result.dart';
import '../models/education_plan.dart';
import '../models/family_info.dart';
import '../services/finance_task_service.dart';
import 'parent_child_page.dart';
import '../widgets/app_bottom_step_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F8FF),
        title: const Text(
          'AI 规划报告',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const AppBottomStepBar(currentStep: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ReportHeroCard(
              score: diagnosis.financialHealthScore,
              pressureLevel: diagnosis.pressureLevel,
              mainGoal: info.mainGoal,
            ),

            const SizedBox(height: 18),

            const _SectionTitle(
              title: '教育金规划助手',
              subtitle: '根据孩子年龄和当前教育支出估算未来储备目标',
            ),

            const SizedBox(height: 12),

            _EducationSummaryCard(
              targetAmount: educationPlan.targetAmount,
              gapAmount: educationPlan.gapAmount,
              suggestedMonthlySaving: educationPlan.suggestedMonthlySaving,
            ),

            const SizedBox(height: 18),

            const _SectionTitle(
              title: '分阶段家庭规划',
              subtitle: '从现金流安全垫开始，再逐步建立教育储备和保障结构',
            ),

            const SizedBox(height: 12),

            _TimelineCard(
              step: '01',
              period: '短期 · 0–6 个月',
              title: '先稳定家庭安全垫',
              content:
                  '优先控制高波动育儿支出，建立 3–6 个月家庭应急储备，避免突发支出影响日常现金流。',
              color: const Color(0xFF21A67A),
              icon: Icons.security_rounded,
              isFirst: true,
            ),

            _TimelineCard(
              step: '02',
              period: '中期 · 6 个月–3 年',
              title: '逐步建立教育储备',
              content: educationPlan.planSummary,
              color: const Color(0xFF004B8D),
              icon: Icons.school_rounded,
            ),

            _TimelineCard(
              step: '03',
              period: '长期 · 3 年以上',
              title: '完善保障与周期复盘',
              content:
                  '逐步补齐家庭基础保障，并根据孩子成长阶段，每 3–6 个月复盘教育支出、储蓄目标和家庭保障结构。',
              color: const Color(0xFFF5A623),
              icon: Icons.repeat_rounded,
              isLast: true,
            ),

            const SizedBox(height: 18),

            _ActionListCard(items: diagnosis.suggestions),

            const SizedBox(height: 18),

            _ModelNoteCard(),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF004B8D),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
                icon: const Icon(Icons.child_friendly_rounded),
                label: const Text(
                  '进入亲子财商陪伴',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
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
            ),

            const SizedBox(height: 12),

            const Center(
              child: Text(
                '报告基于本地模型评分与规则引擎生成，仅用于原型演示',
                style: TextStyle(
                  color: Color(0xFF88889A),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportHeroCard extends StatelessWidget {
  final int score;
  final String pressureLevel;
  final String mainGoal;

  const _ReportHeroCard({
    required this.score,
    required this.pressureLevel,
    required this.mainGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2F80ED),
            Color(0xFF004B8D),
            Color(0xFF2F7BC6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004B8D).withOpacity(0.24),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.description_rounded,
                color: Colors.white,
                size: 32,
              ),
              SizedBox(width: 10),
              Text(
                '家庭规划报告',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Spacer(),
              Text(
                'Step 3 / 4',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              _HeroMetric(
                label: '综合评分',
                value: '$score',
              ),
              const SizedBox(width: 12),
              _HeroMetric(
                label: '压力等级',
                value: pressureLevel,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '主要目标：$mainGoal',
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              height: 1.55,
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '建议围绕“应急金优先、教育金分期、保障逐步补齐”的顺序执行，避免单一大额教育支出冲击家庭现金流。',
            style: TextStyle(
              color: Colors.white.withOpacity(0.90),
              height: 1.55,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final String label;
  final String value;

  const _HeroMetric({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.17),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withOpacity(0.24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.82),
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EducationSummaryCard extends StatelessWidget {
  final double targetAmount;
  final double gapAmount;
  final double suggestedMonthlySaving;

  const _EducationSummaryCard({
    required this.targetAmount,
    required this.gapAmount,
    required this.suggestedMonthlySaving,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFDCE8F7),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004B8D).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _MoneyMiniCard(
                icon: Icons.flag_rounded,
                label: '目标金额',
                amount: targetAmount,
                color: const Color(0xFF004B8D),
              ),
              const SizedBox(width: 12),
              _MoneyMiniCard(
                icon: Icons.trending_up_rounded,
                label: '当前缺口',
                amount: gapAmount,
                color: const Color(0xFFE85D75),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FF),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF21A67A).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    color: Color(0xFF21A67A),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '建议每月储备',
                        style: TextStyle(
                          color: Color(0xFF77778A),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '¥${suggestedMonthlySaving.round()} / 月',
                        style: const TextStyle(
                          color: Color(0xFF1F1F2E),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoneyMiniCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;
  final Color color;

  const _MoneyMiniCard({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 124,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.09),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: color.withOpacity(0.16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 25,
            ),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF77778A),
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '¥${amount.round()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final String step;
  final String period;
  final String title;
  final String content;
  final Color color;
  final IconData icon;
  final bool isFirst;
  final bool isLast;

  const _TimelineCard({
    required this.step,
    required this.period,
    required this.title,
    required this.content,
    required this.color,
    required this.icon,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 46,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 3,
                    color: isFirst ? Colors.transparent : color.withOpacity(0.22),
                  ),
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.28),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      step,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 3,
                    color: isLast ? Colors.transparent : color.withOpacity(0.22),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(19),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: const Color(0xFFDCE8F7),
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          period,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFF1F1F2E),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          content,
                          style: const TextStyle(
                            height: 1.55,
                            color: Color(0xFF555568),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionListCard extends StatelessWidget {
  final List<String> items;

  const _ActionListCard({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFDCE8F7),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004B8D).withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.checklist_rounded,
                color: Color(0xFF004B8D),
              ),
              SizedBox(width: 10),
              Text(
                '优先行动清单',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF1F1F2E),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...items.asMap().entries.map(
                (entry) => _ActionItem(
                  index: entry.key + 1,
                  text: entry.value,
                ),
              ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final int index;
  final String text;

  const _ActionItem({
    required this.index,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFF004B8D),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                height: 1.5,
                color: Color(0xFF44445A),
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModelNoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2E),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_rounded,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '当前原型使用线性回归模型完成综合评分，并通过规则引擎生成规划建议；不连接真实账户，不进行真实金融交易。',
              style: TextStyle(
                color: Colors.white.withOpacity(0.88),
                height: 1.55,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1F1F2E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Color(0xFF77778A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}