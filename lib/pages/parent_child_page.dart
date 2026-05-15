import 'package:flutter/material.dart';

import '../models/family_info.dart';
import '../services/finance_task_service.dart';
import '../widgets/app_bottom_step_bar.dart';

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

  int get earnedTaskPoints {
    int points = 0;

    if (taskCompleted) points += task.points;
    if (challengeCompleted) points += challenge.points;

    return points;
  }

  int get totalPoints => basePoints + earnedTaskPoints;

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

    final previousTarget = currentLevel == 1
        ? 0
        : currentLevel == 2
            ? 25
            : currentLevel == 3
                ? 50
                : 80;

    final range = nextLevelTarget - previousTarget;
    final progress = (totalPoints - previousTarget) / range;

    return progress.clamp(0.0, 1.0);
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
    final int addedPoints = type == 'task' ? task.points : challenge.points;

    setState(() {
      if (type == 'task') {
        taskCompleted = true;
      }

      if (type == 'challenge') {
        challengeCompleted = true;
      }
    });

    final newLevel = currentLevel;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          type == 'task'
              ? '家庭小任务已完成，积分 +${task.points}'
              : '储蓄挑战已完成，积分 +${challenge.points}',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF004B8D),
        duration: const Duration(milliseconds: 1300),
      ),
    );

    if (newLevel > oldLevel) {
      Future.delayed(const Duration(milliseconds: 450), () {
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF004B8D).withOpacity(0.18),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD71920).withOpacity(0.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        color: Color(0xFFD71920),
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      '恭喜升级！',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1F1F2E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '完成任务获得 $addedPoints 分\n当前等级：$levelName',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        height: 1.55,
                        fontSize: 15,
                        color: Color(0xFF44445A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF004B8D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '太棒了',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
                      color: const Color(0xFFDCE8F7),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color(0xFF004B8D).withOpacity(0.10),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.stars_rounded,
                          color: Color(0xFF004B8D),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '亲子积分详情',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1F1F2E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              levelName,
                              style: const TextStyle(
                                color: Color(0xFF77778A),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '$totalPoints 分',
                        style: const TextStyle(
                          color: Color(0xFF004B8D),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: levelProgress,
                      minHeight: 10,
                      backgroundColor: const Color(0xFFEAF1FA),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFD71920),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pointsToNextLevel == 0
                        ? '已经达到当前原型的最高等级。'
                        : '距离下一级还差 $pointsToNextLevel 分。',
                    style: const TextStyle(
                      color: Color(0xFF44445A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _PointDetailRow(
                    label: '基础积分',
                    value: '+$basePoints',
                    completed: true,
                  ),
                  _PointDetailRow(
                    label: '完成家庭小任务',
                    value: '+${task.points}',
                    completed: taskCompleted,
                  ),
                  _PointDetailRow(
                    label: '完成储蓄挑战',
                    value: '+${challenge.points}',
                    completed: challengeCompleted,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F8FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '升级规则：25 分升到 Level 2，50 分升到 Level 3，80 分升到 Level 4。积分用于鼓励亲子持续完成财商任务。',
                      style: TextStyle(
                        height: 1.55,
                        color: Color(0xFF44445A),
                        fontWeight: FontWeight.w600,
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
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F8FF),
        title: const Text(
          '亲子财商陪伴',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const AppBottomStepBar(currentStep: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroCard(childAge: widget.info.childAge),
            const SizedBox(height: 18),
            const _SectionTitle(
              title: '本周亲子任务',
              subtitle: '完成家庭小任务和储蓄挑战后会自动增加亲子积分',
            ),
            const SizedBox(height: 12),
            _MainTaskCard(
              title: '家庭小任务',
              content: task.content,
              icon: Icons.assignment_turned_in_rounded,
              color: const Color(0xFF004B8D),
              badge: 'Task 01',
              points: task.points,
              completed: taskCompleted,
              onComplete: () => completeTask('task'),
            ),
            _MainTaskCard(
              title: '储蓄挑战',
              content: challenge.content,
              icon: Icons.savings_rounded,
              color: const Color(0xFF21A67A),
              badge: 'Task 02',
              points: challenge.points,
              completed: challengeCompleted,
              onComplete: () => completeTask('challenge'),
            ),
            _ConversationCard(content: tip),
            const SizedBox(height: 18),
            const _SectionTitle(
              title: '亲子积分',
              subtitle: '点击积分卡片查看等级、进度和积分明细',
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: showPointsDetail,
              child: _PointsCard(
                points: totalPoints,
                levelName: levelName,
                progress: levelProgress,
                pointsToNextLevel: pointsToNextLevel,
              ),
            ),
            const SizedBox(height: 18),
            _ChecklistCard(
              taskCompleted: taskCompleted,
              challengeCompleted: challengeCompleted,
            ),
            const SizedBox(height: 18),
            _NoteCard(),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF004B8D),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.home_rounded),
                label: const Text(
                  '返回首页',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final int childAge;

  const _HeroCard({
    required this.childAge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.family_restroom_rounded,
                color: Colors.white,
                size: 34,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '亲子财商陪伴',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                'Step 4 / 4',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '$childAge 岁孩子的本周财商计划',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              height: 1.15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '系统根据孩子年龄和家庭财务状态，智能匹配适合本周完成的亲子任务、储蓄挑战和沟通话术。',
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              height: 1.6,
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              _HeroPill(
                icon: Icons.task_alt_rounded,
                text: '任务陪伴',
              ),
              SizedBox(width: 10),
              _HeroPill(
                icon: Icons.emoji_events_rounded,
                text: '积分激励',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeroPill({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.20),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: Colors.white.withOpacity(0.24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 17,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainTaskCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;
  final String badge;
  final int points;
  final bool completed;
  final VoidCallback onComplete;

  const _MainTaskCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
    required this.badge,
    required this.points,
    required this.completed,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: completed ? color.withOpacity(0.35) : const Color(0xFFDCE8F7),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(completed ? 0.14 : 0.08),
            blurRadius: completed ? 22 : 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(completed ? 0.18 : 0.12),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  completed ? Icons.check_rounded : icon,
                  color: color,
                  size: 26,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      badge,
                      style: TextStyle(
                        color: color,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF1F1F2E),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '+$points',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              height: 1.6,
              fontSize: 15,
              color: Color(0xFF44445A),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: completed ? const Color(0xFFEAF1FA) : color,
                foregroundColor:
                    completed ? const Color(0xFF004B8D) : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: completed ? null : onComplete,
              icon: Icon(
                completed ? Icons.check_circle_rounded : Icons.add_task_rounded,
              ),
              label: Text(
                completed ? '已完成' : '完成任务',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  final String content;

  const _ConversationCard({
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2E),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F1F2E).withOpacity(0.16),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.chat_bubble_rounded,
                color: Colors.white,
                size: 25,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '智能建议沟通方式',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
              ),
            ),
            child: Text(
              '“$content”',
              style: TextStyle(
                color: Colors.white.withOpacity(0.92),
                height: 1.65,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF004B8D),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004B8D).withOpacity(0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(end: progress),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 1.0 + value * 0.05,
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.stars_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '本周亲子积分',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
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
                    const SizedBox(height: 4),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.25),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        levelName,
                        key: ValueKey(levelName),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Colors.white,
                size: 28,
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
                  backgroundColor: Colors.white.withOpacity(0.22),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFD71920),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Text(
              pointsToNextLevel == 0
                  ? '已达到当前最高等级，点击查看积分明细。'
                  : '还差 $pointsToNextLevel 分升到下一级，点击查看详情。',
              key: ValueKey(pointsToNextLevel),
              style: TextStyle(
                color: Colors.white.withOpacity(0.86),
                height: 1.45,
                fontSize: 13.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PointDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool completed;

  const _PointDetailRow({
    required this.label,
    required this.value,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: completed ? const Color(0xFFF5F8FF) : const Color(0xFFF7F7FA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color:
                completed ? const Color(0xFF004B8D) : const Color(0xFFAAAAAA),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF44445A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color:
                  completed ? const Color(0xFFD71920) : const Color(0xFFAAAAAA),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  final bool taskCompleted;
  final bool challengeCompleted;

  const _ChecklistCard({
    required this.taskCompleted,
    required this.challengeCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _ChecklistItemData(
        text: '完成一次家庭小任务',
        completed: taskCompleted,
      ),
      _ChecklistItemData(
        text: '完成一次储蓄挑战',
        completed: challengeCompleted,
      ),
    ];

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
                '本周完成清单',
                style: TextStyle(
                  color: Color(0xFF1F1F2E),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: item.completed
                          ? const Color(0xFF004B8D)
                          : const Color(0xFFEAF1FA),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.completed
                          ? Icons.check_rounded
                          : Icons.more_horiz_rounded,
                      color: item.completed
                          ? Colors.white
                          : const Color(0xFF004B8D),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.text,
                      style: TextStyle(
                        color: const Color(0xFF44445A),
                        fontWeight:
                            item.completed ? FontWeight.w900 : FontWeight.w700,
                        height: 1.4,
                      ),
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

class _ChecklistItemData {
  final String text;
  final bool completed;

  const _ChecklistItemData({
    required this.text,
    required this.completed,
  });
}

class _NoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFDCE8F7),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_rounded,
            color: Color(0xFF004B8D),
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              '原型阶段使用规则模板生成亲子财商任务，不接入大语言模型，保证内容稳定可控。',
              style: TextStyle(
                color: Color(0xFF004B8D),
                height: 1.55,
                fontSize: 13.5,
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