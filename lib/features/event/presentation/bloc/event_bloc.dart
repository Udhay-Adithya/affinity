import 'dart:io';

import 'package:affinity/core/usecase/usecase.dart';
import 'package:affinity/features/event/domain/entities/event.dart';
import 'package:affinity/features/event/domain/usecases/get_all_events.dart';
import 'package:affinity/features/event/domain/usecases/join_event.dart';
import 'package:affinity/features/event/domain/usecases/leave_event.dart';
import 'package:affinity/features/event/domain/usecases/upload_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final UploadEvent _uploadEvent;
  final GetAllEvents _getAllEvents;
  final JoinEvent _joinEvent;
  final LeaveEvent _leaveEvent;

  EventBloc({
    required UploadEvent uploadEvent,
    required GetAllEvents getAllEvents,
    required JoinEvent joinEvent,
    required LeaveEvent leaveEvent,
  })  : _uploadEvent = uploadEvent,
        _getAllEvents = getAllEvents,
        _joinEvent = joinEvent,
        _leaveEvent = leaveEvent,
        super(EventInitial()) {
    on<EventEvent>((event, emit) => emit(EventLoading()));
    on<EventUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
    on<EventJoinEvent>(_onJoinEvent);
    on<EventLeaveEvent>(_onLeaveEvent);
  }

  void _onBlogUpload(
    EventUpload event,
    Emitter<EventState> emit,
  ) async {
    final res = await _uploadEvent(
      UploadEventParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        membersLimit: event.membersLimit,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(EventFailure(l.message)),
      (r) => emit(EventUploadSuccess()),
    );
  }

  void _onFetchAllBlogs(
    BlogFetchAllBlogs event,
    Emitter<EventState> emit,
  ) async {
    final res = await _getAllEvents(NoParams());

    res.fold(
      (l) => emit(EventFailure(l.message)),
      (r) => emit(EventsDisplaySuccess(r)),
    );
  }

  void _onJoinEvent(EventJoinEvent event, Emitter<EventState> emit) async {
    final res = await _joinEvent(
        JoinEventParams(event: event.event, userId: event.userId));

    res.fold(
      (l) => emit(EventFailure(l.message)),
      (r) => emit(EventJoinSuccess(r)),
    );
  }

  void _onLeaveEvent(EventLeaveEvent event, Emitter<EventState> emit) async {
    final res = await _leaveEvent(
        LeaveEventParams(event: event.event, userId: event.userId));
    res.fold(
      (l) => emit(EventFailure(l.message)),
      (r) => emit(EventLeaveSuccess(r)),
    );
  }
}
