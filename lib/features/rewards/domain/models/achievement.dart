class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int progress;
  final int total;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.progress,
    required this.total,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      progress: json['progress'] as int,
      total: json['total'] as int,
      isUnlocked: json['isUnlocked'] as bool,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'progress': progress,
      'total': total,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? progress,
    int? total,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      progress: progress ?? this.progress,
      total: total ?? this.total,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
} 