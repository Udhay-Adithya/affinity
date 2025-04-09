import 'package:affinity/core/error/failures.dart';
import 'package:affinity/core/usecase/usecase.dart';
import 'package:affinity/features/event/domain/entities/event.dart';
import 'package:affinity/features/event/domain/repositories/event_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateEvent implements UseCase<Event, UpdateEventParams> {
  final EventRepository eventRepository;
  UpdateEvent(this.eventRepository);

  @override
  Future<Either<Failure, Event>> call(UpdateEventParams params) async {
    return await eventRepository.updateEvent(event: params.event);
  }
}

class UpdateEventParams {
  final Event event;
  UpdateEventParams({required this.event});
}
