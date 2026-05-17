import 'package:flutter/material.dart';

import 'app_ui.dart';

class AppBottomStepBar extends StatelessWidget {
  final int currentStep;

  const AppBottomStepBar({
    super.key,
    required this.currentStep,
  });

  static const List<_StepInfo> steps = [
    _StepInfo(
      label: '输入信息',
      icon: Icons.edit_note_rounded,
    ),
    _StepInfo(
      label: '健康诊断',
      icon: Icons.favorite_rounded,
    ),
    _StepInfo(
      label: '规划报告',
      icon: Icons.assignment_rounded,
    ),
    _StepInfo(
      label: '亲子财商',
      icon: Icons.family_restroom_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 22,
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
    final Color activeColor = AppColors.primary;
    final Color inactiveColor = AppColors.hint;
    final Color color = isActive || isDone ? activeColor : inactiveColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          width: isActive ? 44 : 38,
          height: isActive ? 44 : 38,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.primaryLight,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.border,
              width: 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.22),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Icon(
            isDone ? Icons.check_rounded : icon,
            color: isActive ? Colors.white : color,
            size: isActive ? 22 : 19,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
            fontSize: 11.5,
            fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}