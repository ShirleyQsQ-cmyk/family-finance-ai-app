import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/diagnosis_result.dart';
import '../models/education_plan.dart';
import '../models/family_info.dart';
import '../services/finance_task_service.dart';
import '../widgets/app_bottom_step_bar.dart';
import '../widgets/app_ui.dart';
import 'planning_report_page.dart';

class DiagnosisPage extends StatelessWidget {
  final FamilyInfo info;
  final DiagnosisResult diagnosis;
  final EducationPlan educationPlan;
  final FinanceTaskService financeTaskService;

  const DiagnosisPage({
    super.key,
    required this.info,
    required this.diagnosis,
    required this.educationPlan,
    required this.financeTaskService,
  });

  String get scoreText {
    if (diagnosis.financialHealthScore >= 80) return '状态良好';
    if (diagnosis.financialHealthScore >= 60) return '需要优化';
    return '压力较高';
  }

  List<String> get riskTags {
    final tags = <String>[];

    if (info.savingRate < 0.1) tags.add('应急金不足');
    if (info.educationRate > 0.3) tags.add('教育支出偏高');
    if (!info.hasEducationFund) tags.add('教育金缺口');
    if (!info.hasBasicInsurance) tags.add('保障缺口');

    if (tags.isEmpty) tags.add('结构较稳定');

    return tags;
  }

