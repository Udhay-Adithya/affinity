part of 'event_bloc.dart';

@immutable
sealed class EventEvent {}

final class EventUpload extends EventEvent {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;
  final int membersLimit;

  EventUpload({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
    required this.membersLimit,
  });
}

final class BlogFetchAllBlogs extends EventEvent {}

final class EventJoinEvent extends EventEvent {
  final String userId;
  final Event event;
  EventJoinEvent({
    required this.userId,
    required this.event,
  });
}

final class EventLeaveEvent extends EventEvent {
  final String userId;
  final Event event;
  EventLeaveEvent({
    required this.userId,
    required this.event,
  });
}

final class UpdateEventEvent extends EventEvent {
  final Event event;
  UpdateEventEvent({
    required this.event,
  });
}
