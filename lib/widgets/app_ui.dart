import 'package:flutter/material.dart';

class AppColors {
  // China Merchants Bank inspired palette:
  // deep blue as primary, red as accent, white cards, light blue background.
  static const primary = Color(0xFF004B8D);
  static const primaryLight = Color(0xFF2F7BC6);
  static const accentRed = Color(0xFFD71920);

  static const lightBackground = Color(0xFFF5F8FF);
  static const lightBorder = Color(0xFFDCE8F7);

  static const darkText = Color(0xFF1F1F2E);
  static const greyText = Color(0xFF77778A);

  static const green = Color(0xFF21A67A);
  static const orange = Color(0xFFFF8A65);
  static const yellow = Color(0xFFF5A623);
  static const danger = Color(0xFFE85D75);

  static const white = Colors.white;
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color color;
  final double radius;
  final Color? shadowColor;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.color = AppColors.white,
    this.radius = 26,
    this.shadowColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: border ??
            Border.all(
              color: AppColors.lightBorder,
            ),
        boxShadow: [
          BoxShadow(
            color: (shadowColor ?? AppColors.primary).withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AppSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const AppSectionTitle({
    super.key,
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
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: AppColors.greyText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class AppPrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;

  const AppPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
            ],
          );

    return SizedBox(
      width: double.infinity,
      height: 58,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class AppSecondaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;

  const AppSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          );

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(
            color: AppColors.lightBorder,
            width: 1.2,
          ),
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class AppNoteCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const AppNoteCard({
    super.key,
    required this.text,
    this.icon = Icons.info_rounded,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: color.withOpacity(0.08),
      shadowColor: color,
      border: Border.all(
        color: color.withOpacity(0.20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color.withOpacity(0.90),
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

class AppGradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final List<Color> colors;

  const AppGradientCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.radius = 30,
    this.colors = const [
      AppColors.primary,
      AppColors.primaryLight,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}