  @override
  Widget build(BuildContext context) {
    final int score = diagnosis.financialHealthScore.clamp(0, 100);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '财务健康诊断',
          style: TextStyle(
            color: AppColors.title,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomStepBar(currentStep: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AnimatedIn(
              delay: 0,
              child: _Greeting(info: info),
            ),
            const SizedBox(height: 18),

            _AnimatedIn(
              delay: 80,
              child: _ScoreCard(
                score: score,
                scoreText: scoreText,
              ),
            ),

            const SizedBox(height: 18),

            _AnimatedIn(
              delay: 160,
              child: _FinancePieCard(info: info),
            ),

            const SizedBox(height: 20),

            _AnimatedIn(
              delay: 240,
              child: _StatusGrid(
                info: info,
                diagnosis: diagnosis,
              ),
            ),

            const SizedBox(height: 22),

            const _AnimatedIn(
              delay: 320,
              child: AppSectionTitle(
                title: '风险标签',
                subtitle: '系统根据关键阈值识别当前家庭的主要问题',
                icon: Icons.sell_rounded,
              ),
            ),

            const SizedBox(height: 12),

            _AnimatedIn(
              delay: 380,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: riskTags.map((tag) {
                  final stable = tag == '结构较稳定';

                  return AppPill(
                    text: tag,
                    icon: stable
                        ? Icons.check_circle_rounded
                        : Icons.error_rounded,
                    color: stable ? AppColors.green : AppColors.primary,
                    background: stable
                        ? const Color(0xFFEAF8EF)
                        : AppColors.primaryLight,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 22),

            _AnimatedIn(
              delay: 460,
              child: _AdviceCard(
                title: 'AI 智能提示',
                icon: Icons.auto_awesome_rounded,
                children: [
                  ...diagnosis.risks.map((item) => _Bullet(text: item)),
                  ...diagnosis.suggestions.map((item) => _Bullet(text: item)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _AnimatedIn(
              delay: 540,
              child: AppPrimaryButton(
                text: '查看规划报告',
                icon: Icons.description_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlanningReportPage(
                        info: info,
                        diagnosis: diagnosis,
                        educationPlan: educationPlan,
                        financeTaskService: financeTaskService,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedIn extends StatelessWidget {
  final Widget child;
  final int delay;

  const _AnimatedIn({
    required this.child,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 520 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _Greeting extends StatelessWidget {
  final FamilyInfo info;

  const _Greeting({
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: Colors.white,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          const AppIconBox(
            icon: Icons.waving_hand_rounded,
            size: 48,
            iconSize: 24,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              '您好，基于 ${info.childCount} 个孩子、${info.familyStructure} 的信息，AI 已生成以下诊断结果。',
              style: const TextStyle(
                color: AppColors.text,
                height: 1.5,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final int score;
  final String scoreText;

  const _ScoreCard({
    required this.score,
    required this.scoreText,
  });

  @override
  Widget build(BuildContext context) {
    return AppGradientCard(
      radius: 30,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '综合财务健康分',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: score.toDouble()),
                duration: const Duration(milliseconds: 850),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Text(
                    '${value.round()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 62,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  );
                },
              ),
              const SizedBox(width: 6),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  '分',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
                child: Text(
                  scoreText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            score >= 80
                ? '当前家庭财务结构较稳定，可继续保持储蓄节奏并定期复盘教育投入。'
                : score >= 60
                    ? '家庭具备一定基础，但建议优先关注应急金、教育储备和保障缺口。'
                    : '当前家庭财务压力较明显，建议先稳定现金流，再逐步配置教育和保障。',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.55,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinancePieCard extends StatelessWidget {
  final FamilyInfo info;

  const _FinancePieCard({
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    final double income =
        info.monthlyIncome <= 0 ? 1.0 : info.monthlyIncome.toDouble();

    final double education =
        info.educationExpense.clamp(0.0, income).toDouble();

    final double otherExpense =
        (info.monthlyExpense - info.educationExpense)
            .clamp(0.0, income)
            .toDouble();

    final double saving =
        (info.monthlyIncome - info.monthlyExpense)
            .clamp(0.0, income)
            .toDouble();

    final double total = education + otherExpense + saving <= 0
        ? 1.0
        : education + otherExpense + saving;

    final double educationRatio = education / total;
    final double otherRatio = otherExpense / total;
    final double savingRatio = saving / total;

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionTitle(
            title: '家庭支出结构',
            subtitle: '根据收入、教育支出和其他支出生成结构图',
            icon: Icons.pie_chart_rounded,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return SizedBox(
                    width: 132,
                    height: 132,
                    child: CustomPaint(
                      painter: _PieChartPainter(
                        progress: value,
                        educationRatio: educationRatio,
                        otherRatio: otherRatio,
                        savingRatio: savingRatio,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '储蓄率',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(info.savingRate * 100).clamp(0, 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: AppColors.title,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  children: [
                    _LegendRow(
                      color: AppColors.primary,
                      title: '教育支出',
                      value: '${(educationRatio * 100).toStringAsFixed(1)}%',
                    ),
                    const SizedBox(height: 12),
                    _LegendRow(
                      color: AppColors.gold,
                      title: '其他支出',
                      value: '${(otherRatio * 100).toStringAsFixed(1)}%',
                    ),
                    const SizedBox(height: 12),
                    _LegendRow(
                      color: AppColors.green,
                      title: '可储蓄',
                      value: '${(savingRatio * 100).toStringAsFixed(1)}%',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final double progress;
  final double educationRatio;
  final double otherRatio;
  final double savingRatio;

  _PieChartPainter({
    required this.progress,
    required this.educationRatio,
    required this.otherRatio,
    required this.savingRatio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 18.0;

    final Rect rect = Offset.zero & size;
    final Offset center = rect.center;
    final double radius = (size.width - strokeWidth) / 2;

    final Paint basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFF6DADA);

    canvas.drawCircle(center, radius, basePaint);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -math.pi / 2;
    const double gap = 0.045;

    void drawSegment(double ratio, Color color) {
      final double sweep =
          math.max(0.0, ratio * math.pi * 2 * progress - gap).toDouble();

      if (sweep <= 0) return;

      paint.color = color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        paint,
      );

      startAngle += ratio * math.pi * 2 * progress;
    }

    drawSegment(educationRatio, AppColors.primary);
    drawSegment(otherRatio, AppColors.gold);
    drawSegment(savingRatio, AppColors.green);
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.educationRatio != educationRatio ||
        oldDelegate.otherRatio != otherRatio ||
        oldDelegate.savingRatio != savingRatio;
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String title;
  final String value;

  const _LegendRow({
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.title,
            fontSize: 13.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _StatusGrid extends StatelessWidget {
  final FamilyInfo info;
  final DiagnosisResult diagnosis;

  const _StatusGrid({
    required this.info,
    required this.diagnosis,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.90,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _StatusCard(
          icon: Icons.account_balance_wallet_rounded,
          title: '现金流状态',
          value: diagnosis.cashflowStatus,
          subtitle: '储蓄率 ${(info.savingRate * 100).toStringAsFixed(1)}%',
          color: AppColors.green,
        ),
        _StatusCard(
          icon: Icons.school_rounded,
          title: '教育准备',
          value: diagnosis.educationReadiness,
          subtitle: '教育占比 ${(info.educationRate * 100).toStringAsFixed(1)}%',
          color: AppColors.gold,
        ),
        _StatusCard(
          icon: Icons.health_and_safety_rounded,
          title: '风险保障',
          value: diagnosis.protectionStatus,
          subtitle: info.hasBasicInsurance ? '已有基础保障' : '需要补齐保障',
          color: AppColors.blue,
        ),
        _StatusCard(
          icon: Icons.bolt_rounded,
          title: '压力等级',
          value: diagnosis.pressureLevel,
          subtitle: '由模型与规则判断',
          color: AppColors.primary,
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _StatusCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBox(
            icon: icon,
            color: color,
            background: color.withValues(alpha: 0.12),
            size: 42,
            iconSize: 21,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.title,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11.5,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdviceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _AdviceCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.primaryLight,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconBox(icon: icon),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.title,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;

  const _Bullet({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.text,
                height: 1.55,
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