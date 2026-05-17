import 'package:flutter/material.dart';

import '../models/family_info.dart';
import '../services/finance_task_service.dart';
import '../widgets/app_bottom_step_bar.dart';
import '../widgets/app_ui.dart';

class ParentChildPage extends StatefulWidget {
  final FamilyInfo info;
  final FinanceTaskService financeTaskService;

  const ParentChildPage({
    super.key,
    required this.info,
    required this.financeTaskService,
  });

  @override
  State<ParentChildPage> createState() => _ParentChildPageState();
}

class _ParentChildPageState extends State<ParentChildPage> {
  late final FinanceTaskItem task;
  late final FinanceTaskItem challenge;
  late final String tip;
  late final int basePoints;

  bool taskCompleted = false;
  bool challengeCompleted = false;

  @override
  void initState() {
    super.initState();
    task = widget.financeTaskService.generateWeeklyTask(widget.info);
    challenge = widget.financeTaskService.generateSavingChallenge(widget.info);
    tip = widget.financeTaskService.generateConversationTip(widget.info);
    basePoints = widget.financeTaskService.generateBasePoints(widget.info);
  }

  int get totalPoints {
    int points = basePoints;
    if (taskCompleted) points += task.points;
    if (challengeCompleted) points += challenge.points;
    return points;
  }

  int get currentLevel {
    if (totalPoints >= 80) return 4;
    if (totalPoints >= 50) return 3;
    if (totalPoints >= 25) return 2;
    return 1;
  }

  int get nextLevelTarget {
    if (totalPoints < 25) return 25;
    if (totalPoints < 50) return 50;
    if (totalPoints < 80) return 80;
    return 100;
  }

  int get pointsToNextLevel {
    if (totalPoints >= 100) return 0;
    return nextLevelTarget - totalPoints;
  }

  double get levelProgress {
    if (totalPoints >= 100) return 1.0;

    final previous = currentLevel == 1
        ? 0
        : currentLevel == 2
            ? 25
            : currentLevel == 3
                ? 50
                : 80;

    return ((totalPoints - previous) / (nextLevelTarget - previous))
        .clamp(0.0, 1.0);
  }

  String get levelName {
    switch (currentLevel) {
      case 1:
        return 'Level 1 · 起步小管家';
      case 2:
        return 'Level 2 · 储蓄小能手';
      case 3:
        return 'Level 3 · 预算小达人';
      default:
        return 'Level 4 · 家庭财商之星';
    }
  }

  void completeTask(String type) {
    final oldLevel = currentLevel;
    final added = type == 'task' ? task.points : challenge.points;

    setState(() {
      if (type == 'task') taskCompleted = true;
      if (type == 'challenge') challengeCompleted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          type == 'task'
              ? '家庭小任务已完成，积分 +${task.points}'
              : '储蓄挑战已完成，积分 +${challenge.points}',
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1300),
      ),
    );

