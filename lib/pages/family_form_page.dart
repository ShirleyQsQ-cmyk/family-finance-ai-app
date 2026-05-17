import 'package:flutter/material.dart';

import '../models/family_info.dart';
import '../services/diagnosis_service.dart';
import '../services/education_plan_service.dart';
import '../services/finance_task_service.dart';
import '../services/linear_model_service.dart';
import '../widgets/app_bottom_step_bar.dart';
import '../widgets/app_ui.dart';
import 'diagnosis_page.dart';

class FamilyFormPage extends StatefulWidget {
  final LinearModelService modelService;

  const FamilyFormPage({
    super.key,
    required this.modelService,
  });

  @override
  State<FamilyFormPage> createState() => _FamilyFormPageState();
}

class _FamilyFormPageState extends State<FamilyFormPage> {
  static const int minChildCount = 1;
  static const int maxChildCount = 5;
  static const int minChildAge = 0;
  static const int maxChildAge = 18;

  String selectedFamilyStructure = '双亲家庭';
  int selectedChildCount = 1;
  List<int> selectedChildAges = [8];
  String selectedMainGoal = '规划教育金，降低育儿支出压力';

  final incomeController = TextEditingController(text: '30000');
  final expenseController = TextEditingController(text: '22000');
  final educationController = TextEditingController(text: '7000');

  bool hasEmergencyFund = false;
  bool hasEducationFund = false;
  bool hasBasicInsurance = false;

  final List<String> familyStructures = [
    '双亲家庭',
    '单亲家庭',
    '三代同住家庭',
    '隔代照护家庭',
    '其他家庭结构',
  ];

  final List<String> mainGoals = [
    '规划教育金，降低育儿支出压力',
    '建立家庭应急金',
    '优化兴趣班和教育支出',
    '补齐家庭基础保障',
    '培养孩子财商意识',
  ];

  @override
  void dispose() {
    incomeController.dispose();
    expenseController.dispose();
    educationController.dispose();
    super.dispose();
  }

  double parseDouble(TextEditingController controller) {
    return double.tryParse(controller.text.trim()) ?? 0;
  }

  void updateChildCount(int count) {
    final safeCount = count.clamp(minChildCount, maxChildCount);

    setState(() {
      selectedChildCount = safeCount;

      if (selectedChildAges.length < safeCount) {
        selectedChildAges.addAll(
          List.filled(safeCount - selectedChildAges.length, 8),
        );
      } else if (selectedChildAges.length > safeCount) {
        selectedChildAges = selectedChildAges.take(safeCount).toList();
      }
    });
  }

  void updateChildAge(int index, int age) {
    setState(() {
      selectedChildAges[index] = age;
    });
  }

