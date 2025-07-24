enum TransactionType {
  income,
  expense,
  transfer,
}

class Transaction {
  final int? id;
  final int walletId;
  final String title;
  final String? description;
  final double amount;
  final TransactionType type;
  final String category;
  final String createdAt;
  final String updatedAt;

  Transaction({
    this.id,
    required this.walletId,
    required this.title,
    this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wallet_id': walletId,
      'title': title,
      'description': description,
      'amount': amount,
      'type': type.name,
      'category': category,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id']?.toInt(),
      walletId: map['wallet_id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'],
      amount: map['amount']?.toDouble() ?? 0.0,
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.expense,
      ),
      category: map['category'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  Transaction copyWith({
    int? id,
    int? walletId,
    String? title,
    String? description,
    double? amount,
    TransactionType? type,
    String? category,
    String? createdAt,
    String? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
