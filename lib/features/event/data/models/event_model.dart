import 'package:affinity/features/event/domain/entities/event.dart';

class EventModel extends Event {
  EventModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.topics,
    required super.members,
    required super.maxMembers,
    required super.updatedAt,
    super.posterName,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'members_list': members,
      'members_limit': maxMembers,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as String,
      posterId: map['poster_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['image_url'] as String,
      topics: List<String>.from(map['topics'] ?? []),
      members: List<String>.from(map['members_list'] ?? []),
      maxMembers: map['members_limit'] ?? 0,
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
    );
  }

  EventModel copyWith({
    String? id,
    String? posterId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    List<String>? members,
    int? maxMembers,
    DateTime? updatedAt,
    String? posterName,
  }) {
    return EventModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      members: members ?? this.members,
      maxMembers: maxMembers ?? this.maxMembers,
      updatedAt: updatedAt ?? this.updatedAt,
      posterName: posterName ?? this.posterName,
    );
  }
}
