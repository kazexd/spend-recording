class KanbanList {
  final int? id;
  final int boardId;
  final String title;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;

  KanbanList({
    this.id,
    required this.boardId,
    required this.title,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'board_id': boardId,
      'title': title,
      'position': position,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static KanbanList fromMap(Map<String, dynamic> map) {
    return KanbanList(
      id: map['id']?.toInt(),
      boardId: map['board_id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      position: map['position']?.toInt() ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  KanbanList copyWith({
    int? id,
    int? boardId,
    String? title,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return KanbanList(
      id: id ?? this.id,
      boardId: boardId ?? this.boardId,
      title: title ?? this.title,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
