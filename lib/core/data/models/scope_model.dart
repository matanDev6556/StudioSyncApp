class ScopeModel {
  String name;
  num size;

  ScopeModel({
    required this.name,
    required this.size,
  });

  factory ScopeModel.fromJson(Map<String, dynamic> json) {
    return ScopeModel(
      name: json['name'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'size': size,
      };
}
