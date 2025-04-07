import 'dart:io';
import 'package:affinity/core/constants/constants.dart';
import 'package:affinity/core/error/exceptions.dart';
import 'package:affinity/core/error/failures.dart';
import 'package:affinity/core/network/connection_checker.dart';
import 'package:affinity/features/blog/data/datasources/event_local_data_source.dart';
import 'package:affinity/features/blog/data/datasources/event_remote_data_source.dart';
import 'package:affinity/features/blog/data/models/event_model.dart';
import 'package:affinity/features/blog/domain/entities/event.dart';
import 'package:affinity/features/blog/domain/repositories/event_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource blogRemoteDataSource;
  final EventLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  EventRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSource,
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

      final imageUrl = await blogRemoteDataSource.uploadEventImage(
        image: image,
        event: eventModel,
      );

      eventModel = eventModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedEvent = await blogRemoteDataSource.uploadEvent(eventModel);
      return right(uploadedEvent);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getAllEvents() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllEvents();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<void> joinEvent() async {
    try {} on ServerException catch (e) {}
  }

  @override
  Future<void> leaveEvent() async {
    try {} on ServerException catch (e) {}
  }
}
