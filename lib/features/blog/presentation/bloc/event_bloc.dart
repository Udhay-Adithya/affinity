import 'dart:io';
import 'package:affinity/core/usecase/usecase.dart';
import 'package:affinity/features/blog/domain/entities/event.dart';
import 'package:affinity/features/blog/domain/usecases/get_all_events.dart';
import 'package:affinity/features/blog/domain/usecases/upload_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final UploadEvent _uploadEvent;
  final GetAllEvents _getAllEvents;
  EventBloc({
    required UploadEvent uploadEvent,
    required GetAllEvents getAllEvents,
  })  : _uploadEvent = uploadEvent,
        _getAllEvents = getAllEvents,
        super(EventInitial()) {
    on<EventEvent>((event, emit) => emit(EventLoading()));
    on<EventUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
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
}
