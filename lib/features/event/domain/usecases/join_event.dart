import 'package:affinity/core/error/failures.dart';
import 'package:affinity/core/usecase/usecase.dart';
import 'package:affinity/features/event/domain/entities/event.dart';
import 'package:affinity/features/event/domain/repositories/event_repository.dart';
import 'package:fpdart/fpdart.dart';

class JoinEvent implements UseCase<Event, JoinEventParams> {
  final EventRepository eventRepository;
  JoinEvent(this.eventRepository);

  @override
  Future<Either<Failure, Event>> call(JoinEventParams params) async {
    return await eventRepository.joinEvent(
      event: params.event,
      userId: params.userId,
    );
  }
}

class JoinEventParams {
  final Event event;
  final String userId;

  JoinEventParams({
    required this.event,
    required this.userId,
  });
}
