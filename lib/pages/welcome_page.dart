import 'package:flutter/material.dart';

import '../services/linear_model_service.dart';
import '../widgets/app_ui.dart';
import 'family_form_page.dart';

class WelcomePage extends StatelessWidget {
  final LinearModelService modelService;

  const WelcomePage({
    super.key,
    required this.modelService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppPill(
                text: 'AI 财务规划助手',
                icon: Icons.auto_awesome_rounded,
              ),
              const SizedBox(height: 28),

              const Text(
                '家育财伴',
                style: TextStyle(
                  color: AppColors.title,
                  fontSize: 46,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 4),

              const Text(
                'FamilyFin AI',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 42,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 18),

              const Text(
                '面向 0–18 岁亲子家庭的 AI 财务规划 App',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 26),

              _WelcomeHero(modelService: modelService),

              const SizedBox(height: 22),

              AppCard(
                padding: const EdgeInsets.all(20),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 16,
                      height: 1.7,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(text: '从“焦虑驱动的碎片化决策”\n'),
                      TextSpan(text: '到“'),
                      TextSpan(
                        text: '可理解、可执行、可持续的家庭财务规划',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(text: '”'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: const [
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.track_changes_rounded,
                      title: '目标清晰',
                      subtitle: '识别家庭规划重点',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.analytics_rounded,
                      title: '智能评分',
                      subtitle: '模型生成诊断',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.family_restroom_rounded,
                      title: '亲子陪伴',
                      subtitle: '财商任务互动',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              AppPrimaryButton(
                text: '开始规划',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FamilyFormPage(
                        modelService: modelService,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              AppSecondaryButton(
                text: '了解更多',
                icon: Icons.info_outline_rounded,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const _MoreInfoSheet(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeHero extends StatelessWidget {
  final LinearModelService modelService;

  const _WelcomeHero({
    required this.modelService,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      radius: 34,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(34),
            ),
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 260,
                  child: Image.asset(
                    'assets/images/welcome_family.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFFFF3F3),
                        padding: const EdgeInsets.all(22),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image_rounded,
                                color: AppColors.primary,
                                size: 42,
                              ),
                              SizedBox(height: 10),
                              Text(
                                '图片未加载',
                                style: TextStyle(
                                  color: AppColors.title,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                '请检查 assets/images/welcome_family.png',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.04),
                          Colors.white.withValues(alpha: 0.22),
                          Colors.white.withValues(alpha: 0.72),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 18,
                  right: 20,
                  child: Row(
                    children: const [
                      _Dot(color: Color(0xFFD12E2E)),
                      SizedBox(width: 8),
                      _Dot(color: Color(0xFFFF6A32)),
                      SizedBox(width: 8),
                      _Dot(color: Color(0xFFFFB020)),
                    ],
                  ),
                ),

                const Positioned(
                  left: 24,
                  bottom: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '您好',
                        style: TextStyle(
                          color: AppColors.title,
                          fontSize: 36,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.6,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '让我们一起为孩子规划美好未来',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 16,
                          height: 1.45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: AppGradientCard(
              radius: 26,
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '核心功能',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '家庭财务健康诊断',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      height: 1.15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '填写家庭信息后，系统会生成财务健康评分、教育金规划、基础保障提示和亲子财商任务。',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.90),
                      fontSize: 13.5,
                      height: 1.55,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: const [
                      Expanded(
                        child: _MiniMetric(
                          icon: Icons.analytics_rounded,
                          title: '健康评分',
                          value: '模型预测',
                        ),
                      ),
                      Expanded(
                        child: _MiniMetric(
                          icon: Icons.school_rounded,
                          title: '教育金',
                          value: '缺口测算',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
            child: Row(
              children: const [
                Expanded(
                  child: _PreviewSmallCard(
                    icon: Icons.health_and_safety_rounded,
                    title: '保障提示',
                    subtitle: '识别保障缺口',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _PreviewSmallCard(
                    icon: Icons.child_care_rounded,
                    title: '亲子财商',
                    subtitle: '每周互动任务',
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const AppIconBox(
                    icon: Icons.auto_awesome_rounded,
                    size: 44,
                    iconSize: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'AI 模型已就绪：${modelService.modelType}。填写家庭信息后即可生成诊断结果。',
                      style: const TextStyle(
                        color: AppColors.text,
                        height: 1.45,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
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

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _MiniMetric({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewSmallCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PreviewSmallCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 122,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBox(
            icon: icon,
            size: 42,
            iconSize: 22,
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.title,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      radius: 22,
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 28,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.title,
              fontWeight: FontWeight.w900,
              fontSize: 14.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
              height: 1.35,
              fontWeight: FontWeight.w600,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreInfoSheet extends StatelessWidget {
  const _MoreInfoSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '关于 FamilyFin AI',
            style: TextStyle(
              color: AppColors.title,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'FamilyFin AI 使用线性回归模型进行家庭财务健康评分，并结合规则引擎生成教育金规划、保障提示和亲子财商任务。',
            style: TextStyle(
              color: AppColors.text,
              height: 1.65,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}