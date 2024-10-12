import 'package:studiosync/modules/trainee/models/scope_model.dart';

class WorkoutModel {
  final String id;
  final List<ScopeModel> listScopes;
  final double weight;
  final DateTime dateScope;

  const WorkoutModel({
    required this.id,
    required this.dateScope,
    required this.weight,
    required this.listScopes,
  });

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> scopesListMap =
        listScopes.map((scope) => scope.toMap()).toList();

    return {
      'id': id,
      'dateScope': dateScope.toIso8601String(),
      'weight': weight,
      'listScopes': scopesListMap,
    };
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? scopesList = json['listScopes'];
    List<ScopeModel> parsedScopesList = [];

    if (scopesList != null) {
      parsedScopesList = scopesList
          .map((scope) => ScopeModel.fromJson(scope))
          .cast<ScopeModel>()
          .toList();
    }

    return WorkoutModel(
      id: json['id'] ?? '',
      dateScope: DateTime.parse(json['dateScope']),
      weight: json['weight'],
      listScopes: parsedScopesList,
    );
  }

  WorkoutModel copyWith({
    String? id,
    List<ScopeModel>? listScopes,
    double? weight,
    DateTime? dateScope,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      dateScope: dateScope ?? this.dateScope,
      weight: weight ?? this.weight,
      listScopes: listScopes ?? this.listScopes,
    );
  }
}
