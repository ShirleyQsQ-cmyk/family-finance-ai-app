import 'package:flutter/material.dart';

import '../models/family_info.dart';
import '../services/diagnosis_service.dart';
import '../services/education_plan_service.dart';
import '../services/finance_task_service.dart';
import '../services/linear_model_service.dart';
import '../widgets/app_bottom_step_bar.dart';
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

  final List<int> childCountOptions = [1, 2, 3];

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
    setState(() {
      selectedChildCount = count;

      if (selectedChildAges.length < count) {
        final needAdd = count - selectedChildAges.length;
        selectedChildAges.addAll(List.filled(needAdd, 8));
      } else if (selectedChildAges.length > count) {
        selectedChildAges = selectedChildAges.take(count).toList();
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
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F8FF),
        elevation: 0,
        title: const Text(
          '家庭信息录入',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const AppBottomStepBar(currentStep: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ProgressHeader(),
            const SizedBox(height: 20),

            const _FormSectionTitle(
              title: '基础家庭信息',
              subtitle: '通过选项快速识别家庭阶段、孩子年龄和主要规划目标',
            ),
            const SizedBox(height: 12),

            _SelectCard<String>(
              label: '家庭成员结构',
              icon: Icons.groups_rounded,
              value: selectedFamilyStructure,
              items: familyStructures,
              onChanged: (value) {
                setState(() => selectedFamilyStructure = value);
              },
            ),

            _SelectCard<int>(
              label: '孩子数量',
              icon: Icons.child_friendly_rounded,
              value: selectedChildCount,
              items: childCountOptions,
              displayBuilder: (value) => '$value 个孩子',
              onChanged: updateChildCount,
            ),

            _ChildAgeGroupCard(
              childAges: selectedChildAges,
              onChanged: updateChildAge,
            ),

            _SelectCard<String>(
              label: '主要财务目标',
              icon: Icons.flag_rounded,
              value: selectedMainGoal,
              items: mainGoals,
              onChanged: (value) {
                setState(() => selectedMainGoal = value);
              },
            ),

            const SizedBox(height: 14),

            const _FormSectionTitle(
              title: '收入与支出',
              subtitle: '模型会计算储蓄率和教育支出占比',
            ),
            const SizedBox(height: 12),

            _InputCard(
              controller: incomeController,
              label: '家庭月收入',
              icon: Icons.payments_rounded,
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
              label: '每月教育/兴趣班支出',
              icon: Icons.school_rounded,
              suffix: '元',
            ),

            const SizedBox(height: 14),

            const _FormSectionTitle(
              title: '家庭保障情况',
              subtitle: '用于判断应急金、教育金和基础保障缺口',
            ),
            const SizedBox(height: 12),

            _SwitchCard(
              title: '已有 3–6 个月家庭应急金',
              subtitle: '用于应对突发医疗、失业或大额支出',
              value: hasEmergencyFund,
              onChanged: (value) {
                setState(() => hasEmergencyFund = value);
              },
            ),
            _SwitchCard(
              title: '已有教育金储备',
              subtitle: '已开始为孩子未来教育支出定期储蓄',
              value: hasEducationFund,
              onChanged: (value) {
                setState(() => hasEducationFund = value);
              },
            ),
            _SwitchCard(
              title: '已有基础保险配置',
              subtitle: '家庭主要成员具备基础风险保障',
              value: hasBasicInsurance,
              onChanged: (value) {
                setState(() => hasBasicInsurance = value);
              },
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
                onPressed: submit,
                icon: const Icon(Icons.auto_graph_rounded),
                label: const Text(
                  '生成家庭财务诊断',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Center(
              child: Text(
                '输入信息仅用于本地原型演示，不连接真实账户',
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

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF004B8D),
            Color(0xFF2F7BC6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004B8D).withOpacity(0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                color: Colors.white,
                size: 38,
              ),
              Spacer(),
              Text(
                'Step 1 / 4',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '告诉 AI 你的家庭情况',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '系统会将家庭信息转化为 9 个模型特征，并预测综合财务健康评分。',
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              height: 1.6,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: 0.25,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _FormSectionTitle({
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

class _SelectCard<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final T value;
  final List<T> items;
  final ValueChanged<T> onChanged;
  final String Function(T value)? displayBuilder;

  const _SelectCard({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.displayBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFFDCE8F7),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004B8D).withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF004B8D),
        ),
        decoration: InputDecoration(
          icon: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF004B8D).withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF004B8D),
              size: 21,
            ),
          ),
          labelText: label,
          border: InputBorder.none,
          labelStyle: const TextStyle(
            color: Color(0xFF77778A),
            fontWeight: FontWeight.w600,
          ),
        ),
        style: const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1F1F2E),
        ),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              displayBuilder == null ? item.toString() : displayBuilder!(item),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

class _ChildAgeGroupCard extends StatelessWidget {
  final List<int> childAges;
  final void Function(int index, int age) onChanged;

  const _ChildAgeGroupCard({
    required this.childAges,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ages = List<int>.generate(19, (index) => index);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFFDCE8F7),
          width: 1,
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
        children: List.generate(childAges.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == childAges.length - 1 ? 0 : 12,
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF004B8D).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Color(0xFF004B8D),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: childAges[index],
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF004B8D),
                    ),
                    decoration: InputDecoration(
                      labelText: '第 ${index + 1} 个孩子年龄',
                      border: InputBorder.none,
                      labelStyle: const TextStyle(
                        color: Color(0xFF77778A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F1F2E),
                    ),
                    items: ages.map((age) {
                      return DropdownMenuItem<int>(
                        value: age,
                        child: Text('$age 岁'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        onChanged(index, value);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? suffix;

  const _InputCard({
    required this.controller,
    required this.label,
    required this.icon,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFFDCE8F7),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004B8D).withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1F1F2E),
        ),
        decoration: InputDecoration(
          icon: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF004B8D).withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF004B8D),
              size: 21,
            ),
          ),
          labelText: label,
          suffixText: suffix,
          border: InputBorder.none,
          labelStyle: const TextStyle(
            color: Color(0xFF77778A),
            fontWeight: FontWeight.w600,
          ),
          suffixStyle: const TextStyle(
            color: Color(0xFF77778A),
            fontWeight: FontWeight.w700,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: value
              ? const Color(0xFF004B8D).withOpacity(0.28)
              : const Color(0xFFDCE8F7),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004B8D).withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF004B8D),
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF1F1F2E),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(
              height: 1.45,
              color: Color(0xFF77778A),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}