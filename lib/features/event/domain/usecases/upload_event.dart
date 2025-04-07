import 'dart:io';
import 'package:affinity/core/error/failures.dart';
import 'package:affinity/core/usecase/usecase.dart';
import 'package:affinity/features/event/domain/entities/event.dart';
import 'package:affinity/features/event/domain/repositories/event_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadEvent implements UseCase<Event, UploadEventParams> {
  final EventRepository eventRepository;
  UploadEvent(this.eventRepository);

  @override
  Future<Either<Failure, Event>> call(UploadEventParams params) async {
    return await eventRepository.uploadEvent(
      image: params.image,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
      maxMembers: params.membersLimit,
    );
  }
}

class UploadEventParams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final int membersLimit;
  final List<String> topics;

  UploadEventParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.membersLimit,
    required this.topics,
  });
}
