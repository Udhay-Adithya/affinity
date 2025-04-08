part of 'event_bloc.dart';

@immutable
sealed class EventState {}

final class EventInitial extends EventState {}

final class EventLoading extends EventState {}

final class EventFailure extends EventState {
  final String error;
  EventFailure(this.error);
}

final class EventUploadSuccess extends EventState {}

final class EventsDisplaySuccess extends EventState {
  final List<Event> event;
  EventsDisplaySuccess(this.event);
}

final class EventJoinSuccess extends EventState {
  final Event event;
  EventJoinSuccess(this.event);
}

final class EventLeaveSuccess extends EventState {
  final Event event;
  EventLeaveSuccess(this.event);
}