    if (currentLevel > oldLevel) {
      Future.delayed(const Duration(milliseconds: 450), () {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => _LevelUpDialog(
            levelName: levelName,
            addedPoints: added,
          ),
        );
      });
    }
  }

  void showPointsDetail() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      const AppIconBox(
                        icon: Icons.stars_rounded,
                        size: 54,
                        iconSize: 30,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '亲子积分详情',
                              style: TextStyle(
                                color: AppColors.title,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              levelName,
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '$totalPoints 分',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: levelProgress,
                      minHeight: 10,
                      backgroundColor: const Color(0xFFF7D8D8),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pointsToNextLevel == 0
                        ? '已经达到当前最高等级。'
                        : '距离下一级还差 $pointsToNextLevel 分。',
                    style: const TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _PointRow(
                    label: '基础积分',
                    value: '+$basePoints',
                    completed: true,
                  ),
                  _PointRow(
                    label: '完成家庭小任务',
                    value: '+${task.points}',
                    completed: taskCompleted,
                  ),
                  _PointRow(
                    label: '完成储蓄挑战',
                    value: '+${challenge.points}',
                    completed: challengeCompleted,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '升级规则：25 分升到 Level 2，50 分升到 Level 3，80 分升到 Level 4。',
                      style: TextStyle(
                        color: AppColors.text,
                        height: 1.55,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '亲子财商成长',
          style: TextStyle(
            color: AppColors.title,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomStepBar(currentStep: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionTitle(
              title: '本周任务',
              subtitle: '完成任务获得积分，培养孩子的理财好习惯',
              icon: Icons.calendar_month_rounded,
            ),
            const SizedBox(height: 16),
            _TaskCard(
              title: '家庭小任务',
              content: task.content,
              tag: '财商认知',
              points: task.points,
              icon: Icons.assignment_turned_in_rounded,
              completed: taskCompleted,
              onTap: () => completeTask('task'),
            ),
            _TaskCard(
              title: '储蓄挑战',
              content: challenge.content,
              tag: '储蓄习惯',
              points: challenge.points,
              icon: Icons.savings_rounded,
              completed: challengeCompleted,
              onTap: () => completeTask('challenge'),
            ),
            const SizedBox(height: 12),
            const AppSectionTitle(
              title: '亲子积分',
              subtitle: '点击积分卡片查看等级和积分明细',
              icon: Icons.stars_rounded,
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: showPointsDetail,
              child: _PointsCard(
                points: totalPoints,
                levelName: levelName,
                progress: levelProgress,
                pointsToNextLevel: pointsToNextLevel,
              ),
            ),
            const SizedBox(height: 22),
            const AppSectionTitle(
              title: '沟通小贴士',
              subtitle: '帮助家长用简单语言和孩子讨论金钱',
              icon: Icons.chat_bubble_outline_rounded,
            ),
            const SizedBox(height: 14),
            _TipCard(text: tip),
            const SizedBox(height: 22),
            const AppSectionTitle(
              title: '月度活动推荐',
              subtitle: '趣味财商游戏，让孩子在玩乐中学习',
              icon: Icons.card_giftcard_rounded,
            ),
            const SizedBox(height: 14),
            const _ActivityCard(),
            const SizedBox(height: 24),
            AppPrimaryButton(
              text: '返回首页',
              icon: Icons.home_rounded,
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final String title;
  final String content;
  final String tag;
  final int points;
  final IconData icon;
  final bool completed;
  final VoidCallback onTap;

  const _TaskCard({
    required this.title,
    required this.content,
    required this.tag,
    required this.points,
    required this.icon,
    required this.completed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      border: Border.all(
        color: completed ? AppColors.primary : AppColors.border,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                completed
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.title,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              AppPill(
                text: completed ? '已完成' : '+$points 积分',
                icon: completed ? Icons.check_rounded : Icons.star_border_rounded,
                background: completed ? AppColors.primary : AppColors.primaryLight,
                color: completed ? Colors.white : AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              AppIconBox(icon: icon, size: 46, iconSize: 23),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(
                    color: AppColors.text,
                    height: 1.55,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              AppPill(
                text: tag,
                color: AppColors.gold,
                background: const Color(0xFFFFF6DE),
              ),
              const Spacer(),
              SizedBox(
                height: 38,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: completed ? null : onTap,
                  child: Text(
                    completed ? '已完成' : '完成',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PointsCard extends StatelessWidget {
  final int points;
  final String levelName;
  final double progress;
  final int pointsToNextLevel;

  const _PointsCard({
    required this.points,
    required this.levelName,
    required this.progress,
    required this.pointsToNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    return AppGradientCard(
      radius: 28,
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Row(
            children: [
              const AppIconBox(
                icon: Icons.stars_rounded,
                color: Colors.white,
                background: Colors.white24,
                size: 54,
                iconSize: 30,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '本周亲子积分',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(end: points.toDouble()),
                      duration: const Duration(milliseconds: 650),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Text(
                          '${value.round()} 分',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            height: 1,
                            fontWeight: FontWeight.w900,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                    Text(
                      levelName,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 18),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(end: progress),
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 9,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            pointsToNextLevel == 0
                ? '已达到当前最高等级，点击查看积分明细。'
                : '还差 $pointsToNextLevel 分升到下一级，点击查看详情。',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.86),
              height: 1.45,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String text;

  const _TipCard({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.primaryLight,
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppIconBox(icon: Icons.chat_bubble_rounded),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.text,
                height: 1.6,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              AppIconBox(icon: Icons.track_changes_rounded),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  '小小理财师',
                  style: TextStyle(
                    color: AppColors.title,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '给孩子 100 元，让 TA 规划一次全家周末活动。',
            style: TextStyle(
              color: AppColors.text,
              height: 1.55,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              AppPill(
                text: '8–12 岁',
                color: AppColors.primary,
                background: AppColors.primaryLight,
              ),
              SizedBox(width: 8),
              AppPill(
                text: '30 分钟',
                color: AppColors.gold,
                background: Color(0xFFFFF6DE),
              ),
              SizedBox(width: 8),
              AppPill(
                text: '中等',
                color: AppColors.blue,
                background: Color(0xFFEAF1FF),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PointRow extends StatelessWidget {
  final String label;
  final String value;
  final bool completed;

  const _PointRow({
    required this.label,
    required this.value,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: completed ? AppColors.primaryLight : const Color(0xFFF7F4F4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: completed ? AppColors.primary : AppColors.hint,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: completed ? AppColors.primary : AppColors.hint,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelUpDialog extends StatelessWidget {
  final String levelName;
  final int addedPoints;

  const _LevelUpDialog({
    required this.levelName,
    required this.addedPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AppCard(
        padding: const EdgeInsets.all(24),
        radius: 30,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIconBox(
              icon: Icons.emoji_events_rounded,
              size: 72,
              iconSize: 42,
            ),
            const SizedBox(height: 18),
            const Text(
              '恭喜升级！',
              style: TextStyle(
                color: AppColors.title,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '完成任务获得 $addedPoints 分\n当前等级：$levelName',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.text,
                height: 1.55,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 22),
            AppPrimaryButton(
              text: '太棒了',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}