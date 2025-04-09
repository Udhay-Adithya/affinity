import 'dart:io';

import 'package:affinity/core/constants/constants.dart';
import 'package:affinity/core/error/exceptions.dart';
import 'package:affinity/core/error/failures.dart';
import 'package:affinity/core/network/connection_checker.dart';
import 'package:affinity/features/event/data/datasources/event_local_data_source.dart';
import 'package:affinity/features/event/data/datasources/event_remote_data_source.dart';
import 'package:affinity/features/event/data/models/event_model.dart';
import 'package:affinity/features/event/domain/entities/event.dart';
import 'package:affinity/features/event/domain/repositories/event_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource eventRemoteDataSource;
  final EventLocalDataSource eventLocalDataSource;
  final ConnectionChecker connectionChecker;
  EventRepositoryImpl(
    this.eventRemoteDataSource,
    this.eventLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Event>> uploadEvent({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
    int maxMembers = 4,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      EventModel eventModel = EventModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        members: [posterId],
        maxMembers: maxMembers,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await eventRemoteDataSource.uploadEventImage(
        image: image,
        event: eventModel,
      );

      eventModel = eventModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedEvent = await eventRemoteDataSource.uploadEvent(eventModel);
      return right(uploadedEvent);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getAllEvents() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = eventLocalDataSource.loadEvents();
        return right(blogs);
      }
      final events = await eventRemoteDataSource.getAllEvents();
      eventLocalDataSource.uploadLocalEvents(events: events);
      return right(events);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Event>> joinEvent({
    required Event event,
    required String userId,
  }) async {
    try {
      if (await (connectionChecker.isConnected)) {
        final eventData = await eventRemoteDataSource.joinEvent(
          event: event as EventModel,
          userId: userId,
        );
        return right(eventData);
      } else {
        throw ServerException("No internet connection");
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Event>> leaveEvent({
    required Event event,
    required String userId,
  }) async {
    try {
      if (await (connectionChecker.isConnected)) {
        final eventData = await eventRemoteDataSource.leaveEvent(
          event: event as EventModel,
          userId: userId,
        );
        return right(eventData);
      } else {
        throw ServerException("No internet connection");
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Event>> updateEvent({required Event event}) async {
    try {
      if (await (connectionChecker.isConnected)) {
        final eventData =
            await eventRemoteDataSource.updateEvent(event as EventModel);
        return right(eventData);
      } else {
        throw ServerException("No internet connection");
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
