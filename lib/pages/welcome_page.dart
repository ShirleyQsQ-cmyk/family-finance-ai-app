import 'package:flutter/material.dart';

import '../services/linear_model_service.dart';
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF004B8D),
              Color(0xFF2F7BC6),
              Color(0xFFF5F8FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _TopBadge(),
                  const SizedBox(height: 26),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.32),
                      ),
                    ),
                    child: const Icon(
                      Icons.family_restroom_rounded,
                      color: Colors.white,
                      size: 54,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'FamilyFin AI',
                    style: TextStyle(
                      fontSize: 40,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    '亲子家庭财务健康诊断 App',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    '用一个训练后的线性回归模型，把家庭收入、支出、教育投入和保障状态转化为可解释的财务健康评分。',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.65,
                      color: Colors.white.withOpacity(0.92),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: const [
                      Expanded(
                        child: _FeatureMiniCard(
                          icon: Icons.auto_graph_rounded,
                          title: '智能评分',
                          subtitle: '综合健康分',
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _FeatureMiniCard(
                          icon: Icons.school_rounded,
                          title: '教育金',
                          subtitle: '缺口测算',
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _FeatureMiniCard(
                          icon: Icons.shield_rounded,
                          title: '保障',
                          subtitle: '风险提示',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.94),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF004B8D).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.psychology_alt_rounded,
                            color: Color(0xFF004B8D),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            '模型已加载：${modelService.modelType}\nR² ${modelService.r2.toStringAsFixed(3)} · MAE ${modelService.mae.toStringAsFixed(2)}',
                            style: const TextStyle(
                              height: 1.45,
                              fontSize: 14,
                              color: Color(0xFF303044),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF004B8D),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19),
                        ),
                      ),
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
                      child: const Text(
                        '开始家庭财务体检',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      '无需连接真实账户 · 原型数据仅用于演示',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBadge extends StatelessWidget {
  const _TopBadge();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: Colors.white.withOpacity(0.28),
          ),
        ),
        child: const Text(
          'AI Product Prototype',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _FeatureMiniCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureMiniCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 23,
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.82),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}