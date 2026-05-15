import 'dart:math';

import '../models/family_info.dart';

class FinanceTaskItem {
  final String content;
  final int points;

  const FinanceTaskItem({
    required this.content,
    required this.points,
  });
}

class FinanceTaskService {
  final Random _random = Random();

  T _pick<T>(List<T> items) {
    return items[_random.nextInt(items.length)];
  }

  FinanceTaskItem generateWeeklyTask(FamilyInfo info) {
    if (info.childAge <= 6) {
      return _pick([
        const FinanceTaskItem(
          content: '和孩子一起认识硬币和纸币，讨论买一瓶水需要多少钱。',
          points: 8,
        ),
        const FinanceTaskItem(
          content: '和孩子一起玩“开小商店”游戏，让孩子用玩具币购买水果或文具。',
          points: 10,
        ),
        const FinanceTaskItem(
          content: '和孩子一起做一个小储蓄罐，告诉孩子钱可以慢慢攒起来实现小愿望。',
          points: 12,
        ),
        const FinanceTaskItem(
          content: '让孩子从两样零食中选择一样，帮助孩子理解“选择”和“取舍”。',
          points: 8,
        ),
      ]);
    } else if (info.childAge <= 10) {
      return _pick([
        const FinanceTaskItem(
          content: '和孩子一起记录一次家庭超市消费，区分哪些是必需品，哪些是可选品。',
          points: 10,
        ),
        const FinanceTaskItem(
          content: '和孩子一起制定一周零花钱规则，讨论哪些钱可以花，哪些钱应该存起来。',
          points: 12,
        ),
        const FinanceTaskItem(
          content: '让孩子尝试把 20 元零花钱分成消费、储蓄和分享三部分。',
          points: 15,
        ),
        const FinanceTaskItem(
          content: '和孩子一起列出“想要”和“需要”清单，并讨论为什么有些东西可以晚点买。',
          points: 10,
        ),
        const FinanceTaskItem(
          content: '给孩子设定一个小目标，例如一本书或一个玩具，并计算需要存几周。',
          points: 12,
        ),
      ]);
    } else {
      return _pick([
        const FinanceTaskItem(
          content: '让孩子参与一次家庭购物预算制定，比较不同商品的价格和必要性。',
          points: 12,
        ),
        const FinanceTaskItem(
          content: '和孩子一起制定一个月度零花钱计划，区分固定支出、可选支出和储蓄。',
          points: 15,
        ),
        const FinanceTaskItem(
          content: '让孩子记录一周消费，并在周末复盘哪些支出值得、哪些可以减少。',
          points: 18,
        ),
        const FinanceTaskItem(
          content: '和孩子讨论一次“机会成本”：买了这个东西，就可能暂时不能买另一个东西。',
          points: 15,
        ),
        const FinanceTaskItem(
          content: '和孩子讨论“应急金”的概念：为什么家庭需要为突发情况提前准备钱。',
          points: 18,
        ),
      ]);
    }
  }

  FinanceTaskItem generateSavingChallenge(FamilyInfo info) {
    if (info.educationRate > 0.3) {
      return _pick([
        const FinanceTaskItem(
          content: '本周减少一次冲动型亲子消费，把省下来的钱放入教育储备账户。',
          points: 15,
        ),
        const FinanceTaskItem(
          content: '本周暂停一次非必要兴趣消费，和孩子一起讨论这笔钱可以用于什么长期目标。',
          points: 18,
        ),
        const FinanceTaskItem(
          content: '本周设置一次“延迟购买挑战”：想买的东西先等 24 小时再决定。',
          points: 15,
        ),
      ]);
    }

    if (!info.hasEmergencyFund) {
      return _pick([
        const FinanceTaskItem(
          content: '本周设立一个家庭应急金小目标，先完成第一笔小额储蓄。',
          points: 15,
        ),
        const FinanceTaskItem(
          content: '本周和孩子一起建立“家庭安全罐”，把一笔小额资金作为应急金起点。',
          points: 18,
        ),
        const FinanceTaskItem(
          content: '本周减少一次外出消费，把省下的钱放入家庭应急金账户。',
          points: 12,
        ),
      ]);
    }

    if (!info.hasEducationFund) {
      return _pick([
        const FinanceTaskItem(
          content: '本周建立一个教育金小目标，先为孩子未来学习储备第一笔钱。',
          points: 15,
        ),
        const FinanceTaskItem(
          content: '本周和孩子一起画一个“未来学习目标储蓄进度条”。',
          points: 12,
        ),
        const FinanceTaskItem(
          content: '本周把一笔固定金额放入教育储备账户，形成长期储蓄习惯。',
          points: 18,
        ),
      ]);
    }

    return _pick([
      const FinanceTaskItem(
        content: '本周和孩子一起设定一个小储蓄目标，例如为一本书或一次家庭活动存钱。',
        points: 12,
      ),
      const FinanceTaskItem(
        content: '本周完成一次“不买也可以”挑战，把省下的钱记录下来。',
        points: 15,
      ),
      const FinanceTaskItem(
        content: '本周和孩子一起复盘一次消费，选出最值得的一笔和最可以减少的一笔。',
        points: 18,
      ),
    ]);
  }

  String generateConversationTip(FamilyInfo info) {
    if (info.childAge <= 6) {
      return _pick([
        '可以这样解释：钱是用来交换物品的，但每次花钱前都要想一想，这是不是现在最需要的东西。',
        '可以这样说：我们把钱放进储蓄罐，就像给未来的小愿望慢慢加能量。',
        '可以这样解释：有些东西是每天都需要的，比如食物；有些东西是想要的，比如新玩具。',
      ]);
    } else if (info.childAge <= 10) {
      return _pick([
        '可以这样解释“预算”：预算不是不让我们花钱，而是帮助我们先把钱用在最重要的地方。',
        '可以这样解释“需要”和“想要”：需要是生活必须的，想要是让生活更开心但可以等待的。',
        '可以这样说：聪明花钱不是不花钱，而是知道为什么花、值不值得花。',
      ]);
    } else {
      return _pick([
        '可以这样解释“规划”：有些目标需要更长时间准备，所以我们要把今天的小储蓄变成未来的大选择。',
        '可以这样解释“机会成本”：买一个东西的时候，也意味着暂时放弃了其他可能的选择。',
        '可以这样说：预算不是限制自由，而是让我们更清楚自己能承担什么、想优先完成什么。',
      ]);
    }
  }

  int generateBasePoints(FamilyInfo info) {
    int points = 10;

    if (info.savingRate >= 0.1) points += 5;
    if (info.hasEmergencyFund) points += 5;
    if (info.hasEducationFund) points += 5;

    return points;
  }
}