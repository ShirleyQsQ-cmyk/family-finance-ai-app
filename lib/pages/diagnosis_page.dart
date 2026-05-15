import 'package:flutter/material.dart';

import '../models/diagnosis_result.dart';
import '../models/education_plan.dart';
import '../models/family_info.dart';
import '../services/finance_task_service.dart';
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

  Color get scoreColor {
    if (diagnosis.financialHealthScore >= 80) {
      return const Color(0xFF21A67A);
    } else if (diagnosis.financialHealthScore >= 60) {
      return const Color(0xFFF5A623);
    } else {
      return const Color(0xFFE85D75);
    }
  }

  String get scoreText {
    if (diagnosis.financialHealthScore >= 80) {
      return '整体较健康';
    } else if (diagnosis.financialHealthScore >= 60) {
      return '需要优化';
    } else {
      return '压力较高';
    }
  }

  String get scoreDescription {
    if (diagnosis.financialHealthScore >= 80) {
      return '家庭财务结构较稳定，可继续保持储蓄节奏并定期复盘教育投入。';
    } else if (diagnosis.financialHealthScore >= 60) {
      return '家庭具备一定基础，但应优先关注应急金、教育储备和保障缺口。';
    } else {
      return '当前家庭财务压力较明显，建议先稳定现金流，再逐步配置教育和保障。';
    }
  }

  List<String> get riskTags {
    final tags = <String>[];

    if (info.savingRate < 0.1) tags.add('现金流偏紧');
    if (info.educationRate > 0.3) tags.add('教育支出偏高');
    if (!info.hasEmergencyFund) tags.add('应急金不足');
    if (!info.hasEducationFund) tags.add('教育金缺口');
    if (!info.hasBasicInsurance) tags.add('保障缺口');

    if (tags.isEmpty) tags.add('结构较稳定');

    return tags;
  }

  @override
  Widget build(BuildContext context) {
    final progressValue = diagnosis.financialHealthScore / 100;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F8FF),
        title: const Text(
          '家庭财务健康诊断',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ScoreHeroCard(
              score: diagnosis.financialHealthScore,
              progressValue: progressValue,
              scoreColor: scoreColor,
              scoreText: scoreText,
              description: scoreDescription,
            ),

            const SizedBox(height: 18),

            _ModelExplainCard(
              savingRate: info.savingRate,
              educationRate: info.educationRate,
            ),

            const SizedBox(height: 18),

            const _SectionTitle(
              title: '家庭财务画像',
              subtitle: '根据输入信息生成四个核心状态判断',
            ),

            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.08,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              children: [
                _StatusCard(
                  icon: Icons.account_balance_wallet_rounded,
                  title: '现金流状态',
                  value: diagnosis.cashflowStatus,
                  color: const Color(0xFF21A67A),
                ),
                _StatusCard(
                  icon: Icons.school_rounded,
                  title: '教育准备',
                  value: diagnosis.educationReadiness,
                  color: const Color(0xFF004B8D),
                ),
                _StatusCard(
                  icon: Icons.health_and_safety_rounded,
                  title: '风险保障',
                  value: diagnosis.protectionStatus,
                  color: const Color(0xFF2F80ED),
                ),
                _StatusCard(
                  icon: Icons.bolt_rounded,
                  title: '压力等级',
                  value: diagnosis.pressureLevel,
                  color: const Color(0xFFF5A623),
                ),
              ],
            ),

            const SizedBox(height: 18),

            const _SectionTitle(
              title: '风险标签',
              subtitle: '系统根据关键阈值识别当前家庭的主要问题',
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: riskTags
                  .map(
                    (tag) => _RiskTag(
                      text: tag,
                      isPositive: tag == '结构较稳定',
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 18),

            _SectionCard(
              title: '模型发现的主要风险',
              icon: Icons.warning_amber_rounded,
              iconColor: const Color(0xFFE85D75),
              children: diagnosis.risks
                  .map(
                    (risk) => _BulletItem(
                      text: risk,
                      color: const Color(0xFFE85D75),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 18),

            _SectionCard(
              title: '初步优化建议',
              icon: Icons.lightbulb_rounded,
              iconColor: const Color(0xFF004B8D),
              children: diagnosis.suggestions
                  .map(
                    (item) => _BulletItem(
                      text: item,
                      color: const Color(0xFF004B8D),
                    ),
                  )
                  .toList(),
            ),

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
                icon: const Icon(Icons.description_rounded),
                label: const Text(
                  '查看 AI 规划报告',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
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

            const SizedBox(height: 12),

            const Center(
              child: Text(
                '评分由本地线性回归模型预测，仅用于原型演示',
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

class _ScoreHeroCard extends StatelessWidget {
  final int score;
  final double progressValue;
  final Color scoreColor;
  final String scoreText;
  final String description;

  const _ScoreHeroCard({
    required this.score,
    required this.progressValue,
    required this.scoreColor,
    required this.scoreText,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
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
        children: [
          const Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '综合财务健康评分',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                'Step 2 / 4',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 168,
                height: 168,
                child: CircularProgressIndicator(
                  value: progressValue,
                  strokeWidth: 13,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.22),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$score',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        height: 1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '/ 100',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            scoreText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
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

class _ModelExplainCard extends StatelessWidget {
  final double savingRate;
  final double educationRate;

  const _ModelExplainCard({
    required this.savingRate,
    required this.educationRate,
  });

  @override
  Widget build(BuildContext context) {
    final savingPercent = (savingRate * 100).toStringAsFixed(1);
    final educationPercent = (educationRate * 100).toStringAsFixed(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004B8D).withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF004B8D).withOpacity(0.11),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.psychology_alt_rounded,
              color: Color(0xFF004B8D),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              '模型特征已计算：储蓄率 $savingPercent%，教育支出占比 $educationPercent%。',
              style: const TextStyle(
                height: 1.5,
                color: Color(0xFF44445A),
                fontWeight: FontWeight.w700,
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

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatusCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFDCE8F7),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004B8D).withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF77778A),
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
              color: Color(0xFF1F1F2E),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskTag extends StatelessWidget {
  final String text;
  final bool isPositive;

  const _RiskTag({
    required this.text,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isPositive ? const Color(0xFF21A67A) : const Color(0xFFE85D75);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: color.withOpacity(0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.check_circle_rounded : Icons.error_rounded,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
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
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.11),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF1F1F2E),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final Color color;

  const _BulletItem({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 7),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                height: 1.55,
                fontSize: 15,
                color: Color(0xFF44445A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}