class Wallet {
  final int? id;
  final String name;
  final String currency;
  final double balance;
  final String createdAt;
  final String updatedAt;

  Wallet({
    this.id,
    required this.name,
    required this.currency,
    this.balance = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'currency': currency,
      'balance': balance,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      currency: map['currency'] ?? '',
      balance: map['balance']?.toDouble() ?? 0.0,
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  Wallet copyWith({
    int? id,
    String? name,
    String? currency,
    double? balance,
    String? createdAt,
    String? updatedAt,
  }) {
    return Wallet(
      id: id ?? this.id,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