  void submit() {
    final info = FamilyInfo(
      familyStructure: selectedFamilyStructure,
      childAges: selectedChildAges,
      monthlyIncome: parseDouble(incomeController),
      monthlyExpense: parseDouble(expenseController),
      educationExpense: parseDouble(educationController),
      hasEmergencyFund: hasEmergencyFund,
      hasEducationFund: hasEducationFund,
      hasBasicInsurance: hasBasicInsurance,
      mainGoal: selectedMainGoal,
    );

    final diagnosisService = DiagnosisService(widget.modelService);
    final educationPlanService = EducationPlanService();
    final financeTaskService = FinanceTaskService();

    final diagnosis = diagnosisService.diagnose(info);
    final educationPlan = educationPlanService.generatePlan(info);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiagnosisPage(
          info: info,
          diagnosis: diagnosis,
          educationPlan: educationPlan,
          financeTaskService: financeTaskService,
        ),
      ),
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
          '家庭信息录入',
          style: TextStyle(
            color: AppColors.title,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomStepBar(currentStep: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _StepHeader(),
            const SizedBox(height: 22),

            const AppSectionTitle(
              title: '让我们了解您的家庭',
              subtitle: '请填写基本信息，AI 将为您提供个性化规划',
            ),

            const SizedBox(height: 18),

            const Text(
              '家庭结构',
              style: TextStyle(
                color: AppColors.title,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.35,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: familyStructures.map((item) {
                return _ChoiceCard(
                  title: item,
                  icon: item == '双亲家庭'
                      ? Icons.family_restroom_rounded
                      : item == '单亲家庭'
                          ? Icons.person_rounded
                          : Icons.groups_rounded,
                  selected: selectedFamilyStructure == item,
                  onTap: () {
                    setState(() => selectedFamilyStructure = item);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    '孩子数量',
                    style: TextStyle(
                      color: AppColors.title,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                AppPill(
                  text: '最多 $maxChildCount 个',
                  icon: Icons.info_outline_rounded,
                  color: AppColors.primary,
                  background: AppColors.primaryLight,
                ),
              ],
            ),

            const SizedBox(height: 12),

            AppCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _RoundButton(
                    icon: Icons.remove_rounded,
                    onTap: selectedChildCount > minChildCount
                        ? () => updateChildCount(selectedChildCount - 1)
                        : null,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '$selectedChildCount 个孩子',
                        style: const TextStyle(
                          color: AppColors.title,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  _RoundButton(
                    icon: Icons.add_rounded,
                    onTap: selectedChildCount < maxChildCount
                        ? () => updateChildCount(selectedChildCount + 1)
                        : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: const [
                Expanded(
                  child: Text(
                    '孩子年龄',
                    style: TextStyle(
                      color: AppColors.title,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                AppPill(
                  text: '0–18 岁',
                  icon: Icons.school_rounded,
                  color: AppColors.primary,
                  background: AppColors.primaryLight,
                ),
              ],
            ),

            const SizedBox(height: 12),

            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(selectedChildAges.length, (index) {
                  return _AgePickerRow(
                    label: '第 ${index + 1} 个孩子',
                    value: selectedChildAges[index],
                    minAge: minChildAge,
                    maxAge: maxChildAge,
                    onChanged: (age) => updateChildAge(index, age),
                  );
                }),
              ),
            ),

            const SizedBox(height: 22),

            const AppSectionTitle(
              title: '收入与支出',
              subtitle: '模型会计算储蓄率与教育支出占比',
              icon: Icons.payments_rounded,
            ),

            const SizedBox(height: 14),

            _InputCard(
              controller: incomeController,
              label: '家庭月收入',
              icon: Icons.account_balance_wallet_rounded,
              suffix: '元',
            ),

            _InputCard(
              controller: expenseController,
              label: '家庭月支出',
              icon: Icons.shopping_bag_rounded,
              suffix: '元',
            ),

            _InputCard(
              controller: educationController,
              label: '每月教育 / 兴趣班支出',
              icon: Icons.school_rounded,
              suffix: '元',
            ),

            const SizedBox(height: 22),

            const AppSectionTitle(
              title: '保障情况',
              subtitle: '用于判断应急金、教育金和基础保障缺口',
              icon: Icons.shield_outlined,
            ),

            const SizedBox(height: 14),

            _SwitchCard(
              title: '已有 3–6 个月家庭应急金',
              subtitle: '用于应对突发医疗、失业或大额支出',
              value: hasEmergencyFund,
              onChanged: (value) => setState(() => hasEmergencyFund = value),
            ),

            _SwitchCard(
              title: '已有教育金储备',
              subtitle: '已开始为孩子未来教育支出定期储蓄',
              value: hasEducationFund,
              onChanged: (value) => setState(() => hasEducationFund = value),
            ),

            _SwitchCard(
              title: '已有基础保险配置',
              subtitle: '家庭主要成员具备基础风险保障',
              value: hasBasicInsurance,
              onChanged: (value) => setState(() => hasBasicInsurance = value),
            ),

            const SizedBox(height: 22),

            const AppSectionTitle(
              title: '主要财务目标',
              subtitle: '选择最符合当前家庭需求的规划方向',
              icon: Icons.flag_rounded,
            ),

            const SizedBox(height: 14),

            _SelectCard(
              value: selectedMainGoal,
              items: mainGoals,
              onChanged: (value) {
                setState(() => selectedMainGoal = value);
              },
            ),

            const SizedBox(height: 26),

            AppPrimaryButton(
              text: '生成家庭财务诊断',
              icon: Icons.auto_graph_rounded,
              onPressed: submit,
            ),

            const SizedBox(height: 12),

            const Center(
              child: Text(
                '输入信息仅用于本地原型演示，不连接真实账户',
                style: TextStyle(
                  color: AppColors.muted,
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

class _StepHeader extends StatelessWidget {
  const _StepHeader();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.primaryLight,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          const AppIconBox(
            icon: Icons.edit_note_rounded,
            size: 52,
            iconSize: 27,
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              '基础信息会被转化为模型特征，用于预测家庭财务健康评分。',
              style: TextStyle(
                color: AppColors.text,
                height: 1.5,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          AppPill(
            text: 'Step 1 / 4',
            background: Colors.white,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.hint,
              size: 30,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? AppColors.primary : AppColors.title,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _RoundButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primaryLight : const Color(0xFFF5EEEE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          icon,
          color: enabled ? AppColors.primary : AppColors.hint,
        ),
      ),
    );
  }
}

class _AgePickerRow extends StatelessWidget {
  final String label;
  final int value;
  final int minAge;
  final int maxAge;
  final ValueChanged<int> onChanged;

  const _AgePickerRow({
    required this.label,
    required this.value,
    required this.minAge,
    required this.maxAge,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ages = List<int>.generate(
      maxAge - minAge + 1,
      (index) => minAge + index,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<int>(
        initialValue: value,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.primary,
        ),
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          labelStyle: const TextStyle(
            color: AppColors.muted,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: const TextStyle(
          color: AppColors.title,
          fontWeight: FontWeight.w900,
          fontSize: 15,
        ),
        items: ages.map((age) {
          return DropdownMenuItem<int>(
            value: age,
            child: Text('$age 岁'),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String suffix;

  const _InputCard({
    required this.controller,
    required this.label,
    required this.icon,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: AppColors.title,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
        decoration: InputDecoration(
          icon: AppIconBox(
            icon: icon,
            size: 42,
            iconSize: 21,
          ),
          labelText: label,
          suffixText: suffix,
          border: InputBorder.none,
          labelStyle: const TextStyle(
            color: AppColors.muted,
            fontWeight: FontWeight.w700,
          ),
          suffixStyle: const TextStyle(
            color: AppColors.muted,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SwitchCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
      border: Border.all(
        color: value ? AppColors.primary : AppColors.border,
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.title,
            fontWeight: FontWeight.w900,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.muted,
              height: 1.45,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectCard extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _SelectCard({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.primary,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        style: const TextStyle(
          color: AppColors.title,
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}