import 'package:flutter/material.dart';

import 'app_ui.dart';

class AppBottomStepBar extends StatelessWidget {
  final int currentStep;

  const AppBottomStepBar({
    super.key,
    required this.currentStep,
  });

  static const steps = [
    _StepInfo(label: '录入', icon: Icons.edit_note_rounded),
    _StepInfo(label: '诊断', icon: Icons.analytics_rounded),
    _StepInfo(label: '报告', icon: Icons.description_rounded),
    _StepInfo(label: '陪伴', icon: Icons.child_friendly_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: const Color(0xFFDCE8F7),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: List.generate(
            steps.length,
            (index) {
              final stepNumber = index + 1;
              final item = steps[index];
              final isActive = stepNumber == currentStep;
              final isDone = stepNumber < currentStep;

              return Expanded(
                child: _StepItem(
                  label: item.label,
                  icon: item.icon,
                  isActive: isActive,
                  isDone: isDone,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StepInfo {
  final String label;
  final IconData icon;

  const _StepInfo({
    required this.label,
    required this.icon,
  });
}

class _StepItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isDone;

  const _StepItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive || isDone ? AppColors.primary : const Color(0xFFB8B2CC);
    final bgColor =
        isActive ? AppColors.primary : AppColors.primary.withOpacity(isDone ? 0.10 : 0.05);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: isActive ? 42 : 36,
          height: isActive ? 42 : 36,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDone ? Icons.check_rounded : icon,
            size: isActive ? 22 : 19,
            color: isActive ? Colors.white : color,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}