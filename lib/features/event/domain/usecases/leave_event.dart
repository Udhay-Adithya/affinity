import 'package:affinity/core/error/failures.dart';
import 'package:affinity/core/usecase/usecase.dart';
import 'package:affinity/features/event/domain/entities/event.dart';
import 'package:affinity/features/event/domain/repositories/event_repository.dart';
import 'package:fpdart/fpdart.dart';

class LeaveEvent implements UseCase<Event, LeaveEventParams> {
  final EventRepository eventRepository;
  LeaveEvent(this.eventRepository);

  @override
  Future<Either<Failure, Event>> call(LeaveEventParams params) async {
    return await eventRepository.leaveEvent(
      event: params.event,
      userId: params.userId,
    );
  }
}

class LeaveEventParams {
  final Event event;
  final String userId;

  LeaveEventParams({
    required this.event,
    required this.userId,
  });
}
