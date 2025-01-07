import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/data/models/scope_model.dart';
import 'package:studiosync/core/data/models/workout_model.dart';
import 'package:uuid/uuid.dart';


class WorkoutFormHandler {

  final TextEditingController weightController = TextEditingController();
  final List<TextEditingController> scopeControllers =
      List.generate(5, (_) => TextEditingController());

  static const List<String> bodyParts = [
    'Chest',
    'Arms',
    'Legs',
    'Buttocks',
    'Abs'
  ];

  void resetControllers() {
    weightController.clear();
    for (var scopeController in scopeControllers) {
      scopeController.clear();
    }
  }

  bool validateWorkoutInput() {
    if (weightController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter the weight',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    if (scopeControllers.every((controller) => controller.text.isEmpty)) {
      Get.snackbar('Error', 'Please enter at least one scope',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    return true;
  }

  WorkoutModel createWorkoutFromInput() {
    List<ScopeModel> scopes = createScopesFromInput();
    return WorkoutModel(
      id: const Uuid().v4(),
      weight: double.parse(weightController.text),
      listScopes: scopes,
      dateScope: DateTime.now(),
    );
  }

  List<ScopeModel> createScopesFromInput() {
    return scopeControllers
        .asMap()
        .entries
        .where((entry) => entry.value.text.isNotEmpty)
        .map((entry) => ScopeModel(
              name: bodyParts[entry.key],
              size: double.parse(entry.value.text),
            ))
        .toList();
  }
}