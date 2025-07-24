class KanbanCard {
  final int? id;
  final int listId;
  final String title;
  final String? description;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;

  KanbanCard({
    this.id,
    required this.listId,
    required this.title,
    this.description,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'list_id': listId,
      'title': title,
      'description': description,
      'position': position,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static KanbanCard fromMap(Map<String, dynamic> map) {
    return KanbanCard(
      id: map['id']?.toInt(),
      listId: map['list_id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'],
      position: map['position']?.toInt() ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  KanbanCard copyWith({
    int? id,
    int? listId,
    String? title,
    String? description,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return KanbanCard(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      description: description ?? this.description,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
