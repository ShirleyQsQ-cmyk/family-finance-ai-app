import 'package:flutter/material.dart';

import 'pages/welcome_page.dart';
import 'services/linear_model_service.dart';

void main() {
  runApp(const FamilyAppAI());
}

class FamilyAppAI extends StatefulWidget {
  const FamilyAppAI({super.key});

  @override
  State<FamilyAppAI> createState() => _FamilyAppAIState();
}

class _FamilyAppAIState extends State<FamilyAppAI> {
  final LinearModelService modelService = LinearModelService();

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      await modelService.loadModel();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FamilyFin AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF5F8FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF004B8D),
          primary: const Color(0xFF004B8D),
          secondary: const Color(0xFFFFB86B),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Color(0xFFF5F8FF),
          foregroundColor: Color(0xFF1F1F2E),
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1F1F2E),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF004B8D),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: false,
          labelStyle: const TextStyle(
            color: Color(0xFF66667A),
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),

      // 关键优化：Web / Desktop 居中成手机 App 宽度
      builder: (context, child) {
        return Container(
          color: const Color(0xFFDCE8F7),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F8FF),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
        );
      },

      home: isLoading
          ? const LoadingPage()
          : errorMessage != null
              ? ErrorPage(message: errorMessage!)
              : WelcomePage(modelService: modelService),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F8FF),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF004B8D),
        ),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              '模型加载失败：\n$message',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Color(0xFFE85D75),
              ),
            ),
          ),
        ),
      ),
    );
  }
}