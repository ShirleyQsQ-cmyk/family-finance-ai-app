import 'dart:convert';

import 'package:flutter/services.dart';

class LinearModelService {
  Map<String, dynamic>? _modelData;

  Future<void> loadModel() async {
    final jsonString =
        await rootBundle.loadString('assets/family_finance_model.json');

    _modelData = jsonDecode(jsonString);
  }

  bool get isLoaded => _modelData != null;

  double predictFinancialHealthScore(Map<String, double> features) {
    if (_modelData == null) {
      throw Exception('Model has not been loaded.');
    }

    final model = _modelData!['model'];
    final featureNames = List<String>.from(_modelData!['feature_names']);
    final coefficients = Map<String, dynamic>.from(model['coefficients']);

    double result = (model['intercept'] as num).toDouble();

    for (final featureName in featureNames) {
      final coef = (coefficients[featureName] as num).toDouble();
      final value = features[featureName] ?? 0.0;
      result += coef * value;
    }

    return result.clamp(0, 100);
  }

  double get mae {
    if (_modelData == null) return 0;
    return (_modelData!['model']['mae'] as num).toDouble();
  }

  double get r2 {
    if (_modelData == null) return 0;
    return (_modelData!['model']['r2'] as num).toDouble();
  }

  String get modelType {
    if (_modelData == null) return '';
    return _modelData!['model_type'].toString();
  }

  String get target {
    if (_modelData == null) return '';
    return _modelData!['target'].toString();
  }
}