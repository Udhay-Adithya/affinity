class Event {
  final String id;
  final String posterId;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> topics;
  final List<String> members;
  final int maxMembers;
  final DateTime updatedAt;
  final String? posterName;

  Event({
    required this.id,
    required this.posterId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
    required this.members,
    required this.maxMembers,
    required this.updatedAt,
    this.posterName,
  });
}
