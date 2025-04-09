import 'dart:io';

import 'package:affinity/core/error/failures.dart';
import 'package:affinity/features/event/domain/entities/event.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class EventRepository {
  Future<Either<Failure, Event>> uploadEvent({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
    int maxMembers = 4,
  });

  Future<Either<Failure, Event>> updateEvent({required Event event});

  Future<Either<Failure, List<Event>>> getAllEvents();

  Future<Either<Failure, Event>> joinEvent(
      {required Event event, required String userId});
  Future<Either<Failure, Event>> leaveEvent(
      {required Event event, required String userId});
}
