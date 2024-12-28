class PriceTier {
  final String description;
  final num price; 

  PriceTier({
    required this.description,
    required this.price,
  });

  factory PriceTier.fromJson(Map<String, dynamic> json) {
    return PriceTier(
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'price': price,
    };
  }
}